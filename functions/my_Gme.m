function G = my_Gme(rho, s)
% Homography estimation.

% Syntax:
% G = my_Gme(rho, s)

% Inputs(2)
% (i1) rho = 2xN matrix where each column is a point rho.
%          = [rho_x1, rho_x2, rho_x3, ..., rho_xN
%             rho_y1, rho_y2, rho_y3, ..., rho_yN]
% (i2) s = 2xN matrix where each column the image for each given point rho.
%        = [sx1, sx2, sx3, ..., sxN
%           sy1, sy2, sy3, ..., syN]

% Outputs(1)
% (o1) G = 3x3 estimated homography matrix.

Hr = my_hom(rho);
Z0 = zeros(size(Hr));

% Regression matrix.
A = [Hr', Z0', -repmat(s(1,:)', 1, 2) .* rho'
    Z0', Hr', -repmat(s(2,:)', 1, 2) .* rho'];

z = [ s(1,:)' 
      s(2,:)'];
g_bar = inv(A'*A)*A'*z;

G = [g_bar(1), g_bar(2), g_bar(3)
     g_bar(4), g_bar(5), g_bar(6)
     g_bar(7), g_bar(8), 1]
end

