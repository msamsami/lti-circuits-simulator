function y = nodeVoltage (node, Y, B)        
    
    if node == 0
        y = 0;
    else
        newY = Y;
        newY (:, node) = B;
        y = det (newY) / det(Y);
    end
end