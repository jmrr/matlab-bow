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

%% 4. ENCODING METHODS

% 4.1 Hard assignment: Quantize all descriptors in the dataset

build_histograms(datasetDir,params,dataset,dictDir);

% 4.1 LLC coding

llc_coding(dataset,datasetDir,params,dictDir)

%% (5 optional) Construct spatial pyramids for Spatial Pyramid Matching

% 5.1 Spatial Pyriamid Matching (with Hard Assignment)

pyramid_all = compile_pyramid(dataset,datasetDir,sprintf('_HA_encoded_%d.mat',params.dictionarySize),params);

% 5.2 SPM with LLC.

%% 6. Perform classification

% 6.1 Gather the data from all categories and prepare it for SVM input and
% cross-validation.

[featTrain,featTest,labelsTrain,labelsTest] = gather_data(dataset,datasetDir,params);

% 6.2 Linear SVM
[svmModel,prediction] = linear_svm(featTrain,featTest,labelsTrain,labelsTest,dataset,params);
