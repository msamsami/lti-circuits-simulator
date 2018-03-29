% Basic Circuit Theory II Project
% MOHAMMAD MEHDI SAMSAMI [9232808]

clear all
clc
digits (4);

%--------------SETTING INPUT--------------
inputDir = 'inputz.dat';
%--------------SETTING INPUT--------------

if exist(inputDir, 'file')

else
    warningMessage = sprintf ('Warning! file does not exist :\n%s', inputDir);
    uiwait (msgbox (warningMessage));
    keyboard;
end

inp = fopen (inputDir, 'r'); 
c = fscanf (inp, '%s');
fclose (inp);

% _________________ READING THE INPUT _________________
index = 1;
flag = 0;
for i = 1:length (c)
    
    if isequal (c(i), '*') == 1
        
        if flag == 0
            Start = i;
            flag = 1;
        end
        
    end
    
    if isequal (c(i), '!') == 1 && flag == 1
                k = 1;

                for j = Start+1:i-1
                    inputz {index}{k} = c(j);
                    k = k+ 1;
                end
                flag = 0;
                index = index + 1; 
    end
         
end
% _________________ READING THE INPUT _________________



% _________________ DECLARING THE NUMBER OF NODES _________________
flag = 0;
bnode = 0;

for i = 1:length(inputz{1})
    if inputz{1}{i} == '#' 
        flag = flag + 1;
    end
    
    if flag == 2
        
        if i-1 == 4 
            nodes = str2num ([inputz{1}{3} inputz{1}{i-1}]); %number of nodes
        elseif i-1 == 5
            nodes = str2num ([inputz{1}{3} inputz{1}{i-2} inputz{1}{i-1}]);
        elseif i-1 == 3
            nodes = str2num (inputz{1}{3});
        end
        break;
        
    end
    
end
% _________________ DECLARING THE NUMBER OF NODES _________________

syms t %defining time domain variable

syms s %defining laplace domain variable

syms Y
syms B
%at the end the program will solve this equation :  Yx = B

for i = 1:nodes
    B (i, 1) = 0;
    for j = 1:nodes
        Y (i, j) = 0;
    end
end 

%----------Currents saving----------
indepV = sym ('0');
nindepV = 1;

inductorC = sym ('0');
ninductorC = 1;

shortBranchC = sym ('0');
nshortBranchC = 1;

VcontrolVSC = sym ('0');
nVcontrolVSC = 1;

CcontrolVSC = sym ('0');
nCcontrolVSC = 1;

coupledInductorC = sym ('0');
ncoupledInductorC = 1;
%----------Currents saving----------

inputzN = length (inputz);

%_________________ DECLARING THE OUTPUT _________________
doPlot = 0;
zeroInput = 0;
zeroState = 0;
if str2num (inputz {inputzN}{5}) == 1 %node voltage
    
    outputMode = 1;
    
    if str2num (inputz {inputzN}{7}) == 0 %zero input response
        zeroInput = 1; 
        zeroState = 0;
    elseif str2num (inputz {inputzN}{7}) == 1 %zero state response
        zeroInput = 0;
        zeroState = 1;
    else %complete response
        zeroInput = 0;
        zeroState = 0;
    end
    
    flag = 0;
    index = 0;
    j = 0;
    
    for i = 1:length (inputz {inputzN})
        
        if inputz {inputzN}{i} == '#' 
            flag = flag + 1;
        end
        
        if flag == 3 && index == 0
            index = i;
        elseif flag == 4 && j == 0
            j = i;
        end
        
    end
    
    tStr = ' ';
    for k = 1:j-index-1
       tStr(k) = inputz {inputzN}{k+index};
    end
    desiredE1 = str2num (tStr); %output Node number
    tStr = ' ';
    tStr (1) = inputz {inputzN}{j + 1};
    doPlot = str2num (tStr);

    
elseif str2num (inputz {inputzN}{5}) == 2 %branch voltage
    
    outputMode = 2;
    
    if str2num (inputz {inputzN}{7}) == 0 %zero input response
        zeroInput = 1; 
        zeroState = 0;
    elseif str2num (inputz {inputzN}{7}) == 1 %zero state response
        zeroInput = 0;
        zeroState = 1;
    else %complete response
        zeroInput = 0;
        zeroState = 0;
    end
    
    for i = 1:length (inputz {inputzN})
        if isequal (inputz{inputzN}{i}, ',')  == 1
            desiredE1 = findFirstNode (inputzN, i, inputz); %first node number (+)
            desiredE2 = findSecondNode (inputzN, i, inputz); %second node number (-)
            break;
        end
    end

    tStr = ' ';
    tStr (1) = inputz {inputzN}{length (inputz {inputzN})};
    doPlot = str2num (tStr);
    
elseif str2num (inputz {inputzN}{5}) == 4 %natural frequencies
    outputMode = 4;
    zeroInput = 1; 
    zeroState = 0;    
    
elseif str2num (inputz {inputzN}{5}) == 3 %branch current
    
    outputMode = 3;
    
    if str2num (inputz {inputzN}{7}) == 0 %zero input response
        zeroInput = 1; 
        zeroState = 0;
    elseif str2num (inputz {inputzN}{7}) == 1 %zero state response
        zeroInput = 0;
        zeroState = 1;
    else %complete response
        zeroInput = 0;
        zeroState = 0;
    end

    tStr = ' ';
    tStr (1) = inputz {inputzN}{length (inputz {inputzN})};
    doPlot = str2num (tStr);
    
    outputStr = ' ';
    for i = 9:length (inputz {inputzN}) - 2
        outputStr (i - 8) = inputz {inputzN}{i};
    end
    

    
