%BOUNDINGPOLYGON - finds bounding polygons of regions in a binary mask
%                  image.
%
%   [x, y] = boundingpolygon(BWin) finds the bounding polygon for each
%            region in the binary mask image BWin and returns the
%            corresponding vertex coordinates in arrays x and y.
%            If only one bounding polygon is found, x and y are normal
%            arrays of size 1-by-n where n is the number of vertices of
%            the polygon.
%            In case of several disconnected bounding polygons, x and y are
%            cell arrays of size m-by-1, where m is the total number of
%            disconnected bounding polygons of regions in BWin (one region
%            may have more than one boundary if it contains holes). Each
%            cell of x or y contains a 1-by-n array with the x or y
%            coordinates of the vertices of one of the m polygons. 
%
%   See also:
%   ---------
%   CONTOURC (details about finding contour levels in images)

%%
%==========================================================================
% Further info for function BOUNDINGPOLYGON
% -----------------------------------------
%
% Function subroutines:
% --------------------
% contourc2Lines      - convert contour matrix C (see MATLAB command
%                       'contourc') to cell array containing the vertices
%                       of each contour line in a separate cell.
%
%
% CVS-Info:
% ---------
% $Date: 2006/10/19 10:19:53 $
% $Author: schlepuetz $
% $Revision: 1.2 $
% $Source: /import/cvs/X/PILATUS/App/lib/X_PILATUS_Matlab/boundingpolygon.m,v $
% $Tag: $
%
% Author(s):            C. M. Schlepuetz (CS)
% Co-author(s):         S. A. Pauli (SP)
% Address:              Surface Diffraction Station
%                       Materials Science Beamline X04SA
%                       Swiss Light Source (SLS)
%                       Paul Scherrer Institut
%                       CH - 5232 Villigen PSI
% Created:              2006/06/15
%
% Change Log:
% -----------
% 2006/06/15 (CS):
% -created first version of this file.
%

%%
%==========================================================================
%  Main function - BOUNDINGPOLYGON
%                  ===============
%
function [x,y] = boundingpolygon(BWin)

error(nargchk(1, 1, nargin))

% pad with zeros to have well defined border
BWin = padarray(BWin,[1 1]);

% find contour lines
C = contourc(double(BWin),1);
[x y] = contourc2Lines(C);

% shift contourlines back to original position before the padding occured
for i = 1:length(x)
    x{i} = x{i}-1;
    y{i} = y{i}-1;
end

% return coordinate arrays instead of cell arrays if only one line is
% found.
if length(x) == 1
    x = x{1};
    y = y{1};
end

%%
%==========================================================================
%  Sub-function - contourc2Lines
%  =============================
%
% convert contour matrix C (see MATLAB command 'contourc') to cell
% array containing the vertices of each contour line in a separate cell.
function [xi,yi] = contourc2Lines(C)

dim = size(C);
cols = dim(2);

% find number of contour lines
ind = 1;
nlines = 0;
while ind < cols
    nvertices = C(2,ind);
    ind = ind+nvertices+1;
    nlines = nlines+1;
end

xi = cell(nlines,1);
yi = cell(nlines,1);

ind = 1;
i = 1;
while ind < cols
    nvertices = C(2,ind);
    xi{i} = C(1,ind+1:ind+nvertices);
    yi{i} = C(2,ind+1:ind+nvertices);
    ind = ind+nvertices+1;
    i = i+1;
end

%%
%==========================================================================
%
%---------------------------------------------------%
% emacs setup:  force text mode to get no help with %
%               indentation and force use of spaces %
%               when tabbing.                       %
% Local Variables:                                  %
% mode:text                                         %
% indent-tabs-mode:nil                              %
% End:                                              %
%---------------------------------------------------%
%
% $Log: boundingpolygon.m,v $
% Revision 1.2  2006/10/19 10:19:53  schlepuetz
% minor formatting changes
%
% Revision 1.1  2006/09/13 15:08:44  schlepuetz
% first release of this file
%
%
%============================= End of $RCSfile: boundingpolygon.m,v $ ===