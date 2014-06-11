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

userdata_BOVWdemo

%% 1. Split the dataset between train and test sets

dataset = splitDataset(datasetDir,params.numTrainImages,params.numTestImages);

%% 2. Compute or load features

feature_extraction(datasetDir,dataset,params);

%% 3. Compute or load dictionary of visual words

create_dictionaries(datasetDir,params,dataset,dictDir);

%% 4. ENCODING METHOD

% Hard assignment: Quantize all descriptors in the dataset

build_histograms(datasetDir,params,dataset,dictDir);

%% 5. Perform classification

% 5.1 Gather the data from all categories and prepare it for SVM input and
% cross-validation.

[featTrain,featTest] = gather_data(dataset,datasetDir,params);

% 5.2 Linear SVM

[svmModel,prediction] = linear_svm(featTrain,featTest,dataset,params);

