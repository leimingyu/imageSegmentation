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

%%
figure

%%  Step 9. Fill in the cytoplasm of the macropheges.

closeBw=imclose(Bw,strel('disk',10)); 

fill=imfill(closeBw,'holes');
subplot(2,2,1)
imshow(fill);
title('step5: fill img after morph. closing') 


%% Step 10. Eliminate small pixel values

%This command removes small pixel values that are not macropheges.
elimate_noise = imopen(fill, ones(15,15));
subplot(2,2,2)
imshow(elimate_noise);
title('step6: remove small pixel') 

%% Step 11. Remove pixels that do not contain the nucleophiles

remove_pixel=bwareaopen(elimate_noise, 75); % remove obj < 75 pixels
subplot(2,2,3)
imshow(remove_pixel);
title('step7: remove small obj') 

%% step 12
D = -bwdist(~remove_pixel);
subplot(2,2,4)
imshow(D,[])
title('step8: Euclidean dist') 


%%

% figure
% Ld = watershed(D);
% subplot(2,3,1)
% imshow(label2rgb(Ld))
% title('step9: Watershed Transfm on dist') 
% 
% bw2 = remove_pixel;
% bw2(Ld == 0) = 0;
% subplot(2,3,2)
% imshow(bw2)
% title('step10: separation on the bw') 

%%

figure 


mask = imextendedmin(D,2);
subplot(2,2,1)
imshowpair(remove_pixel,mask,'blend')
title('step9: img compare') 

D2 = imimposemin(D,mask);
Ld2 = watershed(D2);

lab2rgb_ld2 = label2rgb(Ld2); % use colors to lable bg and obj


bw3 = remove_pixel;
bw3(Ld2 == 0) = 0;
subplot(2,2,2)
imshow(bw3)
title('step10: separation')

% Overlay the perimeter of the macropheges

overlay_perm=bwperim(bw3);
subplot(2,2,3)
imshow(overlay_perm);
title('step11: overlay the perimeter')

% Outline the perimeter of the cytoplasm

overlay_cellwall=imoverlay(adj, overlay_perm, [1,0,1]);
subplot(2,2,4)
imshow(overlay_cellwall);
title('step12: outline perimeter')


%% Mask the nucelophiles

figure


mask_nuc=imextendedmax(adj, 70);  % identify bright obj
subplot(2,2,1)
imshow(mask_nuc);
title('step13: identify bright obj')

% Fill in the gaps of the nucelophiles
mask_nuc=imclose(mask_nuc, ones(4,4));
subplot(2,2,2)
imshow(mask_nuc);
title('step14: fill using imclose')

% Fill in nucelophiles
mask_nuc=imfill(mask_nuc, 'holes');
subplot(2,2,3)
imshow(mask_nuc);
title('step15: cnt to fill using imfill')

% Remove pixel values
mask_nuc= bwareaopen(mask_nuc,50);
subplot(2,2,4)
imshow(mask_nuc);
title('step16: remove small obj')



%% finally: Overlay the nucelophiles and the cytoplasm

figure;
subplot(1,2,1)
overlay2 = imoverlay(adj, overlay_perm | mask_nuc, [1 0 1]);
imshow(overlay2);
title('final image')

subplot(1,2,2)
imshow(lab2rgb_ld2);
title('watershed region on ld2');


