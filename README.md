# neuritetracker
## Software for high throughput detection and tracking of migrating neurons and neurites in live cell imaging


## About
Neuritetracker is software for detection, tracking, and segmentation of neurons and neurites as they migrate in live cell imaging. It is designed for high-throughput image analysis.


## Installation
1. vlfeat 0.9.16 available at http://www.vlfeat.org/download/vlfeat-0.9.16-bin.tar.gz
2. Enter the Geodesics directory and run from matlab "compile_mex"

## Running the code
The most important functions and scripts are:
1. trkTracking : to be run for one single sequence
2. processPlate.m
3. processListOfPlates.m

## Contents
The code has been organised into many subdirectories:

* Common
* IO
* CellsDetection
* GreedyTracking
* Geodesics
* NeuritesDetection
* NeuritesTracking
* FeaturesExtraction
* frangi_filter_version2a
* gaimc


