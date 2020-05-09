function [Y, in, ma] = LP(YL, YU, P, maxiter)

[~, N] = size(YL);
FU = YU;
E = zeros(1, maxiter);
e = 1e-8;
PUU = P(N + 1 : end, N + 1 : end);
PUL = P(1 : N, N + 1: end);

for i = 1 : maxiter
    
    F_t = FU;
    FU = F_t * PUU + YL * PUL;
    E(1, i) = sum(sum(abs(FU - F_t)));
    if i > 1
        if E(1, i) < e
            break;
        end
    end

end
[ma, in] = max([YL, FU]);
Y = OneHotEncoding(in, max(in));
end