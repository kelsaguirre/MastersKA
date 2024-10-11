function ShowBICboxplot_all4_sig(BIC_Heuristic, BIC_RL, BIC_BI_simple, BIC_BI_dynamic)

    % This function takes two arrays of BIC scores and plots them in a boxplot
    % Load the data
    cd '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_simple';
    load('BIC_BI_simple.mat');
    cd '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic';
    load('BIC_BI_dynamic.mat');
    cd '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code'/reinforcement_learning/;
    load('BIC_RL.mat');
    cd '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code'/heuristic/;
    load('BIC_Heuristic.mat');
    % This function takes two arrays of BIC scores and plots them in a boxplot
    
    % Combine the data into a matrix, as boxplot requires
    data = [BIC_Heuristic(:), BIC_RL(:), BIC_BI_simple(:), BIC_BI_dynamic(:)]; 

    % Create the boxplot
    bp = boxplot(data, 'Labels', {'Heuristic', 'RL', 'BI Simple', 'BI Dynamic'});
    title('All BIC Scores Comparison');
    ylabel('BIC Score');
    ylim([50,310])
    xlabel('Model Type');
    
    % Add grid for better readability
    grid on;

    % Colors for the models:
    colors = [0.4941 0.1843 0.5569; %purple
              0 0.4471 0.7412; %blue
              0.6471 0.8118 0.4392; %light green
              0.2471 0.3882 0.0627]; %dark green

    % Adjust the color setting loop
    h = findobj(gca,'Tag','Box');
    h = flipud(h);
    for j=1:length(h)
        colorIndex = mod(j-1, size(colors, 1)) + 1; % Ensures the color index wraps around
        patch(get(h(j),'XData'),get(h(j),'YData'),colors(colorIndex,:),'FaceAlpha',.75);
    end

    set(bp,'LineWidth',1.5)
    %why would I want to flip here?
    %set(gca,'children',flipud(get(gca,'children')))

    % Add individual subject dots
    hold on;
    nGroups = size(data, 2);
    jitterAmount = 0.2; % Adjust this value for more or less jitter
    positions = [1, 2, 3, 4]; % Specify the positions for your 4 model groups
    outerSize = 8; % Size of the dot for the outline
    innerSize = 5; % Size of the center dot

    % Initialize arrays to store jittered x positions for each model
    x_positions_model1 = zeros(size(data(:,1)));
    x_positions_model2 = zeros(size(data(:,2)));
    x_positions_model3 = zeros(size(data(:,3)));
    x_positions_model4 = zeros(size(data(:,4)));

    for i = 1:nGroups
        % Add a little jitter to the x-coordinates
        jitter = (rand(size(data(:, i))) - 0.5) * jitterAmount;
        x = positions(i) + jitter;

        % Store jittered x positions for each model
        if i == 1
            x_positions_model1 = x;
        elseif i==2
            x_positions_model2 = x;
        elseif i==3
            x_positions_model3 = x;
        else
            x_positions_model4 = x;
        end

        % Plot the outer dot in black for the outline
        plot(x, data(:, i), 'ko', 'MarkerSize', outerSize, 'MarkerFaceColor', 'k');
        % Plot the inner dot in the corresponding model color
        plot(x, data(:, i), 'o', 'MarkerSize', innerSize, 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', 'none');
        %plot(x, data(:, i), 'k.', 'MarkerSize', 20);
    end

    % Draw lines connecting each subject's scores across the two models
%     for i = 1:size(data, 1)
%         plot([x_positions_model1(i), x_positions_model2(i),  x_positions_model3(i),  x_positions_model4(i)], ...
%             [data(i, 1), data(i, 2), data(i, 3), data(i, 4)], 'k-', 'LineWidth', 1);
%     end
    
%adding the stats from all4_flip script
% Adding the t-test result for BI Dynamic vs. Heuristic
tTestStr1 = sprintf(['BI Dyn vs. Heuristic:\n', ...
    'H: %d, p: %.5g\n'], ...
    1, 7.27016e-05);

% Position for the first t-test result
xPos1 = 1; % Adjust based on figure layout
yPos1 = 75; % Slightly below the upper y-axis limit
text(xPos1, yPos1, tTestStr1, 'FontSize', 10, 'HorizontalAlignment', 'center', 'BackgroundColor', 'white');

% Adding the t-test result for BI Dynamic vs. RL
tTestStr2 = sprintf(['BI Dyn vs. RL:\n', ...
    'H: %d, p: %.7g\n'], ...
    1, 2.5623e-06);

% Position for the second t-test result
xPos2 = 2; % Adjust based on figure layout
yPos2 = 75; % Same vertical position, different horizontal
text(xPos2, yPos2, tTestStr2, 'FontSize', 10, 'HorizontalAlignment', 'center', 'BackgroundColor', 'white');

% Adding the t-test result for BI Dynamic vs. BI Simple
tTestStr3 = sprintf(['BI Dyn vs. BI Simple:\n', ...
    'H: %d, p: %.7g\n'], ...
    1, 0.0150144);

% Position for the third t-test result
xPos3 = 3; % Adjust based on figure layout
yPos3 = 250; % Same vertical position, different horizontal
text(xPos3, yPos3, tTestStr3, 'FontSize', 10, 'HorizontalAlignment', 'center', 'BackgroundColor', 'white');

    hold off;
%     
%     %ttest between both bayesian
%     %compare mean and BIC score within subject ttest
%     [h, p, ci, stats] = ttest(BIC_BI_dynamic, BIC_Heuristic);
%     % Display the results
%     fprintf('T-test results: for BI Dynamic and Heuristic\n');
%     fprintf('Hypothesis Test Result (h): %d\n', h);
%     fprintf('P-value (p): %g\n', p);
%     fprintf('Confidence Interval of the difference (ci): [%g %g]\n', ci(1), ci(2));
%     fprintf('Test statistics: \n');
%     disp(stats);

    %ttest between bayesian dyn and RL
    %compare mean and BIC score within subject ttest
    [h, p, ci, stats] = ttest(BIC_BI_dynamic, BIC_RL);
    % Display the results
    fprintf('T-test results: for BI Dynamic and RL\n');
    fprintf('Hypothesis Test Result (h): %d\n', h);
    fprintf('P-value (p): %g\n', p);
    fprintf('Confidence Interval of the difference (ci): [%g %g]\n', ci(1), ci(2));
    fprintf('Test statistics: \n');
    disp(stats);
% 
% 
%     %ttest between both bayesian
%     %compare mean and BIC score within subject ttest
%     [h, p, ci, stats] = ttest(BIC_BI_dynamic, BIC_BI_simple);
%     % Display the results
%     fprintf('T-test results: for BI Dynamic and BI Simple\n');
%     fprintf('Hypothesis Test Result (h): %d\n', h);
%     fprintf('P-value (p): %g\n', p);
%     fprintf('Confidence Interval of the difference (ci): [%g %g]\n', ci(1), ci(2));
%     fprintf('Test statistics: \n');
%     disp(stats);
    
end
