addpath  /home/ksmith/code/ethz/lmc_dag/projects/flatfield/fig/export_fig/

color0 = [.6 .6 .6];
color1 = [0 1 1];
color2 = [.8 1 0];

%load /home/ksmith/Dropbox/Sinergia_LOCAL/EvalResultsNucleiSomata/Results_ALL.mat


colorFN = [.8 .2 .2]; %[1 .498 .3137];
colorFP = [.2 .2 .8]; %[1 .2 .2];
colorOK = [.5 .5 .5]; %[.3 .3 1];
colorOKgt  = [.5 .5 .5];

numALL = rsum(5);
numOK = rsum(1);    perOK = 100* numOK/numALL;
numFP = rsum(2)*rsum(5)/rsum(4);    perFP = 100* numFP/numALL;
numFN = rsum(3);    perFN = 100* numFN/numALL;


% figure AutoVsLudo100
h = figure; 
set(h, 'Color', [1 1 1]);
h1 = bar([numOK 0 0]);
text(1, numOK+.02*numALL, sprintf('%1.1f%%', perOK), 'HorizontalAlignment', 'Center');
set(h1, 'FaceColor', colorOK);
set(h1, 'EdgeColor', 'none');
hold on;
h2 = bar([0 numFP 0]);
text(2, numFP+.02*numALL, sprintf('%1.1f%%', perFP), 'HorizontalAlignment', 'Center');
set(h2, 'FaceColor', colorFP);
set(h2, 'EdgeColor', 'none');
hold on;
h3 = bar([0  0 numFN]);
text(3, numFN+.02*numALL, sprintf('%1.1f%%', perFN), 'HorizontalAlignment', 'Center');
set(h3, 'FaceColor', colorFN);
set(h3, 'EdgeColor', 'none');
hold on;

str = sprintf('Nuclei Segmentation Results\nN=%d annotations', 790);
%title(str);
ylabel('Area (pixels)');

box off;
set(gca, 'XTickLabel', {'OK', 'FP', 'FN'});
%set(gca, 'YLim', [0 .80]);
%set(gca, 'XLim', [.5 3.5]);
% export the PDF
set(h, 'InvertHardcopy', 'off');
set(h, 'PaperOrientation', 'landscape');
filename = sprintf('/home/ksmith/Dropbox/Sinergia_LOCAL/SuppFigureSomaTracking/sourceFiles/static_nucleus_eval.pdf');
fprintf('saving %s\n', filename);
export_fig temp.pdf -pdf
copyfile('temp.pdf', filename);
delete('temp.pdf');






numALL = rsum(5+5);
numOK = rsum(1+5);    perOK = 100* numOK/numALL;
numFP = rsum(2+5)*rsum(5+5)/rsum(4+5);    perFP = 100* numFP/numALL;
numFN = rsum(3+5);    perFN = 100* numFN/numALL;


% figure AutoVsLudo100
h = figure; 
set(h, 'Color', [1 1 1]);
h1 = bar([numOK 0 0]);
text(1, numOK+.02*numALL, sprintf('%1.1f%%', perOK), 'HorizontalAlignment', 'Center');
set(h1, 'FaceColor', colorOK);
set(h1, 'EdgeColor', 'none');
hold on;
h2 = bar([0 numFP 0]);
text(2, numFP+.02*numALL, sprintf('%1.1f%%', perFP), 'HorizontalAlignment', 'Center');
set(h2, 'FaceColor', colorFP);
set(h2, 'EdgeColor', 'none');
hold on;
h3 = bar([0  0 numFN]);
text(3, numFN+.02*numALL, sprintf('%1.1f%%', perFN), 'HorizontalAlignment', 'Center');
set(h3, 'FaceColor', colorFN);
set(h3, 'EdgeColor', 'none');
hold on;

str = sprintf('Soma Segmentation Results\nN=%d annotations', 790);
%title(str);
ylabel('Area (pixels)');

box off;
set(gca, 'XTickLabel', {'OK', 'FP', 'FN'});
%set(gca, 'YLim', [0 .80]);
%set(gca, 'XLim', [.5 3.5]);
% export the PDF
set(h, 'InvertHardcopy', 'off');
set(h, 'PaperOrientation', 'landscape');
filename = sprintf('/home/ksmith/Dropbox/Sinergia_LOCAL/SuppFigureSomaTracking/sourceFiles/static_soma_eval.pdf');
fprintf('saving %s\n', filename);
export_fig temp.pdf -pdf
copyfile('temp.pdf', filename);
delete('temp.pdf');