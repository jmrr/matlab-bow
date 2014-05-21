% USERDATA  User data for BOW_PIPELINE
%   Edit this script to enter the information you need for BOW_PIPELINE.
%
%   * Specify site and estimation details for the current run in ExpOpt.
%   * Specify sampling time and start and end frames in Tim.
%   * Use as many robots and sensors as you wish with Robot{} and Sensor{}.
%   * Assign sensors to robots via Sensor{i}.robot.
%   * Use field Sensor{i}.distortion for radial distortion parameters if
%   desired.
%   * Use the field Opt.map.numLmk and .lmkSize to specify the maximum
%   number of landmarks that the SLAM map must support.
%   * Use Opt.init.initType to select the type of landmarks to use. Try
%   with one in this list:
%       'idpPnt', 'hmgPnt', 'ahmPnt', 'plkLin', 'ahmLin'.
%   * Use World.points and World.segments to create artificial worlds of
%   points or segments. Check functions THICKCLOISTER and HOUSE.
%
%   See further comments within the file for more detailed information.
%
%   NOTE: You can have multiple copies of this file with different names to
%   store different simulation conditions. Just modify the call in SLAMTB
%   to point to the particular 'USERDATA' file you want.
%
%   See also SLAMTB, EULERANGLES, THICKCLOISTER, HOUSE, USERDATAPNT,
%   USERDATALIN.

%   Copyright 2014 Jose Rivera @ BICV group Imperial College London.

% PATHS

basepath = '..';
libpath = fullfile(basepath,'lib');
addpath(libpath);

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

