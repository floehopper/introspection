require "test_helper"
require "blankslate"

class SnapshotTest < Minitest::Test

  include Introspection

  def test_should_report_methods_added
    instance = Class.new.new
    before = Snapshot.new(instance)
    instance.__metaclass__.send(:define_method, :foo) {}
    after = Snapshot.new(instance)
    diff = before.diff(after)
    assert_equal 1, diff[:added].length
    assert_equal instance.__metaclass__, diff[:added][0].owner
    assert_equal :foo, diff[:added][0].name
  end

  def test_should_report_methods_removed
    instance = Class.new.new
    instance.__metaclass__.send(:define_method, :foo) {}
    before = Snapshot.new(instance)
    instance.__metaclass__.send(:remove_method, :foo)
    after = Snapshot.new(instance)
    diff = before.diff(after)
    assert_equal 1, diff[:removed].length
    assert_equal instance.__metaclass__, diff[:removed][0].owner
    assert_equal :foo, diff[:removed][0].name
  end

  def test_should_indicate_snapshot_has_changed_when_method_is_added
    instance = Class.new.new
    assert_snapshot_changed(instance) do
      instance.__metaclass__.send(:define_method, :foo) {}
    end
  end

  def test_should_indicate_snapshot_has_changed_when_method_is_removed
    instance = Class.new.new
    instance.__metaclass__.send(:define_method, :foo) {}
    assert_snapshot_changed(instance) do
      instance.__metaclass__.send(:remove_method, :foo)
    end
  end

  def test_should_indicate_snapshot_has_not_changed_when_method_no_methods_are_added_or_removed
    instance = Class.new.new
    assert_snapshot_unchanged(instance) {}
  end

  def test_should_cope_with_blankslate_object
    # Should not raise anything
    Snapshot.new(BlankSlate.new)
  end

end
