

function [y, z] = findNodes (semiIndex, inp)  
    for i = semiIndex:length (inp)
       if isequal (inp (i), ')') == 1
           
           for j = 1:i-semiIndex-1
               z (j) = inp (semiIndex + j);
           end
           z = str2num (z);
           break;
       end
    end
    
    for i = semiIndex:-1:semiIndex-5
       if isequal (inp (i), '(') == 1
           
           for j = 1:semiIndex-i-1
               y (j) = inp (i + j);
           end
           y = str2num (y);
           break;
       end
    end
end