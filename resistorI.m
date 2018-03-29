function y = resistorI (e1, e2, R, Y, B)        
    y = (nodeVoltage (e1, Y, B) - nodeVoltage (e2, Y, B)) / R;
end