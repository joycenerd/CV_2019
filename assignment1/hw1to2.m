% get eigenface and originalmean from the csv file we save
eigenface=csvread("eigenface.csv");
origmean=csvread("original_mean.csv");
origmean=repmat(origmean,1,100);


% get 1 random photo from each person -> total 100 photos
selectfolderpath="selected_test_images/";

if ~isfolder(selectfolderpath)
    errorMessage=sprintf('Error: The following folder does not exist:\n%s',selectfolderpath);
    uiwait(warndlg(errorMessage));
    return;
end

selectpattern=fullfile(selectfolderpath,'*.bmp');
selectimg=dir(selectpattern);
numofselect=length(selectimg)
if numofselect~=0
    for i=1:numofselect
        fname=fullfile(selectfolderpath,selectimg(i).name);
        delete(fname);
    end
end

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


% preprocess the selected test images
% 1. grayscale 2. matrix -> vector 3. 100 vector concatenate to into 1
% matrix
selectfolderpath="selected_test_images/";

if ~isfolder(selectfolderpath)
    errorMessage=sprintf('Error: The following folder does not exist:\n%s',selectfolderpath);
    uiwait(warndlg(errorMessage));
    return;
end

selectpattern=fullfile(selectfolderpath,'*.bmp');
selectimg=dir(selectpattern);
numofselect=length(selectimg);

imgmat=zeros(19800,100);

for i=1:100
    fname=fullfile(selectfolderpath,selectimg(i).name);
    finfo=imread(fname);
    grayimg=rgb2gray(finfo);
    grayimg=im2double(grayimg);
    vec=grayimg(:);
    imgmat(:,i)=vec;
end


% compress and decompress the image when d=1,5,9
reducedimdir="after_reduce_dimension/";


% d=1
d1path=strcat(reducedimdir,"d1/");
projectimg=imgmat'*eigenface(:,1);
origimg=projectimg*eigenface(:,1)';
origimg=origimg'+origmean;
vec=num2cell(origimg,1);

for i=1:100
    mat=reshape(vec{i},165,120);
    gray=mat2gray(mat);
    %imshow(gray);
    fname=strcat('person',num2str(i));
    imwrite(gray,fullfile(d1path,strcat(fname,'.bmp')));
end


% d=5
d5path=strcat(reducedimdir,"d5/");
projectimg=imgmat'*eigenface(:,1:5);
origimg=projectimg*eigenface(:,1:5)';
origimg=origimg'+origmean;
vec=num2cell(origimg,1);

for i=1:100
    mat=reshape(vec{i},165,120);
    gray=mat2gray(mat);
    %imshow(gray);
    fname=strcat('person',num2str(i));
    imwrite(gray,fullfile(d5path,strcat(fname,'.bmp')));
end


% d=9
d9path=strcat(reducedimdir,"d9/");
projectimg=imgmat'*eigenface(:,1:9);
origimg=projectimg*eigenface(:,1:9)';
origimg=origimg'+origmean;
vec=num2cell(origimg,1);

for i=1:100
    mat=reshape(vec{i},165,120);
    gray=mat2gray(mat);
    imshow(gray);
    fname=strcat('person',num2str(i));
    imwrite(gray,fullfile(d9path,strcat(fname,'.bmp')));
end