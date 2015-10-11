function fileList = trkGetFileList(fileVar)


switch class(fileVar)
    
    % if we are given string (directory + filter), look in the directory for image files
    case 'char'
        % break source into a path, filter, and extension
        [pth, filter, ext] = fileparts(fileVar);
        pth = [pth '/'];
        source_folder = pth;
        
        % list of filetypes imread can open
        valid_filetypes = {'.bmp', '.gif', '.jpg', '.jpeg', '.tif', '.tiff', '.png',...
            '.BMP', '.GIF', '.JPG', '.JPEG', '.TIF', '.TIFF', '.PNG'};
        
        % check if a file filter is provided, if so use it to generate a list
        % of source filenames
        if ~isempty(filter)
            d = dir([source_folder filter ext]);
            fileList = cell(numel(d),1);
            for i = 1:numel(d)
                fileList{i} = [source_folder d(i).name];
            end
            
            
            % if a file filter is not provided, generate a list of source filanames
            % searching for all valid filetypes
        else
            fileList = {};
            for k = 1:numel(valid_filetypes)
                d = dir([source_folder '*' valid_filetypes{k}]);
                for i = 1:numel(d)
                    fileList{end+1} = [source_folder d(i).name]; %#ok<AGROW>
                end
            end
            fileList = fileList';
            
        end
        
    case 'cell'
        % in the case we are given a cell list of file names
        fileList = {};
        for i = 1:numel(fileVar)
            if strcmpi(finfo(fileVar{i}), 'im')
                fileList{i} = fileVar{i}; %#ok<AGROW>
            else
                error('Neuritetracker: invalid file provided %s', fileVar{i});
            end
        end
end


% check if we have found any valid files in the folder
if numel(fileList) == 0
    error('NEURITETRACKER:trkGetFileList', 'No files found for string: %s', fileVar);
end


% read the first provided image, check that it is monochromatic, store
% its size in the options structure, and determine the working image
% size we will use
I = imread(fileList{1});
if numel(size(I)) == 3
    error('NEURITETRACKER:trkGetFileList', 'Non-monochromatic image provided. Monochromatic images expected. Store each channel as a separate image and try again.');
end


% sort the filenames intelligently in case they do not have leading zeros
fileList = sort_nat(fileList);


