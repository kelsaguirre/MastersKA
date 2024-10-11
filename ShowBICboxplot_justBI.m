function ShowBICboxplot_justBI(BIC_BI_simple, BIC_BI_dynamic)
    % This function takes two arrays of BIC scores and plots them in a boxplot
    % Load the data
    cd '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_simple';
    load('BIC_BI_simple.mat');
    cd '/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic';
    load('BIC_BI_dynamic.mat');
    % This function takes two arrays of BIC scores and plots them in a boxplot
    
    % Combine the data into a matrix, as boxplot requires
    data = [BIC_BI_simple(:), BIC_BI_dynamic(:)];
    
    % Create the boxplot
    bp = boxplot(data, 'Labels', {'BI Simple', 'BI Dynamic'});
    title('Bayesian Observer Models Compared');
    ylabel('BIC Score');
    ylim([50,210])
    xlabel('Model Type');
    
    % Add grid for better readability
    grid on;
    
    % Colors for the models:
    colors = [0.6471 0.8118 0.4392; %light green
              0.2471 0.3882 0.0627]; %dark green

    % Adjust the color setting loop
    h = findobj(gca,'Tag','Box');
    h = flipud(h); %because color order was flipping
    for j=1:length(h)
        colorIndex = mod(j-1, size(colors, 1)) + 1; % Ensures the color index wraps around
        patch(get(h(j),'XData'),get(h(j),'YData'),colors(colorIndex,:),'FaceAlpha',.75);
    end

    set(bp,'LineWidth',2)
    %why would I want to flip here?
    %set(gca,'children',flipud(get(gca,'children')))

    % Add individual subject dots
    hold on;
    nGroups = size(data, 2);
    jitterAmount = 0.3; % Adjust this value for more or less jitter
    positions = [1, 2]; % Specify the positions for your 4 model groups
    outerSize = 8; % Size of the dot for the outline
    innerSize = 8; % Size of the center dot

    % Initialize arrays to store jittered x positions for each model
    x_positions_model1 = zeros(size(data(:,1)));
    x_positions_model2 = zeros(size(data(:,2)));

    for i = 1:nGroups
        % Add a little jitter to the x-coordinates
        jitter = (rand(size(data(:, i))) - 0.5) * jitterAmount;
        x = positions(i) + jitter;

        % Store jittered x positions for each model
        if i == 1
            x_positions_model1 = x;
        else
            x_positions_model2 = x;
        end

        % Plot the outer dot in black for the outline
        plot(x, data(:, i), 'ko', 'MarkerSize', outerSize, 'MarkerFaceColor', 'k');
        % Plot the inner dot in the corresponding model color
        plot(x, data(:, i), 'o', 'MarkerSize', innerSize, 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', 'none');
        %plot(x, data(:, i), 'k.', 'MarkerSize', 20);
    end

    % Positions in the x-axis for each group
    biSimplePos = 1;
    biDynamicPos = 2;


    % Significance info
    comparisons = [...
        struct('groups', [biSimplePos, biDynamicPos], 'pValue', 0.0150144)];

    % Maximum height of box plots for determining starting height of lines
    maxHeight = 175; % Adjust as needed

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
        lineHeight = maxHeight + (i-1) * 15;
        
        % Draw the line
        line(comparisons(i).groups, [lineHeight, lineHeight], 'Color', 'k', 'LineWidth', 2);
        
        % Add text (significance level)
        text(mean(comparisons(i).groups), lineHeight + 2, sigLevel, 'HorizontalAlignment', 'center', 'FontSize', 22);
    end

    hold off;

    %change to scatter w participants dots for monday 
    
    %ttest between bayesian
    %compare mean and BIC score
    %within subject ttest
    
    [h, p, ci, stats] = ttest(BIC_BI_simple, BIC_BI_dynamic);
    
    % Display the results
    fprintf('T-test results:\n');
    fprintf('Hypothesis Test Result (h): %d\n', h);
    fprintf('P-value (p): %g\n', p);
    fprintf('Confidence Interval of the difference (ci): [%g %g]\n', ci(1), ci(2));
    fprintf('Test statistics: \n');
    disp(stats);
    
end
