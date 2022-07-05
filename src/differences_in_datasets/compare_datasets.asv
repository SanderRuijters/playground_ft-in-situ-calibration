%% Initialize and load data

% Initialize
clear
close all
% clc

% Datasets cell
dataset_names = {'TEST_A_parsed'; 'TEST_B_parsed'; 'TEST_C_parsed'; 'TEST_D_parsed'};

%% Collect datasets

% Loop through datasets
for i = 1:length(dataset_names)

    % Load dataset
    load(dataset_names{i})

    % Save ft name to variable
    ft_names = fieldnames(dataset.expected_fts);
    ft_name = ft_names{1};

    % Save timestamps, measured and expected to struct
    data_to_compare.timestamps.(dataset_names{i}) = dataset.timestamp;              % 1 * 1 * 4 * Nx1
    data_to_compare.measured.(dataset_names{i}) = dataset.ft_values.(ft_name);      % 1 * 1 * 4 * Nx6
    data_to_compare.expected.(dataset_names{i}) = dataset.expected_fts.(ft_name);   % 1 * 1 * 4 * Nx6

end

%% Compute errors

% Expected FTs errors
comparison_timestamps = data_to_compare.timestamps.TEST_C_parsed;

% Loop through datasets
for i = 1:length(dataset_names)
    
    % Loop through timestamps
    for j = 1:length(comparison_timestamps)
        
        % Loop through 6 wrenches
        for k = 1:6

            % Save reference value to variable
            expected_reference = data_to_compare.expected.(dataset_names{1})(:,k); % Nx1
            measured_reference = data_to_compare.expected.(dataset_names{1})(:,k); % Nx1

            % Save real value to variable
            expected_real = data_to_compare.expected.(dataset_names{i})(:,k); % Nx1
            measured_real = data_to_compare.expected.(dataset_names{i})(:,k); % Nx1

            % Compute error
            expected_error = expected_real - expected_reference; % Nx1

        end
        
    end

    % Save error to struct
    errors.measured.(dataset_names{i}) = expected_error;
    errors.expected.(dataset_names{i}) = measured_error;

end

%% Plot results
