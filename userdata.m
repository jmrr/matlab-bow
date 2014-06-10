% USERDATA  User data for BOW_PIPELINE
%   Edit this script to enter the information you need for BOW_PIPELINE.
%
%   * Specify paths for the 3rd party libraries
%
%
%   Copyright 2014 Jose Rivera @ BICV group Imperial College London.

%% PATHS



libPath    = './lib';                   % Lib path (3rd party libraries and code)
utilsPath  = './utils';                 % Utils path (utils code)
datasetDir = '../dataset/data';         % Dataset path
dictDir    = '../dataset/dict'; % Dictionary path

lp         = genpath(libPath);
addpath(lp,utilsPath);

% Library initialisation (required for VLFeat)
vl_setup;

% Parameters

params = struct(...
    'feat',             'dsift',...    % Feature type: 'dsift', 'sift'
    'maxImageSize',     300,...
    'gridSpacing',      2,...
    'binSize',          4,...          % Correspond to patchsize = 4*binSize (assuming SIFT and 4x4 bin descriptor)
    'dictionarySize',   400,...        % Number of visual words
    'numTrainImages',   30,...         % # Training images
    'numTestImages',    40,...         % # Test images, -1 for all - training
    'kmeans',           struct(...
      'maxIter',          30,...         % Max # k-means iterations
      'maxNumFeats',      100000,...     % Max number of descriptors to be used
      'normHist',         1),...         % 1 to normalise histograms, 0 otherwise
    'pyramidLevels',    3,...          % Number of spatial pyramid levels
    'encodingMethod',   'HA');        % Encoding methods 'HA', 'llc'...

