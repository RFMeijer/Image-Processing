function [thrImage, outputImage] = SkullStripFilter(image)

erodedImage = imerode(image, strel('disk', 1));

% threshold image
maxVal = max(image(:));
minVal = min(image(:));
threshold1 = minVal + ((maxVal - minVal) / 5);
threshold2 = minVal + (17 * (maxVal - minVal) / 20);
thrImage = erodedImage > threshold1 & erodedImage < threshold2;

se = strel('disk', 7); % get rid of magic number!!!
erodedImage = imerode(thrImage, se);
skullStripped = conditional_dilation(erodedImage, thrImage, strel('disk', 1), 100);

skullStripped = imclose(skullStripped, strel('disk', 25));
skullStripped = image .* skullStripped;

outputImage = skullStripped;

end
