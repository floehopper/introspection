module Introspection

  class Method
    attr_reader :owner, :name, :visibility

    def initialize(owner, name, visibility)
      @owner, @name, @visibility = owner, name, visibility
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

    def inspect
      "#{owner}##{name} (#{visibility})"
    end
  end

end