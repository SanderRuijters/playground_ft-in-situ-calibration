%% Initialize

% Clear and close
clear
close all

% Location of dataset
results_directory = '../../../element_ft-insitu-calibration/src/data/experiment_data/';
result_name = 'robot_logger_device_2022_05_04_15_13_29';
% result_name = 'robot_logger_device_2022_03_28_11_42_50';
load([results_directory,result_name,'.mat']')

% Select FT-sensor
FT_sensor = 'id_r_upper_arm_strain';

% Shorten data
realWrench = squeeze(robot_logger_device.FTs.id_r_upper_arm_strain.data);
realWrench = realWrench(:,1:20);

% Choose number of wrenches and datapoints
nWrenches = 6;
nDataPoints = 20;

% Generate random data
randomWrench = rand(nWrenches, nDataPoints);

% Generate random data
wrench = realWrench;

% Normal SVD
[U,S,V] = svd(wrench)

% Economy SVD
[Ue,Se,Ve] = svd(wrench,'econ')


