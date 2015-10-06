clear all;

addpath('/home/ksmith/code/neurons/matlab/baselFinal2013/Common/');
addpath('/home/ksmith/code/neurons/matlab/baselFinal2013/CellsDetection/');
addpath('/home/ksmith/code/neurons/matlab/baselFinal2013/Geodesics/');
addpath('/home/ksmith/code/neurons/matlab/baselFinal2013/IO/');

R = 520;
C = 696;

% folders
folderRootGT        = '/home/ksmith/Dropbox/Sinergia_LOCAL/EvaluationOfNucleiAndSomata/GT10x/Dynamic/';
ConvertedGTRootDir  = '/home/ksmith/Dropbox/Sinergia_LOCAL/EvaluationOfNucleiAndSomata/GT10x/Dynamic_matlab/';
outputRootFolder        = '/home/ksmith/Dropbox/Sinergia_LOCAL/EvalResultsNucleiSomata/';


d = dir(folderRootGT);
d = d(3:end-1);

Results = [];
Idx_Results = 1;

for i = 1:numel(d)
    

    
    folderGT = [folderRootGT d(i).name '/'];
    
    filenameGFP = fullfile(folderGT, 'green.tif');
    infoGFP = imfinfo(filenameGFP);

    filenameRFP = fullfile(folderGT, 'red.tif');
    infoRFP = imfinfo(filenameRFP);

    maxGFP = 0;
    maxRFP = 0;
    
    % make green and red image folders
    folderGreen = [folderRootGT d(i).name '/green/'];
    if ~exist(folderGreen, 'dir')
        mkdir(folderGreen);
    end
    folderRed = [folderRootGT d(i).name '/red/'];
    if ~exist(folderRed, 'dir')
        mkdir(folderRed);
    end
    
    % read the entire movie
    for t = 1:97        
        I_rawGFP{t} = double(imread(filenameGFP, t, 'Info', infoGFP));        
        maxGFP = max([maxGFP, max(I_rawGFP{t}(:)) ]);
        filename = fullfile(folderGreen,  sprintf('%03d.TIF', t));
        imwrite(uint16(I_rawGFP{t}),filename);
        I_rawRFP{t} = double(imread(filenameRFP, t, 'Info', infoRFP));        
        maxRFP = max([maxRFP, max(I_rawRFP{t}(:)) ]);
        filename = fullfile(folderRed,  sprintf('%03d.TIF',t));
        imwrite(uint16(I_rawRFP{t}),filename);
    end
    
    % convert to 8-bit images
    for t = 1:97
        I_GFP{t} = uint8(I_rawGFP{t} * (2^8)/maxGFP);
        I_RFP{t} = uint8(I_rawRFP{t} * (2^8)/maxRFP);
        Nuclei_GT{t} = zeros(R,C);
        Somata_GT{t} = zeros(R,C);
    end
    
    % detect the Nuclei and Somata for this sequence
    [Nuclei, Somata, Cells, CellsList] = trkDetectNucleiSomataForEvaluation(folderGT, '10x');
    
    % load the ground truth file
    GTFileName = [ConvertedGTRootDir d(i).name '.mat'];
    load(GTFileName);
    
    for t = 1:97
        Nuclei_GT{t} = zeros(R,C);
        Somata_GT{t} = zeros(R,C);
    end
    
    for a = 1:numel(AnnotatedTrackedCells)
        for k = 1:numel(AnnotatedTrackedCells{a}.nucleus.listOfObjects.t2_area)
            PixelIdxList = AnnotatedTrackedCells{a}.nucleus.listOfObjects.t2_area{k}.PixelIdxList;
            t = AnnotatedTrackedCells{a}.nucleus.listOfObjects.t2_area{k}.Time;
            Nuclei_GT{t}(PixelIdxList) = a;  
            
            PixelIdxList = AnnotatedTrackedCells{a}.soma.listOfObjects.t2_area{k}.PixelIdxList;
            t = AnnotatedTrackedCells{a}.soma.listOfObjects.t2_area{k}.Time;
            Somata_GT{t}(PixelIdxList) = a;
        end
    end
    
    GTSOMATA = [];
    DETSOMATA = [];
    GTNUCLEUS = [];
    DETNUCLEUS = [];
    ANNOTATIONS_NUCLEI = 0;
    ANNOTATIONS_SOMATA = 0;

    
    for t = 1:97
                
%         h1 = figure('Position', [1937 262 696 520]); hold on;
        h1 = figure(1); hold off; clf; hold on;
        axis([0 C 0 R]);
