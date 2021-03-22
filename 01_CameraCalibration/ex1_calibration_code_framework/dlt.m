%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xyn: 3xn
% XYZn: 4xn

function [P_normalized] = dlt(xyn, XYZn)
%computes DLT, xy and XYZ should be normalized before calling this function

% 1. For each correspondence xi <-> Xi, computes matrix Ai
for i = 1:2:(2*size(XYZn,2))    
    A(i,:) = [XYZn(:,round(i/2))', zeros(1,4), -xyn(1,round(i/2)).*(XYZn(:,round(i/2))')];
    A(i+1,:) =[ zeros(1,4), -XYZn(:,round(i/2))', xyn(2,round(i/2)).*(XYZn(:,round(i/2))')];
end

% 2. Compute the Singular Value Decomposition of Usvd*S*V' = A
[Usvd, S, V] = svd(A);

% 3. Compute P_normalized (=last column of V if D = matrix with positive
% diagonal entries arranged in descending order)
P_column = V(:,size(V,2));
% Rearrange values so that we end with a 3x4 matrix
P_normalized = [P_column(1:4)'; P_column(5:8)';P_column(9:12)'];
end