elseif str2num (inputz {inputzN}{5}) == 5 %network function
    outputMode = 5;
    doPlot = str2num (inputz {inputzN}{7});
    zeroInput = 0;
    zeroState = 1;
    
    flag = 0;
    index = 0;
    j = 0;
    
    for i = 9:length (inputz {inputzN})
        
        if inputz {inputzN}{i} == '#' 
            flag = flag + 1;
        end
        
        if flag == 1 && index == 0
            index = i;
        elseif flag == 2 && j == 0
            j = i;
        end
        
    end
    
    tStr = ' ';
    for k = 9:index-1
       tStr(k - 8) = inputz {inputzN}{k};
    end
    INPUTP = sym (tStr); 
    INPUTP = laplace (INPUTP * exp(0*t), t, s); %input value (x)
    INPUTP = simplify (INPUTP);
    
    outputVarMode = str2num (inputz {inputzN}{index + 1});
    
    outputStr = ' ';
    for i = j+1:length (inputz {inputzN})
        outputStr (i - j) = inputz {inputzN}{i};
    end
end
%_________________ DECLARING THE OUTPUT _________________


for i = 1:length (inputz)
    
    % _________________ RESISTOR BETWEEN TOW NODES _________________
    if isequal (inputz{i}{1}, 'R') == 1
        tStr = ' ';
        flag = 0;
        for j = 1:length (inputz{i})
            if inputz{i}{j} == '#' 
                    flag = flag + 1;
            end
    
            if flag == 2
                index = length (inputz{i}) - j;
                for k = 1:index
                    tStr(k) = inputz{i}{k+j};
                end
                R = str2num (tStr); %value of resistor
                break;
            end
                    
            if isequal (inputz{i}{j}, ',')  == 1
                    a = findFirstNode (i, j, inputz);
                    b = findSecondNode (i, j, inputz);
            end
            
        end
            
        %__________ MAKING CHANGES IN Y MATRIX __________
        if R == 0
            
            temp = [0 0 1 ; 0 0 -1 ; 1 -1 -R];
            index = length(Y) + 1;
            B (index, 1) = 0;

            for j = 1:index
                Y (index, j) = 0;
                Y (j, index) = 0;
            end

            if a == bnode
                temp (1, :) = 0;
                temp (:, 1) = 0;
            end
            if b == bnode
                temp (2, :) = 0;
                temp (:, 2) = 0;
            end

            if temp (1, 3) ~= 0
                Y (a, index) = Y (a, index) + temp (1, 3);
            end
            if temp (2, 3) ~= 0
                Y (b, index) = Y (b, index) + temp (2, 3);
            end
            if temp (3, 1) ~= 0
                Y (index, a) = Y (index, a) + temp (3, 1);
            end
            if temp (3, 2) ~= 0
                Y (index, b) = Y (index, b) + temp (3, 2);
            end
            Y (index, index) = -R;
            
            shortBranchC (nshortBranchC, 1) = a;
            shortBranchC (nshortBranchC, 2) = b;
            shortBranchC (nshortBranchC, 3) = index;
            nshortBranchC = nshortBranchC + 1;
            
        else
            
            if a == bnode
                Y (b, b) = Y (b, b) + (1/R);
            elseif b == bnode
                Y (a, a) = Y (a, a) + (1/R);
            elseif a ~= 0 && b ~= 0 
                Y (a, a) = Y (a, a) + (1/R);
                Y (b, b) = Y (b, b) + (1/R);
                Y (a, b) = Y (a, b) - (1/R);
                Y (b, a) = Y (b, a) - (1/R);
            end
            
        end
        %__________ MAKING CHANGES IN Y MATRIX __________
        
    end
    % _________________ RESISTOR BETWEEN TOW NODES _________________
    
    
    % _________________ CAPACITOR BETWEEN TOW NODES _________________
    if isequal ([inputz{i}{1} inputz{i}{2}], 'C#') == 1
        tStr = ' ';
        flag = 0;
        for j = 1:length (inputz{i})
            
            if isequal (inputz{i}{j}, ',')  == 1
                    a = findFirstNode (i, j, inputz);
                    b = findSecondNode (i, j, inputz);                
            end
            
            if inputz{i}{j} == '#' 
                    flag = flag + 1;
                    
                    if flag == 2
                        index1 = j;
                    end
            end           
    
            if flag == 3
                if zeroState == 0
                    index = length (inputz{i}) - j;
                    for k = 1:index
                        tStr(k) = inputz{i}{k+j};
                    end
                    VCi = str2num (tStr); %value of initial voltage
                else
                    VCi = 0;
                end
                
                tStr = ' ';
                index = j - index1 - 1;
                for k = 1:index
                    tStr(k) = inputz{i}{k+index1};
                end
                C = str2num (tStr); %value of capacitor
                break;
            end        
            
        end
            
        %__________ MAKING CHANGES IN Y AND B MATRIX __________
        if a == bnode  
            Y (b, b) = Y (b, b) + s*C;
            B (b, 1) = B (b, 1) - C*VCi;
        elseif b == bnode
            Y (a, a) = Y (a, a) + s*C;
            B (a, 1) = B (a, 1) + C*VCi;
        else
            Y (a, a) = Y (a, a) + s*C;
            Y (b, b) = Y (b, b) + s*C;
            Y (a, b) = Y (a, b) - s*C;
            Y (b, a) = Y (b, a) - s*C;
            B (a, 1) = B (a, 1) + C*VCi;
            B (b, 1) = B (b, 1) - C*VCi;
        end
        %__________ MAKING CHANGES IN Y AND B MATRIX __________
 
    end
    % _________________ CAPACITOR BETWEEN TOW NODES _________________

    

    % _________________ INDUCTOR BETWEEN TOW NODES _________________
    if isequal ([inputz{i}{1} inputz{i}{2}], 'L#') == 1
        tStr = ' ';
        flag = 0;
        for j = 1:length (inputz{i})
            
            if isequal (inputz{i}{j}, ',')  == 1
                    a = findFirstNode (i, j, inputz);
                    b = findSecondNode (i, j, inputz);
            end
            
            if inputz{i}{j} == '#' 
                    flag = flag + 1;
                    
                    if flag == 2
                        index1 = j;
                    end
            end
    
            if flag == 3
                if zeroState == 0
                    index = length (inputz{i}) - j;
                    for k = 1:index
                        tStr(k) = inputz{i}{k+j};
                    end
                    ILi = str2num (tStr); %value of initial current
                else
                    ILi = 0;
                end
                
                tStr = ' ';
                index = j - index1 - 1;
                for k = 1:index
                    tStr(k) = inputz{i}{k+index1};
                end
                L = str2num (tStr); %value of inductor
                break;
            end
                    
        end
            
        %__________ MAKING CHANGES IN Y AND B MATRIX __________
        index = length(Y) + 1;
        B (index, 1) = -L*ILi;
        
        for j = 1:index
            Y (index, j) = 0;
            Y (j, index) = 0;
        end
        
        if a == bnode
            Y (index, b) = Y (index, b) - 1;
            Y (b, index) = Y (b, index) - 1;
        elseif b == bnode
            Y (index, a) = Y (index, a) + 1;
            Y (a, index) = Y (a, index) + 1;
        else
            Y (index, a) = Y (index, a) + 1;
            Y (index, b) = Y (index, b) - 1;
            Y (a, index) = Y (a, index) + 1;
            Y (b, index) = Y (b, index) - 1;
        end
        Y (index, index) = -s*L;
        %__________ MAKING CHANGES IN Y AND B MATRIX __________
        
        inductorC (ninductorC, 1) = a;
        inductorC (ninductorC, 2) = b;
        inductorC (ninductorC, 3) = L;
        inductorC (ninductorC, 4) = index;
        ninductorC = ninductorC + 1;
    end
    % _________________ INDUCTOR BETWEEN TOW NODES _________________

  
    % _________________ INDEPENDENT CURRENT SOURCE BETWEEN TOW NODES _________________
    if isequal ([inputz{i}{1} inputz{i}{2} inputz{i}{3}], 'ICS') == 1
        tStr = ' ';
        flag = 0;
        for j = 1:length (inputz{i})
            if inputz{i}{j} == '#' 
                    flag = flag + 1;
            end
    
            if flag == 2
                if zeroInput == 0
                    index = length (inputz{i}) - j;
                    for k = 1:index
                        tStr(k) = inputz{i}{k+j};
                    end
                    Is = sym (tStr);
                    Is = simplify (Is); %value of current source
                else
                    Is = sym ('0');
                end
                break;
            end
                    
            if isequal (inputz{i}{j}, ',')  == 1
                    a = findFirstNode (i, j, inputz);
                    b = findSecondNode (i, j, inputz);                
            end
            
        end
            
        %__________ MAKING CHANGES IN B MATRIX __________
        if a == bnode 
            B (b, 1) = B (b, 1) + laplace (Is * exp(0*t), t, s);
        elseif b == bnode
            B (a, 1) = B (a, 1) - laplace (Is * exp(0*t), t, s);
        else
            B (a, 1) = B (a, 1) - laplace (Is * exp(0*t), t, s);
            B (b, 1) = B (b, 1) + laplace (Is * exp(0*t), t, s);
        end 
        %__________ MAKING CHANGES IN B MATRIX __________
        
    end
    % _________________ INDEPENDENT CURRENT SOURCE BETWEEN TOW NODES _________________

    
    % _________________ INDEPENDENT VOLTAGE SOURCE BETWEEN TOW NODES _________________
    if isequal ([inputz{i}{1} inputz{i}{2} inputz{i}{3}], 'IVS') == 1
        tStr = ' ';
        flag = 0;
        for j = 1:length (inputz{i})
            if inputz{i}{j} == '#' 
                    flag = flag + 1;
            end
    
            if flag == 2
                if zeroInput == 0
                    index = length (inputz{i}) - j;
                    for k = 1:index
                        tStr(k) = inputz{i}{k+j};
                    end
                    Vs = sym (tStr);
                    Vs = simplify (Vs); %value of voltage source
                else
                    Vs = sym ('0');
                end
                
                break;
            end
                    
            if isequal (inputz{i}{j}, ',')  == 1
                    a = findFirstNode (i, j, inputz);
                    b = findSecondNode (i, j, inputz);                
            end
            
        end
            
        %__________ MAKING CHANGES IN Y AND B MATRIX __________
            index = length(Y) + 1;
            B (index, 1) = laplace (Vs * exp(0*t), t, s);
            
            for j = 1:index
                Y (index, j) = 0;
                Y (j, index) = 0;
            end 
            
            if a == bnode
                Y (index, b) = Y (index, b) - 1;
                Y (b, index) = Y (b, index) - 1;
            elseif b == bnode
                Y (index, a) = Y (index, a) + 1;
                Y (a, index) = Y (a, index) + 1;
            else
                Y (index, a) = Y (index, a) + 1;
                Y (index, b) = Y (index, b) - 1;
                Y (a, index) = Y (a, index) + 1;
                Y (b, index) = Y (b, index) - 1;
            end

        %__________ MAKING CHANGES IN Y AND B MATRIX __________
        
        indepV (nindepV, 1) = a;
        indepV (nindepV, 2) = b;
        indepV (nindepV, 3) = index;
        nindepV = nindepV + 1;
    
    end
    % _________________ INDEPENDENT VOLTAGE SOURCE BETWEEN TOW NODES _________________
    

    
    % _________________ VOLTAGE-CONTROLLED CURRENT SOURCE BETWEEN TOW NODES _________________
    if isequal ([inputz{i}{1} inputz{i}{2} inputz{i}{3} inputz{i}{4}], 'V-DC') == 1
        tStr = ' ';
        flag = 0;
        for j = 1:length (inputz{i})
            if inputz{i}{j} == '#' 
                    flag = flag + 1;
            end
    
            if flag == 3
                tStr = ' ';
                index = length (inputz{i}) - j;
                for k = 1:index
                    tStr(k) = inputz{i}{k+j};
                end
                g = str2num (tStr); %for example : I = g(Em - En)
                break;
            end
                    
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 1
                a = findFirstNode (i, j, inputz);
                b = findSecondNode (i, j, inputz);                
            end
            
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 2
                %for example : I = g(Em - En)
                m = findFirstNode (i, j, inputz);
                n = findSecondNode (i, j, inputz);                
            end            
        end
            
        %__________ MAKING CHANGES IN Y MATRIX __________

        temp = [g -g ; -g g];
        
        if a == 0
            temp (1, :) = 0;
        end
        if b == 0
            temp (2, :) = 0;
        end
        if m == 0
            temp (:, 1) = 0;
        end
        if n == 0
            temp (:, 2) = 0;
        end
        
        
        if temp (1, 1) ~= 0
            Y (a, m) = Y (a, m) + temp (1, 1);
        end
        if temp (1, 2) ~= 0
            Y (a, n) = Y (a, n) + temp (1, 2);
        end
        if temp (2, 1) ~= 0
            Y (b, m) = Y (b, m) + temp (2, 1);
        end
        if temp (2, 2) ~= 0
            Y (b, n) = Y (b, n) + temp (2, 2);
        end

        %__________ MAKING CHANGES IN Y MATRIX __________
        
    end
    % _________________ VOLTAGE-CONTROLLED CURRENT SOURCE BETWEEN TOW NODES _________________
    
    
    
    % _________________ VOLTAGE-CONTROLLED VOLTAGE SOURCE BETWEEN TOW NODES _________________
    if isequal ([inputz{i}{1} inputz{i}{2} inputz{i}{3} inputz{i}{4}], 'V-DV') == 1
        tStr = ' ';
        flag = 0;
        for j = 1:length (inputz{i})
            if inputz{i}{j} == '#' 
                    flag = flag + 1;
            end
    
            if flag == 3
                tStr = ' ';
                index = length (inputz{i}) - j;
                for k = 1:index
                    tStr(k) = inputz{i}{k+j};
                end
                g = str2num (tStr); %for example : V = g(Em - En)
                break;
            end
                    
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 1
                a = findFirstNode (i, j, inputz);
                b = findSecondNode (i, j, inputz);                
            end
            
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 2
                %for example : V = g(Em - En)
                m = findFirstNode (i, j, inputz);
                n = findSecondNode (i, j, inputz);                
            end            
        end
            
        %__________ MAKING CHANGES IN Y MATRIX __________
        temp = [0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 1 ; 0 0 0 0 -1 ; -g g 1 -1 0];
        
        index = length(Y) + 1;
        B (index, 1) = 0;
        for j = 1:index
            Y (index, j) = 0;
            Y (j, index) = 0;
        end
        
        if a == bnode
            temp (3, :) = 0;
            temp (:, 3) = 0;
        end
        if b == bnode
            temp (4, :) = 0;
            temp (:, 4) = 0;
        end
        if m == bnode
            temp (1, :) = 0;
            temp (:, 1) = 0;
        end
        if n == bnode
            temp (2, :) = 0;
            temp (:, 2) = 0;
        end
        
        
        if temp (3, 5) ~= 0 
            Y (a, index) = Y (a, index) + temp (3, 5);
        end
        if temp (4, 5) ~= 0 
            Y (b, index) = Y (b, index) + temp (4, 5);
        end
        if temp (5, 1) ~= 0 
            Y (index, m) = Y (index, m) + temp (5, 1);
        end
        if temp (5, 2) ~= 0 
            Y (index, n) = Y (index, n) + temp (5, 2);
        end
        if temp (5, 3) ~= 0 
            Y (index, a) = Y (index, a) + temp (5, 3);
        end
        if temp (5, 4) ~= 0 
            Y (index, b) = Y (index, b) + temp (5, 4);
        end
        %__________ MAKING CHANGES IN Y MATRIX __________
        
        VcontrolVSC (nVcontrolVSC, 1) = a;
        VcontrolVSC (nVcontrolVSC, 2) = b;
        VcontrolVSC (nVcontrolVSC, 3) = index;
        nVcontrolVSC = nVcontrolVSC + 1;
        
    end
    % _________________ VOLTAGE-CONTROLLED VOLTAGE SOURCE BETWEEN TOW NODES _________________
    

    
    % _________________ CURRENT-CONTROLLED CURRENT SOURCE BETWEEN TOW NODES _________________
    if isequal ([inputz{i}{1} inputz{i}{2} inputz{i}{3} inputz{i}{4}], 'C-DC') == 1
        tStr = ' ';
        flag = 0;
        for j = 1:length (inputz{i})
            if inputz{i}{j} == '#' 
                    flag = flag + 1;
            end
    
            if flag == 3
                tStr = ' ';
                index = length (inputz{i}) - j;
                for k = 1:index
                    tStr(k) = inputz{i}{k+j};
                end
                g = str2num (tStr); 
                break;
            end
                    
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 1
                a = findFirstNode (i, j, inputz);
                b = findSecondNode (i, j, inputz);                
            end
            
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 2
                m = findFirstNode (i, j, inputz);
                n = findSecondNode (i, j, inputz);                
            end            
        end
            
        %__________ MAKING CHANGES IN Y MATRIX __________
        temp = [0 0 0 0 1 ; 0 0 0 0 -1 ; 0 0 0 0 g ; 0 0 0 0 -g ; 1 -1 0 0 0];
        
        if a == bnode
            temp (3, :) = 0;
            temp (:, 3) = 0;
        end
        if b == bnode
            temp (4, :) = 0;
            temp (:, 4) = 0;
        end
        if m == bnode
            temp (1, :) = 0;
            temp (:, 1) = 0;
        end
        if n == bnode
            temp (2, :) = 0;
            temp (:, 2) = 0;
        end
        
        index = length(Y) + 1;
        B (index, 1) = 0;
        for j = 1:index
            Y (index, j) = 0;
            Y (j, index) = 0;
        end
        
        if temp (1, 5) ~= 0 
            Y (m, index) = Y (m, index) + temp (1, 5);
        end
        if temp (2, 5) ~= 0 
            Y (n, index) = Y (n, index) + temp (2, 5);
        end
        if temp (3, 5) ~= 0
            Y (a, index) = Y (a, index) + temp (3, 5);
        end
        if temp (4, 5) ~= 0
            Y (b, index) = Y (b, index) + temp (4, 5);
        end
        if temp (5, 1) ~= 0
            Y (index, m) = Y (index, m) + temp (5, 1);
        end
        if temp (5, 2) ~= 0
            Y (index, n) = Y (index, n) + temp (5, 2);
        end
        %__________ MAKING CHANGES IN Y MATRIX __________
        
        shortBranchC (nshortBranchC, 1) = m;
        shortBranchC (nshortBranchC, 2) = n;
        shortBranchC (nshortBranchC, 3) = index;
        nshortBranchC = nshortBranchC + 1;
        
    end
    % _________________ CURRENT-CONTROLLED CURRENT SOURCE BETWEEN TOW NODES _________________    
    
    
    % _________________ CURRENT-CONTROLLED VOLTAGE SOURCE BETWEEN TOW NODES _________________
    if isequal ([inputz{i}{1} inputz{i}{2} inputz{i}{3} inputz{i}{4}], 'C-DV') == 1
        tStr = ' ';
        flag = 0;
        for j = 1:length (inputz{i})
            if inputz{i}{j} == '#' 
                    flag = flag + 1;
            end
    
            if flag == 3
                tStr = ' ';
                index = length (inputz{i}) - j;
                for k = 1:index
                    tStr(k) = inputz{i}{k+j};
                end
                g = str2num (tStr); 
                break;
            end
                    
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 1
                a = findFirstNode (i, j, inputz);
                b = findSecondNode (i, j, inputz);                
            end
            
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 2
                m = findFirstNode (i, j, inputz);
                n = findSecondNode (i, j, inputz);                
            end            
        end
            
        %__________ MAKING CHANGES IN Y MATRIX __________
        temp = [0 0 0 0 1 0 ; 0 0 0 0 -1 0 ; 0 0 0 0 0 1 ; 0 0 0 0 0 -1 ; 1 -1 0 0 0 0 ; 0 0 1 -1 -g 0];
        index = length(Y) + 2;
        B (index - 1, 1) = 0;
        B (index, 1) = 0;

        for j = 1:index-1
            Y (index - 1, j) = 0;
            Y (j, index - 1) = 0;
        end
        for j = 1:index
            Y (index, j) = 0;
            Y (j, index) = 0;
        end
        
        if a == bnode
            temp (3, :) = 0;
            temp (:, 3) = 0;
        end
        if b == bnode 
            temp (4, :) = 0;
            temp (:, 4) = 0;
        end 
        if m == bnode 
            temp (1, :) = 0;
            temp (:, 1) = 0;
        end 
        if n == bnode 
            temp (2, :) = 0;
            temp (:, 2) = 0;
        end
        
        if temp (1, 5) ~= 0
            Y (m, index - 1) = Y (m, index - 1) + temp (1, 5);
        end
        if temp (2, 5) ~= 0
            Y (n, index - 1) = Y (n, index - 1) + temp (2, 5);
        end
        if temp (3, 6) ~= 0
            Y (a, index) = Y (a, index) + temp (3, 6);
        end
        if temp (4, 6) ~= 0
            Y (b, index) = Y (b, index) + temp (4, 6);
        end
        if temp (5, 1) ~= 0
            Y (index - 1, m) = Y (index - 1, m) + temp (5, 1);
        end
        if temp (5, 2) ~= 0
            Y (index - 1, n) = Y (index - 1, n) + temp (5, 2);
        end
        if temp (6, 3) ~= 0
            Y (index, a) = Y (index, a) + temp (6, 3);
        end
        if temp (6, 4) ~= 0
            Y (index, b) = Y (index, b) + temp (6, 4);
        end
        if temp (6, 5) ~= 0
            Y (index, index - 1) = Y (index, index - 1) + temp (6, 5);
        end
        
        %__________ MAKING CHANGES IN Y MATRIX __________
        
        shortBranchC (nshortBranchC, 1) = m;
        shortBranchC (nshortBranchC, 2) = n;
        shortBranchC (nshortBranchC, 3) = index - 1;
        nshortBranchC = nshortBranchC + 1;
        
        CcontrolVSC (nCcontrolVSC, 1) = a;
        CcontrolVSC (nCcontrolVSC, 2) = b;
        CcontrolVSC (nCcontrolVSC, 3) = index;
        nCcontrolVSC = nCcontrolVSC + 1;
        
    end
    % _________________ CURRENT-CONTROLLED VOLTAGE SOURCE BETWEEN TOW NODES _________________ 
    
    
    
    % _________________ GYRATOR BETWEEN TOW NODES _________________
    if isequal ([inputz{i}{1} inputz{i}{2}], 'GY') == 1
        g1 = 0;
        g2 = 0;
        tStr = ' ';
        tStr1 = ' ';
        flag = 0;
        for j = 1:length (inputz{i})
            if inputz{i}{j} == '#' 
                    flag = flag + 1;
            end
            
            if flag == 3 && g1 == 0
                
                for k = j+1:length (inputz{i})
                    if inputz{i}{k} == '#'
                        index = k;
                        break;
                    end
                end
                
                for k = j+1:index-1
                    tStr(k - j) = inputz{i}{k};
                end
                g1 = str2num (tStr);
                
            end
            
            if flag == 4
                tStr = ' ';
                index = length (inputz{i}) - j;
                for k = 1:index
                    tStr1(k) = inputz{i}{k+j};
                end
                g2 = str2num (tStr1);
                
                break;
            end
                    
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 1
                a = findFirstNode (i, j, inputz);
                b = findSecondNode (i, j, inputz);                
            end
            
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 2
                
                m = findFirstNode (i, j, inputz);
                n = findSecondNode (i, j, inputz);                
            end
            %for example : I1 = -g2V2 , I2 = g1V1
        end
            
        %__________ MAKING CHANGES IN Y MATRIX __________
        temp = [g1 -g1 ; -g1 g1];
        temp2 = [-g2 g2 ; g2 -g2];
        if a == bnode
            temp (:, 1) = 0;
            temp2 (1, :) = 0;
        end
        if b == bnode
            temp (:, 2) = 0;
            temp2 (2, :) = 0;
        end
        if m == bnode
            temp (1, :) = 0;
            temp2 (:, 1) = 0;
        end
        if n == bnode
            temp (2, :) = 0;
            temp2 (:, 2) = 0;
        end
        
        if temp (1, 1) ~= 0 
            Y (m, a) = Y (m, a) + temp (1, 1);
        end
        if temp (1, 2) ~= 0 
            Y (m, b) = Y (m, b) + temp (1, 2);
        end
        if temp (2, 1) ~= 0 
            Y (n, a) = Y (n, a) + temp (2, 1);
        end
        if temp (2, 2) ~= 0 
            Y (n, b) = Y (n, b) + temp (2, 2);
        end
        if temp2 (1, 1) ~= 0 
            Y (a, m) = Y (a, m) + temp2 (1, 1);
        end
        if temp2 (1, 2) ~= 0 
            Y (a, n) = Y (a, n) + temp2 (1, 2);
        end
        if temp2 (2, 1) ~= 0 
            Y (b, m) = Y (b, m) + temp2 (2, 1);
        end
        if temp2 (2, 2) ~= 0 
            Y (b, n) = Y (b, n) + temp2 (2, 2);
        end

        %__________ MAKING CHANGES IN Y MATRIX __________
        
    end
    % _________________ GYRATOR BETWEEN TOW NODES _________________

    
    % _________________ COUPLED INDUCTOR _________________
    if isequal ([inputz{i}{1} inputz{i}{2}], 'CL') == 1
        tStr = ' ';
        tStr1 = ' ';
        tStr2 = ' ';
        flag = 0;
        for j = 1:length (inputz{i})
            
            if inputz{i}{j} == '#' 
                    flag = flag + 1;
            end
            
            if flag == 3
                
                for k = j+1:length (inputz{i})
                    if inputz{i}{k} == '#'
                        index = k;
                        break;
                    end
                end
                
                for k = j+1:k-1
                    tStr(k - j) = inputz{i}{k};
                end
                L1 = str2num (tStr);          
            end
            
            if flag == 4
                tStr = ' ';
                for k = j+1:length (inputz{i})
                    if inputz{i}{k} == '#'
                        index = k;
                        break;
                    end
                end
                
                for k = j+1:k-1
                    tStr1(k - j) = inputz{i}{k};
                end
                L2 = str2num (tStr1);              
            end
            
            if flag == 5
                tStr = ' ';
                index = length (inputz{i}) - j;
                for k = 1:index
                    tStr2(k) = inputz{i}{k+j};
                end
                M = str2num (tStr2); 
                break;
            end
                    
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 1
                a = findFirstNode (i, j, inputz);
                b = findSecondNode (i, j, inputz);                
            end
            
            if isequal (inputz{i}{j}, ',')  == 1 && flag == 2
                m = findFirstNode (i, j, inputz);
                n = findSecondNode (i, j, inputz);                
            end
            
        end
            
        %__________ MAKING CHANGES IN Y MATRIX __________
        temp = [0 0 0 0 1 0 ; 0 0 0 0 -1 0 ; 0 0 0 0 0 1 ; 0 0 0 0 0 -1 ; 1 -1 0 0 0 0 ; 0 0 1 -1 0 0];
        index = length(Y) + 2;
        B (index - 1, 1) = 0;
        B (index, 1) = 0;

        for j = 1:index-1
            Y (index - 1, j) = 0;
            Y (j, index - 1) = 0;
        end
        for j = 1:index
            Y (index, j) = 0;
            Y (j, index) = 0;
        end
        
        Y (index, index) = -s*L2;
        Y (index, index - 1) = -s*M;
        Y (index - 1, index) = -s*M;
        Y (index - 1, index - 1) = -s*L1;
        
        if a == bnode
            temp (1, :) = 0;
            temp (:, 1) = 0;
        end
        if b == bnode
            temp (2, :) = 0;
            temp (:, 2) = 0;
        end    
        if m == bnode
            temp (3, :) = 0;
            temp (:, 3) = 0;
        end
        if n == bnode
            temp (4, :) = 0;
            temp (:, 4) = 0;
        end
        
        if temp (1, 5) ~= 0
            Y (a, index - 1) = Y (a, index - 1) + temp (1, 5);
        end
        if temp (2, 5) ~= 0
            Y (b, index - 1) = Y (b, index - 1) + temp (2, 5);
        end
        if temp (3, 6) ~= 0
            Y (m, index) = Y (m, index) + temp (3, 6);
        end
        if temp (4, 6) ~= 0
            Y (n, index) = Y (n, index) + temp (4, 6);
        end
        if temp (5, 1) ~= 0
            Y (index - 1, a) = Y (index - 1, a) + temp (5, 1);
        end
        if temp (5, 2) ~= 0
            Y (index - 1, b) = Y (index - 1, b) + temp (5, 2);
        end
        if temp (6, 3) ~= 0
            Y (index, m) = Y (index, m) + temp (6, 3);
        end
        if temp (6, 4) ~= 0
            Y (index, n) = Y (index, n) + temp (6, 4);
        end   

        %__________ MAKING CHANGES IN Y MATRIX __________
        
        coupledInductorC (ncoupledInductorC, 1) = a;
        coupledInductorC (ncoupledInductorC, 2) = b;
        coupledInductorC (ncoupledInductorC, 3) = m;
        coupledInductorC (ncoupledInductorC, 4) = n;
        coupledInductorC (ncoupledInductorC, 5) = index - 1;
        coupledInductorC (ncoupledInductorC, 6) = index;
        ncoupledInductorC = ncoupledInductorC + 1;
        
    end
    % _________________ COUPLED INDUCTOR _________________
