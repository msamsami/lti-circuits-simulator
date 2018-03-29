function [index, a] = inductorCompare (e1, e2, L, sMatrix)
    index = 0;
    a = 1;
    for i = 1:length (sMatrix)
        if sMatrix (i, 1) == e1 && sMatrix (i, 2) == e2 && sMatrix (i, 3) == L
            index = sMatrix (i, 4);
            a = 1;
            break;
        elseif sMatrix (i, 1) == e2 && sMatrix (i, 2) == e1 && sMatrix (i, 3) == L
            index = sMatrix (i, 4);
            a = -1;
            break;
        end
    end
end