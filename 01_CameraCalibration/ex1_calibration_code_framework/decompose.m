%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
%Decompose P into K, R and t using QR decomposition

% Compute R, K with QR decomposition such M=K*R
M = P(1:3,1:3);
[q,r] = qr(inv(M));
R = inv(q);
K = inv(r);

% Compute camera center C=(cx,cy,cz) such P*C=0
% C is the right nullvector of P, which can be obtained using SVD
[Usvd, S, V] = svd(P);
C = V(:,size(V,2));

% normalize K such K(3,3)=1
K = K./K(3,3);

% Adjust matrices R and Q so that the diagonal elements of K (= intrinsic matrix) are non-negative values and R (= rotation matrix = orthogonal) has det(R)=1
% Obtain diagonal matrix to adjust sign of K
Tk = diag(sign(diag(K)));
%Adjust sign
K = K*Tk; 
R = inv(Tk)*R;

if det(R) == -1
    R = -R;
end    
% Compute translation t=-R*C
t = -R*C(1:3);

end