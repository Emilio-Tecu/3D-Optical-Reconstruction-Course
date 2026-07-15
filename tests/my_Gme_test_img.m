clear; clc

% Rho points (Points on the xy-plane captured by the camera)
% Monitor size: 30x40 cm^2
rho = [0  0   40  40
       0  30  0   30];

% Obtining the s-points by direct.
% detection on the image.
I = imread('monitor.jpg');
dec = 5;
I = I(1:dec:end, 1:dec:end, :);

subplot(1,1,1); imagesc(I)
[sx, sy] = ginput(4);

s = [sx'
     sy'];

% Homography matrix estimation.
G = my_Gme(rho, s);

mu = 1:size(I,2);
nu = 1:size(I,1);

[MU, NU, Z] = meshgrid(mu, nu, 0);
S = [MU(:), NU(:)]';

surf(MU, NU, Z, I, 'EdgeColor', 'None')
xlabel('\mu (s_x)')
ylabel('\nu (s_y)')

% Direct homography transformation:
% s = ihom(G hom(rho))

% Inverse homography transformation:
% rho = ihom(G^{-1}hom(s))  

RHO = my_ihom(inv(G)*my_hom(S));
rhoX = reshape(RHO(1, :), size(MU));
rhoY = reshape(RHO(2, :), size(NU));

figure(2)
surf(rhoX, rhoY, Z, I, 'EdgeColor', 'none')
xlabel('\rho_x')
ylabel('\rho_y')
daspect([1, 1, 1])
view(0, -90)

return

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