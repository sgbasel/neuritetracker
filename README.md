# High throughput detection & tracking of neurons in live cell imaging

Neuritetracker is software for high throughput detection, tracking, and segmentation of neuroblasts in live cell imaging. It runs in Matlab with a GUI interface, analyzes image sequences, and stores results as movies and CSV files.

## Installation
To install neuritetracker on your machine follow these steps:

1. Obtain a licensed copy of [Matlab](http://www.mathworks.com/products/matlab/) with a C/C++ compiler (or download a [trial version](https://www.mathworks.com/programs/nrd/matlab-trial-request.html?ref=ggl&s_eid=ppc_2537843722&q=matlab%20trial)). Refer to the [Mathworks website](https://se.mathworks.com/support/compilers/R2015b/index.html?refresh=true&s_cid=pi_scl_5_R2015b_win64) for a list of supported compilers for your version of Matlab. [Microsoft Windows SDK](http://www.microsoft.com/en-us/download/confirmation.aspx?id=8279) is a freely available option which works for Windows 7. You can use [these instructions from Mathworks](http://www.mathworks.com/matlabcentral/answers/101105-how-do-i-install-microsoft-windows-sdk-7-1) to install it. If you have trouble installing, try the fix suggested [here](http://www.mathworks.com/matlabcentral/answers/95039-why-does-the-sdk-7-1-installation-fail-with-an-installation-failed-message-on-my-windows-system). 
2. Clone the **neuritetracker** repository using the following command line ```git clone git@github.com:sgbasel/neuritetracker.git``` or download a [zip file](https://github.com/sgbasel/neuritetracker/archive/master.zip) of the repository. Unzip the archive file if you downloaded a .zip file.
3. Open Matlab in the ```neuritetracker/trunk/``` folder and run the setup utility from the matlab command prompt ```neuritetracker_setup```. This will set up the **Vlfeat** library and compile the **Geodesics** functions.

## Running the Neuritetracker GUI on a single sequence
1. Open Matlab and run the ```neuritetracker_gui``` function located in the ```neuritetracker/trunk/``` folder. This will open the GUI interface for neuritetracker.
2. Select a folder containing your source images for the nucleus channel (**1** in the diagram).
3. Select a folder containing your source images for the cell body channel (**2** in the diagram).
4. Select a destination folder where you would like the output to be saved (**3** in the diagram).
5. Provide a *UniqueID* string which will uniquely identify the data (**4** in the diagram).
6. Select the output options you prefer (**5** in the diagram).
7. Press the *Run Neuritetracker* button (**6** in the diagram).

![GUI interface](https://github.com/sgbasel/neuritetracker/blob/master/trunk/Documentation/Images/interface.png "GUI interface")

## Using a script to run Neuritetracker on a batch of sequences
1. blah
2. blah
3. blah

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
The code has been organised into folders according to the various functions of the code. They are organized in the ```neuritetracker``` folder according to the list below followed by a short description.

* _trunk_
 * _CellsDetection_ - code to detect neuron cells in static images
 * _Common_ - code shared in several routines
 * _FeaturesExtraction_ - code to extract & organize features describing the cells
 * _frangi-filter-version2a_ - code for the Hessian-based filter to detect neurite-like structures
 * _gaimc_ - 3rd party software with useful graph manipulation functions
 * _Geodesics_ - code to efficiently compute geodesic distances
 * _GreedyTracking_ - code to perform tracking on a graph formed from object detections
 * _IO_ - code for file input/output
 * _NeuritesDetection_ - code for detecting neurites
 * _NeuritesTracking_ - code for tracking the neurites
 * _TestData_ - sample image sequences to test the algorithm
 * _vlfeat-0.9.18_ - 3rd party code for MSER calculation from the vlfeat library (version 0.9.18)

The ```neuritetracker/trunk/``` folder also contains several files, described below.
 * ```neuritetracker_setup.m``` - a setup script. Run it once to compile necessary files.
 * ```neuritetracker_gui.m``` - a graphical user interface used to run neuritetracker
 * ```neuritetracker_cmd.m``` - the main command-line function to run neuritetracker
 * ```settings.ini```       - contains default parameters and configurations for neuritetracker
 * ```neuritetracker_gui.fig``` - matlab gui figure file

## Dependencies
Neuritetracker makes use of the following 3rd party software. These software packages are included in the ```neuritetracker``` repository. 
 
1. The [vlfeat library](http://www.vlfeat.org/download.html) available at http://www.vlfeat.org/download/vlfeat-0.9.20-bin.tar.gz
2. The [Graph Algorithms in Matlab Code (gaimc)](https://github.com/dgleich/gaimc) available on github at https://github.com/dgleich/gaimc





