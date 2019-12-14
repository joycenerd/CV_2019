% calculate the wieghted average of values
function [ val ] = weightedAverage(weights, values)
    val=weights'*values;    % apply the weights to the values by taking the dot-product between the twovectors
    val = val ./ sum(weights, 1);   % divide by the sum of the weights
    
end

