%--------------------------------------------------------------------------
% NAME       : Milan Bui
% INSTRUCTOR : Prof. Hwang
% COURSE     : CSI 4116.01
% DATE       : 7 October 2022
% ASSIGNMENT : Homework 2
% FILE       : reduceWidth.m
%--------------------------------------------------------------------------
function reducedColorImage = reduceWidth(im, display_flag)
    
    % If the display_flag is not specified in the input, the default is False.
    if nargin < 2
        display_flag = false;
    end

    [num_rows, num_cols, num_channels] = size(im);
    
    % Compute the energy image and cumulative energy map
    Ix_kernel = [1 0 -1; 2 0 -2; 1 0 -1];
    Iy_kernel = [1 0 -1; 2 0 -2; 1 0 -1]';
    energyImage = energy_image(im, Ix_kernel, Iy_kernel);
    M = cumulative_minimum_energy_map(energyImage, 'VERTICAL');
    
    % Identify the seam
    vertical_seam = find_optimal_vertical_seam(M);
    assert(length(vertical_seam) == num_rows);
    
    % Initialize an empty image of the reduced size
    reducedColorImage = zeros([num_rows num_cols-1 num_channels]);
    
    for i = 1:num_rows
        for j = 1:num_channels
            % For each row i at channel j
            this_row = im(i, :, j);
            % Remove the pixel correponding to the seam
            this_row(vertical_seam(i)) = [];
            % Assign the reduced row to the reduced image at row i,
            % channel j
            reducedColorImage(i, :, j) = this_row;
        end      
    end
    
    % Typecast the image to be of uint8
    reducedColorImage = uint8(reducedColorImage);
    
    % If display_flag == 1, plot the energy image, cumulative energy map, and
    % the original image with the seam for visualization
    if display_flag 
        figure;
        subplot(1, 3, 1); imagesc(energyImage); axis image; title('Energy Map');
        subplot(1, 3, 2); imagesc(M); axis image; title('M')
        subplot(1, 3, 3); imshow(im); displaySeam(im, vertical_seam, 'VERTICAL');
        axis image; title('Seam');
    end

end