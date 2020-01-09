import numpy as np
import cv2
from matplotlib import pyplot as plt
import os
import random

MIN_MATCH_COUNT = 10

def matching(img1,img2):
    img1 = cv2.cvtColor(img1, cv2.COLOR_BGR2GRAY)
    img2 = cv2.cvtColor(img2, cv2.COLOR_BGR2GRAY)

    #sift
    sift = cv2.xfeatures2d.SIFT_create()

    keypoints_1, descriptors_1 = sift.detectAndCompute(img1,None)
    keypoints_2, descriptors_2 = sift.detectAndCompute(img2,None)

    #feature matching
    bf = cv2.BFMatcher(cv2.NORM_L1, crossCheck=True)

    matches = bf.match(descriptors_1,descriptors_2)
    matches = sorted(matches, key = lambda x:x.distance)

    img3 = cv2.drawMatches(img1, keypoints_1, img2, keypoints_2, matches[:50], img2, flags=2)
    # plt.imshow(img3),plt.show()

    return img3



def main(): 
    path1="src/"
    path2="dataset/"
    savepath="result/"
    for folder in os.listdir(path1):
        folder_path=os.path.join(path1,folder)
        datapath=os.path.join(path2,folder)
        savefolder=os.path.join(savepath,folder)
        if not os.path.isdir(savefolder):
            os.mkdir(savefolder)
        cnt=0
        for image in os.listdir(folder_path):
            cnt+=1
            img1=cv2.imread(os.path.join(folder_path,image))
            random_filename=random.choice([
                x for x in os.listdir(datapath)
                if os.path.isfile(os.path.join(datapath,x))
            ])
            print(random_filename)
            img2 = cv2.imread(os.path.join(datapath,random_filename)) # trainImage
            img3=matching(img1,img2)
            cv2.imwrite(os.path.join(savefolder,str(cnt)+'.jpg'), img3)

if __name__=="__main__":
    main()

