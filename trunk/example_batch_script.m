function example_batch_script()
%Neuritetracker is software for high throughput detection, tracking, and 
%segmentation of neuroblasts and neurites as they migrate in live cell 
%imaging.
%
%This example script demonstrates how to do batch processing of several
%sequences with neuritetracker. It is currently set to run {example_2, 
%example_3} sequences in the TestData folder. Modify it to your needs.
%
%From the Neuritetracker project. https://github.com/sgbasel/neuritetracker
%Copyright © 2015 Kevin Smith and Fethallah Benmansour. KTH Royal
%Institute of Technology in Stockholm, Sweden and University of Basel, 
%Switzerland. All rights reserved.

%The MIT License (MIT)
%
%Permission is hereby granted, free of charge, to any person obtaining a copy
%of this software and associated documentation files (the "Software"), to deal
%in the Software without restriction, including without limitation the rights
%to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%copies of the Software, and to permit persons to whom the Software is
%furnished to do so, subject to the following conditions:
% 
%The above copyright notice and this permission notice shall be included in all
%copies or substantial portions of the Software.
% 
%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%SOFTWARE.

% get current path, add necessary path(s)
if (~isdeployed)
    filenm = mfilename('fullpath');
    p = fileparts(filenm);
    addpath([p filesep 'IO' filesep]);
end

% read the default parameters & output structs from the configuration file
S = ini2struct('settings.ini');
output = S.output;
parameters = S.defaultparameters; clear S;
output.measurements = regexp(output.measurements, ',', 'split');

% set a destination folder
output.destFolder = [p filesep 'temp' filesep 'results' filesep];

% populate a list of source folders
for i = 1:3
    sourceFolders{i} = sprintf([p filesep 'TestData' filesep 'example_%d'], i); %#ok<AGROW>
end

% loop through the source folders and run neuritetracker for each
for i = 2:numel(sourceFolders)
   
    % set a UniqueID for this experiments
    parameters.UniqueID = sprintf('example%d_%s', i, date);
    
    % set a filter string identifying the nucleus channel
    sourceNuc = sprintf('%s%s*mCH*.tif', sourceFolders{i}, filesep, i);
    
    % set a filter string identifying the cell body channel
    sourceBody = sprintf('%s%s*GFP*.tif', sourceFolders{i}, filesep, i);
    
    % run neuritetracker on the current sequence
    neuritetracker_cmd(sourceNuc, sourceBody, parameters, output);
end




