function y = vccsI (e1, e2, g, Y, B)
    y = g * (nodeVoltage (e1, Y, B) - nodeVoltage (e2, Y, B));
end