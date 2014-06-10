function [svmModel,prediction] = precomp_kernel_svm(kernelTrain,kernelTest,dataset,params)

% SVM PARAMETERS

KERNEL_TYPE   = 4;  % 0 -- linear
                    % 1 -- polynomial
                    % 2 -- radial basis function
                    % 3 -- sigmoid
                    % 4 -- precomputed kernel (kernel values in training_set_file)
CROSS_VALID_N = 5;



initTrain     = 1;
initTest      = 1;

for cat = 1:length(dataset)
    
    trainLabels  = -1*ones(size(kernelTrain,1),1);
    testLabels   = -1*ones(size(kernelTest,1),1);
    trainIndices = initTrain:initTrain+params.numTrainImages-1;
    testIndices  = initTest:initTest+params.numTrainImages-1;
    
    trainLabels(trainIndices) = 1;
    testLabels(testIndices)   = 1;    
    
    initTrain = initTrain + params.numTrainImages; % Advance in the training stack
    initTest  = initTest + params.numTestImages;   % Advance in the testing stack
    
    fprintf('Now training SVM for %s ...\n',dataset(cat).className)
    
    c_vals = [1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.6 3.8 4 4.2 4.4 4.6 4.8 ...
             5 5.2 5.4 5.6 5.8 6 6.2 6.4 6.6 6.8 7 7.2 7.4 7.6 7.8];
    
%     c_vals = logspace(7,10,CROSS_VALID_N);

    for ci = 1:length(c_vals);
        
        % svmParams: -t (kernel type), -v (N fold x-valid), -c (cost),
        % -b (probability estimates), -q (quiet)
        
        svmParams = sprintf('-t %d -v %d -c %f -b %d -q',KERNEL_TYPE,CROSS_VALID_N,c_vals(ci),1);
                
        model(ci) = svmtrain(trainLabels,[(1:size(kernelTrain,1))' ,kernelTrain],svmParams);
        
    end
    
    % Select the best C among c_vals and retrain.
    
    [~,best_c] = max(model);
    
    svmParams = sprintf('-t %d -c %f -b %d -q',KERNEL_TYPE,c_vals(best_c),1);
    
    svmModel(cat) = svmtrain(trainLabels,[(1:size(kernelTrain,1))' ,kernelTrain],svmParams);
    
    
    % Test the model on the testing set     
    [predicted_label, accuracy, estimates] = svmpredict(testLabels,[(1:size(kernelTest,1))' ,kernelTest],svmModel(cat),'-b 1');
    
    prediction{cat}.predicted_label = predicted_label;
    prediction{cat}.accuracy        = accuracy;
    prediction{cat}.estimates       = estimates;
    
end % end num categories


end % end function

