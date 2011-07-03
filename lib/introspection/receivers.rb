require "metaid"

module Introspection

  module Receivers

    class NullMetaclass
      def ancestors
        Array.new
      end
    end

    class NullReceiver
      def metaclass
        NullMetaclass.new
      end

      def receivers
        Array.new
      end
    end

    def superklass
      respond_to?(:superclass) ? superclass : NullReceiver.new
    end

    def local_receivers
      [metaclass] + metaclass.ancestors - superklass.metaclass.ancestors
    end

    def receivers
      local_receivers + superklass.receivers
    end

  end
end

class Object
  include Introspection::Receivers
end