end


%----------------------Getting output----------------------
OUTP2 = sym ('');

if outputMode == 1
    
    OUTP = simplify (nodeVoltage (desiredE1, Y, B));
    disp (OUTP);
    OUTP2 = vpa (ilaplace (OUTP));
    disp (OUTP2);
    if doPlot == 1
        ezplot (OUTP2, [0 15]);
    end
    
elseif outputMode == 2
    
    OUTP = simplify (nodeVoltage (desiredE1, Y, B) - nodeVoltage (desiredE2, Y, B));
    disp (OUTP);
    OUTP2 = vpa (ilaplace (OUTP));
    disp (OUTP2);
    if doPlot == 1
        ezplot (OUTP2, [0 15]);
    end
    
elseif outputMode == 3
    %_________________________________________
    %_________________________________________
    %_________________________________________
    
    OUTP = sym ('0');
    tStr = outputStr (1, 1:2);
    outputStr = outputStr (1, 4:length (outputStr));
    
    if isequal (tStr, '00') == 1 % 00
        [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
        outputStr = outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr));
        R = str2num (outputStr);
        OUTP = (nodeVoltage (desiredE1, Y, B) - nodeVoltage (desiredE2, Y, B)) / R;
        OUTP = simplify (OUTP);
    end
    
    if isequal (tStr, '01') == 1 % 01
        [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
        outputStr = outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr));
        C = str2num (outputStr (1, 1:findindex (outputStr, '#', 1) - 1));
        VCi = str2num (outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr)));
        OUTP = capacitorI (desiredE1, desiredE2, C, VCi, Y, B);
        OUTP = simplify (OUTP);
    end
    
    if isequal (tStr, '02') == 1 % 02
        [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
        L = str2num (outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr)));
        [index, z] = inductorCompare (desiredE1, desiredE2, L, inductorC);
        if index > 0 
            OUTP = z * indexI (index, Y, B);
        end
        OUTP = simplify (OUTP);
    end

    if isequal (tStr, '03') == 1 % 03
        [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
        [index, z] = sCompare (desiredE1, desiredE2, shortBranchC);
        if index > 0 
            OUTP = z * indexI (index, Y, B);
        end
        OUTP = simplify (OUTP);
    end
    
    if isequal (tStr, '04') == 1 % 04
        Is = sym (outputStr);
        Is = laplace (Is * exp(0*t), t, s);
        OUTP = simplify (Is);
    end
    
    if isequal (tStr, '05') == 1 % 05
        [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
        [index, z] = sCompare (desiredE1, desiredE2, indepV);
        if index > 0
            OUTP = z * indexI (index, Y, B);
        end
        OUTP = simplify (OUTP);
    end
    
    if isequal (tStr, '06') == 1 % 06
        [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
        g = str2num (outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr)));
        OUTP = vccsI (desiredE1, desiredE2, g, Y, B);
        OUTP = simplify (OUTP);
    end
    
    if isequal (tStr, '07') == 1 % 07
        [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
        [index, z] = sCompare (desiredE1, desiredE2, VcontrolVSC);
        if index > 0
            OUTP = z * indexI (index, Y, B);
        end
        OUTP = simplify (OUTP);
    end
    
    if isequal (tStr, '08') == 1 % 08
        [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
        g = str2num (outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr)));
        [index, z] = sCompare (desiredE1, desiredE2, shortBranchC);
        if index > 0
            OUTP = z * cccsI (index, g, Y, B);
        end
        OUTP = simplify (OUTP);
    end

    if isequal (tStr, '09') == 1 % 09
        [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
        [index, z] = sCompare (desiredE1, desiredE2, CcontrolVSC);
        if index > 0
            OUTP = z * indexI (index, Y, B);
        end
        OUTP = simplify (OUTP);
    end
    
    if isequal (tStr, '10') == 1 % 10
        [a, b] = findNodes (findindex (outputStr, ',', 1), outputStr);
        [m, n] = findNodes (findindex (outputStr, ',', 2), outputStr);
        k = str2num (outputStr (1, findindex (outputStr, '#', 2) + 1:length (outputStr)));
        [index, z] = cinductorCompare (a, b, m, n, coupledInductorC, k);
        if index > 0
            OUTP = z * indexI (index, Y, B);
        end
        OUTP = simplify (OUTP);
    end    
    
    if isequal (tStr, '11') == 1 % 11
        [a, b] = findNodes (findindex (outputStr, ',', 1), outputStr);
        [m, n] = findNodes (findindex (outputStr, ',', 2), outputStr);
        g1 = str2num (outputStr (1, findindex (outputStr, '#', 2) + 1:findindex (outputStr, '#', 3) - 1));
        g2 = str2num (outputStr (1, findindex (outputStr, '#', 3) + 1:findindex (outputStr, '#', 4) - 1));
        k = str2num (outputStr (1, length (outputStr)));
        [y, z] = gyratorI (a, b, m, n, g1, g2, Y, B);
        
        if k == 1
            OUTP = y;
        elseif k == 2 
            OUTP = z;
        end
        
        OUTP = simplify (OUTP);
    end
    
    %_________________________________________
    %_________________________________________
    %_________________________________________
    
    OUTP = simplify (OUTP);
    disp (OUTP);
    OUTP2 = vpa (ilaplace (OUTP));
    disp (OUTP2);
    
    if doPlot == 1
        ezplot (OUTP2, [0 15]);
    end
    
elseif outputMode == 4
    OUTP = solve (det (Y), s);
    OUTP = vpa (OUTP);
    disp (OUTP);
    
elseif outputMode == 5
    if outputVarMode == 0
        OUTP = nodeVoltage (str2num (outputStr), Y, B);
        OUTP = simplify (OUTP);
        
    elseif outputVarMode == 1
        [a, b] = findNodes (findindex (outputStr, ',', 1), outputStr);
        OUTP = nodeVoltage (a, Y, B) - nodeVoltage (b, Y, B);
        OUTP = simplify (OUTP);
        
    elseif outputVarMode == 2
        %_________________________________________
        %_________________________________________
        %_________________________________________

        OUTP = sym ('0');
        tStr = outputStr (1, 1:2);
        outputStr = outputStr (1, 4:length (outputStr));

        if isequal (tStr, '00') == 1 % 00
            [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
            outputStr = outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr));
            R = str2num (outputStr);
            OUTP = (nodeVoltage (desiredE1, Y, B) - nodeVoltage (desiredE2, Y, B)) / R;
            OUTP = simplify (OUTP);
        end

        if isequal (tStr, '01') == 1 % 01
            [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
            outputStr = outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr));
            C = str2num (outputStr (1, 1:findindex (outputStr, '#', 1) - 1));
            VCi = str2num (outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr)));
            OUTP = capacitorI (desiredE1, desiredE2, C, VCi, Y, B);
            OUTP = simplify (OUTP);
        end

        if isequal (tStr, '02') == 1 % 02
            [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
            L = str2num (outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr)));
            [index, z] = inductorCompare (desiredE1, desiredE2, L, inductorC);
            if index > 0 
                OUTP = z * indexI (index, Y, B);
            end
            OUTP = simplify (OUTP);
        end

        if isequal (tStr, '03') == 1 % 03
            [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
            [index, z] = sCompare (desiredE1, desiredE2, shortBranchC);
            if index > 0 
                OUTP = z * indexI (index, Y, B);
            end
            OUTP = simplify (OUTP);
        end

        if isequal (tStr, '04') == 1 % 04
            Is = sym (outputStr);
            Is = laplace (Is * exp(0*t), t, s);
            OUTP = simplify (Is);
        end

        if isequal (tStr, '05') == 1 % 05
            [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
            [index, z] = sCompare (desiredE1, desiredE2, indepV);
            if index > 0
                OUTP = z * indexI (index, Y, B);
            end
            OUTP = simplify (OUTP);
        end

        if isequal (tStr, '06') == 1 % 06
            [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
            g = str2num (outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr)));
            OUTP = vccsI (desiredE1, desiredE2, g, Y, B);
            OUTP = simplify (OUTP);
        end

        if isequal (tStr, '07') == 1 % 07
            [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
            [index, z] = sCompare (desiredE1, desiredE2, VcontrolVSC);
            if index > 0
                OUTP = z * indexI (index, Y, B);
            end
            OUTP = simplify (OUTP);
        end

        if isequal (tStr, '08') == 1 % 08
            [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
            g = str2num (outputStr (1, findindex (outputStr, '#', 1) + 1:length (outputStr)));
            [index, z] = sCompare (desiredE1, desiredE2, shortBranchC);
            if index > 0
                OUTP = z * cccsI (index, g, Y, B);
            end
            OUTP = simplify (OUTP);
        end

        if isequal (tStr, '09') == 1 % 09
            [desiredE1, desiredE2] = findNodes (findindex (outputStr, ',', 1), outputStr);
            [index, z] = sCompare (desiredE1, desiredE2, CcontrolVSC);
            if index > 0
                OUTP = z * indexI (index, Y, B);
            end
            OUTP = simplify (OUTP);
        end

        if isequal (tStr, '10') == 1 % 10
            [a, b] = findNodes (findindex (outputStr, ',', 1), outputStr);
            [m, n] = findNodes (findindex (outputStr, ',', 2), outputStr);
            k = str2num (outputStr (1, findindex (outputStr, '#', 2) + 1:length (outputStr)));
            [index, z] = cinductorCompare (a, b, m, n, coupledInductorC, k);
            if index > 0
                OUTP = z * indexI (index, Y, B);
            end
            OUTP = simplify (OUTP);
        end    

        if isequal (tStr, '11') == 1 % 11
            [a, b] = findNodes (findindex (outputStr, ',', 1), outputStr);
            [m, n] = findNodes (findindex (outputStr, ',', 2), outputStr);
            g1 = str2num (outputStr (1, findindex (outputStr, '#', 2) + 1:findindex (outputStr, '#', 3) - 1));
            g2 = str2num (outputStr (1, findindex (outputStr, '#', 3) + 1:findindex (outputStr, '#', 4) - 1));
            k = str2num (outputStr (1, length (outputStr)));
            [y, z] = gyratorI (a, b, m, n, g1, g2, Y, B);

            if k == 1
                OUTP = y;
            elseif k == 2 
                OUTP = z;
            end

            OUTP = simplify (OUTP);
        end
        %_________________________________________
        %_________________________________________
        %_________________________________________

        OUTP = simplify (OUTP);
    end
    
    OUTP = OUTP / INPUTP;
    
    OUTP = simplify (OUTP);
    disp (OUTP);
    OUTP = vpa (OUTP);
    disp (OUTP);
    if doPlot == 1
        %-----------Frequency response plot-----------
        [numexpr, denexpr] = numden (sym (OUTP));
        numcoeff = coeffs (expand (numexpr), s);
        dencoeff = coeffs (expand (denexpr), s);
        numcoeff = rot90 (numcoeff, 2);
        dencoeff = rot90 (dencoeff, 2);
        w = logspace (-10, 10);
        freqs (double (numcoeff), double (dencoeff), w);
        %-----------Frequency response plot-----------
    end
end
%----------------------Getting output----------------------


%----------------------Saving output-----------------------
tStr = '';

if exist ('output.txt', 'file') == 2
    for i = 1:500
        temp = num2str (i);
        if exist (['output', temp, '.txt'], 'file') == 0
            tStr = temp;
            break;
        end
    end
end
    
inp = fopen (['output', tStr, '.txt'], 'w');
fprintf (inp, '%s\t\t\t\t', char (OUTP), char (OUTP2));
fclose (inp);

if doPlot == 1 
    savefig (['outputPlot', tStr, '.fig']);
end
%----------------------Saving output-----------------------