function pred_CM2d = CM_generator(pred_CM, SP_map)

l = length(unique(SP_map));

pred_CM2d = hyperConvert2d(pred_CM);
SP_map2d = hyperConvert2d(SP_map);

for i = 1 : l
    x = find(SP_map2d == i);
    y = pred_CM2d(:, x);
    c = tabulate(y);
    [ma, in] = max(c(:,2),[],1);
    pred_CM2d(:, x) = repmat(in, 1, length(x));
end
% pred_CM_new = hyperConvert3d(pred_CM2d, size(SP_map,1), size(SP_map,2));
end