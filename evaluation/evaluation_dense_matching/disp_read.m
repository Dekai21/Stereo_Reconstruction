function D = disp_read (filename)
% loads disparity map D from png file
% for details see readme.txt

I = imread(filename);
D = double(I)/256; %ת����������
D(I==0) = -1;

