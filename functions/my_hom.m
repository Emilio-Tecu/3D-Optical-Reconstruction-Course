% Homogeneous coordinates operator.
% Syntax:
%   h = my_hom(c, s)
% Inputs(2)
% (i1) c = NxM Matrix with M columns where each
%          column is a vector defining a point of cartesian coordinates.
% (i2) s = 1x1 Scalar defining the base.
% Outputs(1)
% (o1) h = (N+1)x1 Matrix with M columns where each
%          column is a vector defining a point of cartesian coordinates.
% See Also: my_ihom
function h = my_hom(c, s)
    if nargin<2
        s = 1;
    end

    h = [c 
         s*ones(1, size(c, 2))]; % Vector fila de dimensión 1*numeroCol(c)
end

