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
estimated_wrenches = dataset.ft_values.l_arm_ft_sensor(:,1);
expected_wrenches = dataset.expected_fts.l_arm_ft_sensor(:,1);
uncorrected_timestamps = dataset.timestamp;
offset_timestamps = uncorrected_timestamps(1);
timestamps = uncorrected_timestamps - repmat(offset_timestamps,size(uncorrected_timestamps,1),1);


%% Plot

% Plot
figure
plot(timestamps,expected_wrenches,timestamps,estimated_wrenches)
xlabel('Time [s]')
ylabel('Force [N]')
title('Performance of workbench calibration')
legend('Actual', 'Estimated')
grid on

% Save plot
if save_plots
    image_file_name = [current_timestamp, '-performance_of_workbench_calibration'];
    disp(['Saving image to: ', image_file_name,'.png']);
    saveas(gcf,[image_file_name],'png');
end

