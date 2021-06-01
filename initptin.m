function res = initptin(runtype, data, i)
    
    ptin = struct;
    if strcmp(runtype, 'evaluation-classification')
        row = data(i,:);
        
        % variable initialization
        ptin.female = busts(row(4)==1);
        ptin.age = busts(row(5));
        ptin.height = busts(row(6));
        ptin.weight = busts(row(7));
        ptin.NTproBNP = busts(row(8) * 0.1);   % scale?
        ptin.H = busts(row(9));
        ptin.Pas = busts(bounds(row(10), 40, 140));
        ptin.Pvs = busts(bounds(row(11), 1, 8));
        ptin.Hb = busts(row(12) * 0.0001);     % scale
        ptin.Scr = busts(row(13));             
        ptin.BUN = busts(row(14) * 0.467);     % scale (mmol/L -> mg/dL)
        ptin.PaCO2 = busts(bounds(row(15), 20, 58));
        ptin.FiO2 = busts(row(16) * 0.01);     % scale
        ptin.f = busts(row(17));
        ptin.VT = busts(row(18));
        ptin.PEEP = busts(row(19));
        ptin.Pinsp = busts(row(20));
        ptin.PaO2 = busts(bounds(row(21), 30, 120));
       
        
        % constants
        ptin.black = busts(false);             % const bool
        ptin.Pap = busts(15);                  % const
        ptin.cRS = busts(0);                   % nA
    end
    
    if strcmp(runtype, 'evaluation-fixed')
        age = 45;
        ptin.age = busts(age);                  % ---
        ptin.female = busts(false);             % ---
        ptin.black = busts(false);              % ---
        ptin.height = busts(1.76);               % ---
        ptin.weight = busts(75);                % ---
        ptin.Pas = busts(90);                   % DocCheck
        ptin.Pvs = busts(4);                    % BKST 1.6.1
        ptin.Pap = busts(15);                   % BKST 1.6.1
        ptin.H = busts(70);                     % ---
        ptin.PaO2 = busts(103.5 - 0.42*age);    % [Lotz]
        ptin.PaCO2 = busts(40);                 % 5.3 kPa [ABC of oxygen]
        ptin.FiO2 = busts(0.21);                % as in atmosphere
        ptin.f = busts(18);                     % Gützi [amboss]
        ptin.VT = busts(0);                     % -> 6 mL/kg PBW
        ptin.PEEP = busts(0.5);                 % 
        ptin.Pinsp = busts(12.5);               % not relevant for results
        ptin.cRS = busts(0);                    % not relevant for results
        ptin.BNP = busts(-1);                   % not relevant for results
        ptin.NTproBNP = busts(200);             % not relevant for results
        ptin.Hb = busts(15);                    % not relevant for results
        ptin.Scr = busts(1.1);                  % not relevant for results       
        ptin.BUN = busts(20);                   % not relevant for results
    end
    res = ptin;
end

% TODO: move to separate file, if initptin.m will not be deprecated
function res = busts(val)
    res = timeseries(val, 0);
end

function res = bounds(x, min, max)
    if x < min
        res = min;
    elseif x > max
        res = max;
    else
        res = x;
    end
end