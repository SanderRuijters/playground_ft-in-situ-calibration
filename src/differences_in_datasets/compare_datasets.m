%% Initialize and load data

% Initialize
clear
close all
% clc

% Select which plots to plot
plot_wrenches = false;
plot_differences = true;


%% Collect datasets

% Define dataset names
dataset_names = {'TEST_A';...
    'TEST_B';...
    'TEST_C';...
    'TEST_D'};
dataset_name = 'robot_logger_device_2022_05_04_16_39_15';
dataset_names = {...
    [dataset_name '_parsed' '_temperature'];...
    [dataset_name '_parsed'];...
    [dataset_name '_nQS_parsed' '_temperature'];...
    [dataset_name '_nQS_parsed']};


% Loop through datasets
for i = 1:length(dataset_names)

    % Save dataset location to variable
    setsTEST = 'TEST_SETS/';
    parsed_sets_location = ['../../../DATASETS/' setsTEST];

    % Load dataset
    load([parsed_sets_location dataset_names{i}])

    % Save ft name to variable
    ft_names = fieldnames(dataset.expected_fts);
    ft_name = ft_names{1};

    % Save timestamps, measured and expected to struct
    data_to_compare.timestamps.(dataset_names{i}) = dataset.timestamp;              % 1 * 1 * 4 * Nx1
    data_to_compare.measured.(dataset_names{i}) = dataset.ft_values.(ft_name);      % 1 * 1 * 4 * Nx6
    data_to_compare.expected.(dataset_names{i}) = dataset.expected_fts.(ft_name);   % 1 * 1 * 4 * Nx6

end

%% Compute differences

% Reference indexes and real indexes
reference_indexes = [1 3];
real_indexes = [2 4];

% Loop through normal and interpolated datasets
comparison_names = {'one_and_two'; 'three_and_four'};
for i = 1:length(comparison_names)

    % Save reference values to variable
    reference_index = reference_indexes(i);
    expected_reference = data_to_compare.expected.(dataset_names{reference_index});
    measured_reference = data_to_compare.measured.(dataset_names{reference_index});
    
    % Save real values to variable
    real_index = real_indexes(i);
    expected_real = data_to_compare.expected.(dataset_names{real_index});
    measured_real = data_to_compare.measured.(dataset_names{real_index});
    
    % Compute differences
    expected_difference = expected_real - expected_reference;
    measured_difference = measured_real - measured_reference;
    
    % Save timestamps to variable
    timestamps = data_to_compare.timestamps.(dataset_names{reference_index});

    % Save differences and timestamps to struct
    differences.(comparison_names{i}).expected = expected_difference;
    differences.(comparison_names{i}).measured = measured_difference;
    differences.(comparison_names{i}).timestamps = timestamps;

end


%% Plot all wrenches

% See if it needs to be plotted
if plot_wrenches

    % Create tiled layout for measured FTs
    fig = figure;
    fig.Position = [0 0 1000 800];
    tiledlayout(3,2);
    
    % Create variable for axis labels
    yaxis_labels = {'Fx'; 'Tx'; 'Fy'; 'Ty'; 'Fz'; 'Tz'};
    
    % Loop through wrenches
    ft_order = [1 4 2 5 3 6];
    for i = 1:length(ft_order)
    
        % Plot in next tile
        nexttile
    
        % Loop through 4 datasets
        for j = 1:length(dataset_names)
    
            % Offset timestamps and save it to variable
            uncorrected_timestamps = data_to_compare.timestamps.(dataset_names{j});
            offset_timestamps = uncorrected_timestamps(1);
            timestamps = uncorrected_timestamps - repmat(offset_timestamps,size(uncorrected_timestamps,1),1);
    
            % Save wrench to variable
            wrench = data_to_compare.measured.(dataset_names{j})(:,ft_order(i));
    
            % Plot wrench vs timestamp
            plot(timestamps,wrench)
    
            % Hold on for next dataset
            hold on
    
            % Legend and axis labels
            legend show
            ylabel(yaxis_labels{i})
            xlabel('time')
            legend(dataset_names, 'Interpreter','none')
    
        end
    
    end

end


%% Plot differences

% See if it needs to be plotted
if plot_differences
    
    % Create variable for axis labels
    yaxis_labels = {'difference'; 'difference'; 'difference'; 'difference'; 'difference'; 'difference'};
    title_entries = {'Fx'; 'Tx'; 'Fy'; 'Ty'; 'Fz'; 'Tz'};
    
    % Loop through measured and expected
    wrenches_names = fieldnames(differences.(comparison_names{1}));
    wrenches_names = wrenches_names(1:2,:);
    wrenches_names = wrenches_names(1);
    for i = 1:length(wrenches_names)
    
        % Create tiled layout for measured FTs
        fig = figure;
        fig.Position = [0 0 1000 800];
        til = tiledlayout(3,2);
    
        % Loop through wrenches
        ft_order = [1 4 2 5 3 6];
        for j = 1:length(ft_order)
        
            % Plot in next tile
            nexttile
        
            % Loop through normal and interpolated
            for k = 1:length(comparison_names)
        
                % Offset timestamps and save it to variable
                uncorrected_timestamps = differences.(comparison_names{k}).timestamps;
                offset_timestamps = uncorrected_timestamps(1);
                timestamps = uncorrected_timestamps - repmat(offset_timestamps,size(uncorrected_timestamps,1),1);
        
                % Save difference to variable
                difference = differences.(comparison_names{k}).(wrenches_names{i})(:,ft_order(j));
        
                % Plot difference vs timestamp
                plot(timestamps,difference)
        
                % Hold on for next dataset
                hold on
        
                % Legend and axis labels
                legend show
                grid on
                title(title_entries{j})
                ylabel(yaxis_labels{i})
                xlabel('time')
                legend(comparison_names, 'Interpreter','none')
        
            end
        
        end
    
        % Title
        title(til,{'Difference between assuming and not assuming a QS-situation' [ 'Wrenches: ' wrenches_names{i}]})
    
    end

end

