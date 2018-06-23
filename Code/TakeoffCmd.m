function TakeoffCmd(TakeOffPub)
    TakeOffMsg = rosmessage(TakeOffPub);
    send(TakeOffPub, TakeOffMsg);
end