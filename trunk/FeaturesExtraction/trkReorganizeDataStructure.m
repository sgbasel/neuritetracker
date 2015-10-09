function Sequence = trkReorganizeDataStructure(parameters, ImagesBody_original, ImagesNuc_original, Cells, trkSeq, ...
                                               TrackedNeurites, trkNSeq)


numberOfTracks = 0;
for i =1:length(trkSeq)
    if ~isempty(trkSeq{i})
        numberOfTracks = numberOfTracks + 1;
    end
end

% start with global informations
Sequence = [];
Sequence.numberOfTracks       = numberOfTracks;
Sequence.NucleusImageFiless   = parameters.sourceFilesNuc;
Sequence.BodyImageFilees      = parameters.sourceFilesBod;
Sequence.NumberOfFrames       = parameters.TMAX;
Sequence.UniqueID             = parameters.UniqueID;
Sequence.DateProcessed        = date;
% Sequence.Entropy              = zeros(1, length(ImagesBody_original));
% Sequence.ImgDiffRed           = zeros(1, length(ImagesBody_original));
% Sequence.ImgDiffGreen         = zeros(1, length(ImagesBody_original));

% Entr        = zeros(1, length(ImagesBody_original));
% ImDiffRed   = zeros(1, length(ImagesBody_original));
% ImDiffGreen = zeros(1, length(ImagesBody_original));
% for k = 1:length(ImagesBody_original)
%     Entr(k)= entropy(ImagesBody_original{k});
%     if k == 1
%         ImDiffRed(k)   = 0;
%         ImDiffGreen(k) = 0;
%     else
%         ImDiffRed(k)   = sum(sum(imabsdiff(ImagesNuc_original{k}, ImagesNuc_original{k-1}))) / numel(ImagesNuc_original{k});
%         ImDiffGreen(k) = sum(sum(imabsdiff(ImagesBody_original{k}, ImagesBody_original{k-1}))) / numel(ImagesBody_original{k});
%     end
% end
% 
% Sequence.Entropy              = Entr;
% Sequence.ImgDiffRed           = ImDiffRed;
% Sequence.ImgDiffGreen         = ImDiffGreen;

% now the tracks
Sequence.TrackedCells = [];

%% tracked neurites
NeuriteTrackId = 1;
NbTrackedNeurites = 0;
for i = 1:length(trkNSeq)
    if ~isempty(trkNSeq{i})
        NbTrackedNeurites = NbTrackedNeurites + 1;
    end
end
listOfNeuriteTracks = cell(NbTrackedNeurites, 1);
for i = 1:length(trkNSeq)
    if ~isempty(trkNSeq{i})
        ListOfNeuritesInTrack = [];
        for j = 1:length(trkNSeq{i})
            currentNeurite                                  = TrackedNeurites(trkNSeq{i}(j));
            currentNeurite.isTracked                        = true;
            currentNeurite.NeuriteTrackId                   = NeuriteTrackId;
            % update at the cell level
            CellIdx                                         = currentNeurite.CellIdx;
            NeuriteIdx                                      = currentNeurite.NeuriteIdx;
            Cells(CellIdx).NeuritesList(NeuriteIdx)         = currentNeurite;
            % done
            ListOfNeuritesInTrack = [ListOfNeuritesInTrack, currentNeurite];%#ok
            if j ==1
                CellTrackIdx                                             = currentNeurite.CellTrackId;
            elseif j > 1 && CellTrackIdx ~= currentNeurite.CellTrackId
                keyboard;
                error('cell trk id problem in neurites track');
            end
        end
        
        NeuritesTrack.Neurites     = ListOfNeuritesInTrack;
        NeuritesTrack.CellTrackIdx = CellTrackIdx;
        listOfNeuriteTracks{NeuriteTrackId} = NeuritesTrack;
        NeuriteTrackId = NeuriteTrackId + 1;
    end
end

