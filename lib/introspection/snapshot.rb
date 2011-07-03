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
            if receiver.instance_method(method).owner.equal?(receiver)
              Method.new(receiver, method, visibility)
            end
          end.compact
        end
      end.flatten
    end
  end
end