function cdata = opengl_cdata(hfig)
% Get CDATA from hardcopy using zbuffer
% Need to have PaperPositionMode be auto 
warning('off', 'MATLAB:hardcopy:DeprecatedHardcopyFunction');
orig_mode = get(hfig, 'PaperPositionMode');
set(hfig, 'PaperPositionMode', 'auto');
cdata = hardcopy(hfig, '-Dopengl', '-r0');
% Restore figure to original state
set(hfig, 'PaperPositionMode', orig_mode); % end

warning('on', 'MATLAB:hardcopy:DeprecatedHardcopyFunction');