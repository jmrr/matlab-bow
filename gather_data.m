function [featTrain,featTest] = gather_data(dataset,datasetDir,params)

% Initialise  values

featTrain   = [];
featTest    = [];

% feature type flag

encoding = params.encodingMethod;

for cat = 1:length(dataset)
    
    % Concatenate the svm training and test features
    trainIndices = dataset(cat).train_id;
    testIndices  = dataset(cat).test_id;
    
    numTrainSam  = sum(trainIndices);
    numTestSam   = sum(testIndices);
    % Load training featuresc
    
    load(fullfile(datasetDir,dataset(cat).className,...
        [params.encodingMethod '_' num2str(params.dictionarySize) '.mat']));
    
    if(strcmpi(encoding,'llc'))
        featTrain   = [featTrain; LLC_all(trainIndices,:)];
        featTest    = [featTest; LLC_all(testIndices,:)];
    elseif(strcmpi(encoding,'HA'))
        featTrain = [featTrain; HoVW_all(trainIndices,:)];
        featTest  = [featTest; HoVW_all(testIndices,:)];
    end
    
end % end for categories

end