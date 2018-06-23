function [ControlZBody, ControlYBody, ControlXBody, AlignFlag] =...
    ControlCommandServoWindowFast(ImgSize, SafePt, Kp, MovementPub, ForwardSpeed, StabilErr, AlignFlag)
ControlZBody = -Kp(1)*(SafePt(2) - ImgSize(1)/2);
ControlYBody = -Kp(2)*(SafePt(1) - ImgSize(2)/2);
ControlXBody = 0;

if(~AlignFlag)
if(norm([ControlYBody, ControlZBody])<=StabilErr)
    AlignFlag = 1;
    disp('Aligned! Moving Forward as I wanna go fast!');
    disp([Kp(3)*(ForwardSpeed),0,0.1]);
    MovementCmd(MovementPub, [Kp(3)*(ForwardSpeed),0,0.1,0,0,0]');
    pause(0.5);
else
    disp('Algining to the window!');
    disp(['StabilErr is ', num2str(norm([ControlYBody, ControlZBody]))]);
    disp([ControlXBody, ControlYBody, ControlZBody]);
    MovementCmd(MovementPub, [ControlXBody,ControlYBody,ControlZBody,0,0,0]');
    pause(0.5);
end
else
    disp('Aligned! Moving Forward as I wanna go fast!');
    disp([Kp(3)*(ForwardSpeed),0,0.1]);
    MovementCmd(MovementPub, [Kp(3)*(ForwardSpeed),0,0.1,0,0,0]');
    pause(0.5);
end
disp(['Align Flag ', num2str(AlignFlag)]);
end
