function pred_CM = Generate_CM(MSI, TR_map)

    [m, n, ~] = size(MSI);
    MSI2d = hyperConvert2d(MSI);
    MSI2d = mat2gray(MSI2d);
    TR_map2d = hyperConvert2d(TR_map);
        
    l_Tr = find(TR_map2d > 0);
    TrainMS = MSI2d(:, l_Tr);
    TrainLabel = TR_map2d(:, l_Tr);    
    
    %predict unlabeled samples using CCF classifier
    rng(1);
    nTrees = 100;
    CCF = genCCF(nTrees, TrainMS', TrainLabel'); %train ccf model
    pred_class = predictFromCCF(CCF, MSI2d'); %predict using trained model
    pred_CM = hyperConvert3d(pred_class, m, n); %classification map
    
end