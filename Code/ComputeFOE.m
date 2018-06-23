function [x0, y0, matchedPoints1, matchedPoints2, Sol] = ComputeFOE(matchedPoints1, I2, pointTracker)
% ImageCenter is not used as it cancels out       
tic
[matchedPoints2, isFound] = step(pointTracker, I2);
toc

% Extract only valid points
matchedPoints1 = matchedPoints1(isFound, :);
matchedPoints2 = matchedPoints2(isFound, :);

% A for x
Ax = [matchedPoints2(:,1), -ones(length(matchedPoints2(:,1)),1)];
% B for x
Bx = matchedPoints2(:,1) - matchedPoints1(:,1);

Solx = Ax\Bx;
x0 = Solx(2)/Solx(1);

% Use Solx(1) for computing y0
y0 = mean(matchedPoints2(:,2) - (matchedPoints2(:,2) - matchedPoints1(:,2))./Solx(1));
% Sol has [Alphax, Alphay; Betax, Betay]
Sol = [Solx, Solx];
end