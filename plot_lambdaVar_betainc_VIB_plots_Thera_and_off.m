
% function [Y,stdE] = plot_lambdaVar_betainc_VIB_plots(data)
% function [Y,stdE] = plot_lambdaVar_betainc_VIB_plots(data, group)
clear all
% close all

root_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/lambdavar';
addpath('/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/lambdavar')
% Load the data when comparing all timepoints
data_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic';
clear best_set
clear all_IDs
clear OFf_best_set
clear Off_IDs
clear Thera_best_set
clear Thera_IDs

%time data for stim examples
cd (data_folder)
%therapeutic
%load('slot_opt_bays_dyn_T0_stims.mat'); flagA=0;
%load('slot_opt_bays_dyn_T1_stims.mat'); flagA=1;
%load('slot_opt_bays_dyn_T2_stims.mat'); flagA=2;
load('slot_opt_bays_dyn_T3_stims.mat'); flagA=3;

%start with off stimulation

parsOff=Off_best_set(:,2:5);
Off_IDs = Off_best_set(:,1);
nsOff = length(Off_IDs);
disp(nsOff)
pars_off_numeric = []; % Pre-allocate a cell array to store numeric data for each row
for iS = 1:size(parsOff, 1) %a cell so it could have the subj info with the stim specific best_set
    numericData = cell2mat(parsOff(iS,:)); % Convert the current row to numeric data
    pars_off_numeric = [pars_off_numeric; numericData]; % Store the converted row in the new cell array
end

%then therapeutic stimulation for overlay

parsThera=Thera_best_set(:,2:5);
Thera_IDs = Thera_best_set(:,1);
nsThera = length(Thera_IDs);
disp(nsThera)
pars_thera_numeric = []; % Pre-allocate a cell array to store numeric data for each row
for iS = 1:size(parsThera, 1) %a cell so it could have the subj info with the stim specific best_set
    numericData = cell2mat(parsThera(iS,:)); % Convert the current row to numeric data
    pars_thera_numeric = [pars_thera_numeric; numericData]; % Store the converted row in the new cell array
end

Stim_off_color = [0.5 0.5 0.5]; %grey for baseline
T0_color = [0.4 0.9 0.4]; % Lightest Green
T1_color = [0.3 0.8 0.3]; % Medium Light Green
T2_color = [0.2 0.6 0.2]; % Medium Dark Green
T3_color = [0 0.4 0]; % Darkest Green

x=0.000:0.001:1;

clear yOff
i = 1;
while i<=nsOff
    alpha=pars_off_numeric(i,1);
    beta=pars_off_numeric(i,2);
    th1=abs(pars_off_numeric(i,4)-pars_off_numeric(i,3));
    th2=pars_off_numeric(i,3);
    if pars_off_numeric(i,4)<pars_off_numeric(i,3)
        eta=0;
    else
        eta=1;
    end
    
    if eta==0
        yOff(i,:)=th2-betainc(x,alpha,beta)*(th1);   %decreasing
    elseif eta==1
        yOff(i,:)=th2+betainc(x,alpha,beta)*(th1);       %growing
    end
        i=i+1;
end

clear yThera
i = 1;
while i<=nsThera
    alpha=pars_thera_numeric(i,1);
    beta=pars_thera_numeric(i,2);
    th1=abs(pars_thera_numeric(i,4)-pars_thera_numeric(i,3));
    th2=pars_thera_numeric(i,3);
    if pars_thera_numeric(i,4)<pars_thera_numeric(i,3)
        eta=0;
    else
        eta=1;
    end
    
    if eta==0
        yThera(i,:)=th2-betainc(x,alpha,beta)*(th1);   %decreasing
    elseif eta==1
        yThera(i,:)=th2+betainc(x,alpha,beta)*(th1);       %growing
    end
        i=i+1;
end

%to look at individual lines
% figure
% hold on
% for j=1:length(ybaseline(:,1))
%         plot(x,ybaseline(j,:), 'Color', [0 0 0]);
%         ybaseline(j,:)=ybaseline(j,:);
% end

