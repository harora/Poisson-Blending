function imgout = poisson_blend(im_s, mask_s, im_t)
% -----Input
% im_s     source image (object)
% mask_s   mask for source image (1 meaning inside the selected region)
% im_t     target image (background)
% -----Output
% imgout   the blended image

[imh, imw, nb] = size(im_s);
k = nnz(mask_s);
%TODO: consider different channel numbers

%TODO: initialize counter, A (sparse matrix) and b.
%Note: A don't have to be k¡Ák,
%      you can add useless variables for convenience,
%      e.g., a total of imh*imw variables

A = sparse([],[],[],k*3,k*3, k*3*5);
b = zeros(k,1);

V = zeros(imh,imw);

e=1;
for y = 1:imh 
    for x=1:imw  
        if mask_s(y,x) == 1
            V(y,x)=e;
            e=e+3;

        end
    end
end

%TODO: fill the elements in A and b, for each pixel in the image
e=1;

for y = 1:imh
    for x=1:imw
        if mask_s(y,x) == 1
            %RED
            add = 0;
            
            b(e) = 4*im_s(y,x,1) - im_s(y+1,x,1,1) - im_s(y-1,x,1) - im_s(y,x+1,1) - im_s(y,x-1,1);
            A(e,e) = 4;
            
            if mask_s(y+1,x) == 1
                A(e,V(y+1,x)) = -1;
            else
                b(e) = b(e) + im_t(y+1,x,1);
            end
            
            if mask_s(y-1,x) == 1
                A(e,V(y-1,x)) = -1;
            else
                b(e) = b(e) + im_t(y-1,x,1);
            end 
                
            if mask_s(y,x+1) == 1
                A(e,V(y,x+1)) = -1;
            else
                b(e) = b(e) + im_t(y,x+1,1);
            end 
            
            if mask_s(y,x-1) == 1
                A(e,V(y,x-1)) = -1;
            else
                b(e) = b(e) + im_t(y,x-1,1);
            end
                
            e=e+1;
            %GREEN
            add = 0;
            
            b(e) = 4*im_s(y,x,2) - im_s(y+1,x,2) - im_s(y-1,x,2) - im_s(y,x+1,2) - im_s(y,x-1,2);
            A(e,e) = 4;
            
            if mask_s(y+1,x) == 1
                A(e,V(y+1,x)+1) = -1;
            else
                b(e) = b(e) + im_t(y+1,x,2);
            end
            
            if mask_s(y-1,x) == 1
                A(e,V(y-1,x)+1) = -1;
            else
                b(e) = b(e) + im_t(y-1,x,2);
            end 
                
            if mask_s(y,x+1) == 1
                A(e,V(y,x+1)+1) = -1;
            else
                b(e) = b(e) + im_t(y,x+1,2);
            end 
            
            if mask_s(y,x-1) == 1
                A(e,V(y,x-1)+1) = -1;
            else
                b(e) = b(e) + im_t(y,x-1,2);
            end
                
            e=e+1;
            
            %BLUE
            add = 0;
            
            b(e) = 4*im_s(y,x,3) - im_s(y+1,x,3) - im_s(y-1,x,3) - im_s(y,x+1,3) - im_s(y,x-1,3);
            A(e,e) = 4;
            
            if mask_s(y+1,x) == 1
                A(e,V(y+1,x)+2) = -1;
            else
                b(e) = b(e) + im_t(y+1,x,3);
            end
            
            if mask_s(y-1,x) == 1
                A(e,V(y-1,x)+2) = -1;
            else
                b(e) = b(e) + im_t(y-1,x,3);
            end 
                
            if mask_s(y,x+1) == 1
                A(e,V(y,x+1)+2) = -1;
            else
                b(e) = b(e) + im_t(y,x+1,3);
            end 
            
            if mask_s(y,x-1) == 1
                A(e,V(y,x-1)+2) = -1;
            else
                b(e) = b(e) + im_t(y,x-1,3);
            end
                
            e=e+1;
            
        end
    end
end

%TODO: add extra constraints (if any)
%-----
%-----


%TODO: solve the equation
%use "lscov" or "\", please google the matlab documents
solution = A\b;
error = sum(abs(A*solution-b));
disp(error)

%TODO: copy those variable pixels to the appropriate positions
%      in the output image to obtain the blended image

%imgout = im_t;
for y = 1:imh 
    for x=1:imw 
        if mask_s(y,x) == 1
            imgout(y,x,1) = solution(V(y,x));
            imgout(y,x,2) = solution(V(y,x)+1);
            imgout(y,x,3) = solution(V(y,x)+2);
        else
            imgout(y,x,1) = im_t(y,x,1);
            imgout(y,x,2) = im_t(y,x,2);
            imgout(y,x,3) = im_t(y,x,3);
        %disp(imgout(y,x));
        end
    end
end
