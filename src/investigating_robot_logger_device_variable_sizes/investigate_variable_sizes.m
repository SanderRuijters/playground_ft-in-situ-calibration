clear; close all;
%% LOAD 3 DATASETS LOGGED FROM SEVERAL EXPERIMENTS

% Data provided by Ines
load('robot_logger_device_2022_03_28_11_42_50.mat')
robot_logger_device_collected{1} = robot_logger_device;
% Data from first experiment with slow trajectories
load('robot_logger_device_2022_04_28_16_51_10.mat')
robot_logger_device_collected{2} = robot_logger_device;
% Data from second experiment with slow trajectories
load('robot_logger_device_2022_05_04_15_10_44.mat')
robot_logger_device_collected{3} = robot_logger_device;
% Data from second experiment with fast trajectories
load('robot_logger_device_2022_05_04_16_00_30.mat')
robot_logger_device_collected{4} = robot_logger_device;


%% LOOPS

% Preallocate variables
size_of_variable = cell(1,4);
timestamp_at_min_number_of_samples = cell(1,4);

% Loop through robot_logger_device datasets
for i = 1:2
    size_of_variable{i}.cartesian_wrenches = robot_logger_device_collected{i}.cartesian_wrenches.right_arm_wrench_client.dimensions(3);
    size_of_variable{i}.accelerometers = robot_logger_device_collected{i}.accelerometers.rfeimu_acc.dimensions(3);
    size_of_variable{i}.orientations = robot_logger_device_collected{i}.orientations.rfeimu_eul.dimensions(3);
    size_of_variable{i}.gyros = robot_logger_device_collected{i}.gyros.rfeimu_gyro.dimensions(3);
    size_of_variable{i}.FTs = robot_logger_device_collected{i}.FTs.right_arm_ft_client.dimensions(3);
    size_of_variable{i}.PIDs = robot_logger_device_collected{i}.PIDs.dimensions(3);
    size_of_variable{i}.motors_state = robot_logger_device_collected{i}.motors_state.positions.dimensions(3);
    size_of_variable{i}.joints_state = robot_logger_device_collected{i}.joints_state.positions.dimensions(3);

    size_of_variable{i}.min_number_of_samples = min(cell2mat(struct2cell(size_of_variable{i})));

%     timestamp_at_min_number_of_samples
end


for i = 3:4
    size_of_variable{i}.cartesian_wrenches = robot_logger_device_collected{i}.cartesian_wrenches.right_arm_wrench_client.dimensions(3);
    size_of_variable{i}.temperatures = robot_logger_device_collected{i}.temperatures.id_r_upper_arm_strain.dimensions(3);
    size_of_variable{i}.accelerometers = robot_logger_device_collected{i}.accelerometers.rfeimu_acc.dimensions(3);
    size_of_variable{i}.orientations = robot_logger_device_collected{i}.orientations.rfeimu_eul.dimensions(3);
    size_of_variable{i}.gyros = robot_logger_device_collected{i}.gyros.rfeimu_gyro.dimensions(3);
    size_of_variable{i}.FTs = robot_logger_device_collected{i}.FTs.id_r_upper_arm_strain.dimensions(3);
    size_of_variable{i}.PIDs = robot_logger_device_collected{i}.PIDs.dimensions(3);
    size_of_variable{i}.motors_state = robot_logger_device_collected{i}.motors_state.positions.dimensions(3);
    size_of_variable{i}.joints_state = robot_logger_device_collected{i}.joints_state.positions.dimensions(3);
    size_of_variable{i}.min_number_of_samples = min(cell2mat(struct2cell(size_of_variable{i})));
end


%% DISPLAY RESULTS
disp('For robot_logger_device_2022_03_28_11_42_50: data provided by Ines at start of internship:')
disp(size_of_variable{1})
disp('For robot_logger_device_2022_04_28_16_51_10: data from first experiment with slow trajectories:')
disp(size_of_variable{2})
disp('For robot_logger_device_2022_05_04_15_10_44: data from second experiment with slow trajectories:')
disp(size_of_variable{3})
disp('For robot_logger_device_2022_05_04_16_00_30: data from second experiment with fast trajectories:')
disp(size_of_variable{4})

