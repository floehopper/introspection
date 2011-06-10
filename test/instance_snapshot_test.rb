require "rubygems"
require "bundler/setup"

$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))

require "introspection"
require "test/unit"

class InstanceSnapshotTest < Test::Unit::TestCase

  def test_detect_instance_method_on_singleton_class
    for_all_method_visibilities do |visibility|
      instance = Class.new.new
      instance.meta_def(:foo) {}
      instance.metaclass.send(visibility, :foo)
      assert_instance_method_included(instance, instance.metaclass, "foo", visibility)
    end
  end

  def test_detect_instance_method_on_module_included_into_singleton_class
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.send(:define_method, :foo) {}
      mod.send(visibility, :foo)
      instance = Class.new.new
      instance.extend(mod)
      assert_instance_method_included(instance, mod, "foo", visibility)
    end
  end

  def test_detect_instance_method_on_class
    for_all_method_visibilities do |visibility|
      klass = Class.new
      klass.send(:define_method, :foo) {}
      klass.send(visibility, :foo)
      instance = klass.new
      assert_instance_method_included(instance, klass, "foo", visibility)
    end
  end

  def test_detect_instance_method_on_superclass
    for_all_method_visibilities do |visibility|
      superklass = Class.new
      superklass.send(:define_method, :foo) {}
      superklass.send(visibility, :foo)
      instance = Class.new(superklass).new
      assert_instance_method_included(instance, superklass, "foo", visibility)
    end
  end

  def test_detect_instance_method_on_superclass_of_superclass
    for_all_method_visibilities do |visibility|
      superduperklass = Class.new
      superduperklass.send(:define_method, :foo) {}
      superduperklass.send(visibility, :foo)
      instance = Class.new(Class.new(superduperklass)).new
      assert_instance_method_included(instance, superduperklass, "foo", visibility)
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
      assert_instance_method_included(instance, mod, "foo", visibility)
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
      assert_instance_method_included(instance, mod, "foo", visibility)
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
      assert_instance_method_included(instance, mod, "foo", visibility)
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
      assert_instance_method_included(instance, mod, "foo", visibility)
    end
  end

  def assert_instance_method_included(instance, owner, method_name, visibility)
    snapshot = Introspection::InstanceSnapshot.new(instance)
    methods_for_owner = snapshot.methods.select { |m| m.owner == owner }
    expected_method = Introspection::Method.new(owner, method_name, visibility)
    assert snapshot.methods.include?(expected_method), "Expected method: #{expected_method.inspect}\nMethods detected: #{methods_for_owner.inspect}"
  end

  def for_all_method_visibilities(&block)
    [:public, :protected, :private].each do |visibility|
      block.call(visibility)
    end
  end

end