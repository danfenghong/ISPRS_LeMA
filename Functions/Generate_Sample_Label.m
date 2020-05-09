function [TrainMS, TestMS, Un_MS_CC, TrainHS, TrainLabel,TestLabel, Un_MS_pl_CC] ...
                           = Generate_Sample_Label(HSI, MSI,TR_map, TE_map, pred_CM)

[m, n, ~] = size(MSI);
%% Band-wise filtering for the MSI before running the superpixel segmentation
    for i=1:size(MSI,3)
        MSI(:,:,i)=filter2(fspecial('gaussian',[15 15],1),MSI(:,:,i));
    end
    
%% Generate labeled samples and labels
    HSI2d = hyperConvert2d(HSI);
    MSI2d = hyperConvert2d(MSI);
%     MSI2d = mat2gray(MSI2d);
    
    TR_map2d = hyperConvert2d(TR_map);
    TE_map2d = hyperConvert2d(TE_map);
    
    l_Tr = find(TR_map2d > 0);
    l_Te = find(TE_map2d > 0);
    
    TrainMS = MSI2d(:, l_Tr);    
    TestMS = MSI2d(:, l_Te);
    TrainHS = HSI2d(:, l_Tr);
    TrainLabel = TR_map2d(:, l_Tr);
    TestLabel = TE_map2d(:, l_Te);
   
%% Refine the predictions using superpixel segmentation
    rgb3d = zeros(m, n, 3);
    rgb3d(:, :, 1) = 255 * mat2gray(MSI(:, :, 4));
    rgb3d(:, :, 2) = 255 * mat2gray(MSI(:, :, 3));
    rgb3d(:, :, 3) = 255 * mat2gray(MSI(:, :, 2));
        
    SP_map = superpixels(rgb3d, 14000, 'Compactness',20); %superpixel segmentation
    Refined_pred_class = CM_generator(pred_CM, SP_map); %refine classification map
    Un_MS_pl = Refined_pred_class(:, l_Te); %pseudo-labels w.r.t. unlabeled samples
    [Un_MS_CC, Un_MS_pl_CC] = Create_Cluster_Center(TestMS, Un_MS_pl, 200); %reduce the computional  
                                                                            %complexity using cluster centers

end