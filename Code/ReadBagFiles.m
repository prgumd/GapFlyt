function [Imgs, TImgs, IMU] = ReadBagFiles(BagFilePath)
%% Read Bag Files
BagAll = rosbag(BagFilePath);

% Display all available bag names
disp('The following bags are available:');
disp(unique(BagAll.MessageList(:,2)));

% Read All Data (LeftCameraImgs and IMU data)
[Imgs, TImgs, IMU] = ReadData(BagAll);
end