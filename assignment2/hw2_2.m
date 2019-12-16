import GMM_Examples.*;


% image 1 and 1D
% read image 1 -> Shiba 1
X1=imread('./src/Shiba_1.jpg');
X1_gray=rgb2gray(X1);
[row,col]=size(X1_gray);
X1_gray=im2double(X1_gray(:));
m=length(X1_gray);

% image1, 1D, k=3
GMM_1D(3,m,X1_gray,row,col,'./result/shiba1/1D-K_3.png');

% image1, 1D k=5
GMM_1D(5,m,X1_gray,row,col,'./result/shiba1/1D-K_5.png');

% image1, 1D, k=10
GMM_1D(10,m,X1_gray,row,col,'./result/shiba1/1D-K_10.png');

% image 2 and 1D
% read image 2 -> Shiba 2
X2=imread('./src/Shiba2.jpg');
X2_gray=rgb2gray(X2);
[row,col]=size(X2_gray);
X2_gray=im2double(X2_gray(:));
m=length(X2_gray);

% image2, 1D, k=3
GMM_1D(3,m,X2_gray,row,col,'./result/shiba2/1D-K_3.png');

% image2, 1D, k=5
GMM_1D(5,m,X2_gray,row,col,'./result/shiba2/1D-K_5.png');

% image2, 1D, k=10
GMM_1D(10,m,X2_gray,row,col,'./result/shiba2/1D-K_10.png');

% image 1 and 3D
% process image1-> Shiba 1
[row,col,channel]=size(X1);
X1=im2double(X1);
X=reshape(X1,row*col,3,1);
m=length(X);

% image1, 3D, k=3
GMM_3D(3,m,X,row,col,'./result/shiba1/3D-K_3.png');

% image1, 3D, k=5
GMM_3D(5,m,X,row,col,'./result/shiba1/3D-K_5.png');

% image1, 3D, k=10
GMM_3D(10,m,X,row,col,'./result/shiba1/3D-K_10.png');

% image 2 and 3D
% process image2-> Shiba 2
[row,col,channel]=size(X2);
X2=im2double(X2);
X=reshape(X2,row*col,3,1);
m=length(X);

% image2, 3D, k=3
GMM_3D(3,m,X,row,col,'./result/shiba2/3D-K_3.png');

% image2, 3D, k=5
GMM_3D(5,m,X,row,col,'./result/shiba2/3D-K_5.png');

% image2, 3D, k=10
GMM_3D(10,m,X,row,col,'./result/shiba2/3D-K_10.png');

% GMM one dimensional function
function GMM_1D(k,m,X,row,col,fname)
    % parameters initialization
    indeces = randperm(m);
    mu = zeros(1, k);
    for (i = 1 : k)
        mu(i) = X(indeces(i));
    end
    sigma = ones(1, k) * sqrt(var(X));
    phi = ones(1, k) * (1 / k);
    W = zeros(m, k);
    % run for at most 1000 iterations
    for (iter = 1:1000)
        fprintf('  EM Iteration %d\n', iter);
        % E step
        pdf = zeros(m, k);
        for (j = 1 : k)
            pdf(:, j) = gaussian1D(X, mu(j), sigma(j));
        end
        pdf_w = bsxfun(@times, pdf, phi);  
        W = bsxfun(@rdivide, pdf_w, sum(pdf_w, 2));
        % M step
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
    
    % classify pixel to clusters
    seg_pixels=X;
    cluster=0;
    for i=1:m
        cluster=max(W(i,:));
        cluster=find(W(i,:)==cluster);
        seg_pixels(i,:)=mu(1,cluster);
    end

    % output image
    seg_pixels=reshape(seg_pixels,row,col);
    seg_pixels=mat2gray(seg_pixels);
    imwrite(seg_pixels,fname);
end

% GMM 3 dimensional function
function GMM_3D(k,m,X,row,col,fname)
    % parameters initialization
    indeces=randperm(m);
    mu=X(indeces(1:k),:);
    sigma=[];
    for(j=1:k)
        sigma{j}=cov(X);
    end
    phi=ones(1,k)*(1/k);
    W=zeros(m,k);
    pdf=zeros(row*col,k);
    % run for at most 1000 iterations
    for(iter=1:1000)
        fprintf('EM Iteration %d\n',iter);
        % E step
        for(j=1:k)
            pdf(:,j)=gaussianND(X,mu(j,:),sigma{j});
        end
        pdf_w=bsxfun(@times,pdf,phi);
        W=bsxfun(@rdivide,pdf_w,sum(pdf_w,2));
        % M step
        prevMu=mu;
        for(j=1:k)
            phi(j)=mean(W(:,j),1);
            mu(j,:)=weightedAverage(W(:,j),X);
            sigma_k=zeros(3,3);
            Xm=bsxfun(@minus,X,mu(j,:));
            for(i=1:m)
                sigma_k = sigma_k + (W(i, j) .* (Xm(i, :)' * Xm(i, :)));
            end
            sigma{j} = sigma_k ./ sum(W(:, j));
        end
        muDiff = sum(sum((mu - prevMu).^2));
        if (muDiff<0.000005)
            break
        end
    end
    
    % classify pixel to cluster
    seg_pixels=X;
    cluster=0;
    for i=1:m
        cluster=max(W(i,:));
        cluster=find(W(i,:)==cluster);
        seg_pixels(i,1)=mu(cluster,1);
        seg_pixels(i,2)=mu(cluster,2);
        seg_pixels(i,3)=mu(cluster,3);
    end

    % output images
    seg_pixels=reshape(seg_pixels,row,col,3);
    imwrite(seg_pixels,fname);
end