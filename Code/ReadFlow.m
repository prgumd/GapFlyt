function [Flow, FlowMag, FlowAng] = ReadFlow(ImageNum, SkipNum)
% Model can be flownet2, flownet_s, flownet_c, flownet_cs, flownet_css, flownet_sd

ImagePath = 'Temp/';
WritePath = 'Output/';

if(~exist(ImagePath, 'dir'))
    mkdir(ImagePath);
    disp([ImagePath, ' created']);
end

if(~exist(WritePath, 'dir'))
    mkdir(WritePath);
    disp([WritePath, ' created']);
end

OutPath = GetFullPath(WritePath);
OutName = [num2str(ImageNum), 'and', num2str(ImageNum+SkipNum)];

% Read Flow from file and return
Flow = double(readFlowFile([OutPath, OutName, '.flo']));
FlowMag = sqrt(Flow(:,:,1).^2 + Flow(:,:,2).^2);
% FlowMag = abs(Flow(:,:,1)) + abs(Flow(:,:,2));
FlowAng = atan2(Flow(:,:,2), Flow(:,:,1));
disp(['Flow Read between ', num2str(ImageNum), ' and ', num2str(ImageNum+SkipNum)]);
end