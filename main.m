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

libPath = './lib';
utilsPath = './utils';
addpath(libPath,utilsPath);


% Feature Parameters

features.data = siftArr;
features.x = gridX(:);% + params.patchSize/2 - 0.5;
features.y = gridY(:);% + params.patchSize/2 - 0.5;
features.wid = wid;
features.hgt = hgt;

% Parameters

params = struct(...
    'feat',             'sift',...      % Feature type
    'maxImageSize',     300,...
    'gridSpacing',      2,...
    'patchSize',        16,...
    'dictionarySize',   4000,...        % Number of visual words
    'numTrainImages',   30,...          % # Training or "texton" images
    'numTestImages',    50,...          % # Test images, -1 for all - training
    'kmeans',           struct(...
      'maxIter',          50,...          % Max # k-means iterations
      'maxNumFeats',      100000,...      % Max number of descriptors to be used
      'normHist',         1),...          % 1 to normalise histograms, 0 otherwise
    'pyramidLevels',      3);           % Number of spatial pyramid levels

