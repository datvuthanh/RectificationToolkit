function I2 = imwarp(I,H,bb)
%IMWARP  Image warp 
% Apply the projective transformation specified by H to the image I 
% The bounding box is specified with [minx; miny; maxx; maxy];

[x,y] = meshgrid(bb(1):bb(3),bb(2):bb(4));
pp = htx(inv(H),[x(:),y(:)]');
xi=reshape(pp(1,:),size(x,1),[]);
yi=reshape(pp(2,:),size(y,1),[]);
I21=interp2(1:size(I,2),1:size(I,1),double(I(:,:,1)),xi,yi,'linear',0);
I22=interp2(1:size(I,2),1:size(I,1),double(I(:,:,2)),xi,yi,'linear',0);
I23=interp2(1:size(I,2),1:size(I,1),double(I(:,:,3)),xi,yi,'linear',0);

I2 = cat(3, I21, I22, I23);

cast(I2,class(I)); % cast I2 to whatever was I

