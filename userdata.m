% USERDATA  User data for BOW_PIPELINE
%   Edit this script to enter the information you need for BOW_PIPELINE.
%
%   * Specify paths for the 3rd party libraries
%
%
%   Copyright 2014 Jose Rivera @ BICV group Imperial College London.

% PATHS

libPath = './lib';
lp      = genpath(libPath);
addpath(lp);


utilsPath  = './utils';
datasetDir = '../dataset/data';

addpath(utilsPath);

% Parameters

params = struct(...
    'feat',             'sift',...      % Feature type
    'maxImageSize',     300,...
    'gridSpacing',      2,...
    'binSize',        4,...
    'dictionarySize',   200,...        % Number of visual words
    'numTrainImages',   30,...          % # Training images
    'numTestImages',    50,...          % # Test images, -1 for all - training
    'kmeans',           struct(...
      'maxIter',          50,...          % Max # k-means iterations
      'maxNumFeats',      100000,...      % Max number of descriptors to be used
      'normHist',         1),...          % 1 to normalise histograms, 0 otherwise
    'pyramidLevels',      3);           % Number of spatial pyramid levels

