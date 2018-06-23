function ImgData = DiagonalCmdWithImg(MovementPub, ImageSub)

% Move up to have enough space
for count = 1:10
    MovementCmd(MovementPub, [0,0,0.1,0,0,0]');
    pause(0.2);
end

ImgData{1} = RecieveImg(ImageSub);
pause(0.5);

% Diagonal
for count = 1:3
    MovementCmd(MovementPub, [0,-0.1,0.3,0,0,0]');
    pause(0.2);
end

ImgData{end+1} = RecieveImg(ImageSub);
pause(0.5);

for count = 1:3
    MovementCmd(MovementPub, [0,0.1,-0.3,0,0,0]');
    pause(0.2);
    if(count == 1)
        ImgData{end+1} = RecieveImg(ImageSub);
        pause(0.5);
    end
end

% ImgData{end+1} = RecieveImg(ImageSub);
pause(0.5);

end
