function theta = Solving_Theta(Y, P, H, X, beta, maxiter, L, XX)

epsilon = 1e-6;
iter = 0;

[l, ~] = size(H);
[D, ~] = size(X);

G = zeros(l, D);
lamda1 = zeros(size(H));
lamda2 = zeros(size(G));

stop = false;
theta = zeros(size(G));
mu = 1E-3;
rho = 1.5;
mu_bar = 1E+6;

GL = XX * L * XX';

while ~stop && iter < maxiter + 1
    
    iter = iter + 1;
    
    %update H  
    H = (P' * P + mu * eye(size(P' * P))) \ (P' * Y + mu * (theta * X) - lamda1);
    
    %update theta
    theta = (mu * (H * X') + lamda1 * X' + mu * G + lamda2) / (mu * (X * X') + mu * eye(size(X * X')) + beta * GL);     
    
    %update G for sovling orthogonal constraint
    Q = theta - lamda2 / mu;  
    [U, ~, V] = svd(Q);
    G = U * eye(size(theta)) * V';
 
    lamda1 = lamda1 + mu * (H - theta * X);
    lamda2 = lamda2 + mu * (G - theta);

    mu = min(mu * rho, mu_bar);

    r_H = norm(H - theta * X, 'fro');
    r_G = norm(G - theta, 'fro');

    if r_H < epsilon && r_G < epsilon
        stop = true;
        break;
    end
    
end

end
