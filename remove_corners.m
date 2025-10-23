function [Xx] = remove_corners(edge_coord)

% remove corners to seperate edges into chains
% pixels having more than two neighbours are the corners

distance = 2^0.5;       % the max distance within which pixels are neighbours
Xx = edge_coord;
all_neighbours = rangesearch(Xx, Xx, distance);
chain_corners = (cellfun('length', all_neighbours) >= 4);
Xx(chain_corners, :) = [];
