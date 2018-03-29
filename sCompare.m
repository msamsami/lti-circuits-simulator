function [index, a] = sCompare (e1, e2, sMatrix)
    index = 0;
    a = 1;
    for i = 1:length (sMatrix)
        if sMatrix (i, 1) == e1 && sMatrix (i, 2) == e2
            index = sMatrix (i, 3);
            a = 1;
            break;
        elseif sMatrix (i, 1) == e2 && sMatrix (i, 2) == e1
            index = sMatrix (i, 3);
            a = -1;
            break;
        end
    end
end