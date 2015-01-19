require "test_helper"

class ClassSnapshotTest < Minitest::Test

  def test_detect_class_method_on_class
    for_all_method_visibilities do |visibility|
      klass = Class.new
      klass.__metaclass__.send(:define_method, :foo) {}
      klass.__metaclass__.send(visibility, :foo)
      assert_method_exists(klass, klass.__metaclass__, :foo, visibility)
    end
  end

  def test_detect_class_method_on_superclass
    for_all_method_visibilities do |visibility|
      superklass = Class.new
      superklass.__metaclass__.send(:define_method, :foo) {}
      superklass.__metaclass__.send(visibility, :foo)
      klass = Class.new(superklass)
      assert_method_exists(klass, superklass.__metaclass__, :foo, visibility)
    end
  end

  def test_detect_class_method_on_superclass_of_superclass
    for_all_method_visibilities do |visibility|
      superduperklass = Class.new
      superduperklass.__metaclass__.send(:define_method, :foo) {}
      superduperklass.__metaclass__.send(visibility, :foo)
      klass = Class.new(Class.new(superduperklass))
      assert_method_exists(klass, superduperklass.__metaclass__, :foo, visibility)
    end
  end

  def test_detect_method_on_module_included_as_class_method_into_class
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.send(:define_method, :foo) {}
      mod.send(visibility, :foo)
      klass = Class.new do
        extend mod
      end
      assert_method_exists(klass, mod, :foo, visibility)
    end
  end

  def test_detect_method_on_module_included_as_class_method_into_superclass
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.send(:define_method, :foo) {}
      mod.send(visibility, :foo)
      superklass = Class.new do
        extend mod
      end
      klass = Class.new(superklass)
      assert_method_exists(klass, mod, :foo, visibility)
    end
  end

  def test_detect_method_on_module_included_as_class_method_into_superclass_of_superclass
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.send(:define_method, :foo) {}
      mod.send(visibility, :foo)
      superduperklass = Class.new do
        extend mod
      end
      klass = Class.new(Class.new(superduperklass))
      assert_method_exists(klass, mod, :foo, visibility)
    end
  end

  def test_detect_method_on_module_included_into_module_included_as_class_method_into_class
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.send(:define_method, :foo) {}
      mod.send(visibility, :foo)
      supermod = Module.new do
        include mod
      end
      klass = Class.new do
        extend supermod
      end
      assert_method_exists(klass, mod, :foo, visibility)
    end
  end

end
