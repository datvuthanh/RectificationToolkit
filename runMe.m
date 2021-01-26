% Rectification example. The CV Toolkit is required

% Calibrated rectification. 
% Camera matrices are provided in the same folder as the imafes, 
% with the same base name and extension .pm (see exemple)

% [I1r, I2r, bb1, bb2, Pn1, Pn2]  = doRectify('examples/IMG_0011.JPG','examples/IMG_0012.JPG',true);
% % % [I1r, I2r, bb1, bb2, Pn1, Pn2, H1, H2]  = doRectify('examples/ieu/image_0.jpg','examples/ieu/image_1.jpg',true);

% figure;imshow(mat2gray(I1r),[],'InitialMagnification','fit');
% figure;imshow(mat2gray(I2r),[],'InitialMagnification','fit');
% drawnow;

% Uncalibrated rectification. The VLFEAT toolbox is required for SIFT
pkg load image;

[I1r, I2r, bb1, bb2, Pn1, Pn2]  = doRectify('examples/cporta0.png','examples/cporta1.png',false);

figure;imshow(I1r,[],'InitialMagnification','fit');
figure;imshow(I2r,[],'InitialMagnification','fit');
drawnow;

save_path = sprintf('examples/ieu/rec_%d', 1);
if ~exist(save_path, 'dir')
    mkdir(save_path)
end

img_rec0 = sprintf('%s/rec_0.jpg', save_path);
img_rec1 = sprintf('%s/rec_1.jpg', save_path);
imwrite(mat2gray(I1r), img_rec0);
imwrite(mat2gray(I2r), img_rec1);
