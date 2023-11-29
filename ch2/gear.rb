class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @rim = rim
    @tire = tire
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    # gear inches = wheel diameter * gear ratio
    # where
    # wheel diameter = rim diameter + twice tire diameter
    ratio * (rim + (tire * 2))
    # the second half of this expression is the calculation for the diameter of a wheel, it should be it's own method
  end
end

# interface
#  initialize(chainring, cog) - instance of Gear
#  chainring - number of teeth in big gear
#  cog - number of teeth in small gear
#  ratio - # of teeth in big gear / # of teeth in small
#  rim - rim diameter in inches
#  tire - tire diameter in inches
#  + whatever methods inherited. In this case only has inherited methods from Basic Object

# Does Gear have a single responsibility?
#   each method is a question about the responsibility of the class
#    it's reasonable to say gears have ratios, and maybe gear_inches, but gears don't have tires
#   if a class's responsibility can be summed up in a sentance without using and or or, it fits the SRP or is highly cohesive


# classes store their data in instance variables
#   wrap these in acessors for encapsulation
class Gear
  def initialize(chainring, cog)
    @chainring = chainring
    @cog = cog
  end

  def ratio
    @chainring / @cog.to_f # @chainring and @cog are data, and not methods
  end

  def cog
    # wrapping @cog in a getter method defines the access to the data in one place
    # any needed changes can be made here and consumed everywhere
    @cog
  end
end

# since bicycles have 2 wheels ... 

class ObscuringReferences
  attr_reader :data
  def initialize(data)
    @data = data
  end

  def diameters # this method and other consumers of data know way too much about internal structure of @data
    # @data is 2d array where first el in array is rim, 2nd is tire
    data.collect { |cell| cell[0] + (cell[1] * 2) }
  end
end

class RevealingReferences
  attr_reader :wheels
  def initialize(data)
    @wheels = wheelify(data)
  end

  def diameters
    # this method has the responsibility of iterating over wheels and adding a wheels rim and 2X it's tire inches
    # wheels.collect { |wheel| wheel.rim + (wheel.tire * 2) }
    # this gives it one, iterating over wheels
    wheels.collect { |wheel| diameter(wheel) }
  end

  def diameter(wheel)
    wheel.rim + (wheel.tire * 2)
  end


  Wheel = Struct.new(:rim, :tire) # a struct is a way to group attributes together without defining a class

  def wheelify(data)
    # knowledge of datas internal structure is isolated here
    data.collect { |cell| Wheel.new(cell[0], cell[1]) }
  end
end

# always make your methods fit SRP, even if you don't know if you will need the behavior.

# deferring design decisions:
#   this implementation isolates the behavior of Wheel, but stops short of actually making a class for it

class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @wheel = Wheel.new(rim, tire)
  end

  # ... same interface as before

  Wheel = Struct.new(:rim, :tire) do
    def diameter
      rim + (tire * 2)
    end
  end
end

# when you have enough information to know Wheel can be a class:

class Wheel
  attr_reader :rim, :tire
  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  def diameter
    rim + (tire * 2)
  end

  def circumference
    diameter * Math::PI
  end
end

class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, wheel = nil) # wheel is not necessary to calc gear inches, so nullable
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end

  # ... same interface as before
  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter
  end
end

@wheel = Wheel.new(26, 1.5)
puts @wheel.circumference

puts Gear.new(52, 11, @wheel).gear_inches

puts Gear.new(52, 11).ratio
