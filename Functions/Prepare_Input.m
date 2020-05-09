function [X_l, X_l_un, Y, Y_pl, W_l, W, L, Z_l, Z_l_un] = Prepare_Input(TrainMS, TrainHS, Un_MS_CC, TrainLabel, Un_MS_pl_CC, param, isClustering, num)

%% Input:
%         TrainMS         - training samples for multispectral data,each 
%                           column vector of the data is a sample vector
%         TrainHS         - training samples for hyperspectral data,each 
%                           column vector of the data is a sample vector
%         Un_MS_CC        - unlabled samples for multispectral data,each 
%                           column vector of the data is a sample vector
%         TrainLabel      - labels for training samples
%         Un_MS_pl_CC     - pseudo for unlabled samples
%         param           - parameters for LPP
%                         - k     : the number of neighbor
%                         - d     : subspace dimension
%                         - sigma : standard deviation for Gaussian kernel
%         isClustering    - 'True' : run the clustering for large-scale data
%                         - 'False': output the original data
%         num             - specify the number of cluster center if isClustering is True    

%% Ouput:
%         X_l             - labeled modalities for model input, e.g., X_l = [X_HS, 0
%                                                                             0, X_MS]         
%         X_l_un          - labeled and unlabeled modalities for model input, e.g., X_l = [X_HS, 0,   0
%                                                                                           0, X_MS, X_Un]  
%         Y               - one-hot encoded label matrix
%         W_l             - labeled graph matrix
%         W               - graph matrix
%         L               - Laplacian matrix
%         Z_l             - initialized latent subspace of the labeled modalities obtained by LPP
%         Z_l_un          - initialized latent subspace of the labeled and unlabeled modalities obtained by LPP
    
if strcmp(isClustering, 'False')
    
    X_1 = [TrainHS; zeros(size(TrainMS))];
    X_2 = [zeros(size(TrainHS)); TrainMS];
    X_3 = [zeros(size(TrainHS, 1), size([TrainMS, Un_MS_CC], 2)); [TrainMS, Un_MS_CC]];
    
    X_l = [X_1, X_2];
    X_l_un = [X_1, X_3];
    
    %one hot encoding for training labels and pseudo-labels
    Y = OneHotEncoding(TrainLabel, max(TrainLabel));
    Y_pl = OneHotEncoding(Un_MS_pl_CC, max(Un_MS_pl_CC));
     
    %generate labeled graph matrix(W_l), graph matrix(W) and Laplacian matrix(L)
    d = pdist([TrainLabel, TrainLabel]');
    d = squareform(d);
    d(d > 0) = -1;
    d(d == 0) = 1;
    d(d < 0) = 0;
    W_l = d;
    
    dis = pdist([TrainLabel, TrainLabel, Un_MS_pl_CC]');
    dis = squareform(dis);
    dis(dis > 0) = -1;
    dis(dis == 0) = 1;
    dis(dis < 0) = 0;
    W = dis;
    L = diag(sum(W)) - W;
    
    LP = DR_LPP(X_l_un, param.k ,param.d, param.sigma, W); %LP: linear projections learned by LPP
    Z = LP' * X_l_un;
    Z_l = Z(:, 1 : size(X_l, 2));
    Z_l_un = Z;
end

if strcmp(isClustering, 'True')
    
    if nargin < 8
        error('Please specify the number of cluster center (num)!')
    end
    
    %feature stacking
    Train_HSMS = [TrainHS;TrainMS];
    
    %generate cluster centers and corresponding labels
    [Train_HSMS_CC,TrainLabel_CC] = Create_Cluster_Center(Train_HSMS, TrainLabel, num);
    
    %cluster centers for HS and MS, respectively
    TrainHS_CC = Train_HSMS_CC(1 : size(TrainHS, 1), :);
    TrainMS_CC = Train_HSMS_CC(size(TrainHS, 1) + 1 : end, :);
    
    X_1 = [TrainHS_CC; zeros(size(TrainMS_CC))];
    X_2 = [zeros(size(TrainHS_CC)); TrainMS_CC];
    X_3 = [zeros(size(TrainHS_CC, 1), size([TrainMS_CC, Un_MS_CC], 2)); [TrainMS_CC, Un_MS_CC]];
    
    X_l = [X_1, X_2];
    X_l_un = [X_1, X_3];
    
    %one hot encoding for training labels
    Y = OneHotEncoding(TrainLabel_CC, max(TrainLabel_CC));
    Y_pl = OneHotEncoding(Un_MS_pl_CC, max(Un_MS_pl_CC));
    
    %generate labeled graph matrix(W_l), graph matrix(W) and Laplacian matrix(L)
    d = pdist([TrainLabel_CC, TrainLabel_CC]');
    d = squareform(d);
    d(d > 0) = -1;
    d(d == 0) = 1;
    d(d < 0) = 0;
    W_l = d;
    
    dis = pdist([TrainLabel_CC, TrainLabel_CC, Un_MS_pl_CC]');
    dis = squareform(dis);
    dis(dis > 0) = -1;
    dis(dis == 0) = 1;
    dis(dis < 0) = 0;
    W = dis;
    L = diag(sum(W)) - W;
    
    LP = DR_LPP(X_l_un, param.k, param.d, param.sigma, W); %LP: linear projections learned by LPP
    Z_l = LP' * X_l;
    Z_l_un = LP' * X_l_un;
end