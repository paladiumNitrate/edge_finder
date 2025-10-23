function [edge_coord, binary_mask, image_double, image_original] = prep_image(path, b, contrast_ratio)

% read the image
% find the edges

crop_amount = 10;
folder_content = dir(path);
[~, ~, file_name] = folder_content.name;
full_path = [path, file_name];
file_to_process = imread(full_path);
image_original = mean(file_to_process, 3);
image_original = image_original(crop_amount:end - crop_amount, crop_amount:end - crop_amount);
image_original = uint8(image_original);
image_double = double(image_original);
binary_mask = edge(image_original, 'Canny', contrast_ratio);
binary_sum = sum(binary_mask(:));
img_pixels = size(image_original, 1) * size(image_original, 2);
q = img_pixels / b;

while binary_sum < q
	contrast_ratio = contrast_ratio - 0.01;
	binary_mask = edge(image_original, 'Canny', contrast_ratio);
	binary_sum = sum(binary_mask(:)) + 1;
end
	
% all the edge coordinates
[edge_row, edge_column] = find(binary_mask == 1);
edge_coord = [edge_column, edge_row];