%         h2 = figure('Position', [1937 262 696 520]); hold on;
        h2 = figure(2); hold off; clf; hold on;
        axis([0 C 0 R]);
        
        
        % nuclei eval
        Mask_Nuclei_GT = zeros(R,C);
        Mask_Nuclei_DET = zeros(R,C);
        for n = 1:max(Nuclei{t}(:))
            pixIdxList = find(Nuclei{t} == n);
            mapped_GT_list = setdiff(unique(Nuclei_GT{t}(pixIdxList)), 0);
            if ~isempty(mapped_GT_list)
                Mask_Nuclei_DET(pixIdxList) = 1;
            end
        end
        Mask_Nuclei_GT = double(Nuclei_GT{t} > 0);
        
        PixelIdxList_Nuclei_GT = find(Mask_Nuclei_GT);
        PixelIdxList_Nuclei_DET = find(Mask_Nuclei_DET);
        
        N_correct = numel(intersect(PixelIdxList_Nuclei_DET,PixelIdxList_Nuclei_GT));
        N_fp = numel(setdiff(PixelIdxList_Nuclei_DET, PixelIdxList_Nuclei_GT));
        N_fn = numel(setdiff(PixelIdxList_Nuclei_GT, PixelIdxList_Nuclei_DET));
        N_size_GT = numel(PixelIdxList_Nuclei_GT);
        N_size_DET = numel(PixelIdxList_Nuclei_DET);
    
        % soma eval
        Mask_Somata_GT = zeros(R,C);
        Mask_Somata_DET = zeros(R,C);
        for n = 1:max(Somata{t}(:))
            pixIdxList = find(Somata{t} == n);
            mapped_GT_list = setdiff(unique(Somata_GT{t}(pixIdxList)), 0);
            if ~isempty(mapped_GT_list)
                Mask_Somata_DET(pixIdxList) = 1;
            end
        end
        Mask_Somata_GT = double(Somata_GT{t} > 0);
        
        PixelIdxList_Somata_GT = find(Mask_Somata_GT);
        PixelIdxList_Somata_DET = find(Mask_Somata_DET);
        
        S_correct = numel(intersect(PixelIdxList_Somata_DET,PixelIdxList_Somata_GT));
        S_fp = numel(setdiff(PixelIdxList_Somata_DET, PixelIdxList_Somata_GT));
        S_fn = numel(setdiff(PixelIdxList_Somata_GT, PixelIdxList_Somata_DET));
        S_size_GT = numel(PixelIdxList_Somata_GT);
        S_size_DET = numel(PixelIdxList_Somata_DET);
        
        
        Results(Idx_Results, :) = [N_correct N_fp N_fn N_size_DET N_size_GT S_correct S_fp S_fn S_size_DET S_size_GT];
        fprintf('(%02d/97)  correct %d  fp %d  fn %d\n', t, N_correct, N_fp, N_fn);
        Idx_Results = Idx_Results + 1;
        
        
        
        % render the results
        color_somata_gt = [1 0 0];
        color_somata_det = [0 0 1];
        color_nucleus_gt = [1 0 0 ];
        color_nucleus_det = [0 0 1];
        alpha_somata_gt = .5;
        alpha_somata_det = .5;
        alpha_nucleus_gt = .5;
        alpha_nucleus_det = .5;
        

        L_Somata_GT = bwlabeln(Mask_Somata_GT);
        L_Somata_DET = bwlabeln(Mask_Somata_DET);
        L_Nuclei_GT = bwlabeln(Mask_Nuclei_GT);
        L_Nuclei_DET = bwlabeln(Mask_Nuclei_DET);
        
        ANNOTATIONS_NUCLEI = ANNOTATIONS_NUCLEI + max(L_Nuclei_GT(:));
        ANNOTATIONS_SOMATA = ANNOTATIONS_SOMATA + max(L_Somata_GT(:));

        
        
        figure(h1); imshow(I_GFP{t}); hold on;

        
        % GT somata
        for k = 1:max(L_Somata_GT(:))
            B = zeros(R,C);
            B(L_Somata_GT == k) = 1;
            [x2, y2] = boundingpolygon(B);
            if iscell(x2)
                for l = 1:numel(x2)
                    patch(x2{l}, y2{l}, 1, 'FaceColor', color_somata_gt, 'FaceAlpha', alpha_somata_gt, 'EdgeColor', [0 0 0], 'EdgeAlpha', alpha_somata_gt);
                end
            else
                GTSOMATA(t).S(k).x = x2;
                GTSOMATA(t).S(k).y = y2;
                patch(GTSOMATA(t).S(k).x, GTSOMATA(t).S(k).y, 1, 'FaceColor', color_somata_gt, 'FaceAlpha', alpha_somata_gt, 'EdgeColor', [0 0 0], 'EdgeAlpha', alpha_somata_gt);
            end
        end
        
        % DET somata
        for k = 1:max(L_Somata_DET(:))
            B = zeros(R,C);
            B(L_Somata_DET == k) = 1;
            [x2, y2] = boundingpolygon(B);
            if iscell(x2)
                for l = 1:numel(x2)
                    patch(x2{l}, y2{l}, 1, 'FaceColor', color_somata_det, 'FaceAlpha', alpha_somata_det, 'EdgeColor', [0 0 0], 'EdgeAlpha', alpha_somata_det);
                end
            else
                DETSOMATA(t).S(k).x = x2;
                DETSOMATA(t).S(k).y = y2;
                patch(DETSOMATA(t).S(k).x, DETSOMATA(t).S(k).y, 1, 'FaceColor', color_somata_det, 'FaceAlpha', alpha_somata_det, 'EdgeColor', [0 0 0], 'EdgeAlpha', alpha_somata_det);
            end
        end
        
        figure(h1);
        F = getframe(gcf);
        I = F.cdata;
        SomataMov{t} = I;
        
        figure(h2); imshow(I_RFP{t}); hold on;
        
        
        % GT nucleus
        for k = 1:max(L_Nuclei_GT(:))
            B = zeros(R,C);
            B(L_Nuclei_GT == k) = 1;
            [x2, y2] = boundingpolygon(B);
            GTNUCLEUS(t).S(k).x = x2;
            GTNUCLEUS(t).S(k).y = y2;
            patch(GTNUCLEUS(t).S(k).x, GTNUCLEUS(t).S(k).y, 1, 'FaceColor', color_nucleus_gt, 'FaceAlpha', alpha_nucleus_gt, 'EdgeColor', color_nucleus_gt, 'EdgeAlpha', alpha_nucleus_gt);
        end
        
        % DET nucleus
        for k = 1:max(L_Nuclei_DET(:))
            B = zeros(R,C);
            B(L_Nuclei_DET == k) = 1;
            [x2, y2] = boundingpolygon(B);
            DETNUCLEUS(t).S(k).x = x2;
            DETNUCLEUS(t).S(k).y = y2;
            patch(DETNUCLEUS(t).S(k).x, DETNUCLEUS(t).S(k).y, 1, 'FaceColor', color_nucleus_det, 'FaceAlpha', alpha_nucleus_det, 'EdgeColor', color_nucleus_det, 'EdgeAlpha', alpha_nucleus_det);
        end
        figure(h2);
        F = getframe(gcf);
        I = F.cdata;
        NucleiMov{t} = I;
        
    end
    
    
    movieFolder = [outputRootFolder 'movies/nuclei/' d(i).name '/'];
    if ~exist(movieFolder, 'dir'); mkdir(movieFolder); end;
    movieNucleiFilename =  sprintf('evalNuclei%03d', i);
    trkMovie(NucleiMov, movieFolder, movieFolder, movieNucleiFilename,0); fprintf('\n');
    fprintf('wrote to %s%s.mp4\n', movieFolder,movieNucleiFilename);
    
    
    movieFolder = [outputRootFolder 'movies/somata/' d(i).name '/'];
    if ~exist(movieFolder, 'dir'); mkdir(movieFolder); end;
    movieSomataFilename =  sprintf('evalSomata%03d', i);
    trkMovie(SomataMov, movieFolder, movieFolder, movieSomataFilename,0); fprintf('\n');
    fprintf('wrote to %s%s.mp4\n', movieFolder,movieSomataFilename);
    

    
