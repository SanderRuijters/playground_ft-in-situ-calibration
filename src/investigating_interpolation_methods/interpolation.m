clear; 
close all;
%% LOAD DATASETS LOGGED FROM SEVERAL EXPERIMENTS

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
% logged_file = 'robot_logger_device_2022_05_04_16_36_25'; %X 23609 23610 23610 23610 23610 23610 23611 23613 23614
logged_file = 'robot_logger_device_2022_05_04_16_39_15'; %X 6710 6709 6709 6709 6709 6708 6708 6706 6705
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

% % Print result
% ft_data_dimensions

% Loop through and save joint state dimensions
for i = 1:size(data_field_names.joint_states,1)
    joint_state_dimensions(i,:,:,:) = robot_logger_device.joints_state.(data_field_names.joint_states{i}).dimensions;
end

% % Print result
% joint_state_dimensions


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
    timestamp_start_values(i) = min(timestamps_cell{i});
    timestamp_end_values(i) = max(timestamps_cell{i});
end

% Compute min and max start value
timestamps_min_start_value = min(timestamp_start_values);
timestamps_max_start_value = max(timestamp_start_values);

% Compute min and max end value
timestamps_min_end_value = min(timestamp_end_values);
timestamps_max_end_value = max(timestamp_end_values);

% Compute minimum timestamp size and print it
min_timestamp_size = min(timestamp_sizes);
sprintf('Minimum timestamp sizes = %d',min_timestamp_size)
sprintf('%d ',timestamp_sizes)

%% Compute desired timestamp vector

% Get info from original timestamps
desired_timestamps_min = timestamps_min_end_value;
desired_timestamps_max = timestamps_max_start_value;

% Defined desired sample rate 
interpolation_timestamp_delta = 0.025;

% Compute characteristics of desired timestamps vector
desired_timestamps_max_difference = desired_timestamps_min - desired_timestamps_max;
num_new_timestamp_points = floor(desired_timestamps_max_difference / interpolation_timestamp_delta);
desired_timestamps_start = desired_timestamps_min;
desired_timestamps_end = desired_timestamps_min+interpolation_timestamp_delta*num_new_timestamp_points;

% Compute expected differece and amount the vector is shortened
desired_timestamps_difference = desired_timestamps_end - desired_timestamps_start;
desired_timestamps_shortened = desired_timestamps_max_difference - desired_timestamps_difference;

% Construct desired timestamps vector
interpolation_timestamps_vector = linspace(desired_timestamps_start,desired_timestamps_end,num_new_timestamp_points);

% Investigate correctness of desired timestamps vector
desired_timestamps_vector_start = min(interpolation_timestamps_vector);
desired_timestamps_vector_end = max(interpolation_timestamps_vector);
desired_timestamps_start_error = desired_timestamps_start - desired_timestamps_vector_start;
desired_timestamps_end_error = desired_timestamps_end - desired_timestamps_vector_end;


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
    normalized_timestamps_cell{i} = timestamps_cell{i}-repmat(timestamps_cell{1}(1),1,size(timestamps_cell{i},2));
end
diff_cell
normalized_timestamps_cell

% Test if matrix is filled with ones
equal_matrix
sprintf('Matrix is filled with ones = %d',min(min(equal_matrix)))


%% PERFORM INTERPOLATION

% Preallocate, fill and convert to cell
raw_data_struct.FT1 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{1}).data;
raw_data_struct.FT2 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{2}).data;
raw_data_struct.FT3 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{3}).data;
raw_data_struct.joints_state_pos = robot_logger_device.joints_state.(data_field_names.joint_states{4}).data;
raw_data_cell = struct2cell(raw_data_struct);

% Preallocate, fill and convert to cell
raw_timestamps_struct.FT1 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{1}).timestamps;
raw_timestamps_struct.FT2 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{2}).timestamps;
raw_timestamps_struct.FT3 = robot_logger_device.FTs.(data_field_names.ft_names_yarp{3}).timestamps;
raw_timestamps_struct.joints_state_pos = robot_logger_device.joints_state.(data_field_names.joint_states{4}).timestamps;
raw_timestamps_cell = struct2cell(raw_timestamps_struct);

