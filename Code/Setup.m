%% Load Camera Intrinsics and Camera to IMU Extrinsics
load('CalibParams.mat');

%% Flow Utils path
addpath('FlowReadWrite/');

%% Calculate Flow between
StartFrame = 1;
ImageNum = 1;
SkipNum = 1;
NumFrames = 2;
ResizeFrac = 1;

%% FlowNet Params
% Model can be flownet2, flownet_s, flownet_c, flownet_cs, flownet_css, flownet_sd
Model = 'flownet2';

%% Save All Data
SaveFlag = 1;


