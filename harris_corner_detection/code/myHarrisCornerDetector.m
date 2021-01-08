function[blur1, Ix, Iy, min_eig, max_eig, cornerness, corners, final] = myHarrisCornerDetector(Input, sig1, sig2,k, threshold) 
%   Stretching intensities in [0,1]
    min_I = min(min(Input)); max_I = max(max(Input));
    Img = (Input - min_I)./(max_I-min_I);

%   Smoothening before gradient computation
    G1 = fspecial('gaussian', 2*floor(sig1 * 3) + 1, sig1);
    blur1 = imfilter(Img, G1, 'conv');
    
%   Structure tensor components and smoothening
    [Ix, Iy] = imgradientxy(blur1); %Vertical and Horizontal derivatives
    G2 = fspecial('gaussian', 2*floor(sig2 * 3) + 1, sig2);
    Ix2 = imfilter(Ix .* Ix , G2, 'conv');
    Iy2 = imfilter(Iy .* Iy , G2, 'conv');
    Ixy = imfilter(Ix .* Iy , G2, 'conv');

%   Eigenvalues
    for i = 1:size(Img,1)
        for j = 1:size(Img,2)
            A = [Ix2(i,j), Ixy(i,j); Ixy(i,j), Iy2(i,j)];
            e = eig(A);
            min_eig(i,j) = min(e);
            max_eig(i,j) = max(e);
        end
    end

%   Harris measure
    Det_A = (Ix2).*(Iy2) - (Ixy .* Ixy);
    Trace_A = Ix2 + Iy2;
    cornerness = Det_A - k * (Trace_A .* Trace_A);
    
%   Non-maximum suppression and thresholding
    corners = cornerness;
    c = size(Input);
    for i = 1:size(Input,1)
        for j = 1:size(Input, 2)
            Patch = cornerness(max(1,i-1):min(c,i+1) , max(1,j-1):min(c,j+1)); %3X3 patch-size and cropping the window on edges
            t = max(max(Patch));
            if corners(i,j) ~= t;
                corners(i,j)=0;
            end
        end
    end
    threshold = 0.04;
    corners = corners > threshold;   
    final = Img;
end
    








