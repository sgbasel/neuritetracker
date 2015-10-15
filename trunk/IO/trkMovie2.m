function trkMovie2(mv, destFolder, framesFolder, filename, writeFramesToFile)
% folder  where you construct the movie
% resultsfolder  where the movie ends up




%disp('...writing temporary image files');
if writeFramesToFile
    if ~exist(framesFolder, 'dir'); mkdir(framesFolder); end;
    for i = 1:length(mv)
        imwrite(mv{i}, [framesFolder sprintf('%03d',i) '.png'], 'PNG');
    end
end


% oldpath = pwd;
% cd(folder);


% TODO: adjust movie size to the size of the image

% try
%     cmd_mp4       = ['ffmpeg -v 0 -loglevel 0 -y -r 10 -i %03d.png  -vcodec libx264 -b 4096k -pix_fmt yuv420p -y -s 696x520 -r 10 ' filename '.mp4'];
%     system(cmd_mp4);
% catch
%     fprintf('Warning: unable to encode %s\n', filename);
%     v = VideoWriter([filename '.mp4']);
%     open(v);
%     for i = 1:numel(mv)
%         writeVideo(v, mv{i});
%     end
%     close(v);    
% end

try
%     v = VideoWriter([filename '.mp4'], 'Quality', 100, 'FrameRate', 12);
%     v = VideoWriter([destFolder filename '.mp4'], 'H.264');
    if ~strcmp(destFolder(end), filesep)
        destFolder(end+1) = filesep;
    end

    v = VideoWriter([destFolder filename]);
%     v = VideoWriter([destFolder filename],'Motion JPEG AVI');
    v.Quality = 100;
    v.FrameRate = 10;
    open(v);
    for i = 1:numel(mv)
        writeVideo(v, mv{i});
    end
    close(v);    
catch
        fprintf('Warning: unable to encode %s.avi\n', filename);
end

% keyboard;

% cd(oldpath);




% cmd_webm      = ['ffmpeg -v 0 -loglevel 0 -y -r 10 -i %03d.png -acodec libvorbis -b 4096k -y -s 696x520 -r 10 '  filename '.webm'];
% system(cmd_webm);


