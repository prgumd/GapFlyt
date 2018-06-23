function [Shifted, Masks] = PropagateMaskBoundary(Mask, FOE, Sol, ImageSize)
% Sol has [Alphax, Alphay; Betax, Betay]
% bwboundaries gives [r,c] which is [y,x]
% ImageCenter is not used as it cancels out

BoundaryList = bwboundaries(Mask);
Shifted = cell(length(BoundaryList), 1);
Masks = cell(length(BoundaryList), 1);
for count = 1:length(BoundaryList)
    Shifted{count} = round([Sol(1,1)*(BoundaryList{count}(:,2) - FOE(1)) + BoundaryList{count}(:,2),...
                            Sol(1,2)*(BoundaryList{count}(:,1) - FOE(2)) + BoundaryList{count}(:,1)]);
    Masks{count} = zeros(ImageSize);
    % Remove pixels outside Image
    ValidIdxs = Shifted{count}(:,1) <= ImageSize(2) & Shifted{count}(:,1) >= 1 & ...
                     Shifted{count}(:,2) <= ImageSize(1) & Shifted{count}(:,2) >= 1;
    
    Masks{count}(sub2ind(ImageSize, Shifted{count}(ValidIdxs,2),...
                                    Shifted{count}(ValidIdxs,1))) = 1;
    Masks{count} = filledgegaps(Masks{count}, 5);% Max 5 pixel tolerance
    Masks{count} = imfill(Masks{count}, 'holes');
end

if(length(BoundaryList) == 2)
   % For Fg
   Masks = xor(Masks{1}, Masks{2});  
elseif(length(BoundaryList) == 1)
   % For Bg
   Masks = Masks{1};
else
disp('Size is 3, something is wrong');
% This happens due to the bad corner case handling in filledgegaps
imshow(Masks);
pause;
end

end

