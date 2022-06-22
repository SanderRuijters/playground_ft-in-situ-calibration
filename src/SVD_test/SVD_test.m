%% Initialize

% Clear and close
clear
close all
clc

% Location of dataset
results_directory = '../../../element_ft-insitu-calibration/src/data/experiment_data/';
result_name = 'robot_logger_device_2022_05_04_15_13_29';
% result_name = 'robot_logger_device_2022_03_28_11_42_50';
load([results_directory,result_name,'.mat']')

% Select FT-sensor
FT_sensor = 'id_r_upper_arm_strain';

% Choose number of wrenches and datapoints
nWrenches = 6;
nDataPoints = 20;

% Shorten data
realWrench = squeeze(robot_logger_device.FTs.id_r_upper_arm_strain.data);
realWrench = realWrench(:,1:nDataPoints);

% Generate random data
randomWrench = rand(nWrenches, nDataPoints);

% Generate random data
X = realWrench

% Normal SVD
[U,S,V] = svd(X)

% Economy SVD
[Ue,Se,Ve] = svd(X,'econ')


