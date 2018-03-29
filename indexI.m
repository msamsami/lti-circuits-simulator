function y = indexI (index, Y, B)
    newY = Y;
    newY (:, index) = B;
    y = det (newY) / det(Y);
end

