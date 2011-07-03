require "test_helper"

class ModuleSnapshotTest < Test::Unit::TestCase

  def test_detect_module_method_on_module
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.metaclass.send(:define_method, :foo) {}
      mod.metaclass.send(visibility, :foo)
      assert_method_included(mod, mod.metaclass, "foo", visibility)
    end
  end

  def test_detect_method_on_module_included_as_module_method_on_module
    for_all_method_visibilities do |visibility|
      supermod = Module.new
      supermod.send(:define_method, :foo) {}
      supermod.send(visibility, :foo)
      mod = Module.new do
        extend supermod
      end
      assert_method_included(mod, supermod, "foo", visibility)
    end
  end

  def test_detect_method_on_module_included_into_module_included_as_module_method_on_module
    for_all_method_visibilities do |visibility|
      superdupermod = Module.new
      superdupermod.send(:define_method, :foo) {}
      superdupermod.send(visibility, :foo)
      supermod = Module.new do
        include superdupermod
      end
      mod = Module.new do
        extend supermod
      end
      assert_method_included(mod, superdupermod, "foo", visibility)
    end
  end
end