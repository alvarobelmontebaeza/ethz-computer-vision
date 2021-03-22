% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%   
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)
    distances = ssd(descr1, descr2);
 
    if strcmp(matching, 'one-way')
        % Obtain closest feature in image 2 for each feature in the first image
        matches = zeros(2,size(distances,1));
        for i=1:size(distances,1)
            % For each keypoint in image 1, retrieve the keypoint of image
            % 2 with minimal distance and store its correspondence
            [minVal, minIndex] = min(distances(i,:));
            matches(1,i) = i;
            matches(2,i) = minIndex;
        end
        
    elseif strcmp(matching, 'mutual')
        % Obtain closest feature from I1 in I2
        matches1 = zeros(2,size(distances,1));
        for i=1:size(distances,1) 
            % For each keypoint in image 1, retrieve the keypoint of image
            % 2 with minimal distance and store its correspondence
            [minVal, minIndex] = min(distances(i,:));
            matches1(1,i) = i;
            matches1(2,i) = minIndex;
        end
        %Obtain closest feature from I2 in I1
        matches2 = zeros(2,size(distances,2));
        for j=1:size(distances,2)
            % For each keypoint in image 2, retrieve the keypoint of image
            % 1 with minimal distance and store its correspondence
            [minVal, minIndex] = min(distances(:,j));
            matches2(1,j) = minIndex;
            matches2(2,j) = j;
        end
        
        %Check the mutual correspondences
        matches=[];
        if size(matches1,2) < size(matches2,2) % If there are more keypoints in Image 2
            for i = 1:size(matches1,2)
                if matches1(2,i) == matches2(2,find(matches2(1,:)==i))
                    matches = [matches, matches1(:,i)];
                end
            end
        else % If there are more keypoints in Image 1
            for j = 1:size(matches2,2)
                if matches2(1,j) == matches1(1,find(matches1(2,:)==j))
                    matches = [matches, matches2(:,j)];
                end
            end
        end
          
        
    elseif strcmp(matching, 'ratio')
        % Obtain closest 2 features in image 2 for each feature in the first
        % image and then compute the ratio between them. If it's lower
        % than the specified threshold, consider the match valid.
        matches = [];
        ratio_thresh = 0.5;
        for i=1:size(distances,1)
            % Retrieve 2 minimal distances and corresponding indexs
            [minVals, minIndexs] = mink(distances(i,:),2); 
            if ((minVals(1)/minVals(2)) < ratio_thresh) %Check if ratio is satisfied
                matches = [matches, [i;minIndexs(1)]];
            end
        end
        
    else
        error('Unknown matching type.');
    end
end

function distances = ssd(descr1, descr2)
    % We use the squared euclidean distance, which is equivalent to SSD
    distances = pdist2(descr1',descr2','squaredeuclidean');
end