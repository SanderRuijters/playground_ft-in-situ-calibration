%% Initialize and load data

% Initialize
clear
close all
% clc

% Select which plots to plot
plot_wrenches = true;
plot_errors = true;


%% Collect datasets

% Loop through datasets
dataset_names = {'TEST_A'; 'TEST_B'; 'TEST_C'; 'TEST_D'};
for i = 1:length(dataset_names)

    % Save dataset location to variable
    setsTEST = 'TEST_SETS/';
    parsed_sets_location = ['../../../DATASETS/' setsTEST];

    % Load dataset
    load([parsed_sets_location dataset_names{i} '_parsed'])

    % Save ft name to variable
    ft_names = fieldnames(dataset.expected_fts);
    ft_name = ft_names{1};

    % Save timestamps, measured and expected to struct
    data_to_compare.timestamps.(dataset_names{i}) = dataset.timestamp;              % 1 * 1 * 4 * Nx1
    data_to_compare.measured.(dataset_names{i}) = dataset.ft_values.(ft_name);      % 1 * 1 * 4 * Nx6
    data_to_compare.expected.(dataset_names{i}) = dataset.expected_fts.(ft_name);   % 1 * 1 * 4 * Nx6

end

%% Compute errors

% Reference indexes and real indexes
reference_indexes = [1 3];
real_indexes = [2 4];

% Loop through normal and interpolated datasets
comparison_names = {'normal'; 'interpolated'};
for i = 1:length(comparison_names)

    % Save reference values to variable
    reference_index = reference_indexes(i);
    expected_reference = data_to_compare.expected.(dataset_names{reference_index});
    measured_reference = data_to_compare.measured.(dataset_names{reference_index});
    
    % Save real values to variable
    real_index = real_indexes(i);
    expected_real = data_to_compare.expected.(dataset_names{real_index});
    measured_real = data_to_compare.measured.(dataset_names{real_index});
    
    % Compute errors
    expected_error = expected_real - expected_reference;
    measured_error = measured_real - measured_reference;
    
    % Save timestamps to variable
    timestamps = data_to_compare.timestamps.(dataset_names{reference_index});

    % Save errors and timestamps to struct
    errors.(comparison_names{i}).expected = expected_error;
    errors.(comparison_names{i}).measured = measured_error;
    errors.(comparison_names{i}).timestamps = timestamps;

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


%% Plot errors

% See if it needs to be plotted
if plot_errors
    
    % Create variable for axis labels
    yaxis_labels = {'error'; 'error'; 'error'; 'error'; 'error'; 'error'};
    title_entries = {'Fx'; 'Tx'; 'Fy'; 'Ty'; 'Fz'; 'Tz'};
    
    % Loop through measured and expected
    wrenches_names = fieldnames(errors.(comparison_names{1}));
    wrenches_names = wrenches_names(1:2,:);
    for i = 1:length(wrenches_names)
    
        % Create tiled layout for measured FTs
        fig = figure;
        fig.Position = [0 0 1000 800];
        tit = tiledlayout(3,2);
    
        % Loop through wrenches
        ft_order = [1 4 2 5 3 6];
        for j = 1:length(ft_order)
        
            % Plot in next tile
            nexttile
        
            % Loop through normal and interpolated
            for k = 1:length(comparison_names)
        
                % Offset timestamps and save it to variable
                uncorrected_timestamps = errors.(comparison_names{k}).timestamps;
                offset_timestamps = uncorrected_timestamps(1);
                timestamps = uncorrected_timestamps - repmat(offset_timestamps,size(uncorrected_timestamps,1),1);
        
                % Save error to variable
                error = errors.(comparison_names{k}).(wrenches_names{i})(:,ft_order(j));
        
                % Plot error vs timestamp
                plot(timestamps,error)
        
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
        title(tit,{'Error between assuming and not assuming a QS-situation' [ 'Wrenches: ' wrenches_names{i}]})
    
    end

end

