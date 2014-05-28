function [] = feature_extraction(datasetDir,dataset,params)

% FEATURE_EXTRACTION extracts local features
%
% feature_extraction(datasetDir,dataset,params) extracts the descriptors
% indicated by the option params.feat and stores them in
% datasetDir/features/params.feat.
%
% Authors: Jose Rivera-Rubio and Ioannis Alexiou
%          {jose.rivera,ia2109}@imperial.ac.uk
% Date: May, 2014

% CONSTANT GLOBAL variables
% % Feature Parameters
%
% features.data = d;              % Descriptor data
% features.x    = f(1,:);         % Row coordinate
% features.y    = f(2,:);         % Col coordinate
% features.wid  = wid;            % Width of the image
% features.hgt  = hgt;            % Height of the image
% features.patchSize = 4*binSize; % Patch size in pixels of the desc.

% Force to compute descriptors flag

computeDescriptors = 0;

binSize = params.binSize;
stride  = params.gridSpacing;
fileExt = params.feat;
magnif  = 3;


for cat = 1:length(dataset)
    
    catPath = fullfile(datasetDir,dataset(cat).className);
    
    parfor img = 1:dataset(cat).numImages
        
        imgFname    = dataset(cat).files{img};
        imgPath     = fullfile(catPath,imgFname);
        [~,fname,~] = fileparts(imgFname);
        featFname   = fullfile(catPath,[fname '.' fileExt]);
        
        % Skip if feature already computed
        
        if (exist(featFname,'file') && ~computeDescriptors)
            fprintf('File exists! Skipping %s \n',featFname);
            continue;
        end;
        
        I       = imread(imgPath);
        if ndims(I) > 2
            I = single(rgb2gray(I));
        else
            I = single(I);
        end
        
        Ir  = rescale_max_size(I, params.maxImageSize, 0);
        wid = size(Ir,2);
        hgt = size(Ir,1);
        
        I       = vl_imsmooth(Ir,(binSize/magnif)^2 - .25);
        [f, d]  = vl_dsift(I,'step',stride,'size',binSize);
        
        % Construct the final struct
        
        features = struct('data',single(d'),'x',f(1,:),'y',f(2,:),...
            'wid',wid,'hgt',hgt,'patchSize',4*binSize);
        
        fprintf('Processing %s: wid %d, hgt %d, grid size: %d x %d, %d patches,%.2f%% completed...\n', ...
            imgFname,wid , hgt,...
            (wid-features.patchSize)/params.gridSpacing, ...
            (hgt-features.patchSize)/params.gridSpacing, ...
            ((hgt-features.patchSize)*(wid-features.patchSize))/params.gridSpacing,...
            img/dataset(cat).numImages*100);
        
        % Save file with file name: img_file_name_descriptor_type.mat
        
        parSave(featFname,features);
        
    end % end for loop images within a category
    
    fprintf('\nFinished category %s\n\n',dataset(cat).className);
    
    
end % end for loop categories


end % end feature_extraction function

function parSave(featFname,features)

save(featFname,'features');

end