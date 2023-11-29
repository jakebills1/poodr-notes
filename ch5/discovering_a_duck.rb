class Trip
  attr_reader :bicycles, :customers, :vehicle

  def prepare(mechanic) # mechanic could be anything that responds to prepare_bicycles
    mechanic.prepare_bicycles(bicycles)
  end
  # ...
end

class Mechanic 
  def prepare_bicycles(bicycles)
    bicycles.each { |bike| prepare_bicycle(bike) }
  end
  def prepare_bicycle(bicycle)
    # ...
  end
end


# more requirements could make moving to a duck type more practical

class Trip 
  # preparing a trip now requires more items to prepare
  def prepare(preparers) # this method now expacts an array of objects, specific to certain classes, that may respond to prepare_bicycles, buy_food, gas_up_car, etc
    preparers.each do |preparer|
      case preparer # checking the class of an object may be an indication to use a duck type instead.
        # other clues you want duck-typing: using is_a?, kind_of?, responds_to?
      when Mechanic
        preparer.prepare_bicycles(bicycles)
      when TripCoordinator
        preparer.buy_food(customers)
      when Driver
        preparer.gas_up_car(vehicle)
      end
    end
  end
end