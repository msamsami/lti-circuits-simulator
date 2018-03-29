%If we have an element between nodes a and b, this function would help us
%to find the second node (b)

function y = findSecondNode (i, j, inputz)  
    if isequal (inputz{i}{j+2}, ')') == 1
        y = str2num (inputz{i}{j+1});
    elseif isequal (inputz{i}{j+3}, ')')  == 1
        y = str2num ([inputz{i}{j+1} inputz{i}{j+2}]); 
    elseif isequal (inputz{i}{j+4}, ')')  == 1
        y = str2num ([inputz{i}{j+1} inputz{i}{j+2} inputz{i}{j+3}]);
    end
end