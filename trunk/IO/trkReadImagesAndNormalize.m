function [I_normalized, I_original] = trkReadImagesAndNormalize(fileList, parameters, channel)



I_normalized = cell(1,parameters.TMAX);
I_original   = cell(1,parameters.TMAX);

switch channel
    case 'body'
        STD = parameters.bodySTD;
    case 'nuc'
        STD = parameters.nucSTD;
end

% read the original images into memory
% fprintf('...loading files ');
for t = 1:numel(fileList)
    if mod(t,10) == 0
        fprintf('|');
    end
    I_original{t} = double(imread(fileList{t}));
end

for t = 1:numel(I_original)
    Ilist = I_original{t}(:);
    Ilist = Ilist(Ilist ~= 0);
    
    % center the image background on zero
    originalMedian = median(Ilist);
    originalStd = std(Ilist);
    
    % correct the image
    I_normalized{t} = I_original{t} - originalMedian;
    I_normalized{t} = I_original{t} * (STD / originalStd);
end
% fprintf('\n');

% disp(['   loaded (' num2str(t) '/' num2str(TMAX) ') images from:  ' folder]);
% disp('');



% switch normalizeFlag
%     case 'normalize'
% 
% 
%         % fit an intensity model to the data
%         Ilist = cell2mat(I_original);
%         Ilist = Ilist(:);
%         [h,x] = hist(Ilist,1000);
% 
%         % get the quantiles to set the contrast by
%         switch channel
%             case 'body'
%                 quantileList = [parameters.quantileNucLow parameters.quantileNucHigh];        
%             case 'nuc'
%                 quantileList = [parameters.quantileNucLow parameters.quantileNucHigh];        
%         end
% 
% 
%     otherwise
%         I_normalized = I_original;
% end
%         
%         
% for t = 1:numel(I_original)
%    figure(1);
%    imshow(uint16(2^16 - I_original{t}));
%    pause(0.1);
%     
% end
% 
% 
% keyboard;
% 
% STD = IntensityAjustment.STD;
% 
% fprintf('\n');


% for t = 1:parameters.TMAX
%     if mod(t,10) == 0
%         fprintf('|');
%     end
%     filename = fileList{t};
%     I_original{t}   = double( imread( filename ) );
%     
%     Ilist = double(I_original{t}(:));
%     
%     % normalize according to the background;
%     [h,x] = hist(Ilist,1000);
%     hmax = max(h);
%     h( h < .10 * hmax) = 0;
%     minind = find(h > 0,1, 'first');
%     maxind = find(h > 0,1, 'last');
%     xmin = x(minind);
%     xmax = x(maxind);
%     Ilist(Ilist < xmin) = [];
%     Ilist(Ilist > xmax) = [];
%    
%     % center the image background on zero
%    	originalMedian = median(Ilist);
%     originalStd = std(Ilist);
%     
%     % correct the image
%     I_normalized{t} = I_original{t} - originalMedian;    
%     I_normalized{t} = I_original{t} * (STD / originalStd);
% 
% end
% 
% fprintf('\n');
% disp(['   loaded (' num2str(t) '/' num2str(TMAX) ') images from:  ' folder]);
% disp('');








% 
% 
% function [I_normalized, I_original] = trkReadImagesAndNormalize(TMAX, folder, IntensityAjustment)
% 
% I_normalized = cell(1,TMAX);
% I_original   = cell(1,TMAX);
% 
% STD = IntensityAjustment.STD;
% 
% disp('');
% 
% list = dir(fullfile(folder, '*.TIF'));
% names = {list.name};
% sorted_filenames = sort_nat(names);
% 
% for t = 1:TMAX
%     if mod(t,10) == 0
%         fprintf('|');
%     end
%     filename = [folder sorted_filenames{t}];
%     I_original{t}   = double( imread( filename ) );
%     
%     Ilist = double(I_original{t}(:));
%     
%     % normalize according to the background;
%     [h,x] = hist(Ilist,1000);
%     hmax = max(h);
%     h( h < .10 * hmax) = 0;
%     minind = find(h > 0,1, 'first');
%     maxind = find(h > 0,1, 'last');
%     xmin = x(minind);
%     xmax = x(maxind);
%     Ilist(Ilist < xmin) = [];
%     Ilist(Ilist > xmax) = [];
%    
%     % center the image background on zero
%    	originalMedian = median(Ilist);
%     originalStd = std(Ilist);
%     
%     % correct the image
%     I_normalized{t} = I_original{t} - originalMedian;    
%     I_normalized{t} = I_original{t} * (STD / originalStd);
% 
% end
% 
% fprintf('\n');
% disp(['   loaded (' num2str(t) '/' num2str(TMAX) ') images from:  ' folder]);
% disp('');