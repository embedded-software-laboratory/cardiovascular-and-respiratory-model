function res = initptpars(dia)
    ptpars = struct;
    ptpars.fact_betaL = busts(1);
    ptpars.fact_betaR = busts(1);
    ptpars.lambda = busts(0.35);
    ptpars.rho_ext = busts(0.005);
    ptpars.rho_int = busts(0);
    ptpars.Rp = busts(1.6);

    if strcmp(dia, 'ards')
        ptpars.lambda = busts(0.58);    % extra deadspace [
        ptpars.rho_int = busts(0.35);   % Intrapulmonary shunt [Pathophysiology of ARDS]
        ptpars.Rp = busts(2.8); % PVR
    end
    if strcmp(dia, 'hf')
        ptpars.fact_betaL = busts(0.3);
        ptpars.fact_betaR = busts(0.8);
    end
    res = ptpars;
end

% TODO: move to separate file, if initptpars.m will not be deprecated
function res = busts(val)
    res = timeseries(val, 0);
end