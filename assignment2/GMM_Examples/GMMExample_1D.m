mu1 = 10;      
sigma1 = 1;    
m1 = 100;     

mu2 = 20;
sigma2 = 3;
m2 = 200;


X1 = (randn(m1, 1) * sigma1) + mu1;
X2 = (randn(m2, 1) * sigma2) + mu2;

X = [X1; X2];



x = [0:0.1:30];
y1 = gaussian1D(x, mu1, sigma1);
y2 = gaussian1D(x, mu2, sigma2);

hold off;
plot(x, y1, 'b-');
hold on;
plot(x, y2, 'r-');
plot(X1, zeros(size(X1)), 'bx', 'markersize', 10);
plot(X2, zeros(size(X2)), 'rx', 'markersize', 10);

set(gcf,'color','white') 


m = size(X, 1);


k = 2;


indeces = randperm(m);
mu = zeros(1, k);
for (i = 1 : k)
    mu(i) = X(indeces(i));
end


sigma = ones(1, k) * sqrt(var(X));


phi = ones(1, k) * (1 / k);


W = zeros(m, k);


for (iter = 1:1000)
    
    fprintf('  EM Iteration %d\n', iter);

   
    pdf = zeros(m, k);
    
    
    for (j = 1 : k)
        pdf(:, j) = gaussian1D(X, mu(j), sigma(j));
    end
    
   
    pdf_w = bsxfun(@times, pdf, phi);
    
    
    W = bsxfun(@rdivide, pdf_w, sum(pdf_w, 2));
    
    
    prevMu = mu;    
    
   
    for (j = 1 : k)
    
        
        phi(j) = mean(W(:, j));
        
       
        mu(j) = weightedAverage(W(:, j), X);
    
        
        variance = weightedAverage(W(:, j), (X - mu(j)).^2);
        
        
        sigma(j) = sqrt(variance);
    end
    
   
    if (mu == prevMu)
        break
    end


end


x = [0:0.1:30];
y1 = gaussian1D(x, mu(1), sigma(1));
y2 = gaussian1D(x, mu(2), sigma(2));


plot(x, y1, 'k-');
plot(x, y2, 'k-');

