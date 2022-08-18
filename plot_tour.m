%the solution to CVRP (tour) is plotted, every route travelled by a vehicle
%is colored differently, a title with the tour length (L) is also shown
%moreover:
% (n) --> number of nodes
% (k) --> number of available vehicle
% (depot) --> index related to the depot
% (coordinates_M)[n x 2] --> matrix of the spatial coordinates of the nodes

function [] = plot_tour(tour,L,k,n,depot,coordinates_M)

figure                                            %creation of a new window
plot(coordinates_M(depot,1),coordinates_M(depot,2),'ks','MarkerSize',10,'LineWidth',2) %representation of the depot with a black square
hold on,                                          %holding the window active
plot(coordinates_M([1:depot-1,depot+1:n],1),coordinates_M([1:depot-1,depot+1:n],2),'kd','LineWidth',2) %representation of the depot with black diamonds
legend_CVRP = {'depot';'clients'};                %initialization of the legend for the plot
colors = {'r';'g';'b';'c';'y';'m';'k';'#C0C0C0'}; %declaration of at most eight color
tour = [tour(end);tour];                          %copy and inserting tail of the tour at its beginning
depot_stops = find(tour==depot);                  %identification of depot visits
for i=1:k                                         %for each route (i) travelled by a vehicle, with i = 1,...,k
    %representation of the route that is between two consecutive depot visits
    plot(coordinates_M(tour(depot_stops(i):depot_stops(i+1)),1),coordinates_M(tour(depot_stops(i):depot_stops(i+1)),2),'Color',colors{i})
    legend_CVRP{i+2} = ['route ' num2str(i)];     %update of the legend with a new entry
end
legend(legend_CVRP)                               %plot of the legend
title(['Total tour length: ' num2str(L)])         %plot of a title reporting the length of the tour

end