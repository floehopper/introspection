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
end

class Test::Unit::TestCase
  include Introspection::TestHelper
end