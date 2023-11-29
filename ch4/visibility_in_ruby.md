implicit vs explicit receiver:
```ruby
class Trip
  def is_fun?
    fun_factor > 5 # fun_factor is called implicitly on self, the receiver
  end
  def is_fun?
    self.fun_factor.nil? ? 10 : fun_factor > 5 # doesn't work, defines receiver explicitly
  private
  def fun_factor; end
end
class ClassTrip < Trip
  def is_fun?
    fun_factor > 3 # subclasses have same rules for visibility as base class
  end
end
trip = Trip.new
trip.fun_factor # trip is the explicit receiver here, and this does not work
```
- private
  - can be called with implicit receiver within instance of Trip and subclasses
- public
  - visible everywhere
- protected
  - if `fun_factor` where protected, an instance of Trip can use self.fun_factor
  - `a_trip.fun_factor` can be called within classes of the same type as Trip
