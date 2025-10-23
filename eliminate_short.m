function [all_long_straight, all_straight_edges, img] = ...
    eliminate_short(all_straight, binary_mask)

all_long_straight = [];      % all the long edge pixel coordinates of image matrix (connected as one array)
all_straight_edges = {};     % all the long edge pixel coordinates stored seperately in a cell

for i = 1:length(all_straight)
	current_chain = all_straight{i};        % each chain
	for j = 1:length(current_chain)
		current_edge = current_chain{j};
		current_edge = sortrows(current_edge, 2);    % each edge in a spesific chain
        all_long_straight = [all_long_straight; current_edge];
        all_straight_edges = [all_straight_edges current_edge];
		
	end
end

% binary image containing all the straight long edges
image_dim = [size(binary_mask, 1) size(binary_mask, 2)];
img = zeros(image_dim);
x = all_long_straight(:, 1);
y = all_long_straight(:, 2);
idx = sub2ind(image_dim, y, x);
img(idx) = 1;
subplot(1, 2, 1)
imshow(img)
subplot(1, 2, 2)
imshow(binary_mask)
