function [output,krnl] = mySpatiallyVaryingKernel(I,M,alpha)
    I = double(I);
    M = double(M);
    fore = [];
    [m , n] = size(M);
    krnl = zeros(size(M));
    output = zeros(size(I));
    for i=1:m
        for j=1:n
            if M(i,j)==1
                fore = [fore; [i j]];
            end
        end
    end
    
    for i=1:m
        for j=1:n
            [k,dist] = dsearchn(fore,[[i j]]);
            if dist<=alpha
                dist = floor(dist);
            else
                dist = alpha;
            end
            %dist = min(dist,i-1);
            %dist = min(dist,j-1);
            %dist = min(dist,m-i);
            %dist = min(dist,n-j);
            krnl(i,j) = dist;
            if dist>0
                bmask = fspecial('disk',dist);
            else
                bmask = [[1]];
            end
            if M(i,j)==1
                output(i,j)=I(i,j);
            else
                a = max(i-dist,1);
                b = min(i+dist,m);
                c = max(j-dist,1);
                d = min(j+dist,n);
                aa = max(dist+1 - i+a,1);
                bb = min(dist+1 + b-i,2*dist+1);
                cc = max(dist+1 - j+c,1);
                dd = min(dist+1 +d-j,2*dist+1);
                bmask = bmask(aa:bb,cc:dd);
                ff = (I(a:b,c:d).*bmask);
                output(i,j) = sum(ff(:))/sum(bmask(:));
            end
        end
    end
    
    
end