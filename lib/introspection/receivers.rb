require "metaid"

module Introspection
  module Receivers
    def receivers
      receivers = []
      object = self
      while object
        receivers << object.metaclass
        superklass = object.respond_to?(:superclass) ? object.superclass : nil
        receivers += object.metaclass.ancestors - (superklass ? superklass.metaclass.ancestors : [])
        object = superklass
      end
      receivers
    end
  end
end

class Object
  include Introspection::Receivers
end