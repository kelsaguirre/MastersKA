%Script to pull the best_set from RunBI results on the longitudional data
%file called partial_slot_opt_bays_dyn_T0->6
%do I need to do this with just the log? I'm going to do with both first
%function [stims_ordered] = PullStims(slot_opt_bays_dyn_T0)
%partial_slot_opt_bays_dyn_T1, partial_slot_opt_bays_dyn_T2)

%can I clear up here before I load? Makes more sense to me
clear all_stim
clear best_set
clear all_cond3
clear all_t_data
clear all_data
clear all_IDs

root_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic';
addpath('/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic')

% Load the data when comparing all timepoints
%data_folder = '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic';
cd (root_folder)
%load('slot_opt_bays_dyn_T0.mat'); flagA=0;
%load('slot_opt_bays_dyn_T1.mat'); flagA=1;
%load('slot_opt_bays_dyn_T2.mat'); flagA=2;
load('slot_opt_bays_dyn_T3.mat'); flagA=3;

%need to modify the following to pull out the rows with specific stims from
%best_set from RunBI script? not the BIC cal script (maybe compare that
%with the ybocs scores?

%then either save or pull them and save with best_set
% Calculate the total number of subjects
%nS = size(all_stim, 1);
nS = length(best_set);
%from function GetD3
%Subject = cell(nS,1);
%Stim = all_stim;

%stims = ['O','L','T','M','V']; -all 5
%focusing on just three
stims = ['O','L','T'];
stims = cellstr(stims');
%initalize as zeros
StimO = zeros(nS,1);
StimO_ind = zeros(nS,1);
StimL = zeros(nS,1);
StimL_ind = zeros(nS,1);
StimT = zeros(nS,1);
StimT_ind = zeros(nS,1);

%take the beginning of the names and make a subject list by removing the duplicates
%remove the data structure stuff and just export the saved data into a mat
%data file?
for iS = 1:size(all_stim,1)
    cd (root_folder)
    %clear all_stim
    Stim{iS} = all_stim{iS,1};
    %Replace unwanted characters with an empty string
    unwantedChars = {'\', '=', ' '};
    ogString = Stim{iS};
    new_string = ''; %Initialize an empty string
    %string = Stim{iS};
    for char_ind = 1:strlength(ogString)
    char = extractBetween(ogString, char_ind, char_ind);
        if ~ismember(char,unwantedChars)
            new_string = [new_string, char]; %Concatenate to remove the unwanted character
        end
    end
    all_stim{iS, 1} = new_string; %Update all_stim with the cleaned strings
end

%separate out data from the different stimulations
for iStim = 1:nS
    currentStim = all_stim{iStim};
    if strcmp(currentStim, stims(1))
        StimO_ind(iStim) = iStim; %to pull out the index of the row 
        StimO(iStim) = 1;
    elseif strcmp(currentStim, stims(2))
        StimL_ind(iStim) = iStim; %to pull out the index of the row 
        StimL(iStim) = 1;
    elseif strcmp(currentStim, stims(3))
        StimT_ind(iStim) = iStim; %to pull out the index of the row 
        StimT(iStim) = 1;
    end
end
Off_best_set_data = best_set(StimO == 1, :);
Lat_best_set_data = best_set(StimL == 1, :);
Thera_best_set_data = best_set(StimT == 1, :);

%add the data file name to this too for subj comparison
%to keep the file names with the stim data
% Define the indices arrays and corresponding result containers as a cell array
indexArrays = {StimO_ind, StimL_ind, StimT_ind};
bestSetData = {Off_best_set_data, Lat_best_set_data, Thera_best_set_data};
resultContainers = {'Off_best_set', 'Lat_best_set', 'Thera_best_set'};

% Loop through each stimulation condition
for n = 1:length(indexArrays)
    nonZeroIndices = find(indexArrays{n} > 0); % Find non-zero entries
    relevant_IDs = all_IDs(nonZeroIndices); % Filter all_IDs based on nonZeroIndices
    % Initialize the cell array for the current stim condition
    current_best_set = cell(size(bestSetData{n}, 1), size(bestSetData{n}, 2) + 1);
    % Fill in the IDs into the first column
    for i = 1:length(relevant_IDs)
        current_best_set{i, 1} = relevant_IDs{i}; % Add the relevant ID
    end
    % Fill in the numeric data from the corresponding best_set_data into columns 2 through end
    for i = 1:size(bestSetData{n}, 1)
        current_best_set(i, 2:end) = num2cell(bestSetData{n}(i, :));
    end
    % Assign the constructed cell array to the corresponding result container
    eval([resultContainers{n} ' = current_best_set;']);
end

cd(root_folder)

%works!!
if flagA==0
    save('slot_opt_bays_dyn_T0_stims', 'Off_best_set', 'Lat_best_set', 'Thera_best_set',...
        'best_set', 'all_cond3', 'all_t_data', 'all_data', 'all_IDs', 'all_stim');
elseif flagA==1
    save('slot_opt_bays_dyn_T1_stims', 'Off_best_set', 'Lat_best_set', 'Thera_best_set',...
        'best_set', 'all_cond3', 'all_t_data', 'all_data', 'all_IDs', 'all_stim');
elseif flagA==2
    save('slot_opt_bays_dyn_T2_stims', 'Off_best_set', 'Lat_best_set', 'Thera_best_set',...
        'best_set', 'all_cond3', 'all_t_data', 'all_data', 'all_IDs', 'all_stim');
elseif flagA==3
    save('slot_opt_bays_dyn_T3_stims', 'Off_best_set', 'Lat_best_set', 'Thera_best_set',...
        'best_set', 'all_cond3', 'all_t_data', 'all_data', 'all_IDs', 'all_stim');
end

%before the flags
%save('slot_opt_bays_dyn_T0_stims', 'Off_best_set', 'Lat_best_set', 'Thera_best_set');

%before the file name storing loop at the end
%did like this for just off stimulation initially
% %Find non-zero entries in
% nonZeroIndices = find(StimO_ind>0); % This gives you the indices where Stim is present
% % Filter all_IDs based on nonZeroIndices
% relevant_IDs = all_IDs(nonZeroIndices);
% 
% Off_best_set = cell(size(Off_best_set_data, 1), size(Off_best_set_data, 2) + 1);
% % Initialize the cell array (above and below the same)
% %Off_best_set = cell(size(Off_best_set_data, 1), size(Off_best_set_data, 2) + 1);
% 
% % Assuming the rest of your setup is correct and you've already defined Off_best_set_data and relevant_IDs
% % Fill in the IDs into the first column of Off_best_set
% for i = 1:length(relevant_IDs)
%     Off_best_set{i, 1} = relevant_IDs{i}; % Add the relevant ID to the first column
% end
% % Continue to fill in the numeric data from Off_best_set_data into columns 2 through end
% for i = 1:size(Off_best_set_data, 1)
%     Off_best_set(i, 2:end) = num2cell(Off_best_set_data(i, :));
% end