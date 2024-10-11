% Access files that are organized
cd '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/diagnostics';

% Load baseline data
load('slot_baseline_data.mat', 'baseline_all_data');

% Load treatment data
load('slot_T1_data.mat', 'Lat_all_data_clean', 'Off_all_data_clean', 'Thera_all_data_clean'); 

% Calculate mean switch rates for each subject
baseline_means = calculate_subject_means(baseline_all_data);
off_means = calculate_subject_means(Off_all_data_clean);
thera_means = calculate_subject_means(Thera_all_data_clean);
lat_means = calculate_subject_means(Lat_all_data_clean);

% Calculate standard errors for each condition
baseline_se = calculate_standard_error(baseline_means);
off_se = calculate_standard_error(off_means);
thera_se = calculate_standard_error(thera_means);
lat_se = calculate_standard_error(lat_means);

% Initialize arrays to store means and standard errors
means = [mean(baseline_means), mean(off_means), mean(thera_means), mean(lat_means)];
errors = [baseline_se, off_se, thera_se, lat_se];

% Create the bar plot with error bars
figure;
b = bar(means, 'FaceColor', 'flat');
hold on;
errorbar(1:4, means, errors, 'k', 'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 10);

% Customize the plot
set(gca, 'XTickLabel', {'Pre-DBS', 'Stim: Off', 'Stim: Therapeutic', 'Stim: Lateral'}, 'FontSize', 11, 'LineWidth', 2);
ylabel('Switch Probability');
ylim([0 .75]);
title_text = 'Switch Probability Pre-DBS and T1'; % Define title text
title(title_text);
text(0.5, .65, 'Pre-DBS N = 11', 'FontSize', 14);
text(3.5, .65, 'T1 N = 10', 'FontSize', 14);

% Add colors to bars
colors = [0.5 0.5 0.5; 1 0 0; 0 1 0; 0 0 1]; % Grey, Red, Green, Blue
for k = 1:4
    b.CData(k, :) = colors(k, :);
end

%subject_data = [baseline_means,off_means,thera_means,lat_means];
subject_errors = [baseline_se,off_se,thera_se,lat_se];

% perform between subject ttest2
[h_off, p_off, ci_off, stats_off] = ttest2(subject_data(:,1), subject_data(:,2));
[h_thera, p_thera, ci_thera, stats_thera] = ttest2(subject_data(:,1), subject_data(:,3));
[h_lat, p_lat, ci_lat, stats_lat] = ttest2(subject_data(:,1), subject_data(:,4));

% Save means and p-values to a .mat file
save_filename = [strrep(title_text, ' ', '_') '.mat'];
save(save_filename, 'subject_data', 'subject_errors', 'baseline_means', 'off_means', 'thera_means', 'lat_means', 'p_off', 'p_thera', 'p_lat');

% Positions in the x-axis for each group
Pre_DBS = 1;
Stim_off = 2;
Stim_thera = 3;
Stim_lat = 4;

% Significance info
comparisons = [...
    struct('groups', [Pre_DBS, Stim_off], 'pValue', p_off), ...
    struct('groups', [Pre_DBS, Stim_thera], 'pValue', p_thera), ...
    struct('groups', [Pre_DBS, Stim_lat], 'pValue', p_lat)];

% Maximum height of box plots for determining starting height of lines
maxHeight = max(.475); % Adjust as needed based on your plot's ylim

% Drawing significance lines and annotations
for i = 1:length(comparisons)
    pValue = comparisons(i).pValue;
    if pValue < 0.001
        sigLevel = '***';
    elseif pValue < 0.01
        sigLevel = '**';
    elseif pValue < 0.05
        sigLevel = '*';
    else
        sigLevel = 'n.s.';
    end

    % Adjust line height for each comparison to avoid overlap
    lineHeight = maxHeight + (i-1) * .05;
    
    % Draw the line
    line(comparisons(i).groups, [lineHeight, lineHeight], 'Color', 'k', 'LineWidth', 1.5);
    
    % Add text (significance level)
    text(mean(comparisons(i).groups), lineHeight + .025, sigLevel, 'HorizontalAlignment', 'center', 'FontSize', 11);
end


% Helper function to calculate mean switch rate for each subject
function subject_means = calculate_subject_means(data)
    num_subjects = numel(data);
    subject_means = zeros(num_subjects, 1);
    
    for i = 1:num_subjects
        subject_sum = 0;
        subject_count = 0;
        for j = 1:numel(data{i})
            matrix = data{i}{j};
            if ~isempty(matrix)
                % Initialize variables to track switches and repeats
                switch_count = 0;
                count = size(matrix, 1);
                last_choice = matrix(1, 1); % Initialize the last choice with the first choice

                % Iterate through the choices in the matrix
                for k = 2:count % Start from the second choice
                    if matrix(k, 1) ~= 0 % Check if the current choice is not empty
                        if matrix(k, 1) ~= last_choice % Check for a switch
                            switch_count = switch_count + 1;
                        end
                        last_choice = matrix(k, 1); % Update the last choice
                    end
                end

                % Calculate the switch rate for this matrix
                if count > 1
                    switch_rate = switch_count / (count - 1);
                    subject_sum = subject_sum + switch_rate;
                    subject_count = subject_count + 1;
                end
            end
        end
        if subject_count > 0
            subject_means(i) = subject_sum / subject_count;
        else
            subject_means(i) = NaN; % Handle cases where no valid data is present
        end
    end
end

% Helper function to calculate standard error
function se = calculate_standard_error(data)
    se = std(data, 'omitnan') / sqrt(numel(data(~isnan(data))));
end

