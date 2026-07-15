function [psi, b, a] = my_pshift(I, delta)
% Phase-shifting algorithm.
% Syntax:
% [psi, b, a] = my_pshift(I, D)

% Inputs(2)
% (i1) I = MxNxn stack of K phase-shifted fringe images.
% (i2) delta = 1xn vector of known reference phase shifts.

% Outputs(3)
% (o1) psi = MxN wrapped phase map.
% (o2) b = MxN modulation amplitude map.
% (o3) a = MxN background intensity map.

% Ensuring the given fringe patterns
% are data of double-type format.
I = im2double(I);

[rows, cols, n] = size(I);   % Size of I.

if nargin<2
    delta = 2*pi*(0:n-1)/n;
end

delta = delta(:);            % Ensuring del is a column.
% Regression matrix.
A = [ones(n, 1), cos(delta), -sin(delta)];
% Output vector.
y = reshape(I, rows*cols, n)';
% Solve for x.
x = A\y; % inv(A'*A)*A'*y.

a = reshape(x(1,:), rows, cols);
bcos = x(2,:);
bsin = x(3,:);

b = reshape(sqrt(bcos.^2 + bsin.^2), rows, cols);
psi = reshape(atan2(bsin, bcos), rows, cols);

end
