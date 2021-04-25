% Modified code originally written by GodGOD of the Matlab Forums:
% It has been altered such that it supports a driving signal on the
% receiver

close all;
clear;


% read in and display original image
I = imread('lena_plain.jpg');
figure;
imshow(I); 
title('Plain Image');
drawnow;

% get number of pixels
n = size(I, 1) * size(I, 2);

%%% Lorenz equations parameters %%%
s = 10;
r = 28;
b = 8/3;

%%% Lorenz equations initial values %%%
x0 = 1.1840;
y0 = 1.3627;
z0 = 1.2519;

%%% Step size; white noise level %%%
h = 0.001;
level = 0;

% Solve the Lorenz system with specified settings
[x,y,z] = lorenz_solver(n, level, s, r, b, x0, y0, z0, h);
drawnow;

% Quantize each of the sequences
X = 1000*x - round(1000*x);
Y = 1000*y - round(1000*y);
Z = 1000*z - round(1000*z);
drawnow;

% Sort each of the sequences in ascending order
[X1, lx] = sort(X);
[Y1, ly] = sort(Y);
[Z1, lz] = sort(Z);
drawnow;

% Confuse the colour planes
% Get each colour plane as a vector, first
A = I(:, :, 1);
B = I(:, :, 2);
C = I(:, :, 3);
A1 = reshape(A, 1, []);
B1 = reshape(B, 1, []);
C1 = reshape(C, 1, []);

% Perform the confusion, and convert back to matrix
A2(1:n) = A1(lx);
B2(1:n) = B1(ly);
C2(1:n) = C1(lz);
A3 = reshape(A2, size(I,1), size(I,2));
B3 = reshape(B2, size(I,1), size(I,2));
C3 = reshape(C2, size(I,1), size(I,2));
drawnow;

% Finally display the encrypted image
I(:, :, 1) = A3;
I(:, :, 2) = B3;
I(:, :, 3) = C3;
figure;
imshow(I);
title('Cipher Image (Encrypted)');
% Write to disk
imwrite(I, 'lena_cipher.jpg', 'mode', 'lossless');
drawnow;

%%% Attempt to decrypt the cipher image %%%
% Method 1: Preprocessed confusion arrays lx, ly, lz

% Get each colour plane as a vector, first
I1 = imread('lena_cipher.jpg');
A4 = I1(:, :, 1);
B4 = I1(:, :, 2);
C4 = I1(:, :, 3);
A5 = reshape(A4, 1, []);
B5 = reshape(B4, 1, []);
C5 = reshape(C4, 1, []);

% Perform confusion of the sequences
A6(lx) = A5(1:n);
B6(ly) = B5(1:n);
C6(lz) = C5(1:n);

% Reshape back to a matrix
A7 = reshape(A6,size(I1,1),size(I1,2));
B7 = reshape(B6,size(I1,1),size(I1,2));
C7 = reshape(C6,size(I1,1),size(I1,2));
I1(:, :, 1) = A7;
I1(:, :, 2) = B7;
I1(:, :, 3) = C7;
drawnow;

% Display the plain image
% figure;
% imshow(I1); 
% title('Plain Image (Preprocessed)');
% imwrite(I,'lena2.jpg','mode','lossless');
% drawnow;

%%% Attempt to decrypt the cipher image %%%
% Method 2: use lorenz equations

% Read the cipher image
I2 = imread('lena_cipher.jpg');
% Get the number of pixels
n = size(I2,1)*size(I2,2);

%%% Lorenz equations parameters %%%
s = 10;
r = 28;
b = 8/3;

%%% Lorenz equations initial values %%%
% Now that the signal is driven, changing these initial values to be
% slightly off of x0, should still produce a recognisable image.
x1 = x0;

y1 = y0;
z1 = z0;

%%% Step size; white noise %%%
h = 0.001;
level = 0;

% Solve the Lorenz system with specified settings
[x2, y2, z2] = lorenz_driver(n, level, s, r, b, x1, y1, z1, h, x);

% Quantize each of the sequences
X2 = 1000 * x2-round(1000*x2);
Y2 = 1000 * y2-round(1000*y2);
Z2 = 1000 * z2-round(1000*z2);

% Sort each of the sequences in ascending order
[X3, lx1] = sort(X2);
[Y3, ly1] = sort(Y2);
[Z3, lz1] = sort(Z2);

% Confuse the colour planes
% Get each colour plane as a vector, first
A8=I2(:, :, 1);
B8=I2(:, :, 2);
C8=I2(:, :, 3);
A9 = reshape(A8, 1, []);
B9 = reshape(B8, 1, []);
C9 = reshape(C8, 1, []);

% Perform the confusion, convert back to matrix
A10(lx1) = A9(1:n);
B10(ly1) = B9(1:n);
C10(lz1) = C9(1:n);
A11=reshape(A10, size(I2,1), size(I2,2));
B11=reshape(B10, size(I2,1), size(I2,2));
C11=reshape(C10, size(I2,1), size(I2,2));

% Finally display the decrypted image
I2(:, :, 1) = A11;
I2(:, :, 2) = B11;
I2(:, :, 3) = C11;

figure;
imshow(I2); 
title('Plain Image (Decrypted)');
% imwrite(I,'lena3.jpg','mode','lossless');
drawnow;
