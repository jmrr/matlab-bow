% MAIN  Main script to run BOW_PIPELINE
%   Edit this script to choose the feature parameters for BOW_PIPELINE. The
%   rest of the parameters can be found in userdata.m
%   
%   If this is the first time you use BOW_PIPELINE, run setup.m before
%   running this script
%
%   See also USERDATA, SETUP
%
%   Copyright 2014 Jose Rivera @ BICV group Imperial College London.

% PATHS

%% 0. Choose parameters in userdata and run the script

userdata

%% 1. Split the dataset between train and test sets

dataset = splitDataset(datasetDir,params.numTrainImages,params.numTestImages);

%% 2. Compute or load features

feature_extraction(datasetDir,dataset,params);

%% 3. Generate histogram of visual words

create_dictionaries(datasetDir,params,dataset,dictDir);