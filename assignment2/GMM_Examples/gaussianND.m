function [ pdf ] = gaussianND(X, mu, Sigma)

% get the vector length
n = size(X, 2);

% subtract the mean from every data point
meanDiff = bsxfun(@minus, X, mu);

% calculate the multivariate gaussian (N dimensional)
pdf = 1 / sqrt((2*pi)^n * det(Sigma)) * exp(-1/2 * sum((meanDiff * inv(Sigma) .* meanDiff), 2));

end

