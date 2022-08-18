%data contained in the matrix of spatial coordinates (coordinates_M) about
%the (n) nodes are converted into a distance matrix (dist_M)[n x n]

function dist_M = from_coord_to_distance_matrix(coordinates_M,n)

dist_M = zeros(n,n);       %initialization of the distance matrix
for i = 1:n                %for every column (i) of dist_M, i = 1,...,n
    %the column (i) of (dist_M) is filled with the euclidean distances between every node and node (i)
    dist_M(:,i) = sqrt(sum((coordinates_M-coordinates_M(i,:)).^2,2));
end

end
