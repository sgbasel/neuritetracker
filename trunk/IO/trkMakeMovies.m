function trkMakeMovies(ImagesNuc, ImagesBody, Cells, CellsList, tracks, Sequence, output, parameters, cols3)

% make movie: neuron channel
if output.movieNeuronChannel
    try
        fprintf('...rendering neuron channel movie       '); tic;
        mv_neuron_channel = trkConvertTo8bit(ImagesBody,1);
        FolderMovie = sprintf('%s%smovie_neuron_channel%s', filesep, output.destFolder, filesep);
        filestr = sprintf('%s_neuron_channel', parameters.UniqueID);
        trkMovie2(mv_neuron_channel, output.destFolder, FolderMovie, filestr, output.writeFramesToFile);
        fprintf('   (elapsed time %1.2f seconds)\n', toc);
    catch
    end
end

% make movie: nucleus channel
if output.movieNucleusChannel
    try
        fprintf('...rendering nucleus channel movie      '); tic;
        mv_nucleus_channel = trkConvertTo8bit(ImagesNuc,1);
        FolderMovie = sprintf('%s%smovie_nucleus_channel%s', filesep, output.destFolder, filesep);
        filestr = sprintf('%s_nucleus_channel', parameters.UniqueID);
        trkMovie2(mv_nucleus_channel, output.destFolder, FolderMovie, filestr, output.writeFramesToFile);
        fprintf('   (elapsed time %1.2f seconds)\n', toc);
    catch
    end
end


% make movie: nucleus detection
if output.movieNucleusDetection
    try
        fprintf('...rendering nucleus detection movie    '); tic;
        mv_detect_label = trkRenderFancy2(ImagesNuc, Cells, CellsList, tracks, cols3, 7);
        FolderMovie = sprintf('%s%smovie_nucleus_detections%s', filesep, output.destFolder, filesep);
        filestr = sprintf('%s_nucleus_detections', parameters.UniqueID);
        trkMovie2(mv_detect_label, output.destFolder, FolderMovie, filestr, output.writeFramesToFile);
        fprintf('   (elapsed time %1.2f seconds)\n', toc);
    catch
    end
end


% make movie: tubularity
if output.movieTubularity
    try
        fprintf('...rendering tubularity movie           '); tic;
        mv_tube = trkConvertTo8bit(Sequence.NeuriteProbability,1);
        mv_tube_label = trkRenderFancy2(mv_tube, Cells, CellsList, tracks, cols3, 2);
        FolderMovie = sprintf('%s%smovie_tubularity%s', filesep, output.destFolder, filesep);
        filestr = sprintf('%s_tubularity', parameters.UniqueID);
        trkMovie2(mv_tube_label, output.destFolder, FolderMovie, filestr, output.writeFramesToFile);
        fprintf('   (elapsed time %1.2f seconds)\n', toc);
    catch
    end
end


% make movie: neurite probablility
if output.movieNeuriteProbability
    try
        fprintf('...rendering neurite probability movie  '); tic;
        mv_neurite_prob = renderU(Sequence.NeuronBodies, ImagesBody, parameters);
        mv_neurite_prob_label = trkRenderFancy2(mv_neurite_prob, Cells, CellsList, tracks, cols3, 2);
        FolderMovie = sprintf('%s%smovie_neurite_prob%s', filesep, output.destFolder, filesep);
        filestr = sprintf('%s_neurite_prob', parameters.UniqueID);
        trkMovie2(mv_neurite_prob_label, output.destFolder, FolderMovie, filestr, output.writeFramesToFile);
        fprintf('   (elapsed time %1.2f seconds)\n', toc);
    catch
    end
end

% make movie: cell segmentation
if output.movieCellSegmentation
    try
        fprintf('...rendering cell body segment movie    '); tic;
        mv_cell_segment = trkRenderFancy2(ImagesBody, Cells, CellsList, tracks, cols3, 4);
        FolderMovie = sprintf('%s%smovie_cell_body_segment%s', filesep, output.destFolder, filesep);
        filestr = sprintf('%s_cell_body_segment', parameters.UniqueID);
        trkMovie2(mv_cell_segment, output.destFolder, FolderMovie, filestr, output.writeFramesToFile);
        fprintf('   (elapsed time %1.2f seconds)\n', toc);
    catch
    end
end


% make movie: neurite backtracing
if output.movieBacktracing
    try
        fprintf('...rendering neurite backtracing movie  '); tic;
        mv_neurite_backtracing = trkRenderFancy2(ImagesBody, Cells, CellsList, tracks, cols3, 11);
        FolderMovie = sprintf('%s%smovie_neurite_backtracing%s', filesep, output.destFolder, filesep);
        filestr = sprintf('%s_neurite_backtracing', parameters.UniqueID);
        trkMovie2(mv_neurite_backtracing, output.destFolder, FolderMovie, filestr, output.writeFramesToFile);
        fprintf('   (elapsed time %1.2f seconds)\n', toc);
    catch
    end
end


% make movie: final without numbering
if output.movieFinal
    try
        fprintf('...rendering final movie                '); tic;
        mv_final = trkRenderFancy2(ImagesBody, Cells, CellsList, tracks, cols3, 1);
        FolderMovie = sprintf('%s%smovie_final%s', filesep, output.destFolder, filesep);
        filestr = sprintf('%s_final', parameters.UniqueID);
        trkMovie2(mv_final, output.destFolder, FolderMovie, filestr, output.writeFramesToFile);
        fprintf('   (elapsed time %1.2f seconds)\n', toc);
    catch
    end
end

% make movie: final with numbering
if output.movieFinalNumbered
    try
        fprintf('...rendering final numbered movie       '); tic;
        mv_final = trkRenderFancy2(ImagesBody, Cells, CellsList, tracks, cols3, 0);
        FolderMovie = sprintf('%s%smovie_final_numbered%s', filesep, output.destFolder, filesep);
        filestr = sprintf('%s_final_numbered', parameters.UniqueID);
        trkMovie2(mv_final, output.destFolder, FolderMovie, filestr, output.writeFramesToFile);
        fprintf('   (elapsed time %1.2f seconds)\n', toc);
    catch
    end
end

% make movie: binary model
if output.movieExtractedModel
    try
        fprintf('...rendering extracted HDS movie        '); tic;
        mv_binary = trkRenderFancy2(ImagesBody, Cells, CellsList, tracks, cols3, 6);
        FolderMovie = sprintf('%s%smovie_extracted_HDS_model%s', filesep, output.destFolder, filesep);
        filestr = sprintf('%s_extracted_HDS_model', parameters.UniqueID);
        trkMovie2(mv_binary, output.destFolder, FolderMovie, filestr, output.writeFramesToFile);
        fprintf('   (elapsed time %1.2f seconds)\n', toc);
    catch
    end
end

