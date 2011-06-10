module Introspection

  class ClassSnapshot
    attr_reader :methods

    def initialize(klass)
      @methods = Set.new(
        klass.metaclass.ancestors.map do |meta_ancestor|
          meta_ancestor.public_instance_methods(false).map { |method| Method.new(meta_ancestor, method, :public) } +
          meta_ancestor.protected_instance_methods(false).map { |method| Method.new(meta_ancestor, method, :protected) } +
          meta_ancestor.private_instance_methods(false).map { |method| Method.new(meta_ancestor, method, :private) }
        end.flatten +
        klass.ancestors.map do |ancestor|
          (ancestor.metaclass.public_instance_methods(false) - ancestor.metaclass.ancestors.map { |a| a.public_instance_methods(false) }.flatten - (ancestor.ancestors - [ancestor]).map { |a| a.public_methods(false) }).flatten.map { |method| Method.new(ancestor, method, :public) } +
          (ancestor.metaclass.protected_instance_methods(false) - ancestor.metaclass.ancestors.map { |a| a.protected_instance_methods(false) }.flatten - (ancestor.ancestors - [ancestor]).map { |a| a.protected_methods(false) }).flatten.map { |method| Method.new(ancestor, method, :protected) } +
          (ancestor.metaclass.private_instance_methods(false) - ancestor.metaclass.ancestors.map { |a| a.private_instance_methods(false) }.flatten - (ancestor.ancestors - [ancestor]).map { |a| a.private_methods(false) }).flatten.map { |method| Method.new(ancestor, method, :private) }
        end.flatten
      )
    end
  end
end