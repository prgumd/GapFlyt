function Loc = ExtractCornersInMask(Corners, Mask, ImageSize)
% C.Location has X, Y which is col, row
LocLinIdxs = sub2ind(ImageSize, round(Corners(:,2)), round(Corners(:,1)));
MaskIdxs = find(Mask(:));
MaskLocIdxs = ismember(LocLinIdxs, MaskIdxs);
Loc = Corners(MaskLocIdxs, 1:2);
end