require "forwardable"

module Introspection

  class Method

    extend Forwardable
    def_delegators :@method, :owner, :name

    attr_reader :method, :visibility

    def initialize(method, visibility)
      @method, @visibility = method, visibility
    end

    def ==(other)
      (method == other.method) && (visibility == other.visibility)
    end

    def eql?(other)
      (self.class === other) && (self == other)
    end

    def hash
      [method, visibility].hash
    end

    def inspect
      "#{owner}##{name} (#{visibility})"
    end
  end

end