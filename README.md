# Reconstruction

## Dependency
- OpenCV 3.2
- Eigen 3
- g2o @ 9b41a4e

## Introduction 
Stereo reconstruction is a very active research field in computer vision, which has a wide range of applications in architecture capturing and autonomous driving. In this project, we apply different stereo matching methods to reconstruct 3D scenes and compare their performance. Based on key-point detectors and eight-point algorithm, we recover the camera's extrinsic and rectify the images from left and right camera for the next step. Then we apply three dense matching methods to generate the disparity map respectively and further reconstruct the 3D scene. 
We evaluate the impact of different detectors and bundle adjustment on the accuracy of the estimated transformation. The experiment shows that SIFT performs better than ORB, and the accuracy of the estimated transform is also improved after using bundle adjustment. For dense matching, with PSMNet, which is the SOTA in disparity prediction, we can get much higher precision than classic methods block matching and semi-global matching.

## Pipeline
The images we use in this project are the raw data from KITTI dataset, which are distorted and unrectified. First, we use SIFT and ORB detector to find the matching points in the left and right images. Then we use eight point algorithm to figure out the rotation and translation from these matching points. Here, we also try using bundle adjustment to improve the accuracy of rotation and translation. After we get the extrinsic, we rectify the left and right images for the dense matching. In our project, we use the classic block matching and semi-global matching to compute the disparity map. Furthermore, we use PSMNet to see how is the performance of deep learning in this field. Finally, we reconstruct the 3d scenario with this disparity map. 
In our project, we evaluate two things. One is the estimated transform, and the other is the disparity map. 

![pipeline](./results/structure.png)

## Result
### Sparse matching
We select 30 images from the KITTI2015 dataset as our test dataset and get their corresponding unrectified images from raw data.
We use ORB and SIFT to detect key points in left and right images, which are then used in eight-point algorithm to recover the rotation and translation between left and right images. Then we use bundle adjustment to improve the accuracy. For both SIFT and ORB, we choose 40 keypoint pairs in the image. As for bundle adjustment, we use the result from eight-point algorithm as initialization. For the evaluation of rotation matrix, we convert the rotation matrix into $zyx$ Euler angles and compute the mean squared error. For translation vector, we compute the mean squared error directly. The quantitative results are shown in Table 1.

![table1](./results/table1.png)

Compared with ORB, the accuracy of the methods using SIFT is greatly improved, but in fact the calculation time of SIFT is slightly longer. In addition, the optimization effect of bundle adjustment is obvious.
But overall, the accuracy we obtained is very low, especially the translation vector, given that the baseline is only about 0.54 m. Such accuracy is not enough for us to obtain high-quality rectified images. Considering that our focus is to compare the performance of different stereo matching methods, we decide to use the rectified images provided by the dataset to do the follow-up work.

### Dense matching
We use the rectified images provided in  KITTI2015 dataset to get disparity maps with 3 different methods, namely block matching, semi-global matching and PSMNet. For evaluation, we calculate an error rate, that is the percentage of error pixels to all valid pixels. And an error pixel means the difference between calculated disparity value and ground truth is greater than 3 pixels and greater than 5\%. The qualitative results 
are shown in Figure 2, the first row shows our disparity map, the second row shows the ground truth, and the third row shows the difference between our result and ground truth.

![disp_eval](./results/disp_eval.png)

For comparison, we calculate the average error rate for each method. From Table 2, we know that PSMNet works best, it can ensure that nearly 99\% of pixels have an disparity error within 5\% or under 3 pixels. While block matching has the worst effect, only half of the pixels have lower disparity error.

![table2](./results/table2.png)

After getting disparity map, we can calculate depth and get 3D points, then we can generate 3D meshes by triangulation. Figure 3 gives an example of our mesh reconstruction result.

![fig3](./results/fig3.png)

## Conclusion 
In this project, we achieve a pipeline of stereo reconstruction and compare different methods in sparse matching and dense matching. For sparse matching, in general, SIFT runs slower but provides higher accuracy than ORB. With bundle adjustment we can achieve better accuracy than eight point algorithm, but none of these methods we tried can be accurate enough to be applied in subsequent stereo matching, which can be further improved in future work. For dense matching, semi-global method achieves considerable gain compared with block matching in accuracy and speed, but deep learning method outperforms greatly classic methods.
