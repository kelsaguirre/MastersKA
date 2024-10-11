clear all

data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/Baseline';
root_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_simple';
addpath('/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_simple')

cd (data_folder) %i need to pull from log simple to start

% fc = cell array of file names
fc = dir('slot*');
n_subjects=length(fc);
for i = 1:n_subjects
    subj{i,1}=fc(i).name;
end

par_names{1}='lambda shape';
prmtn=length(par_names);
tic

% Loop over each subject
for iS = 1:n_subjects
    cd (data_folder)
    clear data
    clear t_data
    clear cond3
    disp(iS);
    toc
    %added data here
    data=load(subj{iS});
    IDs{iS}=subj{iS}(9:10);
    %load real choice selections
    all_data{iS,1}=data;
    %all_t_data{iS,1}=t_data;
    %all_cond3{iS,1}=cond3;
    %all_IDs{iS,1}=subj{iS};

    [lambdalog,fvalog] = fminsearch(@(pars) BI_log_simple2(pars,data), 0.8);
    best_set(iS,(prmtn+2):(prmtn*2+1))=lambdalog;
    %sum of all log probs 
    best_set(iS,prmtn*2+2)=fvalog;
   
    %(:,end) 
    %bc I need all of the last column for fvalog
    %total valid trial is diff than num trials bc people can skip
    %[aic1,bic1] = aicbic(-best_set(:,end),4,tot_valid_trials);
    %[aic1,bic1] = aicbic(-best_set(:,end),4,80);

    disp(best_set(iS,:));
    %disp(bic1(iS,:));
    %cd(root_folder)
    %save('BIC_BI_simple', 'best_set');

end

[aic1,bic1] = aicbic(-best_set(:,end),4,80);
disp(bic1)
disp(mean(bic1))
disp(std(bic1))
%Save the BIC score
BIC_BI_simple = bic1;
cd(root_folder)
save('BIC_BI_simple', 'BIC_BI_simple');

%compare mean and BIC score
%within subject ttest
% Calculate BIC WRONG
%BIC_BI_simple = log(totalDataPoints) * n_subjects * prmtn - 2 * fvalog;
%plot in another script
%5/9 baseline have 1 for lambda log - should be fine 
%fvalog is all diff which is great!
