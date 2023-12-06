function [outputImage] = CSFSegmentation(image, skullStripped)

maskedImage = image .* skullStripped;

% Does not work yet.

[minimum, nrPeaks] = LocalMinimum(maskedImage, 6, 0.2);

% if minimum > 0.25 || minimum < 0
%     maxVal = max(image(:));
%     minVal = min(image(:));
%     threshold = minVal + ((maxVal - minVal) / 6);
% else
%     threshold = minimum;
% end
threshold = minimum;

csfSegIm = maskedImage < threshold;
csfSegIm = csfSegIm - imcomplement(skullStripped);

outputImage = csfSegIm;

end
