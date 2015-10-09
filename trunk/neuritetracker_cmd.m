function neuritetracker_cmd(NucChanStr, BodyChanStr, DestStr, parameters) %SeqIndexStr, Sample, magnification)
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



% paramaters
parameters.bodySTD                  = 28.9134; % normalization (TODO: remove this)
parameters.bodyMAX                  = 11234;   % neurite detection
parameters.nucSTD                   = 3.0508;  % normalization (TODO: remove this)
parameters.MaxNucleusArea           = 170;  % nucleus detection
parameters.MinNucleusArea           = 70;   % nucleus detection
parameters.SmoothingNuc             = 2.0;  % nucleus detection
parameters.MSER_MaxVariation        = 0.2;  % nucleus detection
parameters.MSER_Delta               = 2;    % nucleus detection
parameters.GeodesicDistanceThresh   = 2e-6; % somata detection
parameters.LengthThresh             = 7;    % somata detection
parameters.StdMultFactor            = 1.5;  % somata detection
parameters.MinDistanceToBoundary    = 10;   % cell detection filtering
parameters.MaxEccentricity          = 0.85; % cell detection filtering
parameters.MinCircularity           = 0.2;  % cell detection filtering
parameters.TemporalWindowSize       = 4; 	% graph tracking
parameters.SpatialWindowSize        = 50; 	% graph tracking
parameters.MinTrackLength           = 20;	% graph tracking
parameters.NumberBestTracks         = 40; 	% graph tracking
parameters.WeightTime               = 50; 	% graph tracking
parameters.WeightShape              = 40; 	% graph tracking
parameters.WeightThreshold          = 200; 	% graph tracking
parameters.Fopt.FrangiScaleRange  	= [1 2];% neurite detection
parameters.Fopt.FrangiScaleRatio 	= 1; 	% neurite detection
parameters.Fopt.FrangiBetaOne   	= .5;	% neurite detection
parameters.Fopt.FrangiBetaTwo     	= 15;	% neurite detection
parameters.Fopt.BlackWhite        	= false;% neurite detection
parameters.Fopt.verbose           	= false;% neurite detection
parameters.minimalSizeOfNeurite     = 10;   % neurite detection
parameters.GeoDistNeuriteThresh     = 0.0001; % neurite detection
parameters.KeyPointDetectionParam   = 5;    % neurite detection
parameters.NeuriteProbabilityThresh = 0.2;  % neurite detection
parameters.NeuritePruningLengthThsh = 10;   % neurite detection
parameters.NeuriteStabLenghtThresh  = 30;   % neurite tracking
parameters.NeuriteWeightThresh      = 800;  % neurite tracking
parameters.NeuriteMinTrackLength    = 10;   % neutite tracking
% parameters.Magnification
% parameters.BitDepth
% parameters.ExperimentID
% parameters.PlateWellID
parameters.UniqueID                 = 'TestSeq';
parameters.SeqIdxStr                = '001';


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

% run vl_setup to set paths for VLFEAT library
run([p '/vlfeat-0.9.18/toolbox/vl_setup']);

% verify that parameters are set to valid values, otherwise set to default
% TODO

% get a list of image files for the nucleus and cell body channels
parameters.sourceFilesNuc = trkGetFileList(NucChanStr);
parameters.sourceFilesBod = trkGetFileList(BodyChanStr);
if numel(parameters.sourceFilesNuc) ~= numel(parameters.sourceFilesBod); error('NEURITETRACKER:trkGetFileList', 'The number of images is not the same in both channels'); end;
parameters.TMAX = numel(parameters.sourceFilesNuc);


