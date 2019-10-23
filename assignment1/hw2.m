% get eigenface and originalmean from the csv file we save
eigenface=csvread("eigenface.csv");
origmean=csvread("original_mean.csv");
origmean=repmat(origmean,1,1300);


% open the folder of test images and form image matrix
testpath="/home/dmplus/2019_juniorI/CV/assignment/assignment1/dataset/AR/AR_Test_image/";

if ~isfolder(testpath)
    errorMessage=sprintf('Error: The following folder does not exist:\n%s',testpath);
    uiwait(warndlg(errorMessage));
    return;
end

testpattern=fullfile(testpath,'*.bmp');
testimg=dir(testpattern);
numoftest=length(testimg);
testmat=zeros(19800,1300);

for i=1:1300
    imgname=fullfile(testpath,testimg(i).name);
    img=imread(imgname);
    gray=rgb2gray(img);
    gray=im2double(gray);
    testmat(:,i)=gray(:);
end

testmat=testmat-origmean;


% open the folder of train images and form image matrix
trainpath="/home/dmplus/2019_juniorI/CV/assignment/assignment1/dataset/AR/AR_Train_image/";

if ~isfolder(trainpath)
    errorMessage=sprintf('Error: The following folder does not exist:\n%s',trainpath);
    uiwait(warndlg(errorMessage));
    return;
end

trainpattern=fullfile(trainpath,'*.bmp');
trainimg=dir(trainpattern);
numoftrain=length(trainimg);
trainmat=zeros(19800,1300);

for i=1:1300
    imgname=fullfile(trainpath,trainimg(i).name);
    img=imread(imgname);
    gray=rgb2gray(img);
    gray=im2double(gray);
    trainmat(:,i)=gray(:); 
end

trainmat=trainmat-origmean;
errrate=strings(3,2);


% calculate d=1 image error rate
projectimg=trainmat'*eigenface(:,1);
traindecompress=projectimg*eigenface(:,1)';
traindecompress=traindecompress'+origmean;

projectimg=testmat'*eigenface(:,1);
testdecompress=projectimg*eigenface(:,1)';
testdecompress=testdecompress'+origmean;

errors=0;

for i=1:1300
    idx=knnsearch(traindecompress',testdecompress(:,i)');
    if rem(idx,13)~=0
        idxgrp=fix(idx/13)+1;
    else
        idxgrp=fix(idx/13);
    end
    if rem(i,13)~=0
        testgrp=fix(i/13)+1;
    else
        testgrp=fix(i/13);
    end
    if idxgrp~=testgrp
       errors=errors+1;
       
    end
end

d1_error_rate=double(errors)/double(1300);
errrate(1,:)={"d1",num2str(d1_error_rate)};


% calculate d=5 image error rate
projectimg=trainmat'*eigenface(:,1:5);
traindecompress=projectimg*eigenface(:,1:5)';
traindecompress=traindecompress'+origmean;

projectimg=testmat'*eigenface(:,1:5);
testdecompress=projectimg*eigenface(:,1:5)';
testdecompress=testdecompress'+origmean;

errors=0;

for i=1:1300
    idx=knnsearch(traindecompress',testdecompress(:,i)');
    if rem(idx,13)~=0
        idxgrp=fix(idx/13)+1;
    else
        idxgrp=fix(idx/13);
    end
    if rem(i,13)~=0
        testgrp=fix(i/13)+1;
    else
        testgrp=fix(i/13);
    end
    if idxgrp~=testgrp
       errors=errors+1; 
    end
end

d5_error_rate=double(errors)/double(1300);
errrate(2,:)={"d5",num2str(d5_error_rate)};


% calculate d=9 image error rate
projectimg=trainmat'*eigenface(:,1:9);
traindecompress=projectimg*eigenface(:,1:9)';
traindecompress=traindecompress'+origmean;

projectimg=testmat'*eigenface(:,1:9);
testdecompress=projectimg*eigenface(:,1:9)';
testdecompress=testdecompress'+origmean;

errors=0;

for i=1:1300
    idx=knnsearch(traindecompress',testdecompress(:,i)');
    if rem(idx,13)~=0
        idxgrp=fix(idx/13)+1;
    else
        idxgrp=fix(idx/13);
    end
    if rem(i,13)~=0
        testgrp=fix(i/13)+1;
    else
        testgrp=fix(i/13);
    end
    if idxgrp~=testgrp
       errors=errors+1; 
    end
end

d9_error_rate=double(errors)/double(1300);

errrate(3,:)={"d9",num2str(d9_error_rate)};


% wrtie error rate to csv file
errtable=array2table(errrate);
errtable.Properties.VariableNames={'dimension','error_rate'};
writetable(errtable,'error_rate.csv');