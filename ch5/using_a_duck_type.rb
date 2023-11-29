# interface of a Preparer is only prepare_trip that wants an instance of Trip
class Trip
  def prepare(preparers)
    preparers.each { |preparer| preparer.prepare_trip(self) }
  end
end

class Mechanic
  def prepare_trip(trip)
    trip.bicycles.each { |bike| prepare_bicycle(bike) }
  end
  def prepare_bicycle(bicycle)
    # ...
  end
end

class TripCoordinator
  def prepare_trip(trip)
    buy_food(trip.customers)
  end
  def buy_food(customer)
    # ..
  end
end

class Driver
  def prepare_trip(trip)
    gas_up(trip.vehicle)
    check_tires(trip.vehicle)
  end
  def gas_up(vehicle)
    # ...
  end
  def check_tires(vehicle)
    # ...
  end
end