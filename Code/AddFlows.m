FlowMagStacked = double(FlowMag{1});
for count = 2:length(Flow)
    FlowMagStacked = cat(3, FlowMagStacked, double(FlowMag{count}));
end
FlowMagStackedMean = mean(FlowMagStacked, 3);

GradStackedMean = imgradient(FlowMagStackedMean);
[GradStackedMeanEdge, Thresh] = edge(medfilt2(GradStackedMean), 'canny');

figure,
imagesc(FlowMagStackedMean./max(FlowMagStackedMean(:)));
colormap jet
axis equal
title('FlowMagStackedMean');

% figure,
% imagesc(GradStackedMean);
% colormap jet
% axis equal
% title('GradStackedMean');

% figure,
% imshow(Imgs{StartFrame});
% hold on;
% imshow(GradStackedMeanEdge);
% axis equal
% alpha(0.5);
% title('GradStackedMeanEdge');