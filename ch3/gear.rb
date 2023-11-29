class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @rim = rim
    @tire = tire
  end

  def gear_inches
    # 1. dependency on initializing Wheel
    # 2. dependency on argument order
    # 3. dependency that instances of wheel respond to tire
    ratio * Wheel.new(rim, tire).diameter
  end

  def ratio
    chainring / cog.to_f
  end
end

class Wheel
  attr_reader :rim, :tire
  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  def diameter
    rim (tire * 2)
  end
end

Gear.new(52, 11, 26, 1.5).gear_inches # this iteration of Gear can only calculate teh gear inches for something with a Wheel

# removing dependency on initializing Wheel by using Dependency Injection

class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, wheel)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end

  def gear_inches
    ratio * wheel.diameter # all Gear needs to know is that wheel responds to diameter
  end
end

Gear.new(52, 11, Wheel.new(26, 1.5))

# in situations where you cannot remove a dependency on another class, isolate the instantiation


class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @rim = rim
    @tire = tire
    @wheel = Wheel.new(rim, tire) # isolated to constructor
  end

  def gear_inches
    ratio * wheel.diameter
  end
end


class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @rim = rim
    @tire = tire
  end

  def gear_inches
    ratio * wheel.diameter
  end

  def wheel
    @wheel ||= Wheel.new(rim, tire) # isolated to method
  end
end

# gear inches has logic sending a method to an object other than self
# this is fine in simple situations, but is best to isolate from complicated logic

class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @rim = rim
    @tire = tire
    @wheel = Wheel.new(rim, tire) # isolated to constructor
  end

  def gear_inches
    ratio * diameter # tranforms a dependency on a message sent to an external object to a method call on self
  end

  def diameter
    wheel.diameter
  end
end


# clients of Gear will need to depend on the order of its arguments.
# any change to the arguments to Gear.new will require changes in it's call locations
# storing the args in a hash is one solution to this
# clients of Gear must know the hash keys, but this also serves as documentation
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, wheel)
    @chainring = args[:chainring]
    @cog = args[:cog]
    @wheel = args[:wheel]
  end
end

Gear.new({
  chainring: 52,
  cog: 11,
  wheel: Wheel.new(26, 1.5)
})

#  implementation for default args avoiding complications of boolean args
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(args)
    @chainring = args.fetch(:chainring, 40)
    @cog = args.fetch(:cog, 18)
    @wheel = args[:wheel]
  end
end

Gear.new(wheel: Wheel.new(26, 1.5))

# alternatively
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(args)
    args = defaults.merge(args)
    @chainring = args.fetch(:chainring, 40)
    @cog = args.fetch(:cog, 18)
    @wheel = args[:wheel]
  end

  private
  def defaults
    { chainring: 40, cog: 18 }
  end
end

# if you do not have control of the implementation of Gear to change it's argument order dependency
# wrap it in another class that acts as a factory
module SomeFramework
  class Gear
    attr_reader :chainring, :cog, :rim, :tire
    def initialize(chainring, cog, rim, tire)
      @chainring = chainring
      @cog = cog
      @rim = rim
      @tire = tire
      @wheel = Wheel.new(rim, tire)
    end
  end
end

module GearWrapper
  def self.gear(args)
    SomeFramework::Gear.new(args[:chainring], args[:cog], args[:rim], args[:tire])
  end
end

GearWrapper.gear({ chainring: 52, cog: 18, rim: 26, tire: 1.5 }).gear_inches

# As of the beginning of this document, Gear depends on Wheel, but Wheel could depend on Gear just as easily
# When choosing a dependency direction, depend on what will change les
