
filenm = mfilename('fullpath');
[p, name, ext] = fileparts(filenm);

listOfcppFiles = dir([p filesep '*.cpp']);
disp('.. compiling cpp files')
for i = 1:length(listOfcppFiles)
    
    filename = [p filesep listOfcppFiles(i).name];
    mex(filename);
end