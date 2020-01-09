import cv2
import numpy as np
import os


path='./src/'
folders=os.listdir(path)
print(folders)
for folder in folders:
    folder_path=os.path.join(path,folder)
    contents=os.listdir(folder_path)
    save_path=os.path.join("./dataset/",folder)
    if not os.path.isdir(save_path):
        os.mkdir(save_path)
    for content in contents:
        print(content)
        image=cv2.imread(os.path.join(folder_path,content))
        cv2.imwrite(os.path.join(save_path, content),image)
        # cv2.waitKey(0)
        # print(save_path)
        print(content)
        print(content.find("."))
        fname=content[0:content.find(".")]
        print(fname)

        height,width,channel=image.shape
        start_row, start_col = int(0), int(0)
        end_row, end_col = int(height * .5), int(width)
        cropped_top = image[start_row:end_row , start_col:end_col]
        cv2.imwrite(os.path.join(save_path,fname+'0.jpg'),cropped_top)
        
        image2=cv2.imread(os.path.join(save_path,fname+'0.jpg'))
        height,width,channel=image.shape
        start_row, start_col = int(0), int(0)
        end_row, end_col = int(height), int(width*.5)
        cropped_left = image2[start_row:end_row , start_col:end_col]
        cv2.imwrite(os.path.join(save_path,fname+'2.jpg'),cropped_left)
        
        start_row, start_col = int(0), int(width*.5)
        end_row, end_col = int(height), int(width)
        cropped_right = image2[start_row:end_row , start_col:end_col]
        cv2.imwrite(os.path.join(save_path,fname+'3.jpg'),cropped_right)

        height,width,channel=image.shape
        start_row, start_col = int(height * .5), int(0)
        end_row, end_col = int(height), int(width)
        cropped_bot = image[start_row:end_row , start_col:end_col]
        cv2.imwrite(os.path.join(save_path,fname+'1.jpg'),cropped_bot)

        image2=cv2.imread(os.path.join(save_path,fname+'1.jpg'))
        height,width,channel=image.shape
        start_row, start_col = int(0), int(0)
        end_row, end_col = int(height), int(width*.5)
        cropped_left = image2[start_row:end_row , start_col:end_col]
        cv2.imwrite(os.path.join(save_path,fname+'4.jpg'),cropped_left)

        start_row, start_col = int(0), int(width*.5)
        end_row, end_col = int(height), int(width)
        cropped_right = image2[start_row:end_row , start_col:end_col]
        cv2.imwrite(os.path.join(save_path,fname+'5.jpg'),cropped_right)

        height,width,channel=image.shape
        start_row, start_col = int(0), int(0)
        end_row, end_col = int(height), int(width*.5)
        cropped_left = image[start_row:end_row , start_col:end_col]
        cv2.imwrite(os.path.join(save_path,fname+'6.jpg'),cropped_left)

        start_row, start_col = int(0), int(width*.5)
        end_row, end_col = int(height), int(width)
        cropped_right = image[start_row:end_row , start_col:end_col]
        cv2.imwrite(os.path.join(save_path,fname+'7.jpg'),cropped_right)

        