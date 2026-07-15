function [R, t] = my_Lme(G, K)
% Extrinsic parameter estimation.
% 
% Syntax:
% [R, t] = My_Lme(G, K)

% Inputs(2)
% G = 3x3xN Available homographies.
% K = 3x3 Intrinsic parameter matrix.

% Outputs(2)
% (o1) R = 3x3xN rotation matrices (camera orientation)
% (o2) t = 3xN translation vectors (camera position)
n = size(G, 3); % Number of homographies.
R = zeros(size(G));
t = zeros(3, n);

for i=1:n
    [R(:,:,i), t(:,i)] = aux_RT(G(:,:,i), K);
end

end

function [Ri, ti] = aux_RT(Gi, K)
% Auxiliar function to estimate the k-th rotation and translation.
 % Extraemos los vectores columna de G.
 g1 = Gi(:, 1);
 g2 = Gi(:, 2);
 g3 = Gi(:, 3);

 % Matriz inversa de K.
 Ki = inv(K)

 % Coarse estimation of ~R^T
 v1 = Ki*g1
 v2 = Ki*g2
 Rt_e = [v1 v2 cross(v1, v2)];

 % Solving using singular value decomposition.
  [U, ~, V] = svd(Rt_e);
   Ri = V*U';

   % Translation vector estimation.
 A = [K*Ri(1,:)'
      K*Ri(2,:)'];
 y = [g1
      g2];

 lam = A'*y/(A'*A);
 ti = -Ri*Ki*g3/lam;
end
