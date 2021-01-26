% Rectification example. The CV Toolkit is required

% Calibrated rectification. 
% Camera matrices are provided in the same folder as the imafes, 
% with the same base name and extension .pm (see exemple)

% [I1r, I2r, bb1, bb2, Pn1, Pn2]  = doRectify('examples/IMG_0011.JPG','examples/IMG_0012.JPG',true);
pkg load image;
warning('off')

for i = 0:199
    fprintf('processing %06d_10.png \n', i)
    image_path0 = sprintf('/home/ailab/Desktop/mc-cnn/data.kitti2015/unzip/training/image_2/%06d_10.png', i);
    image_path1 = sprintf('/home/ailab/Desktop/mc-cnn/data.kitti2015/unzip/training/image_2/%06d_11.png', i);
    
    doRectify(image_path0,image_path1,false,i);

    % save_path = sprintf('examples/ieu/rec_%d', i);
    % if ~exist(save_path, 'dir')
    %     mkdir(save_path)
    % end
    
    % img_rec0 = sprintf('%s/rec_0.jpg', save_path);
    % img_rec1 = sprintf('%s/rec_1.jpg', save_path);
    % imwrite(mat2gray(I1r), img_rec0);
    % imwrite(mat2gray(I2r), img_rec1);
    
    % pose_file0 = sprintf('examples/ieu/image_%d.pm', i);
    % pose_file1 = sprintf('examples/ieu/image_%d.pm', i+1);
    
    % P1 = load(pose_file0);
    % P2 = load(pose_file1);
    
    % [K1, R1, t1] = krt(P1);
    % [K2, R2, t2] = krt(P2);
    % c1 = -R1'*t1;
    % c2 = -R2'*t2;
    % b = norm(c1-c2);
    
    % [Kn1, Rn1, tn1] = krt(Pn1);
    % [Kn2, Rn2, tn2] = krt(Pn2);
    
    % conf_file = sprintf('%s/ieu.cfg', save_path);
    % f = fopen(conf_file, 'w');
    % fprintf(f, 'Camera.fx = 1184.51770\n');
    % fprintf(f, 'Camera.fy = 1183.63810\n');
    % fprintf(f, 'Camera.cx = 978.30778\n');
    % fprintf(f, 'Camera.cy = 533.85598\n');
    % fprintf(f, 'Camera.baseline = %f\n', b);
    % fprintf(f, 'maxDepth = 1.1\n');
    % fprintf(f, 'minDepth = 0.8\n');
    % fprintf(f, 'P1 = %f %f %f %f %f %f %f %f %f %f %f %f\n', Rn1(1, 1), Rn1(1, 2), Rn1(1, 3), tn1(1), Rn1(2, 1), Rn1(2, 2), Rn1(2, 3), tn1(2), Rn1(3, 1), Rn1(3, 2), Rn1(3, 3), tn1(3));
    % fprintf(f, 'P2 = %f %f %f %f %f %f %f %f %f %f %f %f\n', Rn2(1, 1), Rn2(1, 2), Rn2(1, 3), tn2(1), Rn2(2, 1), Rn2(2, 2), Rn2(2, 3), tn2(2), Rn2(3, 1), Rn2(3, 2), Rn2(3, 3), tn2(3));
    % fprintf(f, 'Pn1 = %f %f %f %f %f %f %f %f %f %f %f %f\n', Pn1(1, 1), Pn1(1, 2), Pn1(1, 3), Pn1(1, 4), Pn1(2, 1), Pn1(2, 2), Pn1(2, 3), Pn1(2, 4), Pn1(3, 1), Pn1(3, 2), Pn1(3, 3), Pn1(3, 4));
    % fprintf(f, 'Pn2 = %f %f %f %f %f %f %f %f %f %f %f %f\n', Pn2(1, 1), Pn2(1, 2), Pn2(1, 3), Pn2(1, 4), Pn2(2, 1), Pn2(2, 2), Pn2(2, 3), Pn2(2, 4), Pn2(3, 1), Pn2(3, 2), Pn2(3, 3), Pn2(3, 4));
    % fclose(f);
end

% Uncalibrated rectification. The VLFEAT toolbox is required for SIFT

% [I1r, I2r, bb1, bb2, Pn1, Pn2]  = doRectify('examples/cporta0.png','examples/cporta1.png',false);
% 
% figure;imshow(I1r,[],'InitialMagnification','fit');
% figure;imshow(I2r,[],'InitialMagnification','fit');
% drawnow;
