function [theta, P, W] = LeMA(Y, X_l, X_l_un, Z, alfa, beta ,L, W, maxiter, W_l)

epsilon = 1e-4; % Tolerance error
iter = 1; 
stop = false;
E = zeros(1, maxiter); % Residuals
m = size(Z, 2);

while ~stop && iter < maxiter + 1
 
 %% Solve P
     P = (Y * Z') / (Z * Z' + alfa * eye(size(Z * Z')));
     
 %% Solve theta
     theta = Solving_Theta(Y, P, Z, X_l, beta, maxiter, L, X_l_un);
     Z = theta * X_l;
     ZZ = theta * X_l_un;
     
 %% Solve W and L
    W_temp = zeros(size(W));
    W1 = learning_alignment(ZZ(:, m + 1 : end), ZZ(:, (m / 2) + 1 : m), beta, maxiter, W(m + 1 : end, (m / 2) + 1 : m)); %left-down
    W2 = graph_learning(ZZ( : ,m + 1 : end), beta, 1000, W(m + 1 : end, m + 1 : end));
    W3 = learning_alignment(ZZ(:, m + 1 : end), ZZ(:, 1 : (m / 2)), beta, maxiter, W(m + 1 : end,1 : (m / 2))); %right-top
    WW = max(W1, W3);
    W_temp(m + 1 : end,m + 1 : end) = W2;
    W_temp(m + 1 : end, (m / 2) + 1 : m) = WW;
    W_temp((m / 2) + 1 : m, m + 1 : end) = WW';
    W_temp(m + 1 : end, 1 : (m / 2)) = WW;
    W_temp(1 : (m / 2), m + 1 : end) = WW';
    W_temp(1 : m, 1 : m) = size(W_l, 2) * W_l / sum(sum(W_l));
    L_temp = diag(sum(W_temp)) - W_temp;
    L = L_temp;
    W = W_temp; 

    E(1, iter) = 0.5 * norm(Y - P * theta * X_l, 'fro')^2 + 0.5 * alfa * norm(P, 'fro')^2 ...
                + 0.5 * beta * trace(ZZ * L * ZZ');
            
    %% Check the convergence condition
    if iter > 1
       r_Obj = abs(E(1, iter) - E(1, iter - 1)) / abs(E(1, iter - 1));
       if r_Obj < epsilon
            stop = true;
            fprintf('i = %f,res_Obj= %f\n', iter, r_Obj);
            break;
       end

       if mod(iter, 10) == 1
           fprintf('i = %f,res_Obj= %f\n', iter, r_Obj);
       end
    end

    iter = iter + 1;
end
W = W -  diag(diag(W));
end