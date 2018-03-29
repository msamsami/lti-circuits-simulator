
function y = capacitorI (e1, e2, C, Vc0, Y, B)
    syms s;
    y = (s*(nodeVoltage (e1, Y, B) - nodeVoltage (e2, Y, B)) - Vc0) * C;
end