% read each image channel and normalize the images
tic;
fprintf('...loading nucleus image files          '); 
[ImagesNuc, ImagesNuc_original] = trkReadImagesAndNormalize(parameters.sourceFilesNuc, parameters, 'nuc');
fprintf('   (elapsed time %1.2f seconds)\n', toc); tic;
fprintf('...loading cell body image files        ');
[ImagesBody, ImagesBody_original] = trkReadImagesAndNormalize(parameters.sourceFilesBod, parameters, 'body');
fprintf('   (elapsed time %1.2f seconds)\n', toc);

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
[Cells CellsList] = trkGatherNucleiAndSomataDetections(ImagesBody_original, ImagesNuc_original, Nuclei, Somata, parameters); 
fprintf('   (elapsed time %1.2f seconds)\n', toc);

% graph-based tracking
fprintf('...tracking to link cell detections     '); tic;
[Cells, tracks, trkSeq, timeSeq] = trkTrackCellsGreedy(CellsList, Cells, parameters);%#ok
fprintf('   (elapsed time %1.2f seconds)\n', toc);

% detect and add neurite-like filaments to cells
fprintf('...detecting neurite-like filaments\n'); tic;
[Cells, P, U, Regions] = trkDetectAndAddFilamentsToCells(ImagesBody, Cells, Somata, parameters);
fprintf('    (elapsed time %1.2f seconds)\n', toc);

% graph-based tracking
fprintf('...tracking neurite detections         '); tic;
[TrackedNeurites, TrackedNeuritesList, trkNSeq, timeNSeq] = trkTrackNeurites(Cells, CellsList, timeSeq, parameters);
fprintf('   (elapsed time %1.2f seconds)\n', toc);

% reorganize data
fprintf('...organizing sequence data structure  '); tic;
Sequence = trkReorganizeDataStructure(parameters, ImagesBody_original, ImagesNuc_original, Cells, trkSeq, TrackedNeurites, trkNSeq);
fprintf('   (elapsed time %1.2f seconds)\n', toc);


keyboard;

filename = [folder SeqIndexStr '.mat'];
fprintf('saving %s...', filename);
save(filename,  '-v7.3', 'Sequence', 'Cells', 'cols3');
fprintf('\n');


resultsFolder = [folder 'csv/'];
measurements = {'DistanceTraveled','Speed','NbBranchesPerNeuriteMean','ComplexityPerNeuriteMean','NumberOfNeurites','TotalNeuritesBranches','SomaMajorAxisLength','TotalNeuritesLength'};
make_csv([cellIDs], measurements, Sequence, resultsFolder,0);

for t = 1:numel(ImagesBody)
   figure(1);
   imagesc(Somata{t}); colormap gray;
end

% for t = 1:numel(ImagesBody)
%    figure(1);
%    imagesc(Nuclei{t}); colormap gray;
% end



% for t = 1:numel(ImagesBody)
%    figure(1);
%    imagesc(ImagesBody{t}); colormap gray;
% end

% 
% for t = 1:numel(ImagesBody)
%    figure(1);
%    imshow(2^16 - uint16(round(ImagesBody{t})));
% %    imagesc(ImagesBody{t});
% end
% 
% for t = 1:numel(ImagesBody)
%    figure(1);
%    imshow(2^16 - uint16(ImagesBody_original{t}));
% %    imagesc(ImagesBody{t});
% end

% % TODO: get rid of these default settings!
% parameters.quantileNucLow  = .02;
% parameters.quantileNucHigh = .85;
% parameters.quantileBodLow  = .02;
% parameters.quantileBodHigh = .85;
% IntensityAjustmentGreen.MED = 2537;
% IntensityAjustmentGreen.STD = 28.9134;
% IntensityAjustmentGreen.MAX = 11234;
% IntensityAjustmentRed.MED = 205;
% IntensityAjustmentRed.STD = 3.0508;
% IntensityAjustmentRed.MAX = 327;
% 
% [Red  , Red_Original]   = trkReadImagesAndNormalize(TMAX, Rfolder, IntensityAjustmentRed);
% [Green, Green_Original] = trkReadImagesAndNormalize(TMAX, Gfolder, IntensityAjustmentGreen);


keyboard;





