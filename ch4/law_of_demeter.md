Law of Demeter: an object can call methods on itself and an immediate neighbor. AKA use only one dot
```ruby
# imagine the following code exists in Trip
customer.bicycle.wheel.tire
# Trip has high knowledge of the behavior of several other classes now. It must know the customer responds to bicycle with something that responds to wheel, with something that responds to tire.
hash = # some hash
hash.keys.sort.join(', ') # this resembles a LoD violation, but is not one because of the Types of the intermediate objects in the chain
# hash.keys: Enumerable
# hash.keys.sort: Enumerable
# hash.keys.sort.join: String
```
