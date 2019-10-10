% open test image folder
testdir="/home/dmplus/2019_juniorI/CV/assignment/assignment1/dataset/AR/AR_Test_image";

if ~isfolder(testdir)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', testdir);
  uiwait(warndlg(errorMessage));
  return;
end

testpattern=fullfile(testdir,'*.bmp');
testimg=dir(testpattern);
numoftest=length(testimg);


% read images + 2d -> 1d +  img vector concatenate to image matrix
imgmtx=[];

for i=1:numoftest
    curfname=fullfile(testdir,testimg(i).name);
    img=imread(curfname);
    grayscaleimg=rgb2gray(img);
    grayscaleimg=im2double(grayscaleimg);
    imgvec=grayscaleimg(:);
    imgmtx=[imgmtx,imgvec];
end


% find mean face
meanface=mean(imgmtx,2);


% value minus mean face
imgmtx=imgmtx-meanface;


% calculate covariance matrix
covmtx=cov(imgmtx');


% find eigenvalues and eigenvector
[eigvec,eigvals,eigvec2]=svds(covmtx,9,"largest");