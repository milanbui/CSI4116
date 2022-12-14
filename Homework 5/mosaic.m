%--------------------------------------------------------------------------
% NAME       : Milan Bui
% INSTRUCTOR : Prof. Hwang
% COURSE     : CSI 4116.01
% DATE       : 30 November 2022
% ASSIGNMENT : Homework 5
% FILE       : mosaic.m (SCRIPT)
% DESCRIPTION: Load images, select matching points, compute a homography,
%              apply it to a new point from the first image, and stitch a 
%              mosaic from the two images.
%   *NOTE: image coordinates x = columns and image coordinates y = rows
%--------------------------------------------------------------------------

% Reading in keble images
% img1 = imread('keble1.png');
% img2 = imread('keble2.png');

% Reading in uttower images
img1 = imread('uttower1.jpeg');
img2 = imread('uttower2.jpeg');

% % Correspondences (matching points)
% % kebl1
% PA = [165, 78; ...
%       154, 186; ...
%       327, 106; ...
%       354, 170; ...
%       340, 14; ...
%       271, 43];
% % keble2
% PB = [68, 88; ...
%       55, 198; ...
%       229, 123; ...
%       252, 186; ...
%       243, 34; ...
%       177, 57];

% uttower1
PA = [481, 310; ...
      328, 510; ...
      106, 507; ...
      108, 619; ...
      56, 176; ...
      129, 483; ...
      526, 537; ...
      375, 293];

% % uttower2
PB = [928, 331; ...
      782, 540; ...
      569, 545; ...
      578, 652; ...
      505, 232; ...
      585, 519; ...
      998, 567; ...
      816, 322];

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

% Saving the results
% imwrite(canvas, 'keble_mosaic.png');
imwrite(canvas, 'uttower_mosaic.png');

% Displays results as a figure
figure;
imshow(canvas);