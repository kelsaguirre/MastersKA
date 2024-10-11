
% function [Y,stdE] = plot_lambdaVar_betainc_VIB_plots(data)
% function [Y,stdE] = plot_lambdaVar_betainc_VIB_plots(data, group)
clear all
% close all

root_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/lambdavar';
addpath('/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/lambdavar')
% Load the data when comparing all timepoints
data_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic';
cd (data_folder)
load('slot_opt_bays_dyn_baseline');
best_set_baseline = best_set;
all_IDs_baseline = all_IDs;
%for baseline
parsB=best_set_baseline(:,1:4);
%disp(parsB)
baselineIDs = all_IDs_baseline;
nsb=length(baselineIDs);
clear best_set
clear all_IDs

%time data for stim examples
load('slot_opt_bays_dyn_T0_stims.mat'); flagA=0;
%load('slot_opt_bays_dyn_T1_stims.mat'); flagA=1;
%load('slot_opt_bays_dyn_T2_stims.mat'); flagA=2;
%load('slot_opt_bays_dyn_T3_stims.mat'); flagA=3;

%start with therapeutic
% parsThera=Thera_best_set(:,2:5);
% Thera_IDs = Thera_best_set(:,1);
% nsThera = length(Thera_IDs);
% disp(nsThera)
% pars_thera_numeric = []; % Pre-allocate a cell array to store numeric data for each row
% for iS = 1:size(parsThera, 1) %a cell so it could have the subj info with the stim specific best_set
%     numericData = cell2mat(parsThera(iS,:)); % Convert the current row to numeric data
%     pars_thera_numeric = [pars_thera_numeric; numericData]; % Store the converted row in the new cell array
% end

%next off stim
% parsOff=Off_best_set(:,2:5);
% Off_IDs = Off_best_set(:,1);
% nsOff = length(Off_IDs);
% disp(nsOff)
% pars_off_numeric = []; % Pre-allocate a cell array to store numeric data for each row
% for iS = 1:size(parsOff, 1) %a cell so it could have the subj info with the stim specific best_set
%     numericData = cell2mat(parsOff(iS,:)); % Convert the current row to numeric data
%     pars_off_numeric = [pars_off_numeric; numericData]; % Store the converted row in the new cell array
% end

%next Lat stim
parsLat= Lat_best_set(:,2:5);
Lat_IDs = Lat_best_set(:,1);
nsLat = length(Lat_IDs);
%nsLat = (nsLat-1); %- added this for lat too T3 bc it was pulling extra datapt (also with off!)
disp(nsLat)
pars_lat_numeric = []; % Pre-allocate a cell array to store numeric data for each row
for iS = 1:size(parsLat, 1) %a cell so it could have the subj info with the stim specific best_set
    numericData = cell2mat(parsLat(iS,:)); % Convert the current row to numeric data
    pars_lat_numeric = [pars_lat_numeric; numericData]; % Store the converted row in the new cell array
end

% Baseline_color = [0.5 0.5 0.5]; %grey for baseline
% T0_color = [0.4 0.9 0.4]; % Lightest Green
% T1_color = [0.3 0.8 0.3]; % Medium Light Green
% T2_color = [0.2 0.6 0.2]; % Medium Dark Green
% T3_color = [0 0.4 0]; % Darkest Green

Baseline_color = [0.5 0.5 0.5]; %grey for baseline
Thera_color = [0.3 0.8 0.3]; % Medium Light Green
Off_color = [1, 0.3, 0.3]; % Medium Red
Lat_color = [0.3, 0.3, 0.9]; % Medium Blue

x=0.000:0.001:1;
clear Off_best_set
clear all_IDs

clear ybaseline
j=1;
%for baseline y (ybaseline)
while j<=nsb
    alpha=parsB(j,1);
    beta=parsB(j,2);
    th1=abs(parsB(j,4)-parsB(j,3));
    th2=parsB(j,3);
    if parsB(j,4)<parsB(j,3)
        eta=0;
    else
        eta=1;
    end
    
    if eta==0
        ybaseline(j,:)=th2-betainc(x,alpha,beta)*(th1);   %decreasing
    elseif eta==1
        ybaseline(j,:)=th2+betainc(x,alpha,beta)*(th1);       %growing
    end
        j=j+1;

end

clear yLat
i = 1;
while i<=nsLat
    alpha=pars_lat_numeric(i,1);
    beta=pars_lat_numeric(i,2);
    th1=abs(pars_lat_numeric(i,4)-pars_lat_numeric(i,3));
    th2=pars_lat_numeric(i,3);
    if pars_lat_numeric(i,4)<pars_lat_numeric(i,3)
        eta=0;
    else
        eta=1;
    end
    
    if eta==0
        yLat(i,:)=th2-betainc(x,alpha,beta)*(th1);   %decreasing
    elseif eta==1
        yLat(i,:)=th2+betainc(x,alpha,beta)*(th1);       %growing
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
hold off
% axis([0 1 0.3 1])

pTcol=[0.9 0.9 0.9];
p05col=pTcol-0.1;
p01col=p05col-0.1;
p005col=p01col-0.1;
p001col=p005col-0.1;

%figure
hold on
for tt1=1:length(ybaseline(1,:))
    [a p1(tt1) c d]=ttest2(ybaseline(:,tt1), yLat(:,tt1));
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
fig=filled_plot((ybaseline), Baseline_color, 0.8, (yLat), Lat_color, 0.4);
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
    legend([fig{1}, fig{3}], {'Pre-DBS', 'T0 Lateral'}, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14, 'Location','southwest')
elseif flagA==1
    legend([fig{1}, fig{3}], {'Pre-DBS', 'T1 Lateral'}, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14, 'Location','southwest')
elseif flagA==2
    legend([fig{1}, fig{3}], {'Pre-DBS', 'T2 Lateral'}, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14, 'Location','southwest')
elseif flagA==3
    legend([fig{1}, fig{3}], {'Pre-DBS', 'T3 Lateral'}, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14, 'Location','southwest')
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
    save('lambdaVar_betainc_Lat_T0', 'yLat')
elseif flagA==1
    save('lambdaVar_betainc_Lat_T1', 'yLat')
elseif flagA==2
    save('lambdaVar_betainc_Lat_T2', 'yLat')
elseif flagA==3
    save('lambdaVar_betainc_Lat_T3', 'yLat')
end
