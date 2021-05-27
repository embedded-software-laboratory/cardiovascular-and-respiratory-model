function evarun(runtype, i0, i1)
% Fuehrt die Simulation durch und generiert Graphen
% runtype: String aus ['eva1', 'eva2', 'eva2-long']
% i0: Zeilennummer des ersten Patienten
% i1: Zeilennummer des letzten Patienten

    %[data, data_pao2] = EVA2DATA();
    [data] = evaluationData();
    n = i1 - i0 + 1;
    c=0;
  
    % check which evaluation runtype is defined
    % eva1 = fixed parameters in "initptin.m"
    % eva2 = testdata from "evaluationData.m"
    if strcmp(runtype, 'evaluation-fix')
        tmax = 600;
        runtype = 'eva1';
    elseif strcmp(runtype, 'evaluation-short')
        tmax = 600;
        runtype = 'eva2';
    elseif strcmp(runtype, 'evaluation-middle')
        tmax = 18000;
        runtype = 'eva2';
    elseif strcmp(runtype, 'evaluation-verylong')
        tmax = 36000;
        runtype = 'eva2';
    end

    clearvars ptruns out;
    ptruns(21) = struct;
    %M = zeros(n, 20);

    for i=i0:i1
        ptruns(i).runtype = runtype;
        ptruns(i).tmax = tmax;
        if strcmp(ptruns(i).runtype, 'eva2')
            ptruns(i).patientid = data(i,1);
            if data(i,2) == 1
                ptruns(i).dia = 'ards';
            end
            if data(i,3) == 1
                ptruns(i).dia = 'hf';
            end
        else
            ptruns(i).patientid = 0;
            ptruns(i).dia = 'none';
        end

        ptin = initptin(ptruns(i).runtype, data, i);
        ptpars = initptpars(ptruns(i).dia);
        assignin('base', 'ptin', ptin);
        assignin('base', 'ptpars', ptpars);
        
        % exclude by:
        exclude = false;
        if strcmp(runtype, 'eva2')
            %    - tidal volume
            exclude = exclude || (data(i,18) > 1);
            %    - breathing frequency
            exclude = exclude || (data(i,17) < 8 || data(i,17) > 42);
        end
        ptruns(i).exclude = exclude;
        fprintf('Start %s(%s)-simulation i=%d (pt#%d), %d seconds\n', ptruns(i).runtype, ptruns(i).dia, i, ptruns(i).patientid, tmax);
        if ~exclude
            % simulate the model
            out = sim('ards_model', 'SimulationMode', 'normal', 'StartTime', '0', 'StopTime', num2str(tmax), 'FixedStep', '0.5');
            
            c=c+1;
            ptruns(i).ptin = ptin;
            ptruns(i).ptpars = ptpars;
            ptruns(i).ptstate = out.ptstate;
            ptruns(i).scores = struct;
            ptruns(i).scores.LVEF = out.LVEF_score;
            ptruns(i).scores.H = out.H_score;
            ptruns(i).scores.NTproBNP = out.NTproBNP_score;
            ptruns(i).scores.RHF = out.RHF_score;
            ptruns(i).scores.pFon = out.logFon_score;
            ptruns(i).scores.Psystas = out.Psystas;
            ptruns(i).scores.Pdiastas = out.Pdiastas;
            ptruns(i).scores.y = out.y_score;

            % generate plots
            fprintf('Rendering plots...\n');
            evaplot(ptruns(i), 'bp', true, false);
            evaplot(ptruns(i), 'baro', true, false);
            evaplot(ptruns(i), 'abps', true, false);
            evaplot(ptruns(i), 'bloodgas', true, false);
            evaplot(ptruns(i), 'horovitz', true, false);
            evaplot(ptruns(i), 'fonarow', true, false);
            evaplot(ptruns(i), 'fonarow-low', true, false);
            evaplot(ptruns(i), 'rajan', true, false);
            evaplot(ptruns(i), 'hfc2', true, false);
            evaplot(ptruns(i), 'lef', true, false);
            evaplot(ptruns(i), 'y', true, false);
        end
    end
    assignin('base', 'ptruns', ptruns);
    path = ['runs/run-',runtype,'-',datestr(now, 'yyyymmdd-HHMMSS'),'.mat'];
    if strcmp(ptruns(i).runtype, 'eva1')
        ptrun = ptruns(1);
        save(path, 'ptrun');
    else
        save(path, 'ptruns');
    end

    fprintf('Simulated %d of %d data sets\n', c, n);

end
