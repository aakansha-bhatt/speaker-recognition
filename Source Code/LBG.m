function codebook = LBG(MFCC, num_centroids)
% Vector quantization using the Linde-Buzo-Gray algorithm
% Inputs: 
%       MFCC: contains training data vectors (one per column)
%       num_centroids: number of centroids required
% Output: 
%       codebook: contains the result VQ codebook (k columns, one for each centroids)

% preset threshold to compare with average distance
epsilon = 0.01;

% initializing single-vector codebook
codebook = mean(MFCC,2);
distortion = 10000;

for i = 1:log2(num_centroids)
    % calculating yn+ and yn-
    codebook = [codebook*(1+epsilon), codebook*(1-epsilon)];
    
    while (1 == 1)
        % nearest neighbour search
        d = disteu(MFCC, codebook);
        
        % find closest codeword
        % index contains the associated cluster number for each training vector
        [nearest_codebook, index] = min(d, [], 2);
        temp = 0;
       
        % cluster vectors and find new centroid
        for j = 1:2^i         
            
            % centroid of all vectors in a particular cluster
            % MFCC(:, find(ind == j)): get all the training vectors that belong to the cluster number j 
            codebook(:,j) = mean(MFCC(:, find(index == j)), 2);
            
            %re-calculate distance
            d = disteu(MFCC(:, find(index == j)), codebook(:,j));
            
            % update temp
            for z = 1:length(d)
                temp = temp + d(z);
            end
            
        end
       
        %compare average distance with threshold
        if (((distortion - temp)/temp) < epsilon)
            % if true, break and move on to finding centroids
            break;
        else 
            % else continue loop until average distance is below threshold
            distortion = temp;
        end
    
    end
    
end
