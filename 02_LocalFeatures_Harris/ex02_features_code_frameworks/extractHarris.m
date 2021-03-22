% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%   
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength
function [corners, C] = extractHarris(img, sigma, k, thresh)
    
    % Define the convolution filters for X and Y directions to replicate
    % the formulas specified in the assignment
    Ix_filter = [0 -0.5 0;0 0 0;0 0.5 0];
    Iy_filter = [0 0 0;-0.5 0 0.5;0 0 0];
    
    % Compute the Image gradients using the 2d convolution function. the
    % 'same' parameter enforces the gradient image to have the same size as
    % the original image
    Ix = conv2(img, Ix_filter, 'same');
    Iy = conv2(img, Iy_filter, 'same');
    
    % Compute auto-correlation    
    % First compute square of derivatives
    Ixx = Ix .* Ix;
    Iyy = Iy .* Iy;
    Ixy = Ix .* Iy;
    
    % Secondly Apply Gausian Filtering
    GIxx = imgaussfilt(Ixx,sigma);
    GIyy = imgaussfilt(Iyy,sigma);
    GIxy = imgaussfilt(Ixy,sigma);
    
    % Compute Harris response
    C = GIxx.*GIyy - GIxy.*GIxy - k*(GIxx + GIyy).^2;
    
    % Apply detection threshold
    thresholdedC = C;
    for i = 1:size(C,1)
        for j = 1:size(C,2)
            if(C(i,j) < thresh)
                thresholdedC(i,j) = 0;
            end
        end
    end
    
    % Perform Non Maximal Supression
    NMSCorners = imregionalmax(thresholdedC);
    
    % List detected corner coordinates
    [corn_x,corn_y] = find(NMSCorners);
    corners = [corn_x';corn_y'];   
end