function [HoVW_all] = build_histograms(datasetDir,params,dataset,dictDir)

% BUILD HISTOGRAMS represents a set of images as histograms of visual words
% from a codebook.

featSuffix = params.feat;

% Load dictionary of training images

dictFname = sprintf('dictionary_%d.mat',params.dictionarySize);
load(fullfile(dictDir,dictFname));

for cat = 1:length(dataset)
    
    numImgs  = length(dataset(cat).files);
    catPath  = fullfile(datasetDir,dataset(cat).className);
    HoVW_all = [];
    
    for img = 1:numImgs
        
        % Load image        
        [~,imgFname,~] = fileparts(dataset(cat).files{img});
        featFname      = fullfile(catPath,[imgFname '.' featSuffix]);
        load(featFname,'features','-mat');
        
        eucDist2 = dist2(double(features.data),dictionary);
        
        [~, words_id] = min(eucDist2,[],2);
        
        % Create encodedImg struct
                encodedImg = struct('data',words_id,'x',features.x,'y',features.y,...
            'wid',features.wid,'hgt',features.hgt);
        
        HoVW = hist(words_id,1:params.dictionarySize);
        
        HoVW_all = [HoVW_all; HoVW];
        
        % Output file names
        savePath  = fullfile(catPath, sprintf('%s_encoded_%d.mat', imgFname, params.dictionarySize));
        savePath2 = fullfile(catPath, sprintf('%s_hist_%d.mat', imgFname, params.dictionarySize));
        
        % Save the data for each image
        save(savePath,'encodedImg');
        save(savePath2,'HoVW');
        
        % Processing message
        fprintf('Processing %s: %.2f%% completed...\n', ...
            imgFname, img/dataset(cat).numImages*100);
        
    end % end for numImgs
    
    fprintf('\nFinished category %s\n\n',dataset(cat).className);
    
    %% Save histograms of all images in a category in this directory in a single file
    
    savePathAll = fullfile(catPath, sprintf('histograms_%d.mat', params.dictionarySize));
    save(savePathAll, 'HoVW_all', '-ascii');
    
end % end for categories

end % end function