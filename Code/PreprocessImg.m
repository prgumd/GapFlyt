function I = PreprocessImg(I, ResizeFrac)
I = imcrop(imresize(I, 0.8, 'bicubic'), [54, 1, 575, 384]);
I = imresize(imresize(I,1/ResizeFrac, 'bicubic'), ResizeFrac, 'bicubic');
end