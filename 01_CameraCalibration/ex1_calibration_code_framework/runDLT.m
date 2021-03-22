%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)

% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

% compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized);

% denormalize projection matrix
P = inv(T) * Pn * U;

% factorize projection matrix into K, R and t
[K, R, t] = decompose(P);   

% compute average reprojection error

% Apply projection matrix P
XYZ_homogeneous=homogenization(XYZ);
xyz_projected=P*XYZ_homogeneous;

% Compute Inhomogeneous projected points 
NB_PTS=size(XYZ,2);
xy_projected=zeros(2,NB_PTS);
for i=1:NB_PTS
    xy_projected(1,i)=xyz_projected(1,i)./xyz_projected(3,i); % compute inhomogeneous coordinates x=x/z 
    xy_projected(2,i)=xyz_projected(2,i)./xyz_projected(3,i); % compute inhomogeneous coordinates y=y/z 
end

% Compute average error 
error = mean(sqrt((xy(1,:)-xy_projected(1,:)).^2 + (xy(2,:)-xy_projected(2,:)).^2));

end