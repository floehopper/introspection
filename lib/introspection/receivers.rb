require "metaclass"

module Introspection

  module Receivers

    class NullMetaclass
      def ancestors
        Array.new
      end
    end

    class NullReceiver
      def __metaclass__
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
      receivers = []
      receivers << __metaclass__ if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.1.0')
      receivers += __metaclass__.ancestors
      receivers -= superklass.__metaclass__.ancestors
      receivers
    end

    def receivers
      local_receivers + superklass.receivers
    end

  end
end

class Object
  include Introspection::Receivers
end