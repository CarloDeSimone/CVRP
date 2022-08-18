clear, close, clc

directory_filename = 'A-n44-k6.vrp';              %directory of the problem instance
%reading of certain data of the instance, look at "read_instance.m"
[n,k,Q,optim_val,coordinates_M,demand_V,depot] = read_instance(directory_filename);
%conversion of coordinates matrix to distance matrix, look at "from_coord_to_distance_matrix.m" 
dist_M = from_coord_to_distance_matrix(coordinates_M,n);

%choice of the seeds maximizing the distance between the depot and each other, look at "seeds_selection.m"
seed_V = seeds_selection(n,k,depot,dist_M);

%formation of cluster of nodes from the seeds (seed_V) as a problem of generalized assignment, look at "assign_node_to_cluster.m"
clusters = assign_node_to_cluster(seed_V,n,k,Q,depot,demand_V,dist_M);

%if a feasible solution to cluster the nodes is found
if all(not(cellfun('isempty',clusters)))          
    is_feas = 1;                                  %setting a flag to 1 representing the correctness of the solution
    tour = zeros(n+k-1,1);                        %definition of the vector containing the solution to the CVRP
    pointer = 0;                                  %initialization of a pointer
    for i=1:k                                     %for each cluster (i), with i = 1,...,k
        cluster_size = numel(clusters{i});        %evaluation of the number of nodes belonging to clusters{i}
        cluster_indices = (1:cluster_size)';      %assignment of a label to each node
        %solution of TSP related to the nodes of (cluster){j}, look at "solve_TSP.m" |it is indispensable the use of new indices|
        route_indices = solve_TSP(cluster_indices,dist_M(clusters{i},clusters{i}));
        route = clusters{i}(route_indices);       %conversion of TSP solution to original indices     
        depot_index = find(route==depot);         %identification of depot index
        %sequence in (route) is ordered placing the depot as last element and it is copied in (tour) after the pointer
        tour(pointer+1:pointer+cluster_size) = [route(depot_index+1:end);route(1:depot_index)];
        pointer = pointer+cluster_size;           %pointer update
    end
    %computation of the tour length (L), look at "evaluate_tour.m"
    L_sol = evaluate_tour(tour,dist_M);
    RPD = 100*(L_sol-optim_val)/optim_val;        %Relative Percentage Deviation (RPD) calculation
%otherwise
else                                              
    is_feas = 0;                                  %setting a flag to 0 representing the incorrectness of the solution
    fprintf('Any feasible solution to the CVRP has been found\n') %display a comment
end

%if it has been found a solution and the number of routes to visualize is at most equal to 8
if is_feas==1 && k<=8                            
    plot_tour(tour,L_sol,k,n,depot,coordinates_M) %tour representation, look at "plot_tour.m"
%if otherwise it has been found a solution but the number of routes to visualize is bigger than 8
elseif is_feas==1
    fprintf('The solution to the CVRP has total length equal to %.4f \n',L_sol) %display a comment
end