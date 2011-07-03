require "introspection/receivers"
require "metaid"

module Introspection

  class Snapshot
    attr_reader :methods

    def initialize(object)
      @methods = object.receivers.map do |receiver|
        receiver.public_instance_methods(false).map { |method| Method.new(receiver, method, :public) } +
        receiver.protected_instance_methods(false).map { |method| Method.new(receiver, method, :protected) } +
        receiver.private_instance_methods(false).map { |method| Method.new(receiver, method, :private) }
      end.flatten
    end
  end
end