function neuritetracker_setup() 
%Neuritetracker is software for high throughput detection, tracking, and 
%segmentation of neuroblasts and neurites as they migrate in live cell 
%imaging.
%
%USAGE               neuritetracker_setup()
%
%Sets up the environment for neuritetracker to run. Compiles 3rd party
%code.
%
%From the Neuritetracker project. https://github.com/sgbasel/neuritetracker
%Copyright © 2015 Kevin Smith and Fethallah Benmansour. KTH Royal
%Institute of Technology in Stockholm, Sweden and University of Basel, 
%Switzerland. All rights reserved.

%The MIT License (MIT)
%
%Permission is hereby granted, free of charge, to any person obtaining a copy
%of this software and associated documentation files (the "Software"), to deal
%in the Software without restriction, including without limitation the rights
%to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%copies of the Software, and to permit persons to whom the Software is
%furnished to do so, subject to the following conditions:
% 
%The above copyright notice and this permission notice shall be included in all
%copies or substantial portions of the Software.
% 
%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%SOFTWARE.


% add necessary paths
if (~isdeployed)
    filenm = mfilename('fullpath');
    p = fileparts(filenm);
    addpath([p filesep 'CellsDetection' filesep]);
    addpath([p filesep 'Common' filesep]);
    addpath([p filesep 'FeaturesExtraction' filesep]);
    addpath([p filesep 'frangi_filter_version2a' filesep]);
    addpath([p filesep 'gaimc' filesep]);
    addpath([p filesep 'Geodesics' filesep]);
    addpath([p filesep 'GreedyTracking' filesep]);
    addpath([p filesep 'IO' filesep]);
    addpath([p filesep 'NeuritesDetection' filesep]);
    addpath([p filesep 'NeuritesTracking' filesep]);
    addpath([p filesep 'vlfeat-0.9.18' filesep]);
end
compile_mex;