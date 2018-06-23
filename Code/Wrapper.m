% Tested on Red Bebop 2 with TX2
% Use ControlCommandServoWindowFast for aligning first and  going through
% the window fast
% Use ControlCommandServoWindow for continuous alignment

clc
clear
close all

%% Initialize
% Kill old ros if running
% Setup
Setup;
try
    rosinit
catch
    rosshutdown
    pause(2);
    rosinit
end

%% Image Subscriber
ImageSub = rossubscriber('/bebop/image_raw');
pause(1);

%% All commands
% Create prototype to run takeoff, land and movement commands on Bebop 2
TakeOffPub = rospublisher('/bebop/takeoff','std_msgs/Empty');
LandPub = rospublisher('/bebop/land','std_msgs/Empty');
MovementPub = rospublisher('/bebop/cmd_vel', 'geometry_msgs/Twist');

%% Test Simple State Machine
% Take Off
TakeoffCmd(TakeOffPub);
pause(5);
% Gain Altitude to maintain the window in frame
AltGainCmd(MovementPub);
pause(2);
% Execute Diagonal and Capture Images
ImgData = DiagonalCmdWithImg(MovementPub, ImageSub);

%% Display Images as a Montage
ImgMontage = cat(4, ImgData{:});
figure,
montage(ImgMontage);

%% Compute Flow
% Write Frames
NumFrames = length(ImgData);
ComputeFlowWrapper;

%% Add Flows
AddInvFlows;

%% Filtering
Filtering;
pause;

%% Saving
if(SaveFlag)
    Path = 'Data/';
    if(~exist(Path, 'dir'))
        mkdir(Path);
    end
    Name = 'DataWorking.mat';
    save([Path,Name]);
    system(['cp -r Output/*   ', Path]);
    system(['cp -r Temp/*   ', Path]);
end

%% Compute Fg and Bg
Dist1 = 35;
FactorFg = 3;
% Go forward after norm error of Y and Z is lower than this
StabilErr = 0.07; 
NumSteps = 35;
Kp = [0.003, 0.003, 0.01];
ForwardSpeed = 40;
AlignFlag = 0;
MasksFg = xor(imdilate(Boundary, strel('disk', Dist1)),imdilate(Boundary, strel('disk', Dist1*FactorFg)));

I1RGB = PreprocessImg(ImgData{1}, ResizeFrac);
I1 = rgb2gray(I1RGB);
ImageSize = size(I1);

C = detectMinEigenFeatures(I1, 'MinQuality',1e-4);
LocFg = ExtractCornersInMask(C.Location, MasksFg, ImageSize);
MasksBoundary = Boundary;

% Point Trackers
% Foreground
pointTrackerFg = vision.PointTracker('MaxBidirectionalError', 1);
initialize(pointTrackerFg, LocFg, I1);

for count = 1:NumSteps
    I2RGB = PreprocessImg(RecieveImg(ImageSub), ResizeFrac);
    I2 = rgb2gray(I2RGB);
    
    try
        % Foreground
        matchedPoints1Fg = LocFg;
        [x0Fg, y0Fg, matchedPoints1Fg, matchedPoints2Fg, SolFg] = ComputeFOE(matchedPoints1Fg, I2, pointTrackerFg);
        [ShiftedBoundary, MasksBoundary] = PropagateMaskBoundary(MasksBoundary, [x0Fg, y0Fg], SolFg, ImageSize);
        MasksFg = PropagateMaskFg(MasksBoundary, Dist1, FactorFg);
        
        % Compute Safe Point
        [yFg, xFg] = ind2sub(ImageSize,find(MasksFg));
        SafePtFg = [median(xFg), median(yFg)];
        
        figure(10)
        clf
        imshow(I2RGB);
        hold on;
        plot(matchedPoints2Fg(:,1), matchedPoints2Fg(:,2), 'r.');
        plot(x0Fg, y0Fg, 'g*','MarkerSize', 20);
        imagesc(MasksFg);
        scatter(SafePtFg(1), SafePtFg(2), 10, 'g', 'filled');
        colormap jet
        alpha(0.5);
        axis auto
        title(count);
        drawnow;
        
        SafePt = SafePtFg;
        
        if(length(matchedPoints2Fg(:,1))>20)
            [ControlZBody, ControlYBody, ControlXBody, AlignFlag] = ...
                ControlCommandServoWindowFast(ImageSize, SafePt, Kp, MovementPub, ForwardSpeed, StabilErr, AlignFlag);
%                 [ControlZBody, ControlYBody, ControlXBody] =  ...
%         ControlCommandServoWindow(ImgSize, SafePt, Kp, MovementPub, ForwardSpeed);
        else
            disp('Moving Forward due to insufficient number of points');
            MovementCmd(MovementPub, [Kp(3)*(ForwardSpeed),0,0,0,0,0]');
        end
        
        % Update everything for next set
        I1 = I2;
        LocFg = matchedPoints2Fg;
        setPoints(pointTrackerFg, matchedPoints2Fg);
        disp(['Step ', num2str(count)]);
    catch
        disp(['Step ', num2str(count)]);
        disp('Moving Forward as I lost track of everything');
        MovementCmd(MovementPub, [Kp(3)*(ForwardSpeed),0,0,0,0,0]');
    end
end

LandCmd(LandPub);

%% Save Data
if(SaveFlag)
    Path = 'Data/';
    if(~exist(Path, 'dir'))
        mkdir(Path);
    end
    Name = 'DataWorking.mat';
    save([Path,Name]);
    system(['cp -r Output/*   ', Path]);
    system(['cp -r Temp/*   ', Path]);
end
