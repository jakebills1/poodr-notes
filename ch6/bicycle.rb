# this currently represents a road bike
class Bicycle
  attr_reader :size, :tape_color
  def initialize(args)
    @size = args[:size]
    @tape_color = args[:tape_color]
  end
  def spares
    {
      chain: '10-speed',
      tire_size: '23',
      tape_color: tape_color
    }
  end
  # ...
end

bike = Bicycle.new({
  size: 'M',
  tape_color: 'red'
})
puts bike.size
puts bike.spares

# now we have a requirement to support mountain bikes as well, so we rewrite the class
class Bicycle
  attr_reader :style, :size, :tape_color,
              :front_shock, :rear_shock
  def initialize(args)
    @style = args[:style] 
    @size = args[:size] 
    @tape_color = args[:tape_color] 
    @front_shock = args[:front_shock] 
    @rear_shock = args[:rear_shock]
  end
  def spares
    if style == :road # this is a clue that this class is trying to be 2 things
      {
        chain: '10-speed',
        tire_size: '23', # mm
        tape_color: tape_color
      }
    else
      {
        chain: '10-speed',
        tire_size: '21', # inches
        rear_shock: rear_shock
      }
    end
  end
  # ...
end

# this has a few problems
# - it will require a change every time we add new types of bikes to the requirements
# - the data exposed as it's public interface is not consistent. clients will have to check the style to know if rear_shock could be nil

# words like type or category mean very close to the word class. This indicates you should break out functionality into a new class
