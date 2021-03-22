function [map peak] = meanshiftSeg(img)

% Separate 3 image channels and create density function
L = size(img,1)*size(img,2); % Nº Pixels in image
% Vectorize each channel
l = reshape(img(:,:,1),1,L);
a = reshape(img(:,:,2),1,L);
b = reshape(img(:,:,3),1,L);
% Create density function X in L*a*b space.
X = [l;a;b];
X = double(X);
map = zeros(1,L); %Initialize map
peak = []; % Initialize peak

% Shift window to mean until convergence
radius = 15;
thresh = radius / 2;

for i = 1:L
    % Find mean for the current pixel
    curr_peak = find_peak(X(:,i),X(:,:), radius);
    % Create peak matrix at the first iteration
    if i==1
        peak = curr_peak;
        map(i) = 1;
    else    
        % Compute SSD from current peak to the rest
        peak_matrix = repmat(curr_peak, [1,size(peak,2)]);
        dist_peak = sqrt(sum(((peak - peak_matrix).^2)));

        % Add current peak to the matrix if distance < threshold
        idx = find(dist_peak < thresh,1);
        if isempty(idx)
            peak = [peak curr_peak];
            map(i) = size(peak,2);
        else
            map(i) = idx;
        end
    
    end
   
end

map = reshape(map, size(img,1), size(img,2));
peak = peak';

end