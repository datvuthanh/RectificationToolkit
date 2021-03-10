% Rectification example. The CV Toolkit is required

% Calibrated rectification. 
% Camera matrices are provided in the same folder as the imafes, 
% with the same base name and extension .pm (see exemple)

pkg load image;
warning('off')


% Get a list of all files and folders in this folder.
files = dir('/home/ailab/Desktop/utils/dataset/0302/2011_09_30/');
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
% Print folder names to command window.
for k = 1 : length(subFolders)
  fprintf('Sub folder #%d = %s\n', k, subFolders(k).name);
  url = '/home/ailab/Desktop/utils/dataset/0302/2011_09_30/';

  firstIter = true;
  if subFolders(k).name != '.' || subFolders(k).name != '..'

    filename = strcat(url,subFolders(k).name);
    %fprintf("FILES: %s \n",filename);

    arr = {"/image_02/data/","/image_03/data/"};
    my = {"_image_02_", "_image_03_"};
    %c = cellstr(arr);
    for j = 1 : 2
        lastname = arr{j};
        fname = strcat(filename,lastname);
        sname = strcat(subFolders(k).name,my{j});
        
        Files=dir(fname);
        % Read files
        for i=0:length(Files)-5 # Discard 5 last files
            FileNames=Files(k).name;
            %fprintf("TEST %s\n",Files(k).name);
            image_path0 = sprintf('%s%010d.png',fname,i);
            image_path1 = sprintf('%s%010d.png',fname,i+1);
            matrix = doRectify(image_path0,image_path1,false,i,sname,subFolders(k).name);
            
            if firstIter == true
                f_arr = matrix;
                firstIter = false;
            else
                f_arr = cat(1,f_arr,matrix);
            end
            

        end
    end

    % Save bin
    fprintf("Save .bin files with %d datas \n",size(f_arr,1));
    path_ = sprintf('%s/%s_%s.bin', "bins_patch",subFolders(k).name,mat2str(size(f_arr)));
    fw_id = fopen(path_, 'wb');
    fwrite(fw_id, f_arr, 'float');
    fclose(fw_id);

  end

end
