function AltGainCmd(MovementPub)
for count = 1:10
MovementCmd(MovementPub, [0,0,0.1,0,0,0]');
pause(0.2);
end
end
