
filenm = mfilename('fullpath');
[p, name, ext] = fileparts(filenm);

listOfcppFiles = dir([p '/*.cpp']);
disp('.. compiling cpp files')
for i = 1:length(listOfcppFiles)
    
    filename = [p '/' listOfcppFiles(i).name];
    mex(filename);
end