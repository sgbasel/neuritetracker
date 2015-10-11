function [parameters, output] = trkValidateInput(p, parameters, output)

% read parameters from the configuration file if they are not provided
if isempty(parameters)    
    S = ini2struct([p '/settings.ini']);
    parameters = S.defaultparameters;
end

% read output from the configuration file if they are not provided
if isempty(output)
    S = ini2struct([p '/settings.ini']);
    output = S.output;
    output.measurements = regexp(output.measurements, ',', 'split');
end


% sort the fields
parameters = orderfields(parameters);
output = orderfields(output);


paramFieldList = {'BitDepth','BlackWhite','FrangiBetaOne', 'FrangiBetaTwo', 'FrangiScaleRange',...
    'FrangiScaleRatio','GeoDistNeuriteThresh','GeodesicDistanceThresh','KeyPointDetectionParam',...
    'LengthThresh','MSER_Delta','MSER_MaxVariation',...
    'Magnification','MaxEccentricity','MaxNucleusArea','MetaData','MicronsPerPixel','MinCircularity',...
    'MinDistanceToBoundary','MinNucleusArea','MinTrackLength','NeuriteMinTrackLength','NeuriteProbabilityThresh',...
    'NeuritePruningLengthThsh','NeuriteStabLenghtThresh','NeuriteWeightThresh','NumberBestTracks',...
    'SmoothingNuc','SpatialWindowSize','StdMultFactor','TemporalWindowSize','UniqueID','WeightShape',...
    'WeightThreshold','WeightTime','bodyMAX','bodySTD','minimalSizeOfNeurite','nucSTD','verbose'};


% check that the correct fields exist in parameters
fieldDifferences = setxor(fieldnames(parameters), paramFieldList);
if ~isempty(fieldDifferences)
    error('Neuritetracker: invalid parameter structure');
end


outputFieldList = {'saveMat','writeFramesToFile','movieNeuronChannel','movieNucleusChannel',...
    'movieNucleusDetection','movieTubularity','movieNeuriteProbability','movieCellSegmentation',...
    'movieBacktracing','movieFinal','movieFinalNumbered','movieExtractedModel','saveCSVmeasurements',...
    'measurements','destFolder'};

% check that the correct fields exist in output
fieldDifferences = setxor(fieldnames(output), outputFieldList);
if ~isempty(fieldDifferences)
    error('Neuritetracker: invalid output structure');
end


if isempty(parameters.UniqueID)
    % generate a unique string
    symbols = ['a':'z' 'A':'Z' '0':'9'];
    MAX_ST_LENGTH = 15;
    stLength = randi(MAX_ST_LENGTH);
    nums = randi(numel(symbols),[1 stLength]);
    st = symbols (nums);
    unique_string = [date '_' st];
    parameters.UniqueID = unique_string;
end

% create the output folder if it doesn't exsit
if isempty(output.destFolder)
    output.destFolder = ['/tmp/neuritetracker/' parameters.UniqueID];
elseif ~exist(output.destFolder, 'dir')
    mkdir(output.destFolder); 
end;
    


% % read parameters from the configuration file
% S = ini2struct([p '/settings.ini']);
% output = S.output;
% parameters = S.defaultparameters; clear S;
% output.measurements = regexp(output.measurements, ',', 'split');




% saveMat
% writeFramesToFile
% movieNeuronChannel
% movieNucleusChannel
% movieNucleusDetection
% movieTubularity
% movieNeuriteProbability
% movieCellSegmentation
% movieBacktracing
% movieFinal
% movieFinalNumbered
% movieExtractedModel
% saveCSVmeasurements
% measurements
% destFolder
%                  
% BitDepth
% BlackWhite
% FrangiBetaOne 
% FrangiBetaTwo
% FrangiScaleRange
% FrangiScaleRatio
% GeoDistNeuriteThresh
% GeodesicDistanceThresh
% KeyPointDetectionParam
% LengthThresh
% MSER_Delta
% MSER_MaxVariation
% Magnification
% MaxEccentricity
% MaxNucleusArea
% MetaData
% MicronsPerPixel
% MinCircularity
% MinDistanceToBoundary
% MinNucleusArea
% MinTrackLength
% NeuriteMinTrackLength
% NeuriteProbabilityThresh
% NeuritePruningLengthThsh
% NeuriteStabLenghtThresh
% NeuriteWeightThresh
% NumberBestTracks
% SmoothingNuc
% SpatialWindowSize
% StdMultFactor
% TemporalWindowSize
% UniqueID
% WeightShape
% WeightThreshold
% WeightTime
% bodyMAX
% bodySTD
% minimalSizeOfNeurite
% nucSTD
% verbose