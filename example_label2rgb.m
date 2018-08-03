clc; clear all; close all;

% https://www.mathworks.com/help/images/ref/label2rgb.html

I = imread('rice.png'); 
imshow(I)

%%
BW = imbinarize(I); 

CC = bwconncomp(BW);
L = labelmatrix(CC);

%%
RGB = label2rgb(L);
figure
imshow(RGB)