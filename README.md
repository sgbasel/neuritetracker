# High throughput detection and tracking of migrating neurons and neurites in live cell imaging


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

## Summary of the method
The image processing is divided into 9 steps. Details of the method are described in
1. L. Fusco, R. Lefort, K. Smith, F. Benmansour, G. Gonzalez, C. Barillari, B. Rinn, F. Fleuret, P. Fua, O. Pertz, [Computer vision profiling of neurite outgrowth dynamics reveals spatio-temporal modularity of Rho GTPase signaling](https://www.google.com), Journal of Cell Biology, *under review*

1. Segmentation of the nucleus using Maximally Stable Extremal Regions (MSER).
2. Soma region growing using a fast marching method on geodesic intensity distance to the nucleus.
3. Cell tracking using a greedy graph-based optimization.
4. Cell filtering and identification of robust tracks.
5. Apply Hessian-based filter to get high responses to tubular neurite-like structures
6. Use this to model the likelihood each pixel belongs to neuron (sigmoid fitting on geodesic distance from soma)
7. Set a likelihood threshold to obtain cell bodies
8. Identify candidate neurite terminals (extreme points), use backtracing & minimal spanning trees to reconstruct the neurites
9. Store the reconstructed neurite model in a HDS graph representation

![Image processing pipeline](https://github.com/sgbasel/neuritetracker/blob/master/trunk/Documentation/Images/figure.png "Image processing pipeline")

## Contents of the repository
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


