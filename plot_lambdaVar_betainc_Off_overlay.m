
% function [Y,stdE] = plot_lambdaVar_betainc_VIB_plots(data)
% function [Y,stdE] = plot_lambdaVar_betainc_VIB_plots(data, group)
clear all
% close all

root_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/lambdavar';
addpath('/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/lambdavar')
% Load the data when comparing all timepoints
data_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic';


cd (root_folder)
%off brining in curves from all timepoints 

clear yOff
%load in all curves and rename to plot together
load('lambdaVar_betainc_Off_T0.mat');
T0yOff = yOff;
clear yOff 
load('lambdaVar_betainc_Off_T1.mat');
T1yOff = yOff;
clear yOff
load('lambdaVar_betainc_Off_T2.mat');
T2yOff = yOff;
clear yOff
load('lambdaVar_betainc_Off_T3.mat');
T3yOff = yOff;


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

%red for off stimulation
T0_color = [0.5 0.5 0.5]; %grey for baseline
T1_color = [1, 0.5, 0.5]; %light Red
T2_color = [1, 0.3, 0.3]; %medium Red
T3_color = [1, 0.1, 0.1]; %Deeper Red

pTcol=[0.9 0.9 0.9];
p05col=pTcol-0.1;
p01col=p05col-0.1;
p005col=p01col-0.1;
p001col=p005col-0.1;

%NEED TO MODIFY THE TTEST LINE, THE FIG LINE AND THE LEGEND TO SWITCH FROM
%TIMEPOINTS CORRECTLY

hold on
for tt1=1:length(T0yOff(1,:))
    %[a p1(tt1) c d]=ttest2(T0yOff(:,tt1), T1yOff(:,tt1));
    %[a p1(tt1) c d]=ttest2(T0yOff(:,tt1), T2yOff(:,tt1));
    [a p1(tt1) c d]=ttest2(T0yOff(:,tt1), T3yOff(:,tt1));
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
%fig=filled_plot((T0yOff), T0_color, 0.8, (T1yOff), T1_color, 0.4);
%fig=filled_plot((T0yOff), T0_color, 0.8, (T2yOff), T2_color, 0.4);
fig=filled_plot((T0yOff), T0_color, 0.8, (T3yOff), T3_color, 0.4);
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
%legend([fig{1}, fig{3}], {'Off T0', 'Off T1'}, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14, 'Location','southwest')
%legend([fig{1}, fig{3}], {'Off T0', 'Off T2'}, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14, 'Location','southwest')
legend([fig{1}, fig{3}], {'Off T0', 'Off T3'}, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 14, 'Location','southwest')
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
