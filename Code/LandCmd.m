function LandCmd(LandPub)
    LandMsg = rosmessage(LandPub);
    send(LandPub, LandMsg);
end