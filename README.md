# CVRP
A constructive heuristics for the Capacitated Vehicle Routing Problem (with fixed number of identical vehicles) is implemented in MATLAB.
A number of nodes equal to the number of vehicle is properly chosen as cluster seeds, then solving a Generalized Assignment Problem all the nodes are clustered, lastly each group of nodes defines a Travelling Salesman Problem and it is solved using an insertion-based heuristics concerning the minimization of extra mileage criterion.
