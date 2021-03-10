function final= doRectify(img1, img2, calibrated,id,name,pname)
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

    % Grayscale
    % I3 = double(imread(img1));
    % I4 = double(imread(img2));

    % I3 = rgb2gray(I3);
    % I4 = rgb2gray(I4);

    % %imshow(I3);

    % I3 = (I3 - mean2(I3))/ (std2(I3));
    % I4 = (I4 - mean2(I4))/ (std2(I4));

    %disp(I3);
    %fprintf("I3 : %f \n",I3(1:2));
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
        patch_size = 9;
  
        % Create matrix here
        a = zeros(size(ml,2),2,patch_size,patch_size);

        for i = 1:size(ml,2)
            %fprintf("DAT VU %d",i)
            p1 = round(ml(:,i));
            p2 = round(mr(:,i));
            
            %fprintf("TOA DO: %d %d \n",p1(1),p1(2));
            % Create patch
            [m,n,d] = size(I1);
            
            if p1(1) - 4 + patch_size < n && p1(2) + 5 + patch_size < m && p2(1) - 4 + patch_size < n && p2(2) + 5 + patch_size < m
                if p1(1) - 4 > 0 && p1(2) + 5 > 0 && p2(1) - 4  > 0 && p2(2) + 5 > 0
                    l = imcrop(I1,[p1(1)-4,p1(2)+5,patch_size-1,patch_size-1]);
                    r = imcrop(I2,[p2(1)-4,p2(2)+5,patch_size-1,patch_size-1]);
                else
                    l = imcrop(I1,[p1(1),p1(2),patch_size-1,patch_size-1]);
                    r = imcrop(I2,[p2(1),p2(2),patch_size-1,patch_size-1]);                    
                end
                
                # Convert to grayscale
                l = double(rgb2gray(l));
                r = double(rgb2gray(r));
                
                # Normalize data to zero mean
                l = (l - mean2(l))/ (std2(l) + 1e-10);
                r = (r - mean2(r))/ (std2(r) + 1e-10);
                % disp(l);

                save_path = sprintf('examples/0103/%s',pname);
                if ~exist(save_path, 'dir')
                    mkdir(save_path);
                end
                %name = 'TrainSeq03';
                % disp(l);
                test_patch = sprintf('%s/%s_%010d_%d.png', save_path,name,id,i);
                if isequal(size(l),[patch_size,patch_size,3]) && isequal(size(r),[patch_size,patch_size,3])
                    % If we want to save images to folder
%                     a = [l r];
%                     imwrite(a,test_patch);
                    
                        c = zeros(1,2,patch_size,patch_size);
                        c(1,1,:,:) = l;
                        c(1,2,:,:) = r;
    
                        if firstIter == true
                            final = c;
                            firstIter = false;
                        else
                            final = cat(1,final,c);
                        end
                    end

                end
            end           
        end
        
    end
    
end
