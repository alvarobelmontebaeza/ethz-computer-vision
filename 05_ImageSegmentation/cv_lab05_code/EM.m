function [map cluster] = EM(img)

% Create the distribution X
L = size(img,1) * size(img,2);
l = reshape(img(:,:,1), 1,L) ;
a = reshape(img(:,:,2), 1,L);
b = reshape(img(:,:,3), 1,L);
X = [l;a;b];
X = double(X);

% Parameter initialization 
% Clusters
K = 3; 
% Initialize alpha as indicates in slides to obtain uniform weightage
alpha = ones(1,K) / K;

% Find ranges of values in each channel
Lmax = max(X(1,:)); Lmin = min(X(1,:)); range_L = Lmax - Lmin;
a_max = max(X(2,:)); a_min = min(X(2,:)); range_a = a_max - a_min;
b_max = max(X(3,:)); b_min = min(X(3,:)); range_b = b_max - b_min;
% use function generate_mu to initialize mus
mu = generate_mu(Lmin,a_min,b_min,range_L,range_a,range_b,K);
% use function generate_cov to initialize covariances
cov = generate_cov(range_L, range_a, range_b, K);

% iterate between maximization and expectation
tol = 1;
delta = tol+1;
it = 0;
while delta > tol
    it = it+1;    
    % Expectation step
    P = expectation(mu,cov,alpha,X);    
    % Maximization step
    [new_mu, new_cov, new_alpha] = maximization(P,X);
    % Update delta
    delta = norm(mu - new_mu);
    
    % Update for next iteration
    mu = new_mu;
    cov = new_cov;
    alpha = new_alpha;  

end

% Show final values as requested
mu
cov
alpha
% Return values
[~,idx] = max(P,[],2);
map = reshape(idx,size(img,1),size(img,2));
cluster = mu';
