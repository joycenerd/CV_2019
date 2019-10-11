% get eigenface from the csv file we save
eigenface=csvread("eigenface.csv");
origmean=csvread("original_mean.csv");


% get 1 random photo from each person -> total 100 photos
testdatapath="/home/dmplus/2019_juniorI/CV/assignment/assignment1/dataset/AR/AR_Test_image"

if ~isfolder(testdatapath)
    errorMessage=sprintf('Error: The following folder does not exist:\n%s',testdatapath);
    uiwait(warndlg(errorMessage));
    return;
end

testpattern=fullfile(testdatapath,'*.bmp');
testimgs=dir(testpattern);
randnumvec=zeros(13,1);

for i=1:100
    randnumvec(i)=randsample(13,1);
end

for i=1:100
    idx=13*(i-1);
    idx=idx+randnumvec(i);
    curfname=fullfile(testdatapath,testimgs(idx).name);
    img=imread(curfname);
    fname=testimgs(idx).name;
    disp(fname);
    imwrite(img,fullfile('selected_test_images/',testimgs(idx).name));
end


% tpreprocess the selected test images
% 1. grayscale 2. matrix -> vector 3. 100 vector concatenate to into 1
% matrix
selectimgdir="selected_test_images/"

if ~isfolder(selectimgdir)
    errorMessage=sprintf('Error: The following folder does not exist:\n%s',selectimgdir);
    uiwait(warndlg(errorMessage));
    return;
end

selectimgpattern=fullfile(selectimgdir,'*.bmp');
selectimgs=dir(selectimgpattern);
numofselect=length(selectimgs);
imgmat=zeros(19800,100);

for i=1:numofselect
    fname=fullfile(selectimgdir,selectimgs(i).name);
    finfo=imread(fname);
    grayimg=rgb2gray(finfo);
    vec=grayimg(:);
    imgmat(:,i)=vec;
end