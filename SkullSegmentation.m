function [outputImage] = SkullSegmentation(image, bgrSegIm)
% SKULLSEGMENTATION - Segment the skull in a T1-weighted image.
%
%   Input:
%   - image: Normalised T1-weighted greyscale image.
%   - bgrSegIm: Binary mask of the background segmentation.
%
%   Output:
%   - outputImage: Binary mask representing the segmented skull.
%
%   Description:
%   This function segments the skull in a T1-weighted image using a series
%   of morphological operations and thresholding techniques. It employs
%   erosion, dilation, and conditional dilation to refine the skull mask.
%
%   Authors:
%   Roos Meijer, Paula Del Popolo, Ellen van Hulst, Erik van Riel.
%   
%   Date of Submission:
%   December 14, 2023

D = Diagonal(image); % Diagonal of the image

% Create the threshold image
bgrRemoved = imcomplement(bgrSegIm);
skullEroded = imerode(bgrRemoved, strel('disk', round(0.0333*D))); % erosion based on diameter to remove part of skull
BrainMasked= image.*skullEroded;
thrImage = BrainMasked> 0.2353 & BrainMasked< 0.90; % threshold to create gap between skull and brain, and to remove high intensities

% Morphological filters to cover the whole brain and remove the skull
erodedImage= erode_max(thrImage,D); % erode as much as possible;
mask = conditional_dilation(erodedImage, thrImage, strel('disk',1),round(0.0167*D));
mask = imfill(mask,"holes");
mask = imopen(mask,strel('disk',round(0.0067*D)));
mask = bwareafilt(logical(mask),[140 size(image,1)*size(image,2)]);
mask = imclose(mask,strel('disk', round(0.0667*D)));
mask = imdilate(mask,strel('disk',round(0.0167*D)));
mask = imfill(mask,"holes");

% Take out only the skull
outputImage = image > 0.1569;
outputImage(mask==1)=0;
outputImage = bwareafilt(outputImage,[250 size(image,1)*size(image,2)]);
outputImage = outputImage & bgrRemoved; % Make sure one pixel can not be in the background and skull mask


end