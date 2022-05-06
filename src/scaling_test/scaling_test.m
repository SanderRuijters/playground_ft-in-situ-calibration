%% INitialize

% Clear things up
clear

% load measured_ft data
load measured_ft_saved.mat

%% Config

% Choose whether to scale C in the optimization problem (sigma*C)
config.scaling_opt = true;

% run loop
sigma = eye(6);
if config.scaling_opt
    tmp_vec = zeros(6,1);
    tmp_max = tmp_vec;
    tmp_min = tmp_vec;
    tmp_diff = tmp_vec;
    for i = 1 : 6
        tmp_max(i) = max(measured_ft(:,i));
        tmp_min(i) = min(measured_ft(:,i));
        tmp_diff(i) = tmp_max(i) - tmp_min(i);
        tmp_vec(i) = 1 / (tmp_diff(i));
    end
    sigma = diag(tmp_vec);
end

