function dataset = splitDataset(datasetDir,Ntrain,Ntest)

% SPLITDATASET Produces a random split of the dataset for each category and
% returns a boolean list with the indices of the training and test images.
%   splitDataset(main_dir,Ntrain,Ntest) For each category randomly selects
%   Ntrain training images and min(Ntotal-Ntrain,Ntest) test images
%
%   Inputs:
%       main_dir: the directory containing the dataset. E.g. in the case of
%       4 categories (cat1, cat2, cat3, cat4) the directory structure
%       should be:
%           main_dir/cat1, main_dir/cat2 ...
%       Ntrain: number of training images Ntest: number of test images
%
%   Output:
%       dataset, a structure array with the following fields: 
%       numImages:  
%       classname: 'airplanes'; 
%       files: cell array with file names withouth path,
%       e.g. cat1_00001.jpg
%       train_id: Boolean array indicating training files
%       test_id: Boolean array indicating test files

% Constants

validFileExtensions = {'.jpg','.jpeg','tif','.tiff','.png','bmp'};


categoryDirs = dir(datasetDir);

% Remove everything that is not a folder

categoryDirs(~[categoryDirs.isdir]) = [];

% Remove '..' and '.' dirs

categoryDirs = categoryDirs(3:end);
    
% For loop

for cat = 1:length(categoryDirs)
   
    % Get the indices of the valid image files within each category
    
    catDir     = fullfile(datasetDir,categoryDirs(1).name);
    file       = dir(catDir);
    fileNames  = {file.name};
    [~,~,exts] = cellfun(@(x) fileparts(x),fileNames,'UniformOutput',0);
    idxExts    = cellfun(@(x) strcmpi(exts,x),validFileExtensions,'UniformOutput',0);
    validIds   = cell2mat(idxExts');
    validIds   = sum(validIds,1);     
    imgs       = file(find(validIds));
        
    imgIds = randperm(length(imgs));     % Permute the indices
    
    
    % Fill in the dataset structure
    
    dataset(cat).numImages = length(imgs);
    dataset(cat).className = categoryDirs(cat).name;
    dataset(cat).files       = {imgs(:).name};
    
    dataset(cat).train_id                = false(1,dataset(cat).numImages);
    dataset(cat).train_id(imgIds(1:Ntrain)) = true;
    
    dataset(cat).test_id = false(1,dataset(cat).numImages);
    dataset(cat).test_id(imgIds(Ntrain+1:Ntrain + ...
        min(Ntest,dataset(cat).numImages-Ntrain))) = true;
    
end
    
end