function [ pyramid_all ] = compile_pyramid(dataset, datasetDir, textonSuffix, params)

% COMPILE_PYRAMID GenerateS the pyramid from the texton lablels
%
%     For each image the texton labels are loaded. Then the histograms are
%     calculated for the finest level. The rest of the pyramid levels are
%     generated by combining the histograms of the higher level.
%
%     - imageFileList: cell of file paths dataBaseDir: the base directory for
%     the data files that are generated by the algorithm. If this dir is
%     the same as imageBaseDir the files will be generated in the same
%     location as the image file.
%      - textonSuffix: this is the suffix appended to the image file name
%      to denote the data file that contains the textons indices and
%     coordinates. Its default value is '_texton_ind_%d.mat'
%     [_encoded_%d.mat for this mod of the code] where %d is the dictionary
%     size. params.dictionarySize: size of descriptor dictionary (200 has
%     been found to be a good size)
%     - params.pyramidLevels: number of levels of the pyramid to build
%     canSkip: if true the calculation will be skipped if the appropriate
%     data file is found in dataBaseDir. This is very useful if you just
%     want to update some of the data or if you've added new images.

%   Original code by Joe Tighe (jtighe@cs.unc.edu) and Svetlana Lazebnik
%   (lazebnik@cs.unc.edu)
%    1/17/2009
%
%   Modified by Jose Rivera (jose.rivera@imperial.ac.uk) 28/5/2014
%
fprintf('Building Spatial Pyramid\n\n');

%% parameters

if(~exist('params','var'))
    params.maxImageSize = 1000;
    params.gridSpacing = 8;
    params.patchSize = 16;
    params.dictionarySize = 200;
    params.numTextonImages = 50;
    params.pyramidLevels = 3;
end
if(~isfield(params,'maxImageSize'))
    params.maxImageSize = 1000;
end
if(~isfield(params,'gridSpacing'))
    params.gridSpacing = 8;
end
if(~isfield(params,'patchSize'))
    params.patchtexton_indSize = 16;
end
if(~isfield(params,'dictionarySize'))
    params.dictionarySize = 200;
end
if(~isfield(params,'numTextonImages'))
    params.numTextonImages = 50;
end
if(~isfield(params,'pyramidLevels'))
    params.pyramidLevels = 3;
end

binsHigh = 2^(params.pyramidLevels-1);

pyramidLevels = params.pyramidLevels;
dictSize      = params.dictionarySize;

for cat = 1:length(dataset)
    
    numImgs     = length(dataset(cat).files);
    catPath     = fullfile(datasetDir,dataset(cat).className);
    pyramid_all = zeros(numImgs,dictSize*sum((2.^(0:(pyramidLevels-1))).^2));
    
    for img = 1:numImgs
        
        % Image base name
        [~,imgFname,~] = fileparts(dataset(cat).files{img});
        
        % Output save path
        outFName = fullfile(catPath,...
            sprintf('%s_pyramid_%d_%d.mat',imgFname, dictSize, pyramidLevels));
        
        if(size(dir(outFName),1))
            fprintf('Skipping %s\n', imgFname);
        end
        
        % Load texton indices (training codebook indices that represent an image)
        in_fname = fullfile(catPath, sprintf('%s%s', imgFname, textonSuffix));
        load(in_fname, 'encodedImg');
        
        % Get width and height of input image
        wid = encodedImg.wid;
        hgt = encodedImg.hgt;
        
%         fprintf('Loaded %s: wid %d, hgt %d\n', imgFname, wid, hgt);
        
        % Compute histogram at the finest level
        pyramid_cell = cell(pyramidLevels,1);
        pyramid_cell{1} = zeros(binsHigh, binsHigh, dictSize);
        
        for i=1:binsHigh
            
            for j=1:binsHigh
                
                % find the coordinates of the current bin
                x_lo = floor(wid/binsHigh * (i-1));
                x_hi = floor(wid/binsHigh * i);
                y_lo = floor(hgt/binsHigh * (j-1));
                y_hi = floor(hgt/binsHigh * j);
                
                texton_patch = encodedImg.data( ...
                    (encodedImg.x > x_lo) & ...
                    (encodedImg.x <= x_hi) & ...
                    (encodedImg.y > y_lo) &...
                    (encodedImg.y <= y_hi));
                
                % make histogram of features in bin
                binCenters = (1:dictSize);
                HoVW       = hist(texton_patch,binCenters);
                pyramid_cell{1}(i,j,:) = HoVW./length(encodedImg.data);
            end
            
        end
        
        % Compute histograms at the coarser levels  by combining the
        % histograms of the higher level.
        
        num_bins = binsHigh/2;
        
        for l = 2:pyramidLevels
            pyramid_cell{l} = zeros(num_bins, num_bins, dictSize);
            for i = 1:num_bins
                for j = 1:num_bins
                    pyramid_cell{l}(i,j,:) = ...
                        pyramid_cell{l-1}(2*i-1,2*j-1,:)...
                        + pyramid_cell{l-1}(2*i,2*j-1,:)...
                        + pyramid_cell{l-1}(2*i-1,2*j,:)...
                        + pyramid_cell{l-1}(2*i,2*j,:);
                end
            end
            num_bins = num_bins/2;
        end
        
        % Stack all the histograms with appropriate weights
        pyramid = [];
        
        for l = 1:pyramidLevels-1
            pyramid = [pyramid pyramid_cell{l}(:)' .* 2^(-l)];
        end
        pyramid = [pyramid pyramid_cell{pyramidLevels}(:)' .* 2^(1-pyramidLevels)];
        
        % Save pyramid
        save(outFName, 'pyramid');
        
        pyramid_all(img,:) = pyramid;
        
        % Processing message
        fprintf('Processing pyramid for image %s: %.2f%% completed...\n', ...
            imgFname, img/dataset(cat).numImages*100);
        
        
    end % end for numImgs
    
    fprintf('\nFinished spatial pyramid computation for category %s\n\n',dataset(cat).className);

    
    outFName = fullfile(catPath, sprintf('pyramids_all_%d_%d.mat', ...
        dictSize, pyramidLevels));
    save(outFName, 'pyramid_all');
    
    
end % end for categories

end % end function
