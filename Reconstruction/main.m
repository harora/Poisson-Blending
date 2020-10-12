clc;
clear;
close all;

imgin = im2double(imread('./target.jpg'));

[imh, imw, nb] = size(imgin);
assert(nb==1);
% the image is grayscale

V = zeros(imh, imw);
V(1:imh*imw) = 1:imh*imw;
% V(y,x) = (y-1)*imw + x
% use V(y,x) to represent the variable index of pixel (x,y)
% Always keep in mind that in matlab indexing starts with 1, not 0

%TODO: initialize counter, A (sparse matrix) and b.
e=1;
A = sparse([],[],[],(imh*imw),imh*imw, (imh-2)*(imw-2)*5 + (imh-2)*3*2 + (imw-2)*3*2 + 4);
b = zeros(imh*imw,1);

%TODO: fill the elements in A and b, for each pixel in the image

for y = 2:imh-1
    for x = 2:imw-1
        A(e, V(y,x-1)) = -1;
        A(e, V(y,x+1)) = -1;
        A(e, V(y-1,x)) = -1;
        A(e, V(y+1,x)) = -1;
        A(e, V(y,x)) = 4;
        b(e) = 4*imgin(y,x) - imgin(y,x+1) - imgin(y,x-1) - imgin(y+1,x) - imgin(y-1,x);
        e=e+1;

    end
end 

%edges

for y = 2:imh-1
    x=1;
    
    A(e, V(y+1,x)) = -1;
    A(e, V(y-1,x)) = -1;
    A(e, V(y,x)) = 2;
    b(e) = 2*imgin(y,x) - imgin(y+1,x) - imgin(y-1,x);
    e=e+1;
    
    x=imw;
    A(e, V(y+1,x)) = -1;
    A(e, V(y-1,x)) = -1;
    A(e, V(y,x)) = 2;
    b(e) = 2*imgin(y,x) - imgin(y+1,x) - imgin(y-1,x);
    e=e+1;
end

for x = 2:imw-1
    y=1;
    
    A(e, V(y,x+1)) = -1;
    A(e, V(y,x-1)) = -1;
    A(e, V(y,x)) = 2;
    b(e) = 2*imgin(y,x) - imgin(y,x+1) - imgin(y,x-1);
    e=e+1;
    
    y=imh;
    A(e, V(y,x+1)) = -1;
    A(e, V(y,x-1)) = -1;
    A(e, V(y,x)) = 2;
    b(e) = 2*imgin(y,x) - imgin(y,x+1) - imgin(y,x-1);
    e=e+1;
end



%TODO: add extra constraints

A(e,V(1,1)) =1;
b(e) = imgin(1,1);
e=e+1;
A(e,V(1,imw)) =1;
b(e) = imgin(1,imw);
e=e+1;
A(e,V(imh,1)) =1;
b(e) = imgin(imh,1);
e=e+1;
A(e,V(imh,imw)) =1;
b(e) = imgin(imh,imw);
%e=e+1;

%TODO: solve the equation
%use "lscov" or "\", please google the matlab documents
solution = A\b
error = sum(abs(A*solution-b));
disp(error)
imgout = reshape(solution,[imh,imw]);

imwrite(imgout,'output.png');
figure(), hold off, imshow(imgout);

