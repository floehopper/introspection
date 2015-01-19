require "test_helper"

class InstanceSnapshotTest < Minitest::Test

  def test_detect_instance_method_on_singleton_class
    for_all_method_visibilities do |visibility|
      instance = Class.new.new
      instance.__metaclass__.send(:define_method, :foo) {}
      instance.__metaclass__.send(visibility, :foo)
      assert_method_exists(instance, instance.__metaclass__, :foo, visibility)
    end
  end

  def test_detect_instance_method_on_module_included_into_singleton_class
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.send(:define_method, :foo) {}
      mod.send(visibility, :foo)
      instance = Class.new.new
      instance.extend(mod)
      assert_method_exists(instance, mod, :foo, visibility)
    end
  end

  def test_detect_instance_method_on_module_included_module_included_into_singleton_class
    for_all_method_visibilities do |visibility|
      supermod = Module.new
      supermod.send(:define_method, :foo) {}
      supermod.send(visibility, :foo)
      mod = Module.new
      mod.send(:include, supermod)
      instance = Class.new.new
      instance.extend(mod)
      assert_method_exists(instance, supermod, :foo, visibility)
    end
  end

  def test_detect_instance_method_on_class
    for_all_method_visibilities do |visibility|
      klass = Class.new
      klass.send(:define_method, :foo) {}
      klass.send(visibility, :foo)
      instance = klass.new
      assert_method_exists(instance, klass, :foo, visibility)
    end
  end

  def test_detect_instance_method_on_superclass
    for_all_method_visibilities do |visibility|
      superklass = Class.new
      superklass.send(:define_method, :foo) {}
      superklass.send(visibility, :foo)
      instance = Class.new(superklass).new
      assert_method_exists(instance, superklass, :foo, visibility)
    end
  end

  def test_detect_instance_method_on_superclass_of_superclass
    for_all_method_visibilities do |visibility|
      superduperklass = Class.new
      superduperklass.send(:define_method, :foo) {}
      superduperklass.send(visibility, :foo)
      instance = Class.new(Class.new(superduperklass)).new
      assert_method_exists(instance, superduperklass, :foo, visibility)
    end
  end

  def test_detect_instance_method_on_module_included_into_class
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.send(:define_method, :foo) {}
      mod.send(visibility, :foo)
      instance = Class.new do
        include mod
      end.new
      assert_method_exists(instance, mod, :foo, visibility)
    end
  end

  def test_detect_instance_method_on_module_included_into_superclass
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.send(:define_method, :foo) {}
      mod.send(visibility, :foo)
      superklass = Class.new do
        include mod
      end
      instance = Class.new(superklass).new
      assert_method_exists(instance, mod, :foo, visibility)
    end
  end

  def test_detect_instance_method_on_module_included_into_superclass_of_superclass
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.send(:define_method, :foo) {}
      mod.send(visibility, :foo)
      superduperklass = Class.new do
        include mod
      end
      instance = Class.new(Class.new(superduperklass)).new
      assert_method_exists(instance, mod, :foo, visibility)
    end
  end

  def test_detect_instance_method_on_module_included_into_module_included_into_class
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.send(:define_method, :foo) {}
      mod.send(visibility, :foo)
      supermod = Module.new do
        include mod
      end
      klass = Class.new do
        include supermod
      end
      instance = klass.new
      assert_method_exists(instance, mod, :foo, visibility)
    end
  end

end
