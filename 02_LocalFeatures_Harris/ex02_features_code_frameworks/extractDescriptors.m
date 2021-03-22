% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%   
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector
function [keypoints, descriptors] = extractDescriptors(img, keypoints)
    
    % Filter keypoints that are too close to the image edges (<5 pixels as
    % we are using 9x9 patches)
    invalid_keypoints = [];
    for j = 1:size(keypoints,2)
        if(keypoints(1,j)<= 5 || keypoints(1,j) >= (size(img,1)-5) || keypoints(2,j)<=10 || keypoints(2,j) >= (size(img,2)-5))
            invalid_keypoints = [invalid_keypoints,j];
        end
    end
    keypoints(:,invalid_keypoints) = []; %Remove border keypoints from set
    
    % Obtain keypoint descriptors as flattened vectors containing the pixel values of
    % the specified patch size
    descriptors = extractPatches(img,keypoints,9);    
end