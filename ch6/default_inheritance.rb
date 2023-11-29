# even if you do not explicitly designate a superclass, your objects will inherit from the Object class, which implements methods like nil? and method_missing?
class DefaultInheritance
  def method_one
  end
  def method_two
  end
end
obj = DefaultInheritance.new
puts obj.nil? # this wasn't one of the methods defined in the class. It must come from somewhere though, and that place is the Object class, from which all instances ultimately inherit

puts nil.nil? # here, nil? is defined in the Nilclass, and always returns tru