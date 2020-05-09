function [oa,pa,ua,kappa]=CCF(traindata,TrainLabel,testdata,TestLabel,nTrees)
% function classTest=CCF(traindata,TrainLabel,nTrees)
train = traindata';
trLab = TrainLabel';
test = testdata';
teLab = TestLabel';
rng(0);
CCF = genCCF(nTrees,train,trLab); %train ccf model
classTest = predictFromCCF(CCF,test); %predict using trained model
[M,oa,pa,ua,kappa] = confusionMatrix( teLab, classTest ); %%evaluation on test sample
end