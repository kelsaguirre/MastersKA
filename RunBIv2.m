% go to folder with data
%cd '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/OCD_DBS_Study/Slot_bytime/Baseline'
%adding the way VF pulls functions w/out putting them in the data folder
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T0'; flagA=0;
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T1'; flagA=1;
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T2'; flagA=2;
data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T3'; flagA=3;

%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T4';
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T5';
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T6';
root_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic';
addpath('/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic')

cd (data_folder)

% fc = cell array of file names
fc = dir('slot*');
n_subjects=length(fc);
for i = 1:n_subjects
    subj{i,1}=fc(i).name;
end

%upperbound
mxb=100; %max value for Alpha and Beta'

%confused by this, how are the pars being shared 
%dont see pars or data defined?
par_names{1}='alpha shape';
par_names{2}='beta shape';
par_names{3}='threshold1';
par_names{4}='threshold2';
%par_names{5}='eta shape';
prmtn=length(par_names);
tic
for iS = 1:n_subjects
    cd (data_folder)
    clear data
    clear t_data
    clear cond3
    clear stim
    %disp(iS);
    toc
    load(subj{iS})
    %disp(subj{iS}) full data file name
    IDs{iS}=subj{iS}(13:15);
    disp(IDs{iS});
    %load real choice selections
    all_data{iS,1}=data;
    all_t_data{iS,1}=t_data;
    all_cond3{iS,1}=cond3;
    all_IDs{iS,1}=subj{iS};
    all_subj_IDs{iS,1}=IDs{iS};
    all_stim{iS,1}=stim;

%     [lambdalin,fvalin] = fminsearch(@(pars) basicBI3_lin(pars, data, mxb), [5 5 0.8 0.8]);
%     [lambdalog,fvalog] = fminsearch(@(pars) basicBI3_log(pars, data, mxb), [5 5 0.8 0.8]);
%     best_set(iS,1:prmtn)=lambdalin;
%     best_set(iS,prmtn+1)=fvalin;
% 
%     best_set(iS,(prmtn+2):(prmtn*2+1))=lambdalog;
%     best_set(iS,prmtn*2+2)=fvalog;

%focus on just log not lin
    [lambdalog,fvalog] = fminsearch(@(pars) basicBI3_log(pars, data, mxb), [5 5 0.8 0.8]);

    best_set(iS,1:prmtn)=lambdalog;
    best_set(iS,prmtn+1)=fvalog;

    %disp(all_IDs(iS,:));
    cd(root_folder)
    %save('partial_slot_opt_bays_dyn_T0', 'best_set');
    %all IDs is just the file name (w session, but not stim)
    save('partial_slot_opt_bays_dyn_wstim', 'best_set', 'all_stim');
end

mean_bs=mean(best_set(1:n_subjects,:));
std_bs=std(best_set(1:n_subjects,:));

if flagA==0
    save('slot_opt_bays_dyn_T0', 'best_set', 'all_cond3', 'all_t_data', 'all_data', 'all_IDs', 'all_subj_IDs', 'all_stim');
elseif flagA==1
    save('slot_opt_bays_dyn_T1', 'best_set', 'all_cond3', 'all_t_data', 'all_data', 'all_IDs', 'all_subj_IDs', 'all_stim');
elseif flagA==2
    save('slot_opt_bays_dyn_T2', 'best_set', 'all_cond3', 'all_t_data', 'all_data', 'all_IDs', 'all_subj_IDs', 'all_stim');
elseif flagA==3
    save('slot_opt_bays_dyn_T3', 'best_set', 'all_cond3', 'all_t_data', 'all_data', 'all_IDs', 'all_subj_IDs', 'all_stim');
end
%what is this plotting?

figure
scatter(ones(length(best_set(:,1)),1),best_set(:,1))
hold on
scatter(ones(length(best_set(:,1)),1)+0.1,best_set(:,2))
scatter(ones(length(best_set(:,1)),1)+1,best_set(:,4))
scatter(ones(length(best_set(:,1)),1)+1.1,best_set(:,5))