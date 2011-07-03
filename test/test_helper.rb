require "rubygems"
require "bundler/setup"

require "introspection"
require "test/unit"

module Introspection
  module TestHelper
    def for_all_method_visibilities(&block)
      [:public, :protected, :private].each do |visibility|
        block.call(visibility)
      end
    end
  end
  module Assertions
    def assert_method_exists(object, owner, method_name, visibility)
      snapshot = Introspection::Snapshot.new(object)
      method = owner.instance_method(method_name)
      expected_method = Introspection::Method.new(method, visibility)
      methods_for_name = snapshot.methods.select { |m| m.name == method_name }
      assert_equal [expected_method], methods_for_name
    end
  end
end

class Test::Unit::TestCase
  include Introspection::TestHelper
  include Introspection::Assertions
end