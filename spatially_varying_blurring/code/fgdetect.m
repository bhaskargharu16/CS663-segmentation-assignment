function output = fgdetect(Image,sigma)
    
    Image = rgb2gray(Image);
    [m,n] = size(Image);
    edd = edge(Image,'log',0.1,sigma);
    imshow(edd);
    output = ones(m,n);
    for i = 1:m
        for j=1:n
            if edd(i,j)==1
                break;
            end
            output(i,j) = 0;
        end
    end
    
    for i = 1:m
        for j=n:-1:1
            if edd(i,j)==1
                break;
            end
            output(i,j) = 0;
        end
    end
    
    for j = 1:n
        for i=1:m
            if edd(i,j)==1
                break;
            end
            output(i,j) = 0;
        end
    end
    for j = 1:n
        for i=m:-1:1
            if edd(i,j)==1
                break;
            end
            output(i,j) = 0;
        end
    end
end