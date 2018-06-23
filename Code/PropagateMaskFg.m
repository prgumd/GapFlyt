function Mask = PropagateMaskFg(Mask, Dist1, FactorFg)
% Sol has [Alphax, Alphay; Betax, Betay]
% bwboundaries gives [r,c] which is [y,x]
% ImageCenter is not used as it cancels out

% Calculate Fg Mask
Mask = xor(imdilate(Mask, strel('disk', Dist1)),imdilate(Mask, strel('disk', Dist1*FactorFg))); 
end

