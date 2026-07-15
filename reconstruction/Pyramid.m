clear; clc

path = "patterns_pyr\fp_";
ng = 4;
ns = 8;

% Image and slide sizes.
MNc = [2076, 3088]; % Image Resolution.
MNp = [1024, 1280]; % Projector Resolution.
MNr = [  7,  10]; % Number of rectangles
MNb = [70, 100]; % Checkerboard size (millimeters)

% Calibration
load("calib\fp__pts_pyr.mat", "ptsr", "ptsb")
close all

%% Homography estimation.
% Size of each rectangle in the calibration target.
wx = MNb(2) / MNr(2);
wy = MNb(1) / MNr(1);

% rho-coordinates of inner corners.
rx =  wx*(  -4:4  );
ry = -wy*(-2.5:2.5);

% Coordinates of inner coordinates.
[Rx, Ry] = meshgrid(rx, ry);

% Rho-coordinates
rho = [ Rx(:)'
        Ry(:)' ];

ptsrn = my_ptsnorm( ptsr, MNc );
ptsbn = my_ptsnorm( ptsb, MNc );

[my_Kc, my_Rc, my_tc, Gc] = my_devcalib(rho, ptsbn);

%% Projector calibration.
% rho-coordinates of inner corners
sx = linspace(-1, 1, 11);
sx = sx(2:end-1);

sy = linspace(-1, 1, 8);
sy = sy(2:end-1)*MNp(1)/MNp(2);

% Coordinates of inner coordinates
[Sx, Sy] = meshgrid(sx, sy);

% Slide-coordinates
sptsn = [Sx(:)' 
          Sy(:)'];

rhop = zeros(2, 54, 11);
for k = 1:11
    rhop(:,:,k) = my_ihom(Gc(:,:,k)\my_hom(ptsrn(:,:,k)));
end
[my_Kp, my_Rp, my_tp] = my_devcalib(rhop, sptsn);
clear Ik ptsr ptsb ptsrn ptsbn rho rhop sptsn Rx Ry Sx Sy
Kc = my_Kc;
Kp = my_Kp;

Rc = my_Rc(:,:,1);
Rp = my_Rp(:,:,1);
tc = my_tc(:,1);
tp = my_tp(:,1);

% Frequency multipliers (phase unwrapping).
ppf = 25; % Pixels per fringe
alpX = (MNp(2)/ppf)^(1/(ng-1));
alpY = (MNp(1)/ppf)^(1/(ng-1));

% Phase demodulation (slide pixel coords).
[Up, Vp, A] = my_pdem(path, ng, ns, alpX(1), alpY(1));

% Scaling the v-axis on the slide (projector).
Vp = Vp*MNp(1)/MNp(2);

% Pixel coordinates in the camera.
uc = linspace(-1, 1, MNc(2));
vc = linspace(-1, 1, MNc(1))*MNc(1)/MNc(2);
[Uc, Vc] = meshgrid(uc, vc);

% Direction vectors from the camera.
dc = Rc*inv(Kc)*my_hom([Uc(:), Vc(:)]');

% Direction vectors from the projector.
dp = Rp*inv(Kp)*my_hom([Up(:), Vp(:)]');

dec = 5;

% Triangulation. 
p = my_triang(tc, tp, dc(:,1:dec:end), dp(:,1:dec:end));

msk = p(3,:)>100;
p(:,msk) = NaN;

msk = p(3,:)<-100;
p(:,msk) = NaN;

Ahd = reshape(A, [], 3);

pcshow(p', Ahd(1:dec:end, :))
axis equal
axis tight
xlabel('x [mm]'); ylabel('y [mm]'); zlabel('z [mm]')
title('3D Reconstruction')
view(45, 20)
camva(10)