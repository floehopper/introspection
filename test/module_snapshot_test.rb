require "test_helper"

class ModuleSnapshotTest < Minitest::Test

  def test_detect_module_method_on_module
    for_all_method_visibilities do |visibility|
      mod = Module.new
      mod.__metaclass__.send(:define_method, :foo) {}
      mod.__metaclass__.send(visibility, :foo)
      assert_method_exists(mod, mod.__metaclass__, :foo, visibility)
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
      assert_method_exists(mod, supermod, :foo, visibility)
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
      assert_method_exists(mod, superdupermod, :foo, visibility)
    end
  end
end
