% read parameters from the configuration file
addpath IO
S = ini2struct('settings.ini');
output = S.output;
parameters = S.defaultparameters; clear S;
output.measurements = regexp(output.measurements, ',', 'split');



output.destFolder = '/home/ksmith/Dropbox/2015-08-17 PC12 selected/results/';


for i = 5
    
    parameters.UniqueID = sprintf('PC12-%02d', i);
    sourceNuc = {sprintf('/home/ksmith/Dropbox/2015-08-17 PC12 selected/mCH_%d.tif', i)};
    sourceBody = {sprintf('/home/ksmith/Dropbox/2015-08-17 PC12 selected/GFP_%d.tif', i)};

    
    
    neuritetracker_cmd(sourceNuc, sourceBody, parameters, output);
    
end