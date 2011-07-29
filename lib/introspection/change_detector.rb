require "introspection"
require "instantiator"

before_class_snapshots = {}
before_instance_snapshots = {}
ObjectSpace.each_object do |object|
  if Class === object
    next if Instantiator.unsupported_class?(object)
    object.instantiate
  end
end
ObjectSpace.each_object do |object|
  if Class === object
    next if Instantiator.unsupported_class?(object)
    before_class_snapshots[object] = Introspection::Snapshot.new(object)
    before_instance_snapshots[object] = Introspection::Snapshot.new(object.instantiate)
  end
end

class String
  def foo
  end
  def self.bar
  end
end

after_class_snapshots = {}
after_instance_snapshots = {}
ObjectSpace.each_object do |object|
  if Class === object
    next if Instantiator.unsupported_class?(object)
    after_class_snapshots[object] = Introspection::Snapshot.new(object)
    after_instance_snapshots[object] = Introspection::Snapshot.new(object.instantiate)
  end
end

before_instance_snapshots.each_key do |key|
  if after_instance_snapshots[key]
    if before_instance_snapshots[key].changed?(after_instance_snapshots[key])
      p [key, :instance_method, before_instance_snapshots[key].diff(after_instance_snapshots[key])]
    end
  end
end

before_class_snapshots.each_key do |key|
  if after_class_snapshots[key]
    if before_class_snapshots[key].changed?(after_class_snapshots[key])
      p [key, :class_method, before_class_snapshots[key].diff(after_class_snapshots[key])]
    end
  end
end

# => [String, :instance_method, {:removed=>[], :added=>[String#foo (public)]}]
# => [String, :class_method, {:removed=>[], :added=>[#<Class:String>#bar (public)]}]
