function Imgs = ExtractImgs(ROSMsgs)
for count = 1:length(ROSMsgs)
    Imgs{count} = im2double(readImage(ROSMsgs{count}));
end
end