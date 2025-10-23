function [all_cond_sep] = segments(all_chain_coord)
% function for seperating each chain into linear segments
% segments may be composed of one or more pixels
% neighbouring pixels having the same x or same y value makes linear segments

for i = 1:length(all_chain_coord)                % i: chain index
	current_chain = all_chain_coord{i};
	
	k = 1;                                       % k: segment index of a specific chain
	cond_seperated = current_chain(1, :);        % store the first pixel of first chain into an array
	all_seperated{1, 1} = cond_seperated;        % store that array into a cell (which refers to that chain)
	
	current_x(1) = current_chain(1, 1);          % x value of the first pixel
	current_y(1) = current_chain(1, 2);          % y value of the first pixel
	
	for j = 2:length(current_chain)                          % j: pixel index
		current_x(j) = current_chain(j, 1);                   % x value of the first pixel
		current_y(j) = current_chain(j, 2);                   % y value of the first pixel
		q1 = isequal(current_x(j), current_x(j - 1));         % check if the succesive pixels have the same x
		q2 = isequal(current_y(j), current_y(j - 1));         % check if the succesive pixels have the same y
		
		if q1 || q2 == 1                                                % if q1 or q2 is true
			cond_seperated = [cond_seperated; current_chain(j, :)];     % store the current pixel in the same array
			all_seperated{1, k} = cond_seperated;                        % array into the same cell as before
			
		elseif q1 || q2 == 0                                            % if not true
			cond_seperated = current_chain(j, :);                       % start with a new array
			k = k + 1;                                                  % index increases one, a new segment starts
			all_seperated{1, k} = cond_seperated;                       % new array is stored in the same cell
		end
	end
	all_cond_sep{i} = all_seperated;                                    % seperated linear segments belonging i th chain
	cond_seperated = [];                                                % empty the array
	all_seperated = [];                                                 % empy the cell for the next chain
end 
		

