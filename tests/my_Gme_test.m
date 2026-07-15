clear; clc

% Rho points (Points on the xy-plane captured by the camera)
rho = [0  0  2  2
       0 -1  0 -1];

% Proposed homography matrix
G = [9, 1, 1
     1, 5, 1
     7, 8, 1];

% s-points (images for each point rho)
s = my_ihom(G*my_hom(rho));

% Confirming that G is non-singular det(G) != 0
det(G)~=0

F = my_Gme(rho, s)

% Plotting rho-points.
subplot(2, 1, 1)
plot([rho(1, 1) rho(1, 2) rho(1, 4) rho(1, 3) rho(1, 1)], ...
     [rho(2, 1) rho(2, 2) rho(2, 4) rho(2, 3) rho(2, 1)], '-o')
grid on
title('rho-points')

% Plotting s-points
subplot(2, 1, 2)
plot([s(1, 1) s(1, 2) s(1, 4) s(1, 3) s(1, 1)], ...
     [s(2, 1) s(2, 2) s(2, 4) s(2, 3) s(2, 1)], '-o')
grid on
title('s-points')