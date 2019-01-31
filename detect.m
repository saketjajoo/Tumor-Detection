clc;
clearvars;
close all;
file = 'ok2.jpg';
imtool close all;
FontSize = 12;
initImage = imread(file);
[rows, columns] = size(initImage);
initImage = rgb2gray(initImage);
initImage = medfilt2(initImage,[10 10]);
[B, A] = imhist(initImage)
C=A.*B;
D=A.*A;
E=B.*D;
n=sum(B);
Mean=sum(C)/sum(B);
var=sum(E)/sum(B)-Mean*Mean;
std= (var)^0.5;
thresholdValue = Mean+0.5*std;
bwImage = initImage > thresholdValue;
figure
imshow(bwImage)
title('binary image');
img_dil = imdilate(bwImage , strel('arbitrary', 20));
figure
imshow(img_dil);
title('dilated image');
bwImage = imerode(img_dil , strel('arbitrary', 20 ));
figure
imshow(bwImage);
title('eroded image');
bigMask = bwareaopen(bwImage, 2000);
finalImage = bwImage;
finalImage(bigMask) = false;
bwImage=bwareaopen(finalImage,55);
figure
imshow(bwImage)
labeledImage = bwlabel(bwImage, 8);
RegionMeasurements = regionprops(labeledImage, initImage,
'all');
Ecc = [RegionMeasurements.Eccentricity];
RegionNo = size(RegionMeasurements, 1);
allowableEccIndexes = (Ecc< 0.98);
keeperIndexes = find(allowableEccIndexes);
RegionImage = ismember(labeledImage, keeperIndexes);
bwImage=RegionImage;
figure
imshow(RegionImage)
%%%%%
clear labeledImage;
clear RegionMeasurements;
clear RegionNo;
labeledImage = bwlabel(bwImage, 8);
RegionMeasurements = regionprops(labeledImage, initImage,
'all');
figure
imshow(initImage);
title('Outlines', 'FontSize', FontSize);
axis image;
hold on;
boundaries = bwboundaries(bwImage);
numberOfBoundaries = size(boundaries, 1);
for k = 1 : numberOfBoundaries
thisBoundary = boundaries{k};
plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth',
3);
end
hold off;
RegionMeas = regionprops(labeledImage, initImage, 'all');
RegionNo = size(RegionMeas, 1);
textFontSize = 14;
labelShiftX = -7;
RegionECD = zeros(1, RegionNo);
%fprintf(1,'Region number Area Perimeter Centroid
Diameter\n');
for k = 1 : RegionNo
RegionArea = RegionMeas(k).Area;
RegionPerimeter = RegionMeas(k).Perimeter;
RegionCentroid = RegionMeas(k).Centroid;
RegionECD(k) = sqrt(4 * RegionArea / pi);
fprintf(1,'#%2d %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k,
RegionArea, RegionPerimeter, RegionCentroid, RegionECD(k));
text(RegionCentroid(1) + labelShiftX, RegionCentroid(2),
num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold');
end