function peak = find_peak(Xi, X, radius)
    % Finds the mode of the density function for a given pixel Xi
    % > X is the discrete samples of the density function and is a matrix
    %   with size L x n
    % > L is the total number of pixels in the image and n=3 for the L*a*b
    %   value

   
    L = max(size(X)) ;

    tol = radius/15 ;
    shift = 15 ;
    old_center = Xi ;
    test = 1 ;

    while(shift>tol)
        dists = sqrt(sum(((X-repmat(old_center,[1,L])).^2))); %avoid for loop
        idx = find(dists<radius) ;
        size(X(:,idx)) ;
        new_center = mean(X(:,idx),2) ;
        shift = norm(new_center-old_center) ;
        old_center = new_center ;
        test = test+1;
    end
    
    peak = new_center ;
    

end