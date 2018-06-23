function DisplayFrames(Imgs)
for  count = 1:length(Imgs)
    imshow(Imgs{count});
    title(count);
    drawnow;
end
end