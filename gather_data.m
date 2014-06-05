function [featTrain,featTest,labelsTrain,labelsTest] = gather_data(dataset,datasetDir,params)

% Initialise  values

featTrain   = [];
featTest    = [];
labelsTrain = [];
labelsTest  = [];

for cat = 1:length(dataset)
    
    % Concatenate the svm training and test features
    trainIndices = dataset(cat).train_id;
    testIndices  = dataset(cat).test_id;
    
    numTrainSam  = sum(trainIndices);
    numTestSam   = sum(testIndices);
    % Load training features
    
    load(fullfile(datasetDir,dataset(cat).className,...
        [params.encodingMethod '_' num2str(params.dictionarySize) '.mat']));
    
    featTrain   = [featTrain; LLC_all(trainIndices,:)];
    featTest    = [featTest; LLC_all(testIndices,:)];
    
    labelsTrain = [labelsTrain; cat*(ones(numTrainSam,1))];
    labelsTest  = [labelsTest; cat*(ones(numTestSam,1))];
end % end for categories

end