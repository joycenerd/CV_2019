function [ val ] = weightedAverage(weights, values)

    val = val ./ sum(weights, 1);
    
end

