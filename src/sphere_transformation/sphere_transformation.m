%% Initialize

% Clear and close
clear
close all

% Select data
results_directory = '../../element_ft-insitu-calibration/src/calibration_results/';
result_name = 'robot_logger_device_2022_04_13_16_29_18';
% result_name = 'robot_logger_device_2022_03_28_11_42_50';
load([results_directory,result_name,'/','calibration_results.mat'])

% Display sensors that have recorded data
disp(sol);

% Select FT-sensor
FT_sensor = 'r_leg_ft_sensor';


%% Computations

% Extract C and o from calibration results
C = sol.(FT_sensor).C;
o = sol.(FT_sensor).o;

% Compute singular value decomposition of transformation matrix
[C_svd_U, C_svd, C_svd_V] = svd(C);

% Extract force and torque part of calibration matrix
C_F = diag(C_svd(1:3,1:3));
C_T = diag(C_svd(4:6,4:6));

% Extract force and torque part of offset vector
o_F = o(1:3);
o_T = o(4:6);

% Create ellipsoid (unit shpere)
[X,Y,Z] = ellipsoid(0,0,0,1,1,1);

% Perform linear scaling of force ellipsoid
X_F_scaled = X*C_F(1);
Y_F_scaled = Y*C_F(2);
Z_F_scaled = Z*C_F(3);

% Perform linear scaling of torque ellipsoid
scaling_torque = 1;
X_T_scaled = X*scaling_torque*C_T(1);
Y_T_scaled = Y*scaling_torque*C_T(2);
Z_T_scaled = Z*scaling_torque*C_T(3);

% Translate center of force ellipsoid
X_F_translated = X+o_F(1);
Y_F_translated = Y+o_F(2);
Z_F_translated = Z+o_F(3);

% Translate center of Torque ellipsoid
X_T_translated = X+o_T(1);
Y_T_translated = Y+o_T(2);
Z_T_translated = Z+o_T(3);

% Plot force ellipsoids
% Scaled subplot
    figure
    surf(X,Y,Z,'EdgeColor','red','FaceAlpha',0.5)
    hold on
    surf(X_F_scaled,Y_F_scaled,Z_F_scaled,'EdgeColor','blue','FaceAlpha',0.5)
    hold off
    % Options
    axis equal
    legend('Unit sphere','Scaled')
    title('Force ellipsoids')
% Translated subplot
    figure
    surf(X,Y,Z,'EdgeColor','red','FaceAlpha',0.5)
    hold on
    surf(X_F_translated,Y_F_translated,Z_F_translated,'EdgeColor','blue','FaceAlpha',0.5)
    hold off
    % Options
    axis equal
    legend('Unit sphere','Translated')
    title('Force ellipsoids')

% Plot torque ellipsoid
% Scaled subplot
    figure
    surf(X,Y,Z,'EdgeColor','red','FaceAlpha',0.5)
    hold on
    surf(X_T_scaled,Y_T_scaled,Z_T_scaled,'EdgeColor','blue','FaceAlpha',0.5)
    legend('Unit sphere','Scaled')
    % Options
    axis equal
    hold off
    title('Torque ellipsoids')
% Translated subplot
    figure
    surf(X,Y,Z,'EdgeColor','red','FaceAlpha',0.5)
    axis equal
    hold on
    surf(X_T_translated,Y_T_translated,Z_T_translated,'EdgeColor','blue','FaceAlpha',0.5)
    hold off
    legend('Unit sphere','Translated')
    title('Torque ellipsoids')

