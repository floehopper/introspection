require "introspection/receivers"
require "metaclass"

module Introspection

  class Snapshot
    attr_reader :methods

    def initialize(object)
      @methods = (object.receivers rescue []).map do |receiver|
        [:public, :protected, :private].map do |visibility|
          query_method = "#{visibility}_instance_methods"
          receiver.send(query_method, false).map do |method|
            unbound_method = receiver.instance_method(method)
            if unbound_method.owner.equal?(receiver)
              Method.new(unbound_method, visibility)
            end
          end.compact
        end
      end.flatten
    end

    def diff(other)
      {
        :added => other.methods - methods,
        :removed => methods - other.methods
      }
    end

    def changed?(other)
      diff(other).values.flatten.any?
    end

  end
end