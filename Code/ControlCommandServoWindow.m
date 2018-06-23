function [ControlZBody, ControlYBody, ControlXBody] =...
        ControlCommandServoWindow(ImgSize, SafePt, Kp, MovementPub, ForwardSpeed)
ControlZBody = -Kp(1)*(SafePt(2) - ImgSize(1)/2);
ControlYBody = -Kp(2)*(SafePt(1) - ImgSize(2)/2);
ControlXBody = Kp(3)*(ForwardSpeed);
disp([ControlXBody, ControlYBody, ControlZBody]); 
MovementCmd(MovementPub, [ControlXBody,ControlYBody,ControlZBody+0.1,0,0,0]'); 
pause(0.5);
end

