function a = my_edit(I)
    a=I;
    [r,c]=size(a);
%     for j=1:c
%         if(a(100,j)==0)
%             left=j+1;
%             break;
%         end
%     end
%     up=0;
%     for i=1:r
%         if(a(i,100)==0)
%             up=i+1;
%             break;
%         end
%     end
%     right=0;
%     for j=c:-1:1
%         if(a(100,j)==0)
%             right=j-1;
%             break;
%         end
%     end
%     down=0;
%     for i=r:-1:1
%         if(a(i,100)==0)
%             down=i-1;
%             break;
%         end
%     end
%     disp(up)
%     disp(left)
%     disp(down)
%     disp(right)
    for i=1:346
        current=0;
        count=0;
        for j=1:c
            if(current==1)
                if(a(i,j)==0)
                    current=0;
                end
            else
                if(a(i,j)==1)
                    current=1;
                    count=count+1;
                end
            end
        end
        if(count>1)
             disp(i)
            current=0;
            for j=1:c
                if(current==1)
                    if(a(i,j)==0)
                        break;
                    else
                        a(i,j)=0;
                    end
                else
                    if(a(i,j)==1)
                        current=1;
                        a(i,j)=0;
                    end
                end
            end
        end
    end
    a(a~=0) = 1;
    a = logical(a);
end