% Loop to find start and end times of timestamps
for i = 1:size(raw_timestamps_cell,1)
    raw_timestamps_cell_start_values(i) = min(raw_timestamps_cell{i},[],2);
    raw_timestamps_cell_end_values(i) = max(raw_timestamps_cell{i},[],2);
end

% Compute start and end value
raw_timestamps_cell_max_start_value = max(raw_timestamps_cell_start_values);
raw_timestamps_cell_min_end_value = min(raw_timestamps_cell_end_values);

% Defined desired sample rate 
interpolation_timestamp_delta = 0.025;

% Compute characteristics of desired timestamps vector
interpolation_timestamps_max_difference = raw_timestamps_cell_min_end_value - raw_timestamps_cell_max_start_value;
num_new_interpolation_timestamp_points = floor(interpolation_timestamps_max_difference / interpolation_timestamp_delta);
interpolation_timestamps_start = raw_timestamps_cell_max_start_value;
interpolation_timestamps_end = interpolation_timestamps_start+interpolation_timestamp_delta*num_new_interpolation_timestamp_points;

% Construct desired timestamps vector
interpolation_timestamps_vector = linspace(interpolation_timestamps_start,interpolation_timestamps_end,num_new_timestamp_points+1);

% Preallocate before loops
interpolated_data_cell = cell(4,1);

% Interpolate FTs
for i = 1:3
    timestamps_vector = raw_timestamps_cell{i};
    for j = 1:size(raw_data_cell{i},1) % 1:6
        raw_data_ft = raw_data_cell{i}(j,:,:);
        ft_vector = reshape(raw_data_ft,1,[]);
        ft_interpolated_temp1 = interp1(timestamps_vector,ft_vector,interpolation_timestamps_vector,'linear');
        ft_interpolated_temp2 = reshape(ft_interpolated_temp1,1,1,[]);
        ft_interpolated(j,1,:) = ft_interpolated_temp2;
        figure
        plot(timestamps_vector',ft_vector',interpolation_timestamps_vector',ft_interpolated_temp1')
        legend('original FT','interpolated FT');
    end    
    interpolated_data_cell{i} = ft_interpolated;
end

% Interpolate joints_state_pos
for i = 4
    timestamps_vector = raw_timestamps_cell{i};
    for j = 1:size(raw_data_cell{i},1) % 1:26
        raw_data_states = raw_data_cell{i}(j,:,:);
        state_vector = reshape(raw_data_states,1,[]);
        state_interpolated_temp1 = interp1(timestamps_vector,state_vector,interpolation_timestamps_vector,'linear');
        state_interpolated_temp2 = reshape(state_interpolated_temp1,1,1,[]);
        states_interpolated(j,1,:) = state_interpolated_temp2;
        figure
        plot(timestamps_vector',state_vector',interpolation_timestamps_vector',state_interpolated_temp1')
        legend('original state','interpolated state');
    end
    interpolated_data_cell{i} = states_interpolated;
end


%% PLOT

% end_data_point = 200;
% 
% figure
% plot(timestamps_cell{1})
% hold on
% plot(timestamps_cell{3})
% hold off
% xlim([0 end_data_point])
% 
% figure
% plot(diff_cell{1})
% hold on
% plot(diff_cell{3})
% hold off
% xlim([0 end_data_point])


%% TEST WITH STRUCT2CELL
% robot_logger_device_cell = struct2cell(robot_logger_device);
% robot_logger_device_cell{2}
% robot_logger_device_cell1 = struct2cell(robot_logger_device_cell{2});
% robot_logger_device_cell1{2}


%% TEST LINSPACE
startvalue = 2;
endvalue = 5.4;
differencevalue = endvalue - startvalue;
deltavalue = 0.5;
numbervalues = floor(differencevalue/deltavalue);
linspacevalue = linspace(startvalue,startvalue+deltavalue*numbervalues,numbervalues+1);

