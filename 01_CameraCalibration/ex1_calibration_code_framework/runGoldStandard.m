%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error to refine P_normalized
% TODO fill the gaps in fminGoldstandard.m
pn = P_normalized;
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized);
end

% denormalize projection matrix
P = inv(T) * pn * U;

%factorize prokection matrix into K, R and t
[K, R, t] = decompose(P);

% TODO compute average reprojection error

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