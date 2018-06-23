FlowMagStacked = double(FlowMag{1});
for count = 2:length(Flow)
    FlowMagStacked = cat(3, FlowMagStacked, double(FlowMag{count}));
end
FlowMagStackedMean = mean(FlowMagStacked, 3);
FlowMagStackedMean = FlowMagStackedMean.^-1;

GradStackedMean = imgradient(FlowMagStackedMean);
[GradStackedMeanEdge, Thresh] = edge(medfilt2(GradStackedMean), 'canny');

figure,
imagesc(FlowMagStackedMean./max(FlowMagStackedMean(:)));
colormap jet
axis equal
title('Inv FlowMagStackedMean');
