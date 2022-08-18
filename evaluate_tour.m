%the length (L) of the tour associated to the sequence of node contained in
%(tour) is computed using the distance matrix

function L = evaluate_tour(tour,dist_M)

L = 0;                                    %initialization of the tour length
tour = [tour(end);tour];                  %copy and inserting tail of the tour at its beginning
for i=1:numel(tour)-1                     %at each iteration (i) the length of an arc covered by the tour is added, with i = 1,...,(end-1)
    L = L+dist_M(tour(i),tour(i+1));      %update of the tour length by the addition of the arc length between node (i) and (i+1) of the tour 
end

end