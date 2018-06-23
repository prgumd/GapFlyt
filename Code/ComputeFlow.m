function ComputeFlow(Imgs, ImageNum, SkipNum, Model, ResizeFrac)
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

% Save the two images into Temp/
I1 = PreprocessImg(Imgs{ImageNum}, ResizeFrac);
imwrite(I1, [ImagePath, sprintf('frame_%04d', ImageNum), '.png']);
I2 = PreprocessImg(Imgs{ImageNum+SkipNum}, ResizeFrac);
imwrite(I2, [ImagePath, sprintf('frame_%04d', ImageNum+SkipNum), '.png']);

FileName1 = GetFullPath([ImagePath, sprintf('frame_%04d', ImageNum), '.png']);
FileName2 = GetFullPath([ImagePath, sprintf('frame_%04d', ImageNum+SkipNum), '.png']);
OutPath = GetFullPath(WritePath);
OutName = [num2str(ImageNum), 'and', num2str(ImageNum+SkipNum)];
FullCurrPath = GetFullPath('flownet2-tf/');
SystemCmd = ['cd ', FullCurrPath, ' && python -m  src.', Model, '.test --input_a ', FileName1,...
    ' --input_b ', FileName2, ' --out ', OutPath, ' --outname ', OutName, ' && cd ..'];
system(['echo ', '"', SystemCmd, '"', ' >> RunFlowNet2.sh']);
disp(['Flow computed between ', num2str(ImageNum), ' and ', num2str(ImageNum+SkipNum)]);
end