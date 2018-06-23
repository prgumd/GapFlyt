Flow = cell(NumFrames, 1);
FlowMag = cell(NumFrames, 1);
FlowAng = cell(NumFrames, 1);
% Clean the .sh file
system('echo "" > RunFlowNet2.sh');

tic
for count = 1:NumFrames-1
    ComputeFlow(ImgData, StartFrame, count*SkipNum, Model, ResizeFrac);
end
Timer1 = toc;

% Calculate All Flows
system('gnome-terminal -x /home/chahatdeep/WindowDetectionWithControlApril05/RunFlowNet2.sh & exit');
pause;

% Read All Flow
for count = 1:NumFrames-1
    [Flow{count}, FlowMag{count}, FlowAng{count}] = ReadFlow(ImageNum, count);
end

ImageSize = size(FlowMag{1});
