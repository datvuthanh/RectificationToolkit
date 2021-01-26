function doRectify(img1, img2, calibrated,id)
   %DORECTIFY Epipolar rectification outermost wrapper
   %
   % img1 and img2 are the filenames of the two images to be rectified
   % calibrated is a flag defining wether the rectification should
   % use the camera matrices provided in the same folder 
   % (same name as the images with extension .pm) or the image
   % matches obtained with SIFT (vlfeat toolbox required)
   % Outputs are: the rectified images, the boundinx boxes and the
   % camera matrices
   
   % doRectify first calls either rectifyP or rectifyF according
   % to the case, which returns the homographies to be applied in
   % order to get the images rectified. Then the  imrectify function
   % is called which perforn the image warping and takes care of bounding 
   % boxes and centering. Rectified camera matrices are also returned,
   % Euclidean in the calibrated case and projective in the uncalibrated one. 
   
    I1 = imread(img1); [a1,b1,~] = fileparts(img1);
    I2 = imread(img2); [a2,b2,~] = fileparts(img2);
    
    % if calibrated
    if calibrated && exist([a1,'/',b1,'.pm'],'file') == 2  &&...
            exist([a2,'/',b2,'.pm'],'file') == 2
        disp('Calibrated: loading PPMs')
        
        P1 = load([a1,'/',b1,'.pm']);
        P2 = load([a2,'/',b2,'.pm']);
        
        [H1,H2,Pn1,Pn2] = rectifyP(P1,P2);
        
        % The F matrix induced by Pn1,Pn2 shoud be skew([1 0 0])
        fprintf('Rectification algebraic error:\t\t %0.5g \n',  ...
            norm (abs(fund(Pn1,Pn2)/norm(fund(Pn1,Pn2))) - abs(skew([1 0 0]))));
        
    else % uncalibrated
        
        disp('Uncalibrated: computing F from SIFT matches')
        [ml,mr,~]= sift_match_pair(I1,I2,'F');
        
        % Dat Vu
        firstIter = true;

        for i = 1:size(ml,2)
            %fprintf("DAT VU %d",i)
            p1 = round(ml(:,i));
            p2 = round(mr(:,i));
            
            %fprintf("TOA DO: %d %d \n",p1(1),p1(2));
            % Create patch
            [m,n,d] = size(I1);
            
            patch_size = 9;
            if p1(1) - 4 + patch_size < n && p1(2) + 5 + patch_size < m && p2(1) - 4 + patch_size < n && p2(2) + 5 + patch_size < m
                if p1(1) - 4 > 0 && p1(2) + 5 > 0 && p2(1) - 4  > 0 && p2(2) + 5 > 0
                    l = imcrop(I1,[p1(1)-4,p1(2)+5,patch_size-1,patch_size-1]);
                    r = imcrop(I2,[p2(1)-4,p2(2)+5,patch_size-1,patch_size-1]);

                else
                    l = imcrop(I1,[p1(1),p1(2),patch_size-1,patch_size-1]);
                    r = imcrop(I2,[p2(1),p2(2),patch_size-1,patch_size-1]);                    
                end
                save_path = sprintf('examples/ieu/kitti2015');
                if ~exist(save_path, 'dir')
                    mkdir(save_path);
                end
                test_patch = sprintf('%s/training_%06d_%d.png', save_path,id,i);
                if isequal(size(l),[patch_size,patch_size,3]) && isequal(size(r),[patch_size,patch_size,3])
                    %fprintf("DUNG");

                    %a = [l,r];
                    %a = zeros(1,2,patch_size,patch_size,3);
                    % a(1,1,:,:,:) = l;
                    % a(1,2,:,:,:) = r;
                    % if firstIter == true
                    %     final = a;
                    %     firstIter = false;
                    % else
                    %     final = cat(1,final,a);
                    % test = squeeze(a(1,2,:,:,:));
                    %disp(a);
                    a = [l r];
                    imwrite(mat2gray(a), test_patch);
                    % imwrite(mat2gray(a), img_rec1);
                    % fprintf("A: %d %d %d %d %d",size(test));
                end
            end           
        end
        %fprintf("A: %d %d %d %d %d",size(final));

        %%
        [H1,H2, K] = rectifyF(ml, mr, [size(I1,2),size(I1,1)] );

        % transform left and right points
        mlx = htx(H1,ml); mrx = htx(H2,mr);
        
        % Sampson error wrt to F=skew([1 0 0])
        err = sqrt(sum(F_sampson(skew([1 0 0]),mlx,mrx).^2)/(length(mlx)-1));
        fprintf('Rectification Sampson RMSE: %0.5g pixel \n',err);
         
        % projective MPP (Euclidean only if K is guessed right)
        % Pn1=[K,[0;0;0]]; Pn2=[K,[1;0;0]];
        
    end
    
%    [I1r,I2r, bb1, bb2] = imrectify(I1,I2,H1,H2,'crop');
    % [I1r,I2r, bb1, bb2] = imrectify(I1,I2,H1,H2,'valid');
    
    % % xshift =  bb1(1)  - bb2(1)
    
    % % fix the MPP after centering
    % Pn1 = [1 0 -bb1(1);  0 1 -bb1(2); 0 0 1] *Pn1;
    % Pn2 = [1 0 -bb2(1);  0 1 -bb2(2); 0 0 1] *Pn2;
    
end