% for j=1:length(yT0(:,1))
%         plot(x,yT0(j,:), 'Color', [0.7 0.2 0.2]);
%         yT0(j,:)=yT0(j,:);
% end
set(gca,'XTick',(0:0.25:1), 'XTickLabel',(0:1/6:1)+1/3)
xlabel('Priors')
ylabel('Likelihood')
%hold off
% axis([0 1 0.3 1])

pTcol=[0.9 0.9 0.9];
p05col=pTcol-0.1;
p01col=p05col-0.1;
p005col=p01col-0.1;
p001col=p005col-0.1;

figure
hold on
for tt1=1:length(yOff(1,:))
    [a p1(tt1) c d]=ttest2(yOff(:,tt1), yThera(:,tt1));
    if p1(tt1)<=.001
        burly=plot([tt1 tt1], [0.3 1], 'Color', p001col, 'LineWidth', 1);
    elseif p1(tt1)<=.005
        burly=plot([tt1 tt1], [0.3 1], 'Color', p005col, 'LineWidth', 1);
    elseif p1(tt1)<=.01
        burly=plot([tt1 tt1], [0.3 1], 'Color', p01col, 'LineWidth', 1);
%         Effect = meanEffectSize(yhc(:,tt1),ynu(:,tt1), Effect="cohen");
%         Effect = meanEffectSize(yhc(:,tt1),ynu(:,tt1), Effect="robustcohen");
    elseif p1(tt1)<=.05
        burly=plot([tt1 tt1], [0.3 1], 'Color', p05col, 'LineWidth', 1);
    elseif p1(tt1)<=.1
        burly=plot([tt1 tt1], [0.3 1], 'Color', pTcol, 'LineWidth', 1);
    end
end
fig=filled_plot((yOff), Stim_off_color, 0.8, (yThera), T1_color, 0.4);
hold off
% After your plot commands, without modifying the plot() function itself
lines = findobj(gca, 'Type', 'Line');
set(lines, 'LineWidth', 2);
set(gca,'XTick',(0:250:1000), 'XTickLabel',({'1/3','1/2','2/3','5/6','1'}))
set(gca,'YTick',(0:0.1:1), 'YTickLabel',0:0.1:1)
axis([0 1000 0.3 1])
set(gca, 'Layer', 'Top')
%xlabel('Priors')
%ylabel('Likelihood')
% Setting the font name, weight, and size for the current axes
set(gca, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14);

% Setting the font name, weight, and size for the axes labels explicitly
xlabel('Priors', 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14);
ylabel('Likelihood', 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14);

%save based on data loaded in
if flagA==0
    legend([fig{1}, fig{3}], {'T0 Off', 'T0 Therapeutic'}, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14, 'Location','southwest')
elseif flagA==1
    legend([fig{1}, fig{3}], {'T1 Off', 'T1 Therapeutic'}, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14, 'Location','southwest')
elseif flagA==2
    legend([fig{1}, fig{3}], {'T2 Off', 'T2 Therapeutic'}, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14, 'Location','southwest')
elseif flagA==3
    legend([fig{1}, fig{3}], {'T3 Off', 'T3 Therapeutic'}, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14, 'Location','southwest')
end
legend boxoff

% Set the line width for the axes
set(gca, 'LineWidth', 2);

%HC-NU comparison
% pars_mod=pars;
% for tti=1:length(pars(1,:))
%     [a p2(tti) c d]=ttest2(pars_mod(1:25,tti), pars_mod(26:end,tti));
% end
%     [a p2(tti+1) c d]=ttest2(pars_mod(1:25,1)-pars_mod(1:25,2), pars_mod(26:end,1)-pars_mod(26:end,2));


%cd (root_folder)
%     save('post_processing_Slot', 'yhc', 'ynu', 'pars_mod')
% rmpath('E:\MSSM\AHIP\models')

%save the values to I can plot easier when I want all 5
cd (root_folder)
if flagA==0
    save('lambdaVar_betainc_Off_and_Thera_T0', 'yThera')
elseif flagA==1
    save('lambdaVar_betainc_Off_and_Thera_T1', 'yThera')
elseif flagA==2
    save('lambdaVar_betainc_Off_and_Thera_T2', 'yThera')
elseif flagA==3
    save('lambdaVar_betainc_Off_and_Thera_T3', 'yThera')
end
