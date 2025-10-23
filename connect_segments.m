function [all_straight] = connect_segments(all_cond_sep)
% function for connecting the neighbouring linear segments
% two neighbouring segments are connected if the inner conditions are the same
% next segment (third or more) is connected if both inner and transition conditions are the same

for i = 1:length(all_cond_sep)               
	k = 0;                                      % number of segments connected
	current_chain = all_cond_sep{i};            % seperated linear segments (array of pixels) of one chain
	trans_conditions = [];
	all_connected = {};
	connected = [];
	for j = 1:length(current_chain)             % j: segment index of a chain
		current_segment = current_chain{j};      % take one segment (array)
		current_center = (current_segment(1, :) + current_segment(end, :)) / 2;
		if size(current_segment, 1) == 1        % if segment is one pixel
			inner_cond{j} = [0 0];              % inner condition of that segment is
		else                                    % if size is bigger than one pixel
			inner_cond{j} = current_segment(2, :) - current_segment(1, :); % inner condition is the difference of neighbouring pixels
		end
		if k == 0                                % if there is no previous segment
			connected = current_segment;         % store the segment in connected without considering any condition
			k = k + 1;                           % k becomes 1, meaning that first segment is stored
		elseif k == 1                            % if there is one segment allready
			prev_segment = current_chain{j - 1}; % dont worry j cant be 1 when k is 1
			prev_center = (prev_segment(1, :) + prev_segment(end, :)) / 2; % center of the previous segment for trans condition
			trans_cond = atand((current_center(2) - prev_center(2)) / ...
				(current_center(1) - prev_center(1)));             % transition condition between neighbouring segments
			if isequal(inner_cond(j), inner_cond(j - 1)) == 1      % for the second segment to be connected
				connected = [connected; current_segment];          % inner conditions must be the same
				k = k + 1;                                         % k becomes 2, meaning two segments connected
				trans_conditions = trans_cond;                     % store trans conditions of a particular chain into an array
			else                                                   % if inner condition is not the same with the previous one
				if size(prev_segment, 1) == 1                      % if previous segment is made of one pixel
					connected = [connected; current_segment];      % connect them
					k = k + 1;                                     % number of segments increased
					trans_conditions = trans_cond;                 % store the transition condition (there is only one) for later use
				else                                               % if the size is bigger than one
					all_connected = [all_connected connected];     % store the connected segments up to here (there is one) into the cell
					connected = current_segment;                   % start with a new connected and store the current segment
					k = 1;                                         % now there is one segment
				end
			end
		elseif k > 1                                               % if there is more than one segment connected
			prev_segment = current_chain{j - 1};
			prev_center = (prev_segment(1, :) + prev_segment(end, :)) / 2;
			trans_cond = atand(current_center(2) - prev_center(2)) / ...
				(current_center(1) - prev_center(1));             % last two transition conditions should be compared for another connection
			cond1 = isequal(inner_cond(j), inner_cond(j - 1));     % inner condition comparison
			cond2 = abs(trans_cond - trans_conditions(end)) < 10;    % transition condition comparison
			cond3 = (trans_cond * trans_conditions(end)) > 0;      % direction of the chain must not change
			if cond1 == 1 && cond2 == 1 && cond3 == 1
				connected = [connected; current_segment];          % to connect another segment
				k = k + 1;
				trans_conditions = [trans_conditions; trans_cond];  % transition condition is stored for the next loop
			elseif cond1 == 1 && cond2 ~= 1 && cond3 ~= 1          % if only inner conditions are met
				all_connected = [all_connected connected];         % store the line up to that segment
				connected = [prev_segment; current_segment];       % start with a new line with the previous segment
				k = 2;                                             % now there is line of two segments
				trans_conditions = trans_cond;                     % store the transition condition
			else                                                   % if no condition is met
				all_connected = [all_connected];                   % store the line up to that segment
				connected = current_segment;                       % start the new line with the current_segment
				k = 1;                                             % now there is a line of one segment
			end
		end
	end                                                            % after the last segment is processed
	all_connected = [all_connected connected];                     % store it to the connected segments of that chain
	all_straight{i} = all_connected;                               % store that with the same cell of connected segments of other chains
end
