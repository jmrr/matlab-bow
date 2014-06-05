function [] = llc_coding(dataset,datasetDir,params,dictDir)

dictFname  = sprintf('dictionary_%d.mat',params.dictionarySize);
load(fullfile(dictDir,dictFname)); % Load variable "dictionary"

featSuffix = params.feat;

for cat = 1:length(dataset)
    
    numImgs  = length(dataset(cat).files);
    catPath  = fullfile(datasetDir,dataset(cat).className);
    LLC_all  = [];
    
    for img = 1:numImgs
        
        % Load image
        [~,imgFname,~] = fileparts(dataset(cat).files{img});
        featFname      = fullfile(catPath,[imgFname '.' featSuffix]);
        load(featFname,'features','-mat'); % Load features
        
        % Output file names
        llcFname = sprintf('%s_LLC_encoded_%d.mat', imgFname, params.dictionarySize);
        savePath  = fullfile(catPath,llcFname);
        if (exist(savePath,'file'))
            fprintf('File exists! Skipping %s \n',llcFname);
            load(savePath);
            LLC_all = [LLC_all ; LLCimg];
            continue
        end
                
        llc = max(LLC_coding_appr(dictionary,features.data)); %max-pooling
        llc = llc/norm(llc); %L2 norm
        
        % Save the data for each image
        LLCimg  = llc;
        LLC_all = [LLC_all ; LLCimg];
        save(savePath,'LLCimg');
        
        fprintf('LLC coding applied to descriptors of image %s\n',dataset(cat).files{img});
        
    end % end for numImgs
    
    fprintf('LLC coding finished for category %s\n',dataset(cat).className);
    
    savePathAll = fullfile(catPath, sprintf('llc_%d.mat', params.dictionarySize));
    save(savePathAll, 'LLC_all');
    
end % end for categories

end %end llc_coding