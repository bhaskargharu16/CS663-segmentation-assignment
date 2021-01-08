%%myMeanShiftSegmentation.m
function [output,shifting_points,idx] = myMeanShiftSegmentation(Input , hs, hr,resize_factor,num_clusters,iter)
    % smoothening image
    G1 = fspecial('gaussian', 9 , 1);
    smooth = imfilter(Input, G1,'replicate');
    % downsampling
    downsampled = imresize(smooth,resize_factor);
    % 5 dimensional data points from each pixel of image
    [m,n,c] = size(downsampled);
    X = zeros(m,n,5); %(r,g,b,x,y)
    for i=1:m
        for j=1:n
            X(i,j,1:3) = downsampled(i,j,:);
            X(i,j,4) = i;
            X(i,j,5) = j;
        end
    end
    N = m*n;%number of pixels
%     X = reshape(X,[N,5]); % 5 number of features
%     shifting_points = X;%5d vectors  (m,n,5)
    shifting_points = reshape(X,[N,5]);
    scaler = [1/hr,1/hr,1/hr,1/hs,1/hs];
    shifting_points = shifting_points.*scaler;
    shifting_points = reshape(shifting_points,[m,n,5]);
%     shifting_points = shifting_points.*scaler;%scaling the data points according to kernel parameteres
    l=0;
    while l<iter
        l = l+1;
        for i=1:m
            for j=1:n
                point = shifting_points(i,j,:);
                point = reshape(point,[1,5]);
                window = shifting_points(max(1,i - hs):min(m,i+hs),max(1,j-hs):min(n,j+hs),:);
                window = reshape(window,[size(window,1)*size(window,2),5]);
                weights = exp(-sum((window - point).^2,2));
                new_point = (weights' * (window))/sum(weights);%mean shift update
                shifting_points(i,j,:) = new_point; 
            end
        end
    end
    shifting_points = reshape(shifting_points,[N,5]);
    % grouping filtered points
    rescaler = [hr,hr,hr,hs,hs];
    shifting_points = shifting_points.*rescaler;%scaling back to original 5D space
    disp(size(shifting_points));
    [idx,C] = kmeans(shifting_points,num_clusters);
    %shape of  idx is NX1 , shape of C is num_clustersX5 
    %5 is the number of components of a pixel (each point in our data)
    output = zeros(N,3);
    for i=1:N
        output(i,:) = C(idx(i),1:3);%extracting only RGB components
    end
    output = reshape(output,[m,n,c]);%reshaping back to MXNX3
end

