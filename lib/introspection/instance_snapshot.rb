require "set"
require "metaid"

module Introspection

  class InstanceSnapshot
    attr_reader :methods

    def initialize(instance)
      ancestors = Set.new([instance.metaclass] + instance.metaclass.ancestors + instance.class.ancestors)
      @methods = Set.new(ancestors.map do |ancestor|
        ancestor.public_instance_methods(false).select { |method| ancestor.instance_method(method).owner == ancestor }.map { |method| Method.new(ancestor, method, :public) } +
        ancestor.protected_instance_methods(false).select { |method| ancestor.instance_method(method).owner == ancestor }.map { |method| Method.new(ancestor, method, :protected) } +
        ancestor.private_instance_methods(false).select { |method| ancestor.instance_method(method).owner == ancestor }.map { |method| Method.new(ancestor, method, :private) }
      end.flatten)
    end

  end
end