end

%[N_correct N_fp N_fn N_size_DET N_size_GT S_correct S_fp S_fn S_size_DET S_size_GT];

fprintf('total annotations: %d nuclei,  %d somata\n', ANNOTATIONS_NUCLEI, ANNOTATIONS_SOMATA);

rsum = sum(Results);
ResultsFilename = fullfile(outputRootFolder, 'Results.mat');
save(ResultsFilename, 'Results', 'rsum', 'Nuclei_GT', 'Somata_GT', 'Nuclei', 'Somata', 'ANNOTATIONS_NUCLEI', 'ANNOTATIONS_SOMATA');
% save(ResultsFilename);
fprintf('saved results to %s\n', ResultsFilename);



fprintf('Nuclei results:\n');
fprintf('%1.2f%% area of annotations recovered (%d / %d)\n', rsum(1)/rsum(5)*100, rsum(1), rsum(5));
fprintf('%1.2f%% false positives (%d / %d)\n', rsum(2)/rsum(4)*100, rsum(2), rsum(4));
fprintf('%1.2f%% false negatives (%d / %d)\n', rsum(3)/rsum(5)*100, rsum(3), rsum(5));
fprintf('\nSomata results:\n');
fprintf('%1.2f%% area of annotations recovered (%d / %d)\n', rsum(1+5)/rsum(5+5)*100, rsum(1+5), rsum(5+5));
fprintf('%1.2f%% false positives (%d / %d)\n', rsum(2+5)/rsum(4+5)*100, rsum(2+5), rsum(4+5));
fprintf('%1.2f%% false negatives (%d / %d)\n', rsum(3+5)/rsum(5+5)*100, rsum(3+5), rsum(5+5));




keyboard;
            
% %         set(gcf, 'Position', [1937 262 696 520]);
%         F = getframe(gcf);
%         I = F.cdata;
%         newmv{t} = I; %#ok<AGROW>
        
    
    jaccard = N_correct / ( N_size_DET + N_size_GT - N_correct);
    
    
    keyboard;