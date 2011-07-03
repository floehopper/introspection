module Kernel
  def foo
    puts "Kernel#foo"
    super
  rescue NoMethodError
  end
end

class Object
  def foo
    puts "Object#foo"
    super
  rescue NoMethodError
  end
  def self.foo
    puts "Object.foo"
    super
  rescue NoMethodError
  end
end

class Module
  def foo
    puts "Module#foo"
    super
  rescue NoMethodError
  end
end

class Class
  def foo
    puts "Class#foo"
    super
  rescue NoMethodError
  end
end

module GreatUncle
  def foo
    puts "GreatUncle#foo"
    super
  rescue NoMethodError
  end
end

module GreatAunt
  def foo
    puts "GreatAunt#foo"
    super
  rescue NoMethodError
  end
end

class Grandaddy
  def self.foo
    puts "Grandaddy.foo"
    super
  rescue NoMethodError
  end
  extend GreatUncle, GreatAunt
end

module Uncle
  def foo
    puts "Uncle#foo"
    super
  rescue NoMethodError
  end
end

module Aunt
  def foo
    puts "Aunt#foo"
    super
  rescue NoMethodError
  end
end

class Daddy < Grandaddy
  def self.foo
    puts "Daddy.foo"
    super
  rescue NoMethodError
  end
  extend Uncle, Aunt
end

module Brother
  def foo
    puts "Brother#foo"
    super
  rescue NoMethodError
  end
end

module HalfSister
  def foo
    puts "HalfSister#foo"
    super
  rescue NoMethodError
  end
end

module Sister
  def foo
    puts "Sister#foo"
    super
  rescue NoMethodError
  end
  include HalfSister
end

class Sonny < Daddy
  def self.foo
    puts "Sonny.foo"
    super
  rescue NoMethodError
  end
  extend Brother, Sister
end

Sonny.foo
