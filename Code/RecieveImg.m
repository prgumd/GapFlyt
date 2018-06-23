function Img = RecieveImg(ImageSub)
ImgMsg = receive(ImageSub, 10);
Img = readImage(ImgMsg);
end