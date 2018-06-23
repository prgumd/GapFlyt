tic
BW = GradStackedMeanEdge;
BW = imclose(BW,strel('disk', 21));
BW = imfill(BW,'holes');
BW = imerode(BW, strel('disk', 21));
BW = imdilate(BW, strel('disk', 15));
Stats = regionprops(BW, 'All');
MaxSolidity = max([Stats.Solidity]);
PercentToRemove  = 0.7;
% Find Largest Blob
Idxs = find([Stats.Solidity]>=0.65 & [Stats.Area]>=50);
L = bwlabel(BW);
BWNew = ismember(L, Idxs);
Stats = regionprops(BWNew, 'Area');
MaxArea = max([Stats.Area]);
L = bwlabel(BWNew);
Idxs = find([Stats.Area]==MaxArea);
Timer2 = tic + Timer1;
Boundary = ismember(L, Idxs);

figure,
imshow(PreprocessImg(ImgData{1}, ResizeFrac));
hold on;
imshow(Boundary);
axis equal
alpha(0.4);
