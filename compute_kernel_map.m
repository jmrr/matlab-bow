function [kernelTrain,kernelTest] = compute_kernel_map(dataset,datasetDir,dictDir,params,kernel)

% Load dictionary of training images

dictFname = sprintf('dictionary_%d.mat',params.dictionarySize);
load(fullfile(dictDir,dictFname));

for cat = 1:length(dataset)
    
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
    
    stackTrain = HoVW_all(trainIndices,:);
    stackTest  = HoVW_all(testIndices,:);
    
    % Normalize
    
    stackTrain = stackTrain./repmat(sum(stackTrain.^2,2)+eps,[1, params.dictionarySize]);
    stackTest  = stackTest./repmat(sum(stackTest.^2,2)+eps,[1, params.dictionarySize]);
    
    % Compute the feature maps
    psiTrain = vl_homkermap(stackTrain',1,kernel);
    psiTest  = vl_homkermap(stackTest',1,kernel);

    % Compute the kernels
    kernelTrain{cat} = psiTrain'*psiTrain;
    kernelTest{cat}  = psiTest'*psiTest;
    
end % end for images

end % end for categories
