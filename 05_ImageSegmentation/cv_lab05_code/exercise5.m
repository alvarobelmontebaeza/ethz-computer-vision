%function run_ex5()

% load image
img = imread('cow.jpg');
% for faster debugging you might want to decrease the size of your image
% (use imresize)
% (especially for the mean-shift part!)
figure, imshow(img), title('original image')

%% smooth image (6.1a)
% Create gaussian filter. We could have used 'imgaussfilt', but instead we
% used fspecial + imfilter to be consistent with the assignment
window_size = 5;
sigma = 5;
gaussianFilter = fspecial('gaussian',window_size,sigma);
imgSmoothed = imfilter(img,gaussianFilter,'replicate');
figure, imshow(imgSmoothed), title('smoothed image')

%% convert to L*a*b* image (6.1b)
cform = makecform('srgb2lab');
imglab = applycform(imgSmoothed, cform);
figure, imshow(imglab), title('l*a*b* image')

%% (6.2) Segmentation using Mean-Shift
[mapMS peak] = meanshiftSeg(imglab);
visualizeSegmentationResults(mapMS,peak);

%% (6.3) Segmentation using EM
[mapEM cluster] = EM(imglab);
visualizeSegmentationResults (mapEM,cluster);

%end