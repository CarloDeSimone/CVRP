%istance .vrp of set A from CVRPLIB is read and certain data are returned: 

% (n) --> number of nodes
% (k) --> number of available vehicle
% (Q) --> vehicle capacity (supposed the same for all)
% (optim_val) --> optimal value of the solution to the CVRP
% (coordinates_M)[n x 2] --> matrix of the spatial coordinates of the nodes
% (demand_V)[n x 1] --> vector of client demands
% (depot) --> index related to the depot

function [n,k,Q,optim_val,coordinates_M,demand_V,depot] = read_instance(directory_filename)

%reading of (k),(optim_val),(n) and (Q)
TEXT = readlines(directory_filename);                               %reading of the text from the file
comment_data = extract(TEXT(2),digitsPattern);                      %extraction of numerical values from the comment row:
k = double(comment_data(1));                                        % - the first number is (k)
optim_val = double(comment_data(2));                                % - the second number is (optim_val)
n = double(extract(TEXT(4),digitsPattern));                         %extraction of (n) from the row in which is written
Q = double(extract(TEXT(6),digitsPattern));                         %extraction of (Q) from the row in which is written

%reading of (coordinates_M)
start_coord_ind = find(contains(TEXT,'NODE_COORD_SECTION'));        %identification of the row containing a sentence about coordinates
coord_string = split(TEXT(start_coord_ind+1:start_coord_ind+n));    %reading of the next (n) lines
coordinates_M = str2double(coord_string(:,[3,4]));                  %saving in (coordinates_M) of the data

%reading of (demand_V)
start_demand_ind = find(contains(TEXT,'DEMAND_SECTION'));           %identification of the row containing a sentence about client demands
demand_string = split(TEXT(start_demand_ind+1:start_demand_ind+n)); %reading of the next (n) lines
demand_V = str2double(demand_string(:,2));                          %saving in (demand_V) of the data

%identification of (depot)
depot = find(demand_V==0);                                          %searching of the only node with demand equal to 0                

end