%% Tracked cell bodies
for i = 1:length(trkSeq)
    fprintf('|');
    if ~isempty(trkSeq{i})
        currentTrack = [];
        % add some statistics
        currentTrack.LifeTime = length(trkSeq{i});
        
        currentTrack.TimeStep = [];
        
        %% time step level
        for j = 1:length(trkSeq{i})
            currentTrackedCellTimeStep = Cells(trkSeq{i}(j));
            
            % gather the neurites-based mesurments
            LengthBranches               = [];
            LeafLengthBranches           = [];
            ExtremeLength                = [];
            TotalCableLengthPerNeurite   = [];
            ComplexityPerNeurite         = [];
            NbBranchesPerNeurite         = [];
            MaxExtremeLengthPerNeurite   = [];
            for k = 1:length(currentTrackedCellTimeStep.NeuritesList)
                LengthBranches               = [LengthBranches             currentTrackedCellTimeStep.NeuritesList(k).LengthBranches];%#ok
                LeafLengthBranches           = [LeafLengthBranches         currentTrackedCellTimeStep.NeuritesList(k).LeafLengthBranches];%#ok
                ExtremeLength                = [ExtremeLength              currentTrackedCellTimeStep.NeuritesList(k).ExtremeLength];%#ok
                TotalCableLengthPerNeurite   = [TotalCableLengthPerNeurite currentTrackedCellTimeStep.NeuritesList(k).TotalCableLength];%#ok
                ComplexityPerNeurite         = [ComplexityPerNeurite       currentTrackedCellTimeStep.NeuritesList(k).Complexity];%#ok
                NbBranchesPerNeurite         = [NbBranchesPerNeurite       length(currentTrackedCellTimeStep.NeuritesList(k).LengthBranches)];%#ok
                MaxExtremeLengthPerNeurite   = [MaxExtremeLengthPerNeurite max(currentTrackedCellTimeStep.NeuritesList(k).ExtremeLength)];%#ok
            end
            
            currentTrackedCellTimeStep.AllNeurites_LengthBranches          = LengthBranches;
            currentTrackedCellTimeStep.AllNeurites_LeafLengthBranches      = LeafLengthBranches;
            currentTrackedCellTimeStep.AllNeurites_ExtremeLength           = ExtremeLength;
            currentTrackedCellTimeStep.TotalCableLengthsPerNeurite         = TotalCableLengthPerNeurite;
            currentTrackedCellTimeStep.ComplexityPerNeurite                = ComplexityPerNeurite;
            currentTrackedCellTimeStep.NbBranchesPerNeurite                = NbBranchesPerNeurite;
            currentTrackedCellTimeStep.MaxExtremeLengthPerNeurite          = MaxExtremeLengthPerNeurite;
            fieldsToQuantile = {'AllNeurites_LengthBranches', 'AllNeurites_LeafLengthBranches', 'AllNeurites_ExtremeLength', ...
                                'TotalCableLengthsPerNeurite', 'ComplexityPerNeurite', ...
                                'NbBranchesPerNeurite', 'MaxExtremeLengthPerNeurite'};
            quantilesList    = [0 0.25, 0.5, 0.75 1];
            
            currentTrackedCellTimeStep = trkComputeQuantilesAndMean(currentTrackedCellTimeStep, fieldsToQuantile, quantilesList);
            
            currentTrackedCellTimeStep.TotalNeuritesLength   = sum(currentTrackedCellTimeStep.TotalCableLengthsPerNeurite);
            currentTrackedCellTimeStep.TotalNeuritesBranches = sum(currentTrackedCellTimeStep.NbBranchesPerNeurite);
            currentTrackedCellTimeStep.TotalComplexity       = currentTrackedCellTimeStep.TotalNeuritesBranches / ...
                                                               currentTrackedCellTimeStep.TotalNeuritesLength;
            
            currentTrack.TimeStep    = [currentTrack.TimeStep        currentTrackedCellTimeStep];
        end
        
        %% speed, displacement and acceleration
        
        currentTrack = trkSpatioTemporalAnalysis(currentTrack);
        %% temporal analysis for other features (not considering tracked neurites)
        fieldsToAnalyse = { 'NucleusArea',...
                            'NucleusEccentricity', ...
                            'NucleusMajorAxisLength', ...
                            'NucleusMinorAxisLength', ...
                            'NucleusOrientation', ...
                            'NucleusPerimeter', ...
                            'NucleusCircularity', ...
                            'NucleusMeanRedIntensity', ...
                            'NucleusMeanGreenIntensity', ...
                            'SomaArea', ...
                            'SomaEccentricity', ...
                            'SomaMajorAxisLength', ...
                            'SomaMinorAxisLength', ...
                            'SomaOrientation', ...
                            'SomaPerimeter', ...
                            'SomaCircularity', ...
                            'SomaMeanGreenIntensity',...
                            'NumberOfNeurites', ...
                            'TotalNeuritesLength', ...
                            'TotalNeuritesBranches', ...
                            'TotalComplexity', ...
                            'AllNeurites_ExtremeLength_q_0', ...
                            'AllNeurites_ExtremeLength_q_25', ...
                            'AllNeurites_ExtremeLength_q_50', ...
                            'AllNeurites_ExtremeLength_q_75', ...
                            'AllNeurites_ExtremeLength_q_100'};
        currentTrack = trkTemporalAnalysis(currentTrack, fieldsToAnalyse);
        
        
        ListOfNeuriteTracksAssociatedToCellTrack = [];
        for k = 1:NbTrackedNeurites
            if currentTrack.TimeStep(1).ID == listOfNeuriteTracks{k}.CellTrackIdx
                ListOfNeuriteTracksAssociatedToCellTrack = [ListOfNeuriteTracksAssociatedToCellTrack  listOfNeuriteTracks{k}];%#ok
            end
        end
        
        neuriteFieldsToAnalyse = {  'MaxExtremeLength',...
                                    'MeanBranchLength', ...
                                    'MeanLeafLength', ...
                                    'TotalCableLength', ...
                                    'LengthBranches_q_0', ...
                                    'LengthBranches_q_25', ...
                                    'LengthBranches_q_50', ...
                                    'LengthBranches_q_75', ...
                                    'LengthBranches_q_100', ...
                                    'LengthBranchesMean', ...
                                    'ExtremeLength_q_0', ...
                                    'ExtremeLength_q_25', ...
                                    'ExtremeLength_q_50', ...
                                    'ExtremeLength_q_75', ...
                                    'ExtremeLength_q_100', ...
                                    'ExtremeLengthMean', ...
                                    'LeafLengthBranches_q_0',...
                                    'LeafLengthBranches_q_25', ...
                                    'LeafLengthBranches_q_50', ...
                                    'LeafLengthBranches_q_75', ...
                                    'LeafLengthBranches_q_100', ...
                                    'LeafLengthBranchesMean', ...
                                    'MeanGreenIntensities'};
                                
        ListOfNeuriteTracksAssociatedToCellTrack = trkTemporalAnalysisNeurites(ListOfNeuriteTracksAssociatedToCellTrack,...
                                                                               neuriteFieldsToAnalyse);
        
        currentTrack.ListOfNeuriteTracks        = ListOfNeuriteTracksAssociatedToCellTrack;
        currentTrack.NumberOfTrackedNeurites    = length(ListOfNeuriteTracksAssociatedToCellTrack);
        
        Sequence.TrackedCells = [Sequence.TrackedCells currentTrack];
    end
end
