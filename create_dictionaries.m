function [] = create_dictionaries(datasetDir,params,dataset,dictDir)

% CREATE_DICTIONARIES generates a vocabulary of visual words using K-means
%
%   CREATE_DICTIONARIES(descriptors_path,params,dict_path) groups randomly
%   selected descriptors from a specific training set into
%   clusters using k-means.
%
%   Requirements: k-means code from Liefeng Bo
%   (http://homes.cs.washington.edu/~lfb/)
%
%   See also FEATURE_EXTRACTION and BUILD_HISTOGRAMS
%   
%   Author: Jose Rivera-Rubio @ BICV group Imperial College London
%           jose.rivera@imperial.ac.uk 
%           http://www.bicv.org
%
%   Date: May, 2014

if ~isfield(params.kmeans,'maxNumFeats')
    maxNumFeats = 100000; %use 4% avalible memory if its greater than the default
end

maxNumFeats    = params.kmeans.maxNumFeats;
maxNumFeatsImg = maxNumFeats/params.numTrainImages;
featSuffix        = params.feat;

fprintf('\nBuilding vocabulary of visual words:\n');

% Load all the descriptors of the training set and concatenate them into a
% single array:

allDescriptors = [];

for cat = 1:length(dataset)
    
    catPath     = fullfile(datasetDir,dataset(cat).className);
    trainLabels = find(dataset(cat).train_id);
    
    for t = 1:length(trainLabels)
        
        [~,imgFname,~] = fileparts(dataset(cat).files{t});
        featFname      = fullfile(catPath,[imgFname '.' featSuffix]);
        load(featFname,'features','-mat');
        
        data2add = features.data;
        numDesc  = size(features.data,1);
        
        % Add a balanced amount the descriptors per image
        
        if numDesc > maxNumFeatsImg
            p        = randi(numDesc,1,floor(maxNumFeatsImg));
            data2add = data2add(p,:);
        end
        
        allDescriptors = [allDescriptors ; data2add];
        
    end % end for trainLabels
    
    % Select the maxNumFeats
    
    totalDesc = size(allDescriptors,1);
    
    if totalDesc > maxNumFeats
    
        fprintf('Reducing to %d descriptors\n', maxNumFeats);
        p              = randi(totalDesc,1,maxNumFeats);
        allDescriptors = allDescriptors(p,:);
    
    end
    
    % Perform clustering
    fprintf('\nRunning K-means...\n');
    dictionary =  kmeans_bo(double(allDescriptors),params.dictionarySize,...
        params.kmeans.maxIter); % BOVW Codebook

    dictionary = dictionary'; % Back to num_words x desc_dim size
    % Saving the dictionary
    
    fprintf('Saving BOVW dictionary...\n');
    
    savepath = dictDir;
    saveFname = sprintf('dictionary_%d.mat',params.dictionarySize);
    mkdir(savepath);
    
    save(fullfile(savepath,saveFname),'dictionary');
    
	fprintf('Done.\n');


end % for categories

