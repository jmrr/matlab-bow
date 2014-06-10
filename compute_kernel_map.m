function [kernelTrain,kernelTest] = compute_kernel_map(dataset,datasetDir,dictDir,params,kernelType)

% Load dictionary of training images

dictFname = sprintf('dictionary_%d.mat',params.dictionarySize);
load(fullfile(dictDir,dictFname));

stackTrain = [];
stackTest  = [];

for cat = 1:length(dataset)
    
    % Initial parameters
    numImgs  = length(dataset(cat).files);
    catPath  = fullfile(datasetDir,dataset(cat).className);
    
    % Concatenate the svm training and test features
    trainIndices = dataset(cat).train_id;
    testIndices  = dataset(cat).test_id;
    
    numTrainSam  = sum(trainIndices);
    numTestSam   = sum(testIndices);
    % Load training features
    
    load(fullfile(datasetDir,dataset(cat).className,...
        [params.encodingMethod '_' num2str(params.dictionarySize) '.mat']));
    
    stackTrain = [stackTrain; HoVW_all(trainIndices,:)];
    stackTest  = [stackTest; HoVW_all(testIndices,:)];
    
end % end for categories

% Normalize

stackTrain = stackTrain./repmat(sum(stackTrain.^2,2)+eps,[1, params.dictionarySize]);
stackTest  = stackTest./repmat(sum(stackTest.^2,2)+eps,[1, params.dictionarySize]);

% Compute the feature maps
psiTrain = vl_homkermap(stackTrain',1,kernelType);
psiTest  = vl_homkermap(stackTest',1,kernelType);

% Compute the kernels
kernelTrain = psiTrain'*psiTrain;
kernelTest  = psiTest'*psiTest;

end % end
