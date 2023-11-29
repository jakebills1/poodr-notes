# Bicycle is now used as an abstract class. It does not refer to a complete bicycle, but the attributes all bicycles have in common
# to refactor, we will start by moving all functionality in Bicycle to RoadBike
class Bicycle
  # empty class
end

class RoadBike < Bicycle
  # has all functionality previously given to Bicycle
end

class MountainBike < Bicycle
end

# this has obvious problems
bike = RoadBike.new(
  size: 'M',
  tape_color: 'red' 
)
mtb = MountainBike.new(
  size: 'S',
  front_shock:  'Manitou',
  rear_shock:   'Fox'
)
puts bike.size # => 'M'
puts mtb.size # => NoMethodError
# MountainBike does not implement the size method

# refactoring by pulling functionality from the subclass to the superclass.
# the previous example proved that size needed to be common to RoadBike and MountainBike, so it belongs in Bicycle
# a naive attempt at fixing it would be to duplicate the size method between classes, which would make it really obvious it should be in the superclass
class Bicycle
  attr_reader :size
  def initialize(args = {})
    @size = args[:size]
  end
end

class RoadBike < Bicycle
  attr_reader :tape_color
  def initialize(args) # this is an override, meaning RoadBike will not delegate this message to Bicycle unless it calls super
    @tape_color = args[:tape_color]
    super(args)
  end
end

class MountainBike < Bicycle
end

# now both work as expected
bike = RoadBike.new(
  size: 'M',
  tape_color: 'red' 
)
mtb = MountainBike.new(
  size: 'S',
  front_shock:  'Manitou',
  rear_shock:   'Fox'
)
puts bike.size # => 'M'
puts mtb.size # => 'S' 

# we have a new problem
puts mtb.spares # => NoMethodError: super: no superclass method 'spares'
# bike has spares method from original bicycle class, but mtb does not
# the pattern so far has seen all subclasses needed chain and tire_size as well as size, so moving to superclass
# superclass provides defaults using overridable methods
class Bicycle
  attr_reader :size, :chain, :tire_size
  def initialize(args = {})
    @size = args[:size]
    @chain = args[:chain] || default_chain
    @tire_size = args[:tire_size] || default_tire_size
  end

  def default_chain
    '10-speed'
  end

end

# subclasses will implement default_tire_size, but not default_chain, as they both would have the same value for it
# this is called template method pattern
class RoadBike < Bicycle
  # ... 
  def default_tire_size
    '23'
  end
end

class MountainBike < Bicycle
  # ...
  def default_tire_size
    '21'
  end
end

# we have a new requirement, Recumbent Bikes
class RecumbentBike < Bicycle
  def default_chain
    '9-speed'
  end
end

rb = RecumbentBike.new # => NameError: undefined local variable or method 'default_tire_size'
# RecumbentBike needed to have implemented that method to avoid the error, but that's not expected

# better: 
class Bicycle
  def default_tire_size
    raise NotImplementedError # a more specific and helpful error message
  end
end
