
function y = findindex (sourceChar, searchChar, chandomi)
    index = 0;
    for i = 1:length (sourceChar)
        if sourceChar (i) == searchChar
            index = index + 1;
        end
        
        if index == chandomi
            y = i;
            break;
        end
    end 
end