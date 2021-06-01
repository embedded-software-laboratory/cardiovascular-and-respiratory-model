function evaplot(ptrun, plottype, saveplot, openplot)
    
    tmax = ptrun.tmax;
    %tmax = 600;
    
    labelFontSize = 15;
    axisFontSize = 12;
    
    linewidth = 1;
    f = figure;
    plotcolors = evalin('base', 'plotcolors');

    %f = figure('visible', 'off');
    % ---------- BLUTDRÜCKE ----------------------------------------------
    if strcmp(plottype, 'bp')
        plot(ptrun.ptstate.cvs.Pas,'LineWidth',linewidth,'Color',plotcolors.art);
        hold on
        plot(ptrun.ptstate.cvs.Pvs,'LineWidth',linewidth,'Color',plotcolors.ven);
        plot(ptrun.ptstate.cvs.Pap,'LineWidth',linewidth,'Color',plotcolors.ven,'LineStyle',':');
        plot(ptrun.ptstate.cvs.Pvp,'LineWidth',linewidth,'Color',plotcolors.art,'LineStyle',':');
        ylim([0,130]);
        ylabel('Mean Blood Pressure (mmHg)');

        lgd=legend('$P_{\rm{as}}$', '$P_{\rm{vs}}$', '$P_{\rm{ap}}$', '$P_{\rm{vp}}$');
        %lgd =legend('art. systemisch', 'ven. systemisch', 'art. pulmonal', 'ven. pulmonal');
    end
    % ---------- HERZFREQUENZ ---------------------------------------------
    if strcmp(plottype, 'baro')
        plot(ptrun.ptstate.cvs.H,'LineWidth',linewidth,'Color','black');
        hold on
        plot(ptrun.ptstate.cvs.Pas,'LineWidth',linewidth,'Color',plotcolors.art,'LineStyle',':');
        ylim([0,150]);
        ylabel({'Frequency (1/min)', 'Blood Pressure (mmHg)'});
        
        lgd=legend('$HR$', '$P_{\rm{as}}$');
        %lgd =legend('art. systemisch', 'ven. systemisch', 'art. pulmonal', 'ven. pulmonal');
    end
    % ---------- ESTIMATE syst. diast. ABP -------------------------------
    if strcmp(plottype, 'abps')
        plot(ptrun.ptstate.cvs.Pas,'LineWidth',linewidth,'Color',plotcolors.art,'LineStyle',':');
        hold on
        plot(ptrun.scores.Psystas,'LineWidth',linewidth,'Color',plotcolors.art);
        plot(ptrun.scores.Pdiastas,'LineWidth',linewidth,'Color','blue');
        ymax = max(ptrun.scores.Psystas) + 5;
        if ymax < 120
            ymax = 120;
        end
        ylim([0,ymax]);
        ylabel('Blood Pressure (mmHg)');
        lgd=legend('$P_{\rm{as}}$', '$P_{\rm{as}}^{\rm{syst}}$', '$P_{\rm{as}}^{\rm{diast}}$');
    end
    % ---------- PARTIALDRÜCKE -------------------------------------------
    if strcmp(plottype, 'bloodgas')
        plot(ptrun.ptstate.rs.PaO2,'LineWidth',0.75,'Color',plotcolors.o2);
        hold on
        plot(ptrun.ptstate.rs.PaCO2,'LineWidth',0.75,'Color',.5*plotcolors.co22+.5*plotcolors.co2);
        plot(ptrun.ptstate.rs.PvO2,'LineWidth',1.6*linewidth,'Color',plotcolors.o2,'LineStyle',':');
        plot(ptrun.ptstate.rs.PvCO2,'LineWidth',1.6*linewidth,'Color',.5*plotcolors.co22+.5*plotcolors.co2,'LineStyle',':');
        
        ymax = 155;
%         ymax = max(ptrun.ptstate.rs.PaO2) + 5;
%         if ymax < 120
%             ymax = 120;
%         end
        ylim([0,ymax]);
        ylabel('Partial Pressure (mmHg)');

        lgd=legend('$P_{\rm{a,O}_{2}}$', '$P_{\rm{a,CO}_{2}}$', '$P_{\rm{v,O}_{2}}$', '$P_{\rm{v,CO}_{2}}$');
        
    end
    % ---------- KLASSIFIKATION: HOROWITZ -------------------------------
    if strcmp(plottype, 'horovitz')
        plot(ptrun.ptstate.rs.horowitz,'LineWidth',linewidth,'Color',plotcolors.art);
        ylim([0,700]);
        ylabel('Horovitz-quotient (mmHg)');
        lgd=legend('Horovitz-quotient');
    end
    
    % ---------- KLASSIFIKATION: FONAROW -------------------------------
    if strcmp(plottype, 'fonarow')
        plot(ptrun.scores.pFon,'LineWidth',linewidth,'Color',plotcolors.art);
        ylim([0,30]);
        ylabel('Fonarow-Score');
        lgd=legend('Fonarow-score');
    end
    
        % ---------- KLASSIFIKATION: FONAROW-Low -------------------------------
    if strcmp(plottype, 'fonarow-low')
        plot(ptrun.scores.pFon,'LineWidth',linewidth,'Color',plotcolors.art);
        ylim([0,0.1]);
        ylabel('Fonarow-Score');
        lgd=legend('Fonarow-score');
    end
    
    % ---------- KLASSIFIKATION: RAJAN -------------------------------
    if strcmp(plottype, 'rajan')
        plot(ptrun.scores.RHF,'LineWidth',linewidth,'Color',plotcolors.art);
        ylim([0,100]);
        ylabel('R_HF');
        lgd=legend('Rajans Heart Failure score');
    end
    
    % ---------- KLASSIFIKATION: H/NTproBNP/LVEF ------------------------
    if strcmp(plottype, 'hfc2')
        plot(ptrun.scores.H,'LineWidth',linewidth,'Color','black');
        hold on
        plot(ptrun.scores.LVEF,'LineWidth',linewidth,'Color',plotcolors.art);
        plot(ptrun.scores.NTproBNP,'LineWidth',linewidth,'Color',plotcolors.bnp);
        ylim([0,1]);
        ylabel('Score');
        lgd=legend('$y_{HR}$', '$y_{EF}$', '$y_{\rm{NT-proBNP}}$');
    end
    % ---------- KLASSIFIKATION: LEF ------------------------
    if strcmp(plottype, 'lef')
        plot(ptrun.ptstate.cvs.LV.EF,'LineWidth',linewidth,'Color','black');
        ylim([0,1]);
        ylabel('LV-EF');
        lgd=legend('$LV-EF$');
    end
    
    % ---------- KLASSIFIKATION: LEF-Calculation------------------------
    if strcmp(plottype, 'lefcalc')
        plot(ptrun.ptstate.cvs.LV.Vdiast,'LineWidth',linewidth,'Color','blue');
        hold on
        plot(ptrun.ptstate.cvs.LV.Vstr,'LineWidth',linewidth,'Color','red','LineStyle',':');
        ylim([0,1]);
        ylabel('L');
        lgd=legend('$Vdiast$', '$Vstr$');
    end
    
    % ---------- KLASSIFIKATION: y-Score -------------------------------
    if strcmp(plottype, 'Phf')
        plot(ptrun.scores.Phf,'LineWidth',linewidth,'Color','black');
        ylim([0,1]);
        ylabel('Phf-Score');
        lgd=legend('Phf-Score');
    end
    
    % ----- x axis
    xlim([0,tmax]);
    xlabel('t (min)');
    
    if tmax == 600
        xticks([0 60 120 180 240 300 360 420 480 540 600]);
        xticklabels({'0','','','','','5','','','','','10'});
    elseif tmax == 1800
        xticks([0 300 600 900 1200 1500 1800]);
        xticklabels({'0','','10','','20','','30'});
    elseif tmax == 36000
        xticks([0 6000 12000 18000 24000 30000 36000]);
        xticklabels({'0','','200','','400','','600'});
    end
    set(gca, 'FontSize', axisFontSize, 'YGrid', 'on', 'XGrid', 'off');
%     set(gca, 'FontSize', axisFontSize, 'YGrid', 'on', 'XGrid', 'off', 'YMinorGrid', 'on');
    
    % ----- legend
    title('');
    if exist('lgd', 'var') ~= 0
        %print('Hallo');
        lgd.Interpreter = 'latex';
        lgd.FontSize = labelFontSize;
        lgd.Location = 'northoutside';
        lgd.NumColumns = 4;
        lgd.Orientation = 'horizontal';
        lgd.Box = 'off';
        lgd.ItemTokenSize = [20,18];
        
        %disp(lgd.EntryContainer.NodeChildren);
%         fprintf("num: %d", size(lgd.EntryContainer.NodeChildren));
%         for li = 1:size(lgd.EntryContainer.NodeChildren)
%             hLegendEntry = lgd.EntryContainer.NodeChildren(li);
%             hLegendIconLine = hLegendEntry.Icon.Transform.Children.Children;
%             %disp(hLegendIconLine);
%             hLegendIconLine.LineWidth = 5 * linewidth;
%             %assignin('base', 'lineInfo', hLegendIconLine);
%         end
        
    end
    
%     fprintf('size %d', size(lgd.EntryContainer.NodeChildren));
%     if strcmp(plottype, 'bloodgas')
%         for ii=1:4
%             legendEntry = lgd.EntryContainer.NodeChildren(ii);
%             legendEntry.Icon.Transform.Children.Children.LineWidth = 2 * i * linewidth;
%         end
%     end
    
    %hold off
    %fig = gcf;
    %f.Renderer = 'Painters';
    if saveplot
        f.set('visible', 'off');
        filename = ['plot-',ptrun.runtype,'-',ptrun.dia,'-',plottype,'-',datestr(now, 'yyyymmdd-HHMMSS'),'-pt',sprintf('%d',ptrun.patientid),'.pdf'];
        %saveas(gcf, [pwd '/plots/',filename], 'pdf')
        
        figuresize(12,10,'cm',0);
        print(gcf, [pwd '/plots/',filename], '-dpdf', '-fillpage', '-loose');
%         filename = ['plot-',ptrun.runtype,'-',ptrun.dia,'-',plottype,'-',datestr(now, 'yyyymmdd-HHMMSS'),'-pt',sprintf('%d',ptrun.patientid),'.png'];
%         saveas(gcf, [pwd '/plots/',filename], 'png')
        if openplot
            folder = fileparts(mfilename('fullpath'));
            winopen(fullfile(folder, 'plots', filename));
        end
    end
    

end