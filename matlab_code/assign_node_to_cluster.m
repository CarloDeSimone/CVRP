%(k) clusters are generated solving a generalized assignement problem GAP
%that employ the vector of seeds (seed_V), the number of nodes (n) and
%vehicle (k), the capacity of each vehicle (Q), the depot index (depot),
%the client demands (demand_V) and the distance matrix (dist_M)

function clusters = assign_node_to_cluster(seed_V,n,k,Q,depot,demand_V,dist_M)

not_assigned_list = (1:n)';                               %generation of the list of nodes from (n)
not_assigned_list([depot;seed_V]) = [];                   %cancellation of depot and seeds from (not_assigned_list)
m = n-k-1;                                                %evaluation of the number of nodes to be assigned
cost_V = zeros(m*k,1);                                    %initialization of the vector of cost related to the GAP objective function
for i=1:k                                                 %for each cluster (i), i = 1,...,k
    cost_from_depot = dist_M(not_assigned_list,depot);    %evaluation of the cost to go from the depot to each node of (not_assigned_list)
    cost_from_seed = dist_M(not_assigned_list,seed_V(i)); %evaluation of the cost to reach seed (i) from each node of (not_assigned_list)
    cost_depot_to_seed = dist_M(depot,seed_V(i));         %evaluation of the cost to go from depot to seed (i)
    cost_V(m*(i-1)+1:m*i) = cost_from_depot+cost_from_seed-cost_depot_to_seed; %sum of the three components as an extra-mileage cost
end

%setting of inputs needed to define and solve an ILP problem
f = cost_V;                                               %copy of cost_V in f such that ((f)'*x) gives a scalar objective function
%definition of [m*k] decision variables, x(t) = 1 with (t = (c-1)*m+r) and (r < m) if node (r) of (not_assigned_list) is assigned to cluster (c) 
intcon = (1:m*k)';
%creation of (k) inequality constraints about the capacity, the total demand of the nodes composing each cluster must not overcome (Q)
A = kron(eye(k),demand_V(not_assigned_list)');  
b = Q*ones(k,1)-demand_V(seed_V); 
%creation of (m) equality constraints about the assignment, each node in (not_assigned_list) must be assigned to only one cluster 
Aeq = repmat(eye(m),1,k);
beq = ones(m,1);
%space definition of the decision variables (x), it is a binary variable therefore only 0 and 1 are allowed
lb = zeros(m*k,1);
ub = ones(m*k,1);
options = optimoptions('intlinprog','Display','off');     %setting options to not display any comment
%solution to the GAP
x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,options);       

clusters = cell(k,1);                                     %initialization of the cell array that will contain the clusters 
if ~isempty(x)                                            %if a feasible solution is found
    %conversion of the solution into a logical matrix, (x)(r,c) = 1 if node (r) of (not_assigned_list) is assigned to cluster (c) 
    x = reshape(x>0.5,m,k); 
    for i=1:k                                             %for each cluster (i), with i = 1,...,k
        clusters{i} = [not_assigned_list(x(:,i));seed_V(i);depot]; %copy of the elements composing cluster (i) into the cell array
    end
end