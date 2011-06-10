require "test_helper"

class ClassSnapshotTest < Test::Unit::TestCase

  def test_detect_class_method_on_class
    for_all_method_visibilities do |visibility|
      klass = Class.new
      klass.metaclass.send(:define_method, :foo) {}
      klass.metaclass.send(visibility, :foo)
      assert_class_method_included(klass, klass, "foo", visibility)
    end
  end

  def test_detect_class_method_on_superclass
    for_all_method_visibilities do |visibility|
      superklass = Class.new
      superklass.metaclass.send(:define_method, :foo) {}
      superklass.metaclass.send(visibility, :foo)
      klass = Class.new(superklass)
      assert_class_method_included(klass, superklass, "foo", visibility)
    end
  end

  def test_detect_class_method_on_superclass_of_superclass
    for_all_method_visibilities do |visibility|
      superduperklass = Class.new
      superduperklass.metaclass.send(:define_method, :foo) {}
      superduperklass.metaclass.send(visibility, :foo)
      klass = Class.new(Class.new(superduperklass))
      assert_class_method_included(klass, superduperklass, "foo", visibility)
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
      assert_class_method_included(klass, mod, "foo", visibility)
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
      assert_class_method_included(klass, mod, "foo", visibility)
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
      assert_class_method_included(klass, mod, "foo", visibility)
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
      assert_class_method_included(klass, mod, "foo", visibility)
    end
  end

  def assert_class_method_included(klass, owner, method_name, visibility)
    snapshot = Introspection::ClassSnapshot.new(klass)
    methods_for_owner = snapshot.methods.select { |m| m.owner == owner }
    expected_method = Introspection::Method.new(owner, method_name, visibility)
    error_message  = [
      "Expected method: #{expected_method.inspect}",
      "Methods detected: #{methods_for_owner.inspect}"
    ].join("\n")
    assert snapshot.methods.include?(expected_method), error_message
  end
end