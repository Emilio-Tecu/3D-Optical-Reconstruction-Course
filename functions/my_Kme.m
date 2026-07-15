function K = my_Kme(G)
% K matrix estimation (intrinsic parameters).

% Syntax:
% K = my_Kme(G)

% Inputs(1)
% (i1) G = 3x3xn Available homographies

% Outputs(1)
% (o1) K = 3x3 intrinsic parameter matrix

% See Also: my_Gme

    % Number of available homographies.
    n = size(G, 3);

    % Regression matrix.
    A = zeros(2*n, 6);
    for k = 1:n
        A(k, :) = G(:, 1, k)'*auxF(G(:, 1, k)) - G(:, 2, k)'*auxF(G(:, 2, k));
        A(n+k, :) = G(:, 1, k)'*auxF(G(:, 2, k));
    end

    % Solving using singular value decomposition.
    [~, ~, V] = svd(A);
    w = V(:, end);

    W = [w(1) w(6) w(5)
         w(6) w(2) w(4)
         w(5) w(4) w(3)];

    [Ki, flag] = chol(W);
    if flag ~= 0
        Ki = chol(-W);
    end
    K = inv(Ki);
    K = K/K(3, 3);
end

function F = auxF(v)
% Auxiliar function to construct.
% F = [diag(v), Gamma(v)]

    F1 = diag(v);
    F2 = [0     v(3)   v(2)
          v(3)   0     v(1)
          v(2)  v(1)     0];
    
    F = [F1, F2];
end