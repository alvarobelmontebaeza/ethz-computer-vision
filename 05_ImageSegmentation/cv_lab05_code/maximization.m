function [mu, var, alpha] = maximization(P, X)

K = size(P,2);
N = size(X,2);
% Intialize distribution parameters
alpha = zeros(1,K);
mu = zeros(3,K);
var = zeros(3,3,K);

% For each cluster
for k = 1:K
    curr_cov = zeros(3,3);
    
    Z = sum(P(:,k));
    alpha(1,k) = Z/N;
    mu(:,k) = sum(X.*repmat(P(:,k)',[3,1]),2) / Z;
    diff = X - repmat(mu(:,k),[1,N]);
    % Obtain covariance for each pixel
    for n = 1:N
        curr_cov = curr_cov + P(n,k)*(diff(:,n)*diff(:,n)');
    end
    
    % Assign normalized covariance obtained for this cluster
    var(:,:,k) = curr_cov ./ Z;
end

end