function [ pdf ] = gaussianND(X, mu, Sigma)


n = size(X, 2);


meanDiff = bsxfun(@minus, X, mu);


pdf = 1 / sqrt((2*pi)^n * det(Sigma)) * exp(-1/2 * sum((meanDiff * inv(Sigma) .* meanDiff), 2));

end

