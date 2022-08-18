%the list of nodes (nodes) is solved as a Travelling Salesman Problem using
%a constructive heuristics that employ only the distance matrix (dist_M)
%and the ordererd sequence (tabu_list) is returned 

function tabu_list = solve_TSP(nodes,dist_M)

not_visited_list = nodes;                                     %copy of the list of nodes in a new vector that contains the nodes not visited yet 
n = numel(nodes);                                             %evaluation of the number of nodes
[~,linear_index] = min(dist_M+diag(inf(n,1)),[],'all');       %identification of the two nodes closest to each other |the information about these elements is saved using a linear index| 
[row,column] = ind2sub([n,n],linear_index);                   %conversion of the linear index into double subscript
tabu_list = [not_visited_list(row);not_visited_list(column)]; %creation of the partial tour using the two closest nodes 
not_visited_list([row;column]) = [];                          %cancellation of the two closest nodes from the list of nodes not visited yet
n = numel(not_visited_list);                                  %update of the number of nodes to visit

%insertion of missing nodes in (tabu_list) 
while n>0                                                     %until the number of nodes to visit (n) is greater than 0
    %the node to include is chosen
    insertion_cost_M = dist_M(not_visited_list,tabu_list);    %extraction of the elements of (dist_M) related to the distances between missing nodes and the ones already included in the tour
    [~,row] = min(min(insertion_cost_M,[],2));                %return of the index associated with the minimum value between minimum insertion cost of not visited nodes into the tour
    insertion = not_visited_list(row);                        %assigning the chosen node to a variable

    %choice of the arc to remove in order to include the node in the tour
    extra_mil_V = zeros(numel(tabu_list),1);                  %definition of the vector containing extra mileage information
    extra_mil_V(1) = dist_M(tabu_list(end),insertion)+dist_M(insertion,tabu_list(1))-dist_M(tabu_list(end),tabu_list(1)); %evaluation of the extra mileage of inserting the node chosen between the last and the first node in the partial tour
    for i = 2:numel(tabu_list)                                %every iteration (i) the extra mileage related to a different arc is computed, with i = 2,...,end
        extra_mil_V(i) = dist_M(tabu_list(i-1),insertion)+dist_M(insertion,tabu_list(i))-dist_M(tabu_list(i-1),tabu_list(i)); %evaluation of the extra mileage of inserting the node chosen between node (i-1) and (i) of the partial tour
    end
    [~,arc] = min(extra_mil_V);                               %identification of the arc to remove by finding the minimum of the extra mileage vector

    tabu_list = [tabu_list(1:arc-1);insertion;tabu_list(arc:end)]; %update of the partial tour
    not_visited_list(row) = [];                               %cancellation of the included node from the list of nodes not visited yet
    n = numel(not_visited_list);                              %update of the number of nodes to visit
end

end