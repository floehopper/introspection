require "introspection/receivers"
require "metaid"

module Introspection

  class Snapshot
    attr_reader :methods

    def initialize(object)
      @methods = object.receivers.map do |receiver|
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
  end
end