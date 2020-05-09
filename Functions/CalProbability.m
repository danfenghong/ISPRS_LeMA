function P = CalProbability(W)

[m, ~] = size(W);
P = zeros(size(W));

for i = 1 : m
    if sum(W(i, :))~=0
       P(i, :) = W(i, :) / sum(W(i, :));
    end
end

end