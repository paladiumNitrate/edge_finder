clc
clear


contrast_ratio = 0.5;               % for Canny edge detector
b = 150;                            % # image pixels / # edge pixels (make it smaller for more edges. if too small, it may result infinite loop)
resolution = [240, 352];             % # of pixels of the image region of interest


path1 = 'C:\Users\ev\Desktop\matlab_work\find_straight\image\';    % path for camera MTF

[edgeCoord, binaryMask, imageDouble, imgOriginal] = prep_image(path1, b, contrast_ratio);

[Xy] = remove_corners(edgeCoord);

[allChainCoord] = pixel_chains(Xy);

[allCondSep] = segments(allChainCoord);

[allStraight] = connect_segments(allCondSep);

[all_long_straight, all_straight_edges, img] = eliminate_short(allStraight, binaryMask);

