function [R, t] = my_relpose(Rc, tc, Rp, tp)
% Relative pose (camera -> projector) from multiple checkerboard captures.
% Syntax:
% [R, t] = my_relpose(Rc, tc, Rp, tp)
% Inputs(4)
% (i1) Rc = 3x3xN rotation matrices, board->camera.
% (i2) tc = 3xN translation vectors, board->camera.
% (i3) Rp = 3x3xN rotation matrices, board->projector.
% (i4) tp = 3xN translation vectors, board->projector.
% Outputs(2)
% (o1) R = 3x3 averaged rotation, camera->projector.
% (o2) t = 3x1 averaged translation, camera->projector.

n = size(Rc, 3);
Ri = zeros(3, 3, n);
ti = zeros(3, n);
for k = 1:n
    Ri(:,:,k) = Rp(:,:,k) * Rc(:,:,k)';
    ti(:,k) = tp(:,k) - Ri(:,:,k) * tc(:,k);
end
M = mean(Ri, 3);
[U, ~, V] = svd(M);
R = U * V';
t = mean(ti, 2);
end