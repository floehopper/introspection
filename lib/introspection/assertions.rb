module Introspection
  module Assertions
    def assert_snapshot_changed(object)
      before = Snapshot.new(object)
      yield
      after = Snapshot.new(object)
      assert before.changed?(after), "Snapshot has not changed."
    end

    def assert_snapshot_unchanged(object)
      before = Snapshot.new(object)
      yield
      after = Snapshot.new(object)
      assert !before.changed?(after), "Snapshot has changed: #{before.diff(after).inspect}"
    end
  end
end