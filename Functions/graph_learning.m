function [W, L] = graph_learning(Z, gama, maxiter, W)

epsilon = 1e-6;
iter = 0;

V = zeros(size(W));
U = zeros(size(W));
T = zeros(size(W));
S = zeros(size(W));
K = zeros(size(W));
M=W;

lamda1 = zeros(size(W));
lamda2 = zeros(size(W));
lamda3 = zeros(size(W));
lamda4 = zeros(size(W));
lamda5 = zeros(size(W));
lamda6 = zeros(size(W));
lamda7 = zeros(size(W));

stop = false;
mu = 1e-2;
rho = 2;
mu_bar = 1E+6;

d = pdist(Z');
d = squareform(d);
weighted = d.^2;

for i = 1 : size(weighted,2)
    weighted(i, i) = 1;
end

while ~stop && iter < maxiter + 1
    
    iter = iter + 1;
    
    T_temp = W;

    W = (1 / 6) * (V + U' + M + T + S + K + (lamda1 + lamda2' + lamda3 + lamda4 + lamda6 + lamda7) / mu);
    U = 0.5 * (W' + V - (lamda2 + lamda5) / mu);    
    V = 0.5 * (W + U - (lamda1 - lamda5) / mu);  
    K = max(W - (lamda7 / mu), 0);
    T = min(W - (lamda3 / mu), 1 / 10);
    M = max(abs(W - lamda4 / mu) - (0.25 * gama * weighted / mu), 0).* sign(W - lamda4 / mu); 
 
    Q = W - lamda6 / mu;
    S = size(W, 2) * Q / sum((sum(Q)));
    
    lamda1 = lamda1 + mu * (V - W);
    lamda2 = lamda2 + mu * (U - W');
    lamda3 = lamda3 + mu * (T - W);
    lamda4 = lamda4 + mu * (M - W);
    lamda5 = lamda5 + mu * (U - V);
    lamda6 = lamda6 + mu * (S - W);
    lamda7 = lamda7 + mu * (K - W);

     mu = min(mu * rho, mu_bar);


     r = norm(W - T_temp, 'fro');
     r_V = norm(V - W, 'fro');
     r_U = norm(U - W', 'fro');
     r_M = norm(M - W, 'fro');
     r_T = norm(T - W, 'fro');
     r_UV = norm(U - V, 'fro');
     r_S = norm(S - W, 'fro');
     r_K = norm(K - W, 'fro');

     if r_V < epsilon && r_U < epsilon && r_UV < epsilon && r_M < epsilon ...
        && r_S < epsilon && r_K < epsilon && r < epsilon && r_T < epsilon
         stop = true;
         break;
     end
      
end

L = diag(sum(W)) - W;
end