%--------------------------------------------------------------------------
% NAME       : Milan Bui
% INSTRUCTOR : Prof. Hwang
% COURSE     : CSI 4116.01
% DATE       : 11 November 2022
% ASSIGNMENT : Homework 4
% FILE       : quantizeRGB.m
% DESCRIPTION: Quantize a color space by applying k-means clustering to the
%              pixels. Replaces the RGB value at each pixel with the 
%              average Rgb value in the cluster to which that pixel belongs 
%              (mapping each pixel in the input image to its nearest k-means 
%              center). The RGB values are treated jointly as the 3D 
%              representation of the pixel. Use kmeans.
%              
%              INPUTS:
%              origImg - RGB image of class uint8
%              k       - number of colors to quantize to (num of clusters)
%
%              OUTPUTS:
%              outputImg   - RGB image of class uint8, quantized
%              meanColors  - kx3 array of k centers (one val for each
%                            cluster and each color channel)
%              clustersIds - numpixelsx1 matrix (with numpixels =
%                            numrows*numcolumns) that says to which cluster 
%                            each pixel belongs
%--------------------------------------------------------------------------
function [outputImg, meanColors, clusterIds] = quantizeRGB(origImg, k)
    % You may get a warning Warning: Failed to converge in 100 iterations. Do 
    % not worry about it. This just warns you that the kmeans could still be 
    % improved slightly if we let it run for longer by increasing MaxIter which
    % the default is 100.
    
    % Finds dimensions of image and calculates number of pixels
    numOfRows = height(rgb2gray(origImg));
    numOfCols = width(rgb2gray(origImg));
    numOfPixels = numOfRows * numOfCols;
    
    outputImg = origImg;
    
    % reshape reshapes origImg into a numOfPixels x 3 matrix.
    % rows = samples, columns = features. Each column = color channel
    X = reshape(origImg, [numOfPixels 3]);
    
    % performs kmeans clustering on image, resulting in clusterIds
    clusterIds = kmeans(double(X), double(k));
    meanColors = zeros(k, 3);
    
    % for each cluster
    for cluster = 1 : k
        % finds which pixels are in the current cluster
        clusterPixels = (clusterIds == cluster);

        % Obtains rgb values of pixels in cluster
        rValues = X(clusterPixels,1);
        gValues = X(clusterPixels,2);
        bValues = X(clusterPixels,3);
    
        % Calculates the mean of each rgb value
        rMean = mean(rValues);
        gMean = mean(gValues);
        bMean = mean(bValues);
        
        % Stores mean values in meanColors to return
        meanColors(cluster,1) = rMean;
        meanColors(cluster,2) = gMean;
        meanColors(cluster,3) = bMean;

        % Image is currently being evaluated by each pixel, not using xy
        % coordinates, so we need to convert from linear indices to xy
        [rows, cols] = ind2sub([numOfRows, numOfCols],find(clusterPixels));
    
        % for each pixel in the cluster, change value to the mean
        for index = 1 : size(rows)
            outputImg(rows(index), cols(index), 1) = rMean; 
            outputImg(rows(index), cols(index), 2) = gMean; 
            outputImg(rows(index), cols(index), 3) = bMean; 
        end
        
    end

end