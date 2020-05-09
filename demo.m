clc;
clear;
close all;

addpath('Data'); %load data
addpath('Functions'); %load functions used for LeMA
addpath('SVM'); %load SVM classifier
addpath('CCF'); %load CCF classifier

%load data, if you wanna run this code in your own data, please change
%the following data using your data.
load MS_HR_Houston.mat; % size: M * N * Z (M and N: width and length of the image, Z: band)
load HS_LR_Houston.mat; % size: M * N * Z (M and N: width and length of the image, Z: band)
load TrainImage.mat; % size: M * N (M and N: width and length of the image)
load TestImage.mat; % size: M * N (M and N: width and length of the image)

%% Generate classification map for initializing the graph of unlabeled samples
pred_CM = Generate_CM(data_MS_HR, TrainImage);

%% Generate samples and labels
[TrainMS, TestMS, Un_MS_CC, TrainHS, TrainLabel,TestLabel, Un_MS_pl_CC] ...
                          = Generate_Sample_Label(data_HS_LR, data_MS_HR, TrainImage, TestImage, pred_CM);

%LPP's parameters used for initializing CoSpace
param.k = 10;
param.d = 30;
param.sigma = 1;

isClustering = 'True';
num = 10; %the number of cluster center

%CoSpace's parameters
maxiter = 1000;
alfa = 0.01;
beta = 0.01;

%% Prepare model's input,including
[X_l, X_l_un, Y, Y_pl, W_l, W, L, Z_l, Z_l_un] ...
         = Prepare_Input(TrainMS, TrainHS, Un_MS_CC, TrainLabel, Un_MS_pl_CC, param, isClustering, num);

%% Run the model
[thetaT, ~, learned_W] = LeMA([Y, Y], X_l, X_l_un, Z_l, alfa, beta, L, W, maxiter, W_l);

%% Label propagation
pro = CalProbability(learned_W); %compute the probabilities
[~, Label, ind] = LP([Y,Y],zeros(size(Y_pl)), pro, maxiter); %LP
updated_label = Label(:, size(X_l, 2) + 1 : end);
x = find(ind(size(X_l, 2) + 1:end) > 0.4); %select the potential unlabeled samples
selected_labels = updated_label(:, x);

f = [TrainMS, Un_MS_CC(:,x), TestMS];
f = thetaT(:, size(TrainHS, 1) + 1 : end) * f; %project into the learned subspace

updated_trainLabel = [TrainLabel, selected_labels];

% feature normalization
for i = 1 : size(f, 1)
     f(i, :) = mat2gray(f(i, :));
end

traindata = f(:, 1 : length(updated_trainLabel));
testdata = f(:, length(updated_trainLabel) + 1 : end);

oa_SVM = LSVM(traindata, updated_trainLabel, testdata, TestLabel);
oa_CCF = CCF(traindata, updated_trainLabel, testdata, TestLabel, 100);
