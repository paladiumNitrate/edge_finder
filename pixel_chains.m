function [all_chain_coord] = pixel_chains(Xx)

% function for registering chains into seperate arrays
% gather all the arrays in a cell

distance = 2^0.5;
all_neighbours = rangesearch(Xx, Xx, distance);
% pixels having one neighbour are the chain tips (small_possibility: no tip chains)
chain_tips = find(cellfun('length', all_neighbours) == 2);
all_chain_indice = {};
all_chain_coord = {};

% when registering, each element of the array must be closest one to the previous one
% each chain has two tips, number of chains = length(chain_tips) / 2

for i = 1:length(chain_tips) / 2

	current_tip = chain_tips(i);                       % index in all neighbours
	current_neighbour = all_neighbours{current_tip};   % neighbour of the tip
	num_of_neighbour = 3;                               % to start the while loop
	chain = [current_tip current_neighbour(2)];         % first two elements of the chain
	succesive_neighbours = {current_neighbour};        % first neighbour array of the first element
	while num_of_neighbour == 3
		
		current_neighbour = all_neighbours{chain(end)};                  % last elements neighbour
		succesive_neighbours = [succesive_neighbours current_neighbour]; % chain neighbours of succesive elements
		next_element = setdiff(succesive_neighbours{end}, ...
			succesive_neighbours{end - 1});                              % current one has, previous one doesnt have
		chain = [chain next_element];
		num_of_neighbour = length(current_neighbour);                    % when the tip is reached, it is 2, loop ends
	end
	end_tip = chain(end);
	q = chain_tips == end_tip;
	chain_tips(q) = [];          % remove the end tip from the chain tips
	
	% store all the chains
	all_chain_indice = [all_chain_indice chain];
	all_chain_coord = [all_chain_coord Xx(chain, :)];
end 
		
	

