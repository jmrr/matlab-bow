% SETUP library setup for BOW_PIPELINE
%   Edit this script to specify the versions for the current libraries:
%       - libsvm
%       - vlfeat Matlab toolbox
%
%   These libraries should be located in ./lib for the current code to
%   work out of the box.
%
%   Copyright 2014 Jose Rivera @ BICV group Imperial College London.


wd         = pwd;    % Current directory
libpath    = './lib';

% LibSVM info

libsvmver  = 'libsvm-3.18';
libsvmpath = fullfile(libpath,libsvmver,'matlab');

% VLFEAT info

vl_ver     = 'vlfeat-0.9.18';
vlfeatpath = fullfile(libpath,vl_ver,'toolbox');

% Setup

archStr = computer('arch');

if(strcmp(archStr,'win64'))
%     lapacklib = fullfile(matlabroot, ...
%         'extern', 'lib', 'win64', 'microsoft', 'libmwlapack.lib');
%     blaslib = fullfile(matlabroot, ...
%         'extern', 'lib', 'win64', 'microsoft', 'libmwblas.lib');
%     command =  'mex(''LLCEncodeHelper.cpp'', lapacklib, blaslib, largeArrayDims)';
      command = 'mex -setup';  
elseif(strcmp(archStr,'win32'))
%     lapacklib = fullfile(matlabroot, ...
%         'extern', 'lib', 'win32', 'microsoft', 'libmwlapack.lib');
%     blaslib = fullfile(matlabroot, ...
%         'extern', 'lib', 'win32', 'microsoft', 'libmwblas.lib');
%     command =  'mex(''LLCEncodeHelper.cpp'', lapacklib, blaslib)';
      command = 'mex -setup';  

elseif strcmp(archStr,'glnx86')
%     command = 'mex -O LLCEncodeHelper.cpp -lmwlapack -lmwblas';
      command = 'mex -setup';  

elseif strcmp(archStr,'glnxa64')
%     command = 'mex -O LLCEncodeHelper.cpp -lmwlapack -lmwblas -largeArrayDims';
      command = 'mex -setup';  

else
    error('System architecture could not be identified');
end

eval(command);  % Mex setup         

% Installing LIBSVM

cd(libsvmpath);
fprintf('\nInstalling %s...\n',libsvmver);
make;

% Installing VLFEAT

cd(wd);         % Return to working directory
fprintf('\nInstalling %s...\n',vl_ver);
run(fullfile(vlfeatpath,'vl_setup'));
vl_version('verbose');
