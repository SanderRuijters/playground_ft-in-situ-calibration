%% Define values
values = 1:6;
k = 3;


%% Compute combinations
combinations = nmultichoosek(values,k)
number_of_combinations_with_repetition = size(combinations,1)


%% Define function
function combs = nmultichoosek(values, k)
    %// Return number of multisubsets or actual multisubsets.
    % from: https://stackoverflow.com/questions/28284671/generating-all-combinations-with-repetition-using-matlab
    % wikipedia: https://en.wikipedia.org/wiki/Combination#Number_of_combinations_with_repetition
    if numel(values)==1 
        n = values;
        combs = nchoosek(n+k-1,k);
    else
        n = numel(values);
        combs = bsxfun(@minus, nchoosek(1:n+k-1,k), 0:k-1);
        combs = reshape(values(combs),[],k);
    end
end

