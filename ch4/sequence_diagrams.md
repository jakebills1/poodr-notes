Sequence Diagrams are an aspect of Unified Modeling Language allowing prototyping of message passing behavior between domain objects.
In the example of a company that rents bikes and organizes tours for people, the following could be a sequence diagram:
- Moe, an instance of a Customer, sends the message suitable_trips with the parameters on_date, of_difficulty, need_bike to the Trip class
  - Its reasonable to say Trip should be concerned with finding a trip of a certain difficulty on a day, but it raises the question: Should it also be responsible for finding a bicycle for the trip?

The question at the heart of this process is: This is the message, who should respond to it?

If we wanted a Bicycle class to respond to the message suitable_bicycle with parameters trip_date, and route_type, that looks like:
- moe sends the message suitable_trip with arguments on_date and of_difficulty and receives a list of trips matching the parameters
  - For each trip, moe sends the message suitable_bicycle to Bicycle with the arguments trip_date and route_type

In this iteration, Moe knows
- he wants a list of trips
- there is an object implementing the suitable_trips message
- a suitable trip requires finding a bicycle to match
- an object responds to the suitable_bicycle message

This represents a transferrance of responsibilities that may have lied with Trip before to Customer. The Customer is defining the interaction between classes to get the end result.

Another example, preparing bicycles for a trip:
- an instance of Trip has many bicycles
- For each bicycle, it sends clean_bicycle(bike) to an instance of Mechanic
- then pump_tires(bike)
- then lube_chain(bike)
- check_brakes(bike)

In this iteration, Trip knows more about bike maintenance than Mechanic. New requirements in maintenance will be reflected in Trip as much as in Mechanic

A better interaction would be:
- an instance of trip iterates over it's bicycles
- for each bicycle it sends the message prepare_bicycle(bike) to Mechanic
  - Mechanic knows the implementation details to prepare a bicycle and returns a prepared bicycle once done

The interaction went from defined by How (to prepare a bicycle do the following) to What (I need a prepared bicycle)

Context: a Trip always involves preparing bicycles so Trip always expects to send the message prepare_bicycle to Mechanic
  In order to function, a trip must have this context
  To reuse Trip, it must have an object that responds to the message prepare_bicycle

Making Trip more independant requires redefining what it wants. It wants to be prepared, not to prepare bicycles specifically

A more context independant design would be
- Trip calls prepare_trip with itself as an argument on Mechanic
- Mechanic calls its own method prepare_bicycle for each bicycle exposed in the public interface of Trip

This improvements went from:
- "I know what I want and I know how you do it" to
- “I know what I want and I know what you do” to
- “I know what I want and I trust you to do your part.”


The example of the Customer and the Trip was missing another object to define interactions between Trip and Bicycle instead of leaving that to Customer
- moe, an instance of Customer, sends the message suitable_trips with the parameters on_date, of_difficulty, need_bike to TripFinder
- TripFinder sends the message suitable_trips with the arguments on_date, of_difficulty to Trip
- For each trip found, it sends the message suitable_bicycle with the arguments trip_date and route_type to Bicycle
- It returns the results to Moe
