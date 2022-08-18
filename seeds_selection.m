%data contained in the distance matrix (dist_M), information about the 
%number of nodes (n), vehicles (k) and depot index (depot) are used to 
%select the seeds from which the clusters of clients will be generated

function seed_V = seeds_selection(n,k,depot,dist_M)

seed_V = zeros(k,1);                        %initialization of the vector that will contain the selected (k) seeds
not_selected_list = [1:depot-1,depot+1:n]'; %creation of the vector of clients not selected yet
for i=1:k                                   %every iteration (i) a client is chosen as seed, with i = 1,...,k
    %extraction of the distance matrix between the nodes of not selected list and the elements of an array containing the depot and the seeds already selected
    dist_seed_depot = dist_M(not_selected_list,[depot;seed_V(1:i-1)]);
    %calculation of the node more distant from the depot and the other seed already selected by taking the maximum value of the minimum row by row of (dist_seed_depot)
    [~,choice] = max(min(dist_seed_depot,[],2)); 
    seed_V(i) = not_selected_list(choice);  %evaluation of the seed from (choice)
    not_selected_list(choice) = [];         %removal of the client selected as seed from (not_selected_list)
end   

end