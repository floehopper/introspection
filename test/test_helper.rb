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
    def assert_method_included(object, owner, method_name, visibility)
      snapshot = Introspection::Snapshot.new(object)
      methods_for_owner = snapshot.methods.select { |m| m.owner == owner }
      expected_method = Introspection::Method.new(owner, method_name, visibility)
      error_message  = [
        "Expected method: #{expected_method.inspect}",
        "Methods detected: #{methods_for_owner.inspect}"
      ].join("\n")
      assert snapshot.methods.include?(expected_method), error_message
    end
  end
end

class Test::Unit::TestCase
  include Introspection::TestHelper
  include Introspection::Assertions
end