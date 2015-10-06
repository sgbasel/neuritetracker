addpath  /home/ksmith/code/ethz/lmc_dag/projects/flatfield/fig/export_fig/

color0 = [.6 .6 .6];
color1 = [0 1 1];
color2 = [.8 1 0];

% 58064 total tracked detections
% 
% 90.28\% correct   (52418)
% 6.80\% FN errors (3949)
% 0.16\% FP errors (95)
% 0.20\% MO errors (116)
% 0.01\% MT errors (3)
% 2.55\% FI errors (1483)

numFN = 3949;
numFP = 95;
numMO = 116;
numMT = 3;
numFI = 1483;
numOK = 52418;

numALL= numFN + numFP + numMO + numMT + numFI + numOK;

perFN = 100*3949/numALL;
perFP = 100*95/numALL;
perMO = 100*116/numALL;
perMT = 100*3/numALL;
perFI = 100*1483/numALL;
perOK = 100*52418/numALL;


colorFN = [1 .498 .3137];
colorFP = [1 .2 .2];
colorMT = [1 .2 1];
colorMO = [.7216 .4510 .2];
colorFI = [0 1 0];
colorOK = [.3 .3 1];
colorOKgt  = [.5 .5 .5];


% figure AutoVsLudo100
h = figure; 
set(h, 'Color', [1 1 1]);
h1 = bar([numOK 0 0 0 0 0]);
text(1, numOK+.02*numALL, sprintf('%1.1f%%', perOK), 'HorizontalAlignment', 'Center');
set(h1, 'FaceColor', colorOK);
set(h1, 'EdgeColor', 'none');
hold on;
h2 = bar([0 numFN 0 0 0 0]);
text(2, numFN+.02*numALL, sprintf('%1.1f%%', perFN), 'HorizontalAlignment', 'Center');
set(h2, 'FaceColor', colorFP);
set(h2, 'EdgeColor', 'none');
hold on;
h3 = bar([0  0 numFP 0 0 0]);
text(3, numFP+.02*numALL, sprintf('%1.1f%%', perFP), 'HorizontalAlignment', 'Center');
set(h3, 'FaceColor', colorFN);
set(h3, 'EdgeColor', 'none');
hold on;
h4 = bar([0 0 0 numMT 0 0]);
text(4, numMT+.02*numALL, sprintf('%1.1f%%', perMT), 'HorizontalAlignment', 'Center');
set(h4, 'FaceColor', colorMT);
set(h4, 'EdgeColor', 'none');
hold on;
h5 = bar([0 0 0 0 numMO 0]);
text(5, numMO+.02*numALL, sprintf('%1.1f%%', perMO), 'HorizontalAlignment', 'Center');
set(h5, 'FaceColor', colorMO);
set(h5, 'EdgeColor', 'none');
hold on;
h6 = bar([0 0 0 0 0 numFI]);
text(6, numFI+.02*numALL, sprintf('%1.1f%%', perFI), 'HorizontalAlignment', 'Center');
set(h6, 'FaceColor', colorFI);
set(h6, 'EdgeColor', 'none');

box off;
set(gca, 'XTickLabel', {'OK', 'FP', 'FN', 'MT', 'MO', 'FI'});
%set(gca, 'YLim', [0 .80]);
%set(gca, 'XLim', [.5 3.5]);
% export the PDF
set(h, 'InvertHardcopy', 'off');
set(h, 'PaperOrientation', 'landscape');
filename = sprintf('/home/ksmith/Dropbox/Sinergia_LOCAL/SuppFigureStatic/source_figures/tracking_eval.pdf');
fprintf('saving %s\n', filename);
export_fig temp.pdf -pdf
copyfile('temp.pdf', filename);
delete('temp.pdf');
