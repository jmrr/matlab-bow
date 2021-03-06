#  Bag of Words Pipeline toolkit
                        
This is a Matlab toolkit that provides the necessary modules to construct a
typical bag of words pipeline for object recognition and categorisation 
purposes.

It is also an evaluation toolkit for the comparison of the different
algorithms that comprise the pipeline modules.
          
Version 0.1 (05/2014)                                              

##### Authors: 

 *   [Jose Rivera](http://joserivera.org) (jose.rivera@imperial.ac.uk)                  
 *   Ioannis Alexiou (i.alexiou@qmul.ac.uk)                    
 *   Anil Bharath (a.bharath@imperial.ac.uk)                    
                                                                    
                                                                    
Biologically Inspired Computer Vision Group                        
                                                                    
Web: http://www.bicv.org                                           

## Requirements:

`SIFT`, `DSIFT`, `VLAD` and kernel implementations require `VLFEAT` (http://www.vlfeat.org/)
Clustering requires `kmeans_bo.m` by Liefeng Bo (http://research.cs.washington.edu/istc/lfb/).
`LibSVM` is used to implement SVM classification (http://www.csie.ntu.edu.tw/~cjlin/libsvm/).
`LLC_coding_appr.m` is part of MATLAB's `LLC` package (http://www.ifp.illinois.edu/~jyang29/LLC.htm)

A downloadable version of the required libraries and code can be found in the `Downloads` section of the repository. [Link](https://bitbucket.org/josemrivera/bow_pipeline_toolkit/downloads/bovw_toolkit_lib.zip) to libraries:

## Data:

This toolkit can be used with any dataset. However, a 4-object version of Caltech-101
is included in the 'Downloads' section of the repository. [Link](https://bitbucket.org/josemrivera/bow_pipeline_toolkit/downloads/4_ObjectCategories.zip) to 4-object Caltech-101.

## Running Instructions:

1. Run `setup.m` for the installation of the 3rd party libraries.
2. Run `main.m` 

## Instructions for beginners:


A *beginners* version of the toolkit, consisiting of a simple Hard Assignment bag-of-visual-words
model for object classification is included as `BOVWdemo.m`

### Steps

0. Download and unzip the `bovw_pipeline_lib.zip` from the [Downloads](https://bitbucket.org/josemrivera/bow_pipeline_toolkit/downloads) section.
1. Run `setup.m`
2. Run `BOVWdemo.m`
