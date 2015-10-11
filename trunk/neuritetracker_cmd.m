function neuritetracker_cmd(NucChanStr, BodyChanStr, output, parameters) %SeqIndexStr, Sample, magnification)
%Neuritetracker is software for high throughput detection, tracking, and 
%segmentation of neuroblasts and neurites as they migrate in live cell 
%imaging.
%
%USAGE   Sequence =  neuritetracker_cmd(NucChanStr, BodyChanStr, InputFolder, parameters)
%
%
%INPUT   NucChanStr  a path to a folder containing the nucleus-stained 
%                    images or a path with a filter (eg. "/my/images/*RFP*.tif")
%
%        BodyChanStr a path to a folder containing the cell body-stained 
%                    images or a path with a filter (eg. "/my/images/*GFP*.tif")
%
%        DestStr     a path to a folder where corrected images and processed
%                    data will be stored.
%
%        parameters  TODO
%
%
%OUTPUT  Sequence    TODO
%
%
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


% add necessary paths
if (~isdeployed)
    p = mfilename('fullpath');
    p = p(1:end-19);
    addpath([p '/CellsDetection/']);
    addpath([p '/Common/']);
    addpath([p '/FeaturesExtraction/']);
    addpath([p '/frangi_filter_version2a/']);
    addpath([p '/gaimc/']);
    addpath([p '/Geodesics/']);
    addpath([p '/GreedyTracking/']);
    addpath([p '/IO/']);
    addpath([p '/NeuritesDetection/']);
    addpath([p '/NeuritesTracking/']);
    addpath([p '/vlfeat-0.9.18/']);
end


% read parameters from the configuration file
S = ini2struct([p '/settings.ini']);
output = S.output;
parameters = S.defaultparameters; clear S;
output.measurements = regexp(output.measurements, ',', 'split');

% verify that parameters are set to valid values, otherwise set to default
% TODO
parameters.UniqueID                 = 'TestSeq';
parameters.SeqIdxStr                = '001';
% parameters.Magnification
% parameters.BitDepth
% parameters.ExperimentID
% parameters.PlateWellID

output.destFolder                   = '/home/ksmith/temp/neuritetracker5/';
if ~exist(output.destFolder, 'dir'); mkdir(output.destFolder); end;

% run vl_setup to set paths for VLFEAT library
run([p '/vlfeat-0.9.18/toolbox/vl_setup']);


% get a list of image files for the nucleus and cell body channels
parameters.sourceFilesNuc = trkGetFileList(NucChanStr);
parameters.sourceFilesBod = trkGetFileList(BodyChanStr);
if numel(parameters.sourceFilesNuc) ~= numel(parameters.sourceFilesBod); error('NEURITETRACKER:trkGetFileList', 'The number of images is not the same in both channels'); end;



% read each image channel and normalize the images
tic;
fprintf('...loading nucleus image files          '); 
[ImagesNuc, ImagesNuc_original] = trkReadImagesAndNormalize(parameters.sourceFilesNuc, parameters, 'nuc');
fprintf('   (elapsed time %1.2f seconds)\n', toc); tic;
fprintf('...loading cell body image files        ');
[ImagesBody, ImagesBody_original] = trkReadImagesAndNormalize(parameters.sourceFilesBod, parameters, 'body');
fprintf('   (elapsed time %1.2f seconds)\n', toc);
parameters.TMAX = numel(ImagesNuc);

% Detect Nuclei
fprintf('...detecting Nuclei                     '); tic;
Nuclei = trkDetectNuclei(ImagesNuc, parameters);
fprintf('   (elapsed time %1.2f seconds)\n', toc);

% detect the Somata using region growing
fprintf('...detecting somata                     '); tic;
Somata = trkDetectSomataGlobal(Nuclei, ImagesBody, parameters);
fprintf('   (elapsed time %1.2f seconds)\n', toc);

% gather detections into cells
fprintf('...filtering detections & making cells  '); tic;
[Cells, CellsList] = trkGatherNucleiAndSomataDetections(ImagesBody_original, ImagesNuc_original, Nuclei, Somata, parameters); 
fprintf('   (elapsed time %1.2f seconds)\n', toc);

% graph-based tracking
fprintf('...tracking to link cell detections     '); tic;
[Cells, tracks, trkSeq, timeSeq] = trkTrackCellsGreedy(CellsList, Cells, parameters);
fprintf('   (elapsed time %1.2f seconds)\n', toc);

% detect and add neurite-like filaments to cells
fprintf('...detecting neurite-like filaments\n'); tic;
[Cells, P, U, Regions] = trkDetectAndAddFilamentsToCells(ImagesBody, Cells, Somata, parameters); %#ok<NASGU>
fprintf('   (elapsed time %1.2f seconds)\n', toc);

% graph-based tracking
fprintf('...tracking neurite detections          '); tic;
[TrackedNeurites, TrackedNeuritesList, trkNSeq, timeNSeq] = trkTrackNeurites(Cells, CellsList, timeSeq, parameters); %#ok<NASGU,ASGLU>
fprintf('   (elapsed time %1.2f seconds)\n', toc);

% reorganize data
fprintf('...organizing sequence data structure   '); tic;
Sequence = trkReorganizeDataStructure(parameters, ImagesBody_original, ImagesNuc_original, Cells, trkSeq, TrackedNeurites, trkNSeq);
Sequence.NeuriteProbability = P;
Sequence.NeuronBodies = U;
fprintf('   (elapsed time %1.2f seconds)\n', toc);


% load colors for rendering
load cols3.mat;

% save the data files containing all Sequence info if requested (might be large)
if output.saveMat
    filename = fullfile(output.destFolder, sprintf('%s.mat', parameters.UniqueID));
    fprintf('...saving %s\n', filename);
    save(filename, '-v7.3', 'Sequence', 'Cells', 'cols3');
end

% save output to CSV files if requested
if output.saveCSVmeasurements
    fprintf('...writing CSV measurement files        '); tic;
    FolderCSV = sprintf('%s/csv/%s/', output.destFolder, parameters.UniqueID);
    make_csv(1:Sequence.numberOfTracks, output.measurements, Sequence, FolderCSV);
    fprintf('   (elapsed time %1.2f seconds)\n', toc);
end

% write requested movies to file
trkMakeMovies(ImagesNuc, ImagesBody, Cells, CellsList, tracks, Sequence, output, parameters, cols3);








keyboard;





