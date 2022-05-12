clear; close all;
%% LOAD 3 DATASETS LOGGED FROM SEVERAL EXPERIMENTS

% List .mat files in folder
print_directory = false;
if print_directory
    dir ../investigating_robot_logger_device_variable_sizes/
end

% Add path and load mat file
addpath(genpath('../../../logged_data/'))
% logged_file = 'robot_logger_device_2022_05_04_15_10_44'; % 23195 23196 23196 23196 23196 23197 23197 23200 23201
% logged_file = 'robot_logger_device_2022_05_04_15_13_29'; %X 6486 6485 6485 6485 6485 6484 6484 6481 6480
% logged_file = 'robot_logger_device_2022_05_04_16_00_30'; % 15894 15894 15894 15894 15894 15894 15894 15894 15894
logged_file = 'robot_logger_device_2022_05_04_16_36_25'; %X 23609 23610 23610 23610 23610 23610 23611 23613 23614
% logged_file = 'robot_logger_device_2022_05_04_16_39_15'; %X 6710 6709 6709 6709 6709 6708 6708 6706 6705
load(logged_file);


%% FIND SHORTEST AND LONGEST SIZES

% Get field names
data_field_names.joint_names = robot_logger_device.description_list;
data_field_names.logged_variable_names = fieldnames(robot_logger_device);
data_field_names.ft_names_yarp = fieldnames(robot_logger_device.FTs);
data_field_names.joint_states = fieldnames(robot_logger_device.joints_state);

% Loop through and save FT data dimensions
for i=1:size(data_field_names.ft_names_yarp,1)
    ft_data_dimensions(i,:,:,:) = robot_logger_device.FTs.(data_field_names.ft_names_yarp{i}).dimensions; %#ok<*SAGROW> 
end
% ft_data_dimensions
% Loop through and save joint state dimensions
for i = 1:size(data_field_names.joint_states,1)
    joint_state_dimensions(i,:,:,:) = robot_logger_device.joints_state.(data_field_names.joint_states{i}).dimensions;
end
% joint_state_dimensions
% % Required to extract:
% robot_logger_device.joints_state.positions.timestamps
% robot_logger_device.joints_state.positions.data
% robot_logger_device.joints_state.velocities.data


%% ANALYZE TIMESTAMPS

% Save timestamps to different variable
timestamps.FT1 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{1}).timestamps;
timestamps.FT2 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{2}).timestamps;
timestamps.FT3 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{3}).timestamps;
timestamps.FT4 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{4}).timestamps;
timestamps.FT5 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{5}).timestamps;
timestamps.FT6 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{6}).timestamps;
timestamps.FT7 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{7}).timestamps;
timestamps.joints_state_acc = robot_logger_device.joints_state.(data_field_names.joint_states{2}).timestamps;
timestamps.joints_state_vel = robot_logger_device.joints_state.(data_field_names.joint_states{3}).timestamps;
timestamps.joints_state_pos = robot_logger_device.joints_state.(data_field_names.joint_states{4}).timestamps;

% timestamps.motors_state = robot_logger_device.motors_state.positions.timestamps;
% timestamps.cartesian_wrenches = robot_logger_device.cartesian_wrenches.right_arm_wrench_client.timestamps;
% timestamps.temperatures = robot_logger_device.temperatures.id_r_upper_arm_strain.timestamps;
% timestamps.accelerometers = robot_logger_device.accelerometers.rfeimu_acc.timestamps;
% timestamps.orientations = robot_logger_device.orientations.rfeimu_eul.timestamps;
% timestamps.gyros = robot_logger_device.gyros.rfeimu_gyro.timestamps;
% timestamps.FTs = robot_logger_device.FTs.id_r_upper_arm_strain.timestamps;
% timestamps.PIDs = robot_logger_device.PIDs.timestamps;
% timestamps.joints_state = robot_logger_device.joints_state.positions.timestamps;

% convert to cell
timestamps_cell = struct2cell(timestamps);

% Loop to find sizes of timestamps
for i = 1:size(timestamps_cell,1)
    timestamp_sizes(i) = size(timestamps_cell{i},2);
    timestamp_min_values(i) = min(timestamps_cell{i});
    timestamp_max_values(i) = max(timestamps_cell{i});
end
timestamps_min = min(timestamp_min_values);
timestamps_max = max(timestamp_max_values);
timestamps_difference = timestamps_max - timestamps_min;

desired_timestamp_delta = 0.025;
num_new_timestamp_points = timestamps_difference / desired_timestamp_delta;
new_timestamps = timestamps_min:desired_timestamp_delta:timestamps_min+timestamps_max*desired_timestamp_delta;

% Minimum timestamp size
min_timestamp_size = min(timestamp_sizes);
sprintf('Minimum timestamp sizes = %d',min_timestamp_size)
sprintf('%d ',timestamp_sizes)


%% ANALYZE SIMILARITY OF MATRICES

% Preallocate matrix
equal_matrix = zeros(size(timestamps_cell,1));
diff_cell = cell(size(timestamps_cell,1),1);
mean_diff_cell = cell(size(timestamps_cell,1),1);
normalized_timestamps_cell = cell(size(timestamps_cell,1),1);

% Loop to fill matrix
for i = 1:size(timestamps_cell,1)
    for j = 1:size(timestamps_cell,1)
        equal_matrix(i,j) = isequal(timestamps_cell{i}(1:min_timestamp_size),timestamps_cell{j}(1:min_timestamp_size));
    end
    diff_cell{i} = diff(timestamps_cell{i});
    mean_diff_cell{i} = mean(diff_cell{i});
    normalized_timestamps_cell{i} = timestamps_cell{i}-repmat(timestamps_cell{i}(1),1,size(timestamps_cell{i},2));
end
diff_cell
normalized_timestamps_cell

% Test if matrix is filled with ones
equal_matrix
sprintf('Matrix is filled with ones = %d',min(min(equal_matrix)))


%% PLOT
end_data_point = 200;

figure
plot(timestamps_cell{1})
hold on
plot(timestamps_cell{3})
hold off
xlim([0 end_data_point])

figure
plot(diff_cell{1})
hold on
plot(diff_cell{3})
hold off
xlim([0 end_data_point])


%% TEST WITH STRUCT2CELL
% robot_logger_device_cell = struct2cell(robot_logger_device);
% robot_logger_device_cell{2}
% robot_logger_device_cell1 = struct2cell(robot_logger_device_cell{2});
% robot_logger_device_cell1{2}

