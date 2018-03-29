function [y, z] = gyratorI (a, b, m, n, g1, g2, Y, B)
    y = 0;
    z = 0;
    
    v1 = nodeVoltage (a, Y, B) - nodeVoltage (b, Y, B);
    v2 = nodeVoltage (m, Y, B) - nodeVoltage (n, Y, B);
    
    y = -g2 * v2; %I1
    z = g1 * v1; %I2
end