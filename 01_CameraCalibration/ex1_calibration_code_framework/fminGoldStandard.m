%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function f = fminGoldStandard(pn, xy_normalized, XYZ_normalized)
%reassemble P
P = pn;

% Apply projection matrix P
xyz_projected=P*XYZ_normalized;

% Compute Inhomogeneous projected points 
NB_PTS=size(XYZ_normalized,2);
xy_projected=zeros(2,NB_PTS);
for i=1:NB_PTS
    xy_projected(1,i)=xyz_projected(1,i)./xyz_projected(3,i); % compute inhomogeneous coordinates x=x/z 
    xy_projected(2,i)=xyz_projected(2,i)./xyz_projected(3,i); % compute inhomogeneous coordinates y=y/z 
end

% TODO compute reprojection errors
distances = sqrt((xy_normalized(1,:)-xy_projected(1,:)).^2 + (xy_normalized(2,:)-xy_projected(2,:)).^2);

% TODO compute cost function value
f = sum(distances.^2);
end