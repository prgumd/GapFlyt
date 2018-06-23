function MovementCmd(MovementPub, Cmd)
    MovementMsg = rosmessage(MovementPub);
    MovementMsg.Linear.X = Cmd(1);
    MovementMsg.Linear.Y = Cmd(2);
    MovementMsg.Linear.Z = Cmd(3);
    MovementMsg.Angular.X = Cmd(4);
    MovementMsg.Angular.Y = Cmd(5);
    MovementMsg.Angular.Z = Cmd(6);
    send(MovementPub, MovementMsg);
end