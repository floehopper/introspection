require "rubygems"
require "bundler/setup"

$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))

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
      expected_method = Introspection::Method.new(owner, method_name, visibility)
      methods_for_name = snapshot.methods.select { |m| m.name == method_name }
      assert_equal [expected_method], methods_for_name
    end
  end
end

class Test::Unit::TestCase
  include Introspection::TestHelper
  include Introspection::Assertions
end