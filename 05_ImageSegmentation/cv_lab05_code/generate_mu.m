% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(Lmin, amin, bmin, range_L, range_a, range_b, K)

    mu = zeros(3,K);
    for i = 1:K
        % Compute random means inside the range of L*a*b space
        mu(1,i) = Lmin + range_L .* rand(1,1);
        mu(2,i) = amin + range_a .* rand(1,1);
        mu(3,i) = bmin + range_b .* rand(1,1);
    end

end