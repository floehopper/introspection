require "metaid"

module Introspection

  class Snapshot
    attr_reader :methods

    def initialize(klass)
      ancestors = []
      while klass
        ancestors << klass.metaclass
        superklass = klass.respond_to?(:superclass) ? klass.superclass : nil
        ancestors += klass.metaclass.ancestors - (superklass ? superklass.metaclass.ancestors : [])
        klass = superklass
      end

      @methods = ancestors.map do |ancestor|
        ancestor.public_instance_methods(false).map { |method| Method.new(ancestor, method, :public) } +
        ancestor.protected_instance_methods(false).map { |method| Method.new(ancestor, method, :protected) } +
        ancestor.private_instance_methods(false).map { |method| Method.new(ancestor, method, :private) }
      end.flatten
    end
  end
end