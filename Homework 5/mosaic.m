%--------------------------------------------------------------------------
% NAME       : Milan Bui
% INSTRUCTOR : Prof. Hwang
% COURSE     : CSI 4116.01
% DATE       : 30 November 2022
% ASSIGNMENT : Homework 5
% FILE       : mosaic.m
% DESCRIPTION: Load images, select matching points, compute a homography,
%              apply it to a new point from the first image, and stitch a 
%              mosaic from the two images.
%              
%              INPUTS:
%              img1 - image 1 ('from' image)
%              img2 - image 2 ('to' image)
%              PA   - Nx2 matrix. Each row is the (x,y) coordinate in image
%                     1 of the matching points
%              PB   - Nx2 matrix. Each row is the (x,y) coordinate in image
%                     2 of the matching points
%
%              OUTPUTS:
%              canvas - resulting mosaic as a result of stitching the two
%                       images after applying the homography
%
%   *NOTE: image coordinates x = columns and image coordinates y = rows
%--------------------------------------------------------------------------

function [canvas] = mosaic(img1, img2, PA, PB)

    % Computes homography
    H = estimate_homography(PA, PB);

    numRows = size(img2, 1); % # of rows in the matrix
    numCols = size(img2, 2); % # of cols in the matrix

    % Creates new canvas and places image 2 in the center
    canvas = uint8(zeros(3*numRows, 3*numCols, 3));
    canvas(numRows:2*numRows-1, numCols:2*numCols-1, :) = img2;

    % for all pixels in image 1
    for x = 1 : width(img1)        % x = cols
        for y = 1 : height(img1)   % y = rows

            p1 = [x, y];  % current pixel's image coordinates

            % Applies the homography
            p2 = apply_homography(p1, H);

            % Rounds up and down for x and y and adds offset from canvas
            xFloor = floor(p2(1,1)) + numCols;
            xCeil = ceil(p2(1,1)) + numCols;
            yFloor = floor(p2(1,2)) + numRows;
            yCeil = ceil(p2(1,2)) + numRows;

            % Switch x and y as image coordinate x = col and y = row
            % Places pixel of image 1 into the canvas (stitching mosaic)
            canvas(yFloor, xFloor, :) = img1(y, x, :);  
            canvas(yFloor, xCeil, :) = img1(y, x, :); 
            canvas(yCeil, xFloor, :) = img1(y, x, :); 
            canvas(yCeil, xCeil, :) = img1(y, x, :); 
        end
    end
end