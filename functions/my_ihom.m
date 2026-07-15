function c = my_ihom(h, s)
% Inverse Homogeneous coordinates operator.
% Syntax:
%   h = my_ihom(h, s)
% Inputs(2)
% (i1) h = (N+1)xM Matrix with M columns where each
%          column is a vector defining a point of cartesian coordinates.
% (i2) s = 1x1 Scalar defining the base.
% Outputs(1)
% (o1) c = Nx1 Matrix with M columns where each
%          column is a vector defining a point of cartesian coordinates.
if nargin < 2
    s=1;
end
H0 = h(1:end-1, :); % H_0^{-1}[h]
S0 = h(end, :); % Escala de h.
c = (s * H0)./S0; 
end

