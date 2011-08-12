require "forwardable"

module Introspection

  class Method

    extend Forwardable
    def_delegators :@method, :owner

    attr_reader :visibility

    def initialize(method, visibility = :public)
      @method, @visibility = method, visibility
    end

    def ==(other)
      (owner == other.owner) && (name == other.name) && (visibility == other.visibility)
    end

    def eql?(other)
      (self.class === other) && (self == other)
    end

    def hash
      [owner, name, visibility].hash
    end

    def name
      @method.name.to_sym
    end

    def inspect
      "#{owner}##{name} (#{visibility})"
    end
  end

end