mu1 = [1 2];       
sigma1 = [ 3 .2;   
          .2  2];
m1 = 200;          

mu2 = [-1 -2];
sigma2 = [2 0;
          0 1];
m2 = 100;


R1 = chol(sigma1);
X1 = randn(m1, 2) * R1;
X1 = X1 + repmat(mu1, size(X1, 1), 1);

R2 = chol(sigma2);
X2 = randn(m2, 2) * R2;
X2 = X2 + repmat(mu2, size(X2, 1), 1);

X = [X1; X2];


figure(1);


hold off;
plot(X1(:, 1), X1(:, 2), 'bo');
hold on;
plot(X2(:, 1), X2(:, 2), 'ro');

set(gcf,'color','white')


gridSize = 100;
u = linspace(-6, 6, gridSize);
[A B] = meshgrid(u, u);
gridX = [A(:), B(:)];


z1 = gaussianND(gridX, mu1, sigma1);
z2 = gaussianND(gridX, mu2, sigma2);


Z1 = reshape(z1, gridSize, gridSize);
Z2 = reshape(z2, gridSize, gridSize);


[C, h] = contour(u, u, Z1);
[C, h] = contour(u, u, Z2);

axis([-6 6 -6 6])
title('Original Data and PDFs');


m = size(X, 1);

k = 2;  
n = 2;  


indeces = randperm(m);
mu = X(indeces(1:k), :);

sigma = [];


for (j = 1 : k)
    sigma{j} = cov(X);
end




W = zeros(m, k);


for (iter = 1:1000)
    fprintf('  EM Iteration %d\n', iter);
    for (j = 1 : k)
        pdf(:, j) = gaussianND(X, mu(j, :), sigma{j});
    end
    
    pdf_w = bsxfun(@times, pdf, phi);
    
    W = bsxfun(@rdivide, pdf_w, sum(pdf_w, 2));

    prevMu = mu;    

    for (j = 1 : k)
    
       
        phi(j) = mean(W(:, j), 1);
        
 
        mu(j, :) = weightedAverage(W(:, j), X);

        
        sigma_k = zeros(n, n);
        

        Xm = bsxfun(@minus, X, mu(j, :));
        

        for (i = 1 : m)
            sigma_k = sigma_k + (W(i, j) .* (Xm(i, :)' * Xm(i, :)));
        end
        

        sigma{j} = sigma_k ./ sum(W(:, j));
    end
    

    if (mu == prevMu)
        break
    end
            
 
end

figure(2);
hold off;
plot(X1(:, 1), X1(:, 2), 'bo');
hold on;
plot(X2(:, 1), X2(:, 2), 'ro');

set(gcf,'color','white') 

plot(mu1(1), mu1(2), 'kx');
plot(mu2(1), mu2(2), 'kx');


gridSize = 100;
u = linspace(-6, 6, gridSize);
[A B] = meshgrid(u, u);
gridX = [A(:), B(:)];


z1 = gaussianND(gridX, mu(1, :), sigma{1});
z2 = gaussianND(gridX, mu(2, :), sigma{2});


Z1 = reshape(z1, gridSize, gridSize);
Z2 = reshape(z2, gridSize, gridSize);


[C, h] = contour(u, u, Z1);
[C, h] = contour(u, u, Z2);
axis([-6 6 -6 6])

title('Original Data and Estimated PDFs');