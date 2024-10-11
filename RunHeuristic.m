% go to folder with data
%cd '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/OCD_DBS_Study/Slot_bytime/Baseline'

%adding the way VF pulls functions w/out putting them in the data folder
data_folder= '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/Slot_bytime/Baseline';
root_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/heuristic';
addpath('/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/heuristic')

cd (data_folder)

% fc = cell array of file names
fc = dir('slot*');
n_subjects=length(fc);
for i = 1:n_subjects
    subj{i,1}=fc(i).name;
end

par_names{1}='alpha shape';
prmtn=length(par_names);
tic
for iS = 1:n_subjects
    cd (data_folder)
    clear data
    clear t_data
    clear cond3
    disp(iS);
    toc
    load(subj{iS})
    IDs{iS}=subj{iS}(9:10);
    %load real choice selections
    all_data{iS,1}=data;
    all_t_data{iS,1}=t_data;
    all_cond3{iS,1}=cond3;
    all_IDs{iS,1}=subj{iS};
     
    %data=data_folder;
    [alphalin,fvalin] = fminsearch(@(pars) basicheuristiclin(pars,data), 0.2);
    [alphalog,fvalog] = fminsearch(@(pars) basicheuristiclog(pars,data), 0.2);

    best_set(iS,1:prmtn)=alphalin;
    best_set(iS,prmtn+1)=fvalin;

    best_set(iS,(prmtn+2):(prmtn*2+1))=alphalog;
    best_set(iS,prmtn*2+2)=fvalog;

    disp(best_set(iS,:));
    cd(root_folder)
    save('partial_slot_opt_heuristic_baseline', 'best_set');
end

mean_bs=mean(best_set(1:n_subjects,:))
std_bs=std(best_set(1:n_subjects,:))

save('slot_opt_heuristic_baseline', 'best_set', 'all_cond3', 'all_t_data', 'all_data', 'all_IDs');

%what is this plotting?

figure
scatter(ones(length(best_set(:,1)),1),best_set(:,1))
hold on
scatter(ones(length(best_set(:,1)),1)+0.1,best_set(:,2))
scatter(ones(length(best_set(:,1)),1)+1,best_set(:,4))
%scatter(ones(length(best_set(:,1)),1)+1.1,best_set(:,5))