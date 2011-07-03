module Grandaddy
  def foo
    puts "Grandaddy#foo"
    super
  rescue NoMethodError
  end
end

module Daddy
  def foo
    puts "Daddy#foo"
    super
  rescue NoMethodError
  end
  include Grandaddy
end

module Sonny
  def self.foo
    puts "Sonny.foo"
    super
  rescue NoMethodError
  end
  extend Daddy
end

Sonny.foo