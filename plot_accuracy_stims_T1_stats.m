% Access files that are organized
cd '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/diagnostics';

% Load baseline data
load('slot_baseline_data.mat', 'baseline_all_data');

% Load treatment data
load('slot_T1_data.mat', 'Lat_all_data_clean', 'Off_all_data_clean', 'Thera_all_data_clean'); 

% Calculate mean and standard error for baseline data
[baseline_mean, baseline_means] = calculate_mean_accuracy(baseline_all_data);
baseline_se = calculate_standard_error(baseline_all_data);

% Initialize arrays to store means and standard errors
means = zeros(1, 4);
errors = zeros(1, 4);

% Store baseline mean and error
means(1) = baseline_mean;
errors(1) = baseline_se;

% Calculate means for each condition
[off_mean, off_means] = calculate_mean_accuracy(Off_all_data_clean);
[thera_mean, thera_means] = calculate_mean_accuracy(Thera_all_data_clean);
[lat_mean, lat_means] = calculate_mean_accuracy(Lat_all_data_clean);

% Calculate standard errors for each condition
off_se = calculate_standard_error(Off_all_data_clean);
thera_se = calculate_standard_error(Thera_all_data_clean);
lat_se = calculate_standard_error(Lat_all_data_clean);

% Store treatment means and errors
means(2:4) = [off_mean, thera_mean, lat_mean];
errors(2:4) = [off_se, thera_se, lat_se];

% Create the bar plot with error bars
figure;
b = bar(means, 'FaceColor', 'flat');
hold on;
errorbar(1:4, means, errors, 'k', 'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 10);

% Customize the plot
set(gca, 'XTickLabel', {'Pre-DBS', 'Stim: Off', 'Stim: Therapeutic', 'Stim: Lateral'}, 'FontSize', 11, 'LineWidth', 2);
ylabel('Accuracy');
ylim([0 1]);
title_text = 'Mean Accuracy Pre-DBS and T1'; % Define title text
title(title_text);
text(0.5, 0.90, 'Pre-DBS N = 11', 'FontSize', 14);
text(3.5, 0.90, 'T1 N = 10', 'FontSize', 14);

% Add colors to bars
colors = [0.5 0.5 0.5; 1 0 0; 0 1 0; 0 0 1]; % Grey, Red, Green, Blue
for k = 1:4
    b.CData(k, :) = colors(k, :);
end

% Concatenate means into subject_data
subject_data = [baseline_means, off_means, thera_means, lat_means];

% Save standard errors
subject_errors = [baseline_se, off_se, thera_se, lat_se];

% Perform between-subject t-tests
[h_off, p_off, ci_off, stats_off] = ttest2(baseline_means, off_means);
[h_thera, p_thera, ci_thera, stats_thera] = ttest2(baseline_means, thera_means);
[h_lat, p_lat, ci_lat, stats_lat] = ttest2(baseline_means, lat_means);

% Save means, errors, and p-values to a .mat file
save_filename = [strrep(title_text, ' ', '_') '.mat'];
save(save_filename, 'subject_errors', 'baseline_means', 'off_means', 'thera_means', 'lat_means', 'h_off', 'p_off', 'ci_off', 'stats_off', 'h_thera', 'p_thera', 'ci_thera', 'stats_thera', 'h_lat', 'p_lat', 'ci_lat', 'stats_lat');

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
maxHeight = max(.7); % Adjust as needed based on your plot's ylim

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

% Helper function to calculate mean accuracy from the nested cell structure
function [mean_accuracy, subject_means] = calculate_mean_accuracy(data)
    correct_count = 0;
    total_count = 0;
    subject_means = zeros(1, numel(data));

    for i = 1:numel(data)
        subject_correct_count = 0;
        subject_total_count = 0;
        for j = 1:numel(data{i})
            matrix = data{i}{j};
            if ~isempty(matrix)
                subject_total_count = subject_total_count + size(matrix, 1);
                for k = 1:size(matrix, 1)
                    choice = matrix(k, 1);
                    if choice == 1 && matrix(k, 3) == 1
                        correct_count = correct_count + 1;
                        subject_correct_count = subject_correct_count + 1;
                    elseif choice == 2 && matrix(k, 4) == 1
                        correct_count = correct_count + 1;
                        subject_correct_count = subject_correct_count + 1;
                    elseif choice == 3 && matrix(k, 5) == 1
                        correct_count = correct_count + 1;
                        subject_correct_count = subject_correct_count + 1;
                    end
                end
            end
        end
        subject_means(i) = subject_correct_count / subject_total_count;
        total_count = total_count + subject_total_count;
    end

    mean_accuracy = correct_count / total_count;
end

% Helper function to calculate standard error from the nested cell structure
function se = calculate_standard_error(data)
    subject_means = [];
    for i = 1:numel(data)
        for j = 1:numel(data{i})
            matrix = data{i}{j};
            if ~isempty(matrix)
                subject_means(end+1) = mean(matrix(:, 1));
            end
        end
    end
    se = std(subject_means) / sqrt(numel(subject_means));
end
