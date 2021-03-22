%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn
% T: 3x3
% U: 4x4

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)
%data normalization

%1. compute centroids
C_xy = [sum(xy(1,:));sum(xy(2,:))]./size(xy,2);
C_XYZ = [sum(XYZ(1,:));sum(XYZ(2,:));sum(XYZ(3,:))]./size(XYZ,2);

%2. shift the points to have the centroid at the origin
shift_xy = xy - C_xy;
shift_XYZ = XYZ - C_XYZ;

%3. compute scale
distances2d = sqrt((shift_xy(1,:).^2) + (shift_xy(2,:).^2));
s2d = mean(distances2d);

distances3d = sqrt((shift_XYZ(1,:).^2) + (shift_XYZ(2,:).^2) + (shift_XYZ(3,:).^2));
s3d = mean(distances3d);

%4. create T and U transformation matrices (similarity transformation)
T = inv([s2d 0 C_xy(1);
         0 s2d C_xy(2);
         0 0 1]);
 
U = inv([s3d 0 0 C_XYZ(1);
         0 s3d 0 C_XYZ(2);
         0 0 s3d C_XYZ(3);
         0 0 0 1]);

%5. normalize the points according to the transformations
xy_normalized = T * homogenization(xy);
XYZ_normalized = U * homogenization(XYZ);

end