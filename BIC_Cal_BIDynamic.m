clear all

data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/Baseline';
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T0'; flagA=0;
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T1'; flagA=1;
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T2'; flagA=2;
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T3'; flagA=3;
root_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic';
addpath('/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic')

%dont have these saving yet
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T4'; flagA=4;
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T5'; flagA=5;
%data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/T6'; flagA=6;

cd (data_folder) %i need to pull from log simple to start

% fc = cell array of file names
fc = dir('slot*');
n_subjects=length(fc);
for i = 1:n_subjects
    subj{i,1}=fc(i).name;
end

% Total number of data points
%change this name
totalDataPoints = 0; % You will calculate this in the loop

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
    IDs{iS}=subj{iS}(13:15);
    %load real choice selections
    all_data{iS,1}=data;
    %all_t_data{iS,1}=t_data;
    %all_cond3{iS,1}=cond3;
    %all_IDs{iS,1}=subj{iS};

    [lambdalog,fvalog] = fminsearch(@(pars) basicBI3_log2(pars, data, mxb), [5 5 0.8 0.8]);

    best_set(iS,1:prmtn)=lambdalog;
    best_set(iS,prmtn+1)=fvalog;

    %disp(best_set(iS,:));

    %trying to add in a calculation for missing choices 
    cd(root_folder)
    missing = dir('block*');
    missingchoicefilename = (missing.name);
    % Load the existing missing data from basicBI3_log2 script
    data = load(missingchoicefilename);
    
    % Access the existing variables
    slotprior = data.slotprior;
    numchoices = data.numchoices;
    
    % Add new data (example)
    subject = iS;
    missing_ID = IDs(iS);

    cd (data_folder)
    % Save the updated data back to the same file
    save('missingchoice.mat', 'slotprior', 'numchoices', 'subject', 'missing_ID');

end

[aic1,bic1] = aicbic(-best_set(:,end),4,80);
%disp(bic1)
disp(mean(bic1));
disp(std(bic1));

%Save the BIC score original
%disp(bic1)
BIC_BI_dynamic = bic1;
cd(root_folder)
save('BIC_BI_dynamic', 'BIC_BI_dynamic');

%Save the BIC score longitudional modification for saving
%disp(bic1)
% BIC_BI_dynamic = bic1;
% cd(root_folder)
% 
% if flagA==0
%     save('BIC_BI_dynamic_T0', 'BIC_BI_dynamic');
% elseif flagA==1
%     save('BIC_BI_dynamic_T1', 'BIC_BI_dynamic');
% elseif flagA==2
%     save('BIC_BI_dynamic_T2', 'BIC_BI_dynamic');
% elseif flagA==3
%     save('BIC_BI_dynamic_T3', 'BIC_BI_dynamic');
% end

%save('BIC_BI_dynamic_T6', 'BIC_BI_dynamic_T6');

%(:,end)bc I need all of the last column for fvalog
%total valid trial is diff than num trials bc people can skip
%[aic1,bic1] = aicbic(-best_set(:,end),4,tot_valid_trials);

%switch to cal for each subject

%fvalog is already the sum!
%totalLogLikelihood = sum(fvalog);
% Update total number of data points
%this can be replaced too
%totalDataPoints = totalDataPoints + length(data);

%compare mean and BIC score
%within subject ttest
% Calculate BIC
%use the matlab aic and bic 
%BIC_BI_dynamic = log(totalDataPoints) * n_subjects * prmtn - 2 * fvalog;

%plot in another script
