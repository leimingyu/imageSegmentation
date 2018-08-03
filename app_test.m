%% Step 1. Load the BALF image

clc; clear all; close all;

%This command reads the balf image and tif extension.

Balf=imread('balf.tif');

%% Step 2. Convert to grayscale
% Convert the Balf RGB image to gray scale. %
grayscale=rgb2gray(Balf);
figure
subplot(2,2,1)
imshow(grayscale);
title('step1: grayscale')  

%% Step 4. Invert the gray scale image
% This command reverses black and white image into a binary image. Black becomes 0's and white becomes 1's.  %

% Note: the grayscale image has min value 17 and max value 253
% therefore, imcomplement() computes the the complement value by subtract
% the pixel value from 255.
% here, the output is not binary
invert=imcomplement(grayscale);
subplot(2,2,2)
imshow(invert);
title('step2: complement of grayscale')  

%% Step 5. Adjust the the image intensity value

% Adjust the the inverted black and white image intensity value.
adj=imadjust(invert);
subplot(2,2,3)
imshow(adj);
title('step3: adjust intensity') 

%% Step 6. Covert the grayscale image to binary image.

Bw=im2bw(adj,graythresh(adj));
subplot(2,2,4)
imshow(Bw);
title('step4: grayscale to binary') 
 

 

%%  Step 9. Fill in the cytoplasm of the macropheges.

closeBw=imclose(Bw,strel('disk',10));
fill=imfill(closeBw,'holes');
imshow(fill);

 

%% Step 10. Eliminate small pixel values

%This command removes small pixel values that are not macropheges.

elimate_noise = imopen(fill, ones(15,15));

figure, imshow(elimate_noise);

 

 

%% Step 11. Remove pixels that do not contain the nucleophiles

 

remove_pixel=bwareaopen(elimate_noise, 75);

figure, imshow(remove_pixel);

 

 

%% Step 12.

 

 

D = -bwdist(~remove_pixel);

imshow(D,[])

 

%%

Ld = watershed(D);

imshow(label2rgb(Ld))

 

bw2 = remove_pixel;

bw2(Ld == 0) = 0;

imshow(bw2)

mask = imextendedmin(D,2);

imshowpair(remove_pixel,mask,'blend')

D2 = imimposemin(D,mask);

Ld2 = watershed(D2);

bw3 = remove_pixel;

bw3(Ld2 == 0) = 0;

imshow(bw3)

 

%% Step 12. Overlay the perimeter of the macropheges

overlay_perm=bwperim(bw3);

imshow(overlay_perm);

 

%% Outline the perimeter of the cytoplasm

overlay_cellwall=imoverlay(adj, overlay_perm, [1,0,1]);
imshow(overlay_cellwall);

 

%% Mask the nucelophiles

 

mask_nuc=imextendedmax(adj, 70);
imshow(mask_nuc);

%% Fill in the gaps of the nucelophiles
mask_nuc=imclose(mask_nuc, ones(4,4));
imshow(mask_nuc);

%% Fill in nucelophiles
mask_nuc=imfill(mask_nuc, 'holes');
imshow(mask_nuc);
%% Remove pixel values
mask_nuc= bwareaopen(mask_nuc,50);
imshow(mask_nuc);

 
 

%% Overlay the nucelophiles and the cytoplasm

 

overlay2 = imoverlay(adj, overlay_perm| mask_nuc, [1 0 1]);

imshow(overlay2);