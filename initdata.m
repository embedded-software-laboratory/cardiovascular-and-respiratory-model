% TODO: initialize ptin and ptpars from file

[data, data_pao2] = EVA2DATA();
i = 1;
row = data(i, :);
ptin = struct;
clamp = @(x, a, b) max(min(x, a), b);

ptin.female = timeseries(row(4) == 1);
ptin.age = timeseries(row(5));
ptin.height = timeseries(row(6));
ptin.weight = timeseries(row(7));
ptin.NTproBNP = timeseries(row(8) * 0.1);   % scale?
% row(9) missing
% row(10) missing
ptin.H = timeseries(row(11));
ptin.Pas = timeseries(clamp(row(12), 40, 140));
ptin.Pvs = timeseries(clamp(row(13), 1, 8));
% row(14) missing
ptin.Hb = timeseries(row(15) * 0.0001);     % scale
ptin.Scr = timeseries(row(16));             
ptin.BUN = timeseries(row(17) * 0.467);     % scale (mmol/L -> mg/dL)
% row(18) missing
% row(19) missing
% row(20) missing
ptin.PaCO2 = timeseries(clamp(row(21), 20, 58));
ptin.FiO2 = timeseries(row(22) * 0.01);     % scale
ptin.f = timeseries(row(23));
ptin.VT = timeseries(row(24));
ptin.PEEP = timeseries(row(25));
ptin.Pinsp = timeseries(row(26));

ptin.PaO2 = timeseries(clamp(data_pao2(i), 30, 120));

ptin.black = timeseries(false);             % const bool
ptin.Pap = timeseries(15);                  % const
ptin.cRS = timeseries(0);                   % nA
ptin.BNP = timeseries(-1);                  % nA