function W = learning_alignment(Z1, Z2, gama, maxiter, W)

epsilon = 1e-6;
iter = 0;

U = zeros(size(W));
T = zeros(size(W));
S = zeros(size(W));
M=W;

lamda1=zeros(size(W));
lamda2=zeros(size(W));
lamda3=zeros(size(W));
lamda4=zeros(size(W));

stop = false;
mu = 1e-2;
rho = 2;
mu_bar = 1E+6;

d = pdist2(Z1',Z2');
weighted = d.^2;



while ~stop && iter < maxiter + 1
    

    iter=iter+1;
    
    W_temp = W;
    
    W = (1 / 4) * (M + S + T + U +(lamda1 + lamda2 + lamda3 + lamda4) / mu);
    U = max(W - (lamda1 / mu), 0);
    T = min(W - (lamda2 / mu), 1 / 10);
    
    Q = W - lamda4 / mu;
    S = size(W, 2) * Q / sum(sum(Q));    
    M = max(abs(W - lamda3 / mu) - (0.25 * gama * weighted / mu), 0).* sign(W - lamda3 / mu); 

    lamda1 = lamda1 + mu * (U - W);
    lamda2 = lamda2 + mu * (T - W);
    lamda3 = lamda3 + mu * (M - W);
    lamda4 = lamda4 + mu * (S - W);
    mu = min(mu * rho, mu_bar);

    r = norm(W - W_temp, 'fro');
    r_U = norm(U - W, 'fro');
    r_V = norm(T - W, 'fro');
    r_M = norm(M - W, 'fro');
    r_S = norm(S - W, 'fro');
    
    if r_M < epsilon && r_U < epsilon && r_S < epsilon && r < epsilon && r_V < epsilon
        stop = true;
        break;
    end

end

end