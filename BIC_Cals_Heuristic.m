clear all

data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/Baseline';
root_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/heuristic';
addpath('/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/heuristic')

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

par_names{1}='alpha shape';
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

    [alphalog,fvalog] = fminsearch(@(pars) basicheuristiclog2(pars,data), 0.2);
    
    best_set(iS,(prmtn+2):(prmtn*2+1))=alphalog;
    %sum of all log probs 
    best_set(iS,prmtn*2+2)=fvalog;

end

%check if there's really 80 trials per subject
[aic1,bic1] = aicbic(-best_set(:,end),4,80);
disp(bic1)
disp(mean(bic1))
disp(std(bic1))

%Save the BIC score
BIC_Heuristic = bic1;
cd(root_folder)
save('BIC_Heuristic', 'BIC_Heuristic');

%plot in another script