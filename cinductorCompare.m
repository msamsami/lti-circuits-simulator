function [index, a] = cinductorCompare (e1, e2, m, n, sMatrix, chandomi)
    index = 0;
    a = 1;
    
    for i = 1:length (sMatrix)
        if sMatrix (i, 1) == e1 && sMatrix (i, 2) == e2
            
            if sMatrix (i, 3) == m && sMatrix (i, 4) == n
                
                if chandomi == 1
                    index = sMatrix (i, 5);
                elseif chandomi == 2
                    index = sMatrix (i, 6);
                end
                a = 1;
                break;
                
            end

            if sMatrix (i, 3) == n && sMatrix (i, 4) == m
                
                if chandomi == 1
                    index = sMatrix (i, 5);
                    a = 1;
                elseif chandomi == 2
                    index = sMatrix (i, 6);
                    a = -1;
                end
                break;
                
            end
            
        elseif sMatrix (i, 1) == e2 && sMatrix (i, 2) == e1

             if sMatrix (i, 3) == m && sMatrix (i, 4) == n
                
                if chandomi == 1
                    index = sMatrix (i, 5);
                    a = -1;
                elseif chandomi == 2
                    index = sMatrix (i, 6);
                    a = 1;
                end
                break;
                
            end

            if sMatrix (i, 3) == n && sMatrix (i, 4) == m
                
                if chandomi == 1
                    index = sMatrix (i, 5);
                elseif chandomi == 2
                    index = sMatrix (i, 6);
                end
                a = -1;
                break;
                
            end

            
        end
    end
end