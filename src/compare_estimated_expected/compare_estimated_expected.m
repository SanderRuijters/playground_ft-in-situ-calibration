%% Initialize and load data

% Initialize
clear
close all
clc


%% Prepare

% Save plot options
save_plots = true;
current_timestamp = datestr(now,'yyyy_mm_dd_HH_MM_SS');

% Load dataset
load('robot_logger_device_2022_05_27_15_14_58_nQS_parsed_temperature.mat')

% Save variables
estimated_wrenches = dataset.ft_values.l_arm_ft_sensor;
expected_wrenches = dataset.expected_fts.l_arm_ft_sensor;
uncorrected_timestamps = dataset.timestamp;
offset_timestamps = uncorrected_timestamps(1);
timestamps = uncorrected_timestamps - repmat(offset_timestamps,size(uncorrected_timestamps,1),1);


%% Plot

% Create tiled layout for measured FTs
fig = figure;
fig.Position = [0 0 1000 800];
til = tiledlayout(3,2);
yaxis_labels = {'Force [N]'; 'Torque [N.m]'; 'Force [N]'; 'Torque [N.m]'; 'Force [N]'; 'Torque [N.m]'};
title_entries = {'Fx'; 'Tx'; 'Fy'; 'Ty'; 'Fz'; 'Tz'};

% Loop through wrenches
ft_order = [1 4 2 5 3 6];
for i = 1:length(ft_order)
    
    % Next tile
    nexttile

    % Plot
    plot(timestamps,expected_wrenches(:,ft_order(i)),timestamps,estimated_wrenches(:,ft_order(i)))
    xlabel('Time [s]')
    ylabel(yaxis_labels{i})
    title(title_entries{i})
    legend('Actual', 'Estimated')
    grid on

end

% Title
title(til,'Actual and estimated wrenches')

% Save plot
if save_plots
    image_file_name = [current_timestamp, '-performance_of_workbench_calibration'];
    disp(['Saving image to: ', image_file_name,'.png']);
    saveas(gcf,[image_file_name],'png');
end

