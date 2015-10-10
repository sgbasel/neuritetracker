# High throughput detection and tracking of migrating neurons and neurites in live cell imaging


## About
Neuritetracker is software for high throughput detection, tracking, and segmentation of neuroblasts and neurites as they migrate in live cell imaging.

## Installation
To install neuritetracker on your machine follow these steps:

1. Obtain a licensed copy of Matlab.
2. Clone the **neuritetracker** repository using the following command line ```git clone git@github.com:sgbasel/neuritetracker.git``` or download a [zip file](https://github.com/sgbasel/neuritetracker/archive/master.zip) of the repository 
3. Set-up the **vlfeat library**. Run ```neuritetracker/vlfeat-0.9.18/toolbox/vl_setup.m``` at the Matlab prompt.
4. Compile the **Geodesics** functions. Run ```neuritetracker/Geodesics/compile_mex.m``` at the Matlab prompt.

## Running the code
Open Matlab and

1. trkTracking : to be run for one single sequence
2. processPlate.m
3. processListOfPlates.m

## Summary of the method
Details of the method are described in the article

1. L. Fusco, R. Lefort, K. Smith, F. Benmansour, G. Gonzalez, C. Barillari, B. Rinn, F. Fleuret, P. Fua, O. Pertz, [Computer vision profiling of neurite outgrowth dynamics reveals spatio-temporal modularity of Rho GTPase signaling](https://www.google.com), Journal of Cell Biology, *under review*

The image processing is divided into 9 steps, summarized in the figure. A brief description of each step is provided below.

![Image processing pipeline](https://github.com/sgbasel/neuritetracker/blob/master/trunk/Documentation/Images/figure.png "Image processing pipeline")

1. Segmentation of the nucleus using Maximally Stable Extremal Regions (MSER).
2. Soma region growing using a fast marching method on geodesic intensity distance to the nucleus.
3. Cell tracking using a greedy graph-based optimization.
4. Cell filtering and identification of robust tracks.
5. Apply Hessian-based filter to get high responses to tubular neurite-like structures
6. Use this to model the likelihood each pixel belongs to neuron (sigmoid fitting on geodesic distance from soma)
7. Set a likelihood threshold to obtain cell bodies
8. Identify candidate neurite terminals (extreme points), use backtracing & minimal spanning trees to reconstruct the neurites
9. Store the reconstructed neurite model in a HDS graph representation

## Contents of the repository
The code has been organised into folders according to the various functions of the code. They are organized according to the list below followed by a short description.

* trunk
 * CellsDetection - code to detect neuron cells in static images
 * Common - code shared in several routines
 * FeaturesExtraction - code to extract & organize features describing the cells
 * frangi_filter_version2a - code for the Hessian-based filter to detect neurite-like structures
 * gaimc - 3rd party software with useful graph manipulation functions
 * Geodesics - code to efficiently compute geodesic distances
 * GreedyTracking - code to perform tracking on a graph formed from object detections
 * IO - code for file input/output
 * NeuritesDetection - code for detecting neurites
 * NeuritesTracking - code for tracking the neurites
 * TestData - sample image sequences to test the algorithm
 * vlfeat-0.9.18 - 3rd party code for MSER calculation from the vlfeat library (version 0.9.18)

## Dependencies
Neuritetracker makes use of the following 3rd party software. 
 
1. (included) The [vlfeat library](http://www.vlfeat.org/download.html) available at http://www.vlfeat.org/download/vlfeat-0.9.20-bin.tar.gz
2. (included) The [Graph Algorithms in Matlab Code (gaimc)](https://github.com/dgleich/gaimc) available on github at https://github.com/dgleich/gaimc





