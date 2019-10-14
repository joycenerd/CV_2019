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

for i=1:numoftest
    imgname=fullfile(testpath,testimg(i).name);
    img=imread(imgname);
    gray=rgb2gray(img);
    gray=im2double(gray);
    testmat(:,i)=gray(:);
end


% calculate d=1 image error rate
d1path="after_reduce_dimension/d1";

if ~isfolder(d1path)
    errorMessage=sprintf('Error: The following folder does not exist:\n%s',d1path);
    uiwait(warndlg(errorMessage));
    return;
end

d1pattern=fullfile(d1path,'*.bmp');
d1img=dir(d1pattern);
imgpair=strings([100,3]);

for i=1:100
    imgname=fullfile(d1path,d1img(i).name);
    img=imread(imgname);
    vec=mat2gray(img);
    vec=im2double(vec(:));
    ssdvec=zeros(19800,100);
    for j=1:1300
       ssdvec(:,j)=(vec-testmat(:,j)).^2; 
    end
    ssdans=sum(ssdvec);
    [errrate,idx]=min(ssdans);
    imgpair(i,:)=reshape({d1img(i).name,testimg(idx).name,num2str(errrate)},1,3);
end

imgtable=array2table(imgpair);
imgtable.Properties.VariableNames={'image_after_PCA','matched_test_image','min_error_rate'};
writetable(imgtable,'d1_error_rate.csv');


% calculate d=5 image error rate 
d5path="after_reduce_dimension/d5";

if ~isfolder(d5path)
    errorMessage=sprintf('Error: The following folder does not exist:\n%s',d5path);
    uiwait(warndlg(errorMessage));
    return;
end

d5pattern=fullfile(d5path,'*.bmp');
d5img=dir(d5pattern);
imgpair=strings([100,3]);

for i=1:100
    imgname=fullfile(d5path,d5img(i).name);
    img=imread(imgname);
    vec=mat2gray(img);
    vec=im2double(vec(:));
    ssdvec=zeros(19800,100);
    for j=1:1300
       ssdvec(:,j)=(vec-testmat(:,j)).^2; 
    end
    ssdans=sum(ssdvec);
    [errrate,idx]=min(ssdans);
    imgpair(i,:)=reshape({d5img(i).name,testimg(idx).name,num2str(errrate)},1,3);
end

imgtable=array2table(imgpair);
imgtable.Properties.VariableNames={'image_after_PCA','matched_test_image','min_error_rate'};
writetable(imgtable,'d5_error_rate.csv');


% calculate d=9 image error rate 
d9path="after_reduce_dimension/d9";

if ~isfolder(d9path)
    errorMessage=sprintf('Error: The following folder does not exist:\n%s',d9path);
    uiwait(warndlg(errorMessage));
    return;
end

d9pattern=fullfile(d9path,'*.bmp');
d9img=dir(d9pattern);
imgpair=strings([100,3]);

for i=1:100
    imgname=fullfile(d9path,d9img(i).name);
    img=imread(imgname);
    vec=mat2gray(img);
    vec=im2double(vec(:));
    ssdvec=zeros(19800,100);
    for j=1:1300
       ssdvec(:,j)=(vec-testmat(:,j)).^2; 
    end
    ssdans=sum(ssdvec);
    [errrate,idx]=min(ssdans);
    imgpair(i,:)=reshape({d9img(i).name,testimg(idx).name,num2str(errrate)},1,3);
end

imgtable=array2table(imgpair);
imgtable.Properties.VariableNames={'image_after_PCA','matched_test_image','min_error_rate'};
writetable(imgtable,'d9_error_rate.csv');
