clear; clc

path = "patterns\fp_";
ng = 4;
ns = 6;

% Image and slide sizes.
MNc = [2076, 3088]; % Image Resolution.
MNp = [737, 1280]; % Projector Resolution.
MNr = [  7,  10]; % Number of rectangles
MNb = [157, 225]; % Checkerboard size (millimeters)

% Calibration
load("calibration\checkerboard\fp__pts.mat", ...
    "ptsr", "ptsb")
% for k=1:33
%     Ik = imread("calibration\checkerboard\fp_"+num2str(k)+".jpg");
% 
%     subplot(2,2,1); imagesc(Ik);title("RGB image"+num2str(k))
%     subplot(2,2,2); imshow(Ik(:,:,1)); title("Red-channel")
%     for i = 1:54
%         drawpoint("Position", ptsr(i,:, k), ...
%             "Label", num2str(i) );
%     end
% 
%     subplot(2,2,4); imshow(Ik(:,:,3)); title("Blue-channel")
%     for i = 1:54
%         drawpoint("Position", ptsb(i,:, k), ...
%             "Label", num2str(i));
%     end
% 
%     drawnow
% end
close all

%% Homography estimation.
% Size of each rectangle in the calibration target
wx = MNb(2) / MNr(2);
wy = MNb(1) / MNr(1);

% rho-coordinates of inner corners
rx =  wx*(  -4:4  );
ry = -wy*(-2.5:2.5);

% Coordinates of inner coordinates
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

rhop = zeros(2, 54, 33);
for k = 1:33
    rhop(:,:,k) = my_ihom(Gc(:,:,k)\my_hom(ptsrn(:,:,k)));
end
[my_Kp, my_Rp, my_tp] = my_devcalib(rhop, sptsn);
clear Ik ptsr ptsb ptsrn ptsbn rho rhop sptsn Rx Ry Sx Sy
Kc = my_Kc;
Kp = my_Kp;

Rc = my_Rc(:,:,32);
Rp = my_Rp(:,:,32);

tc = my_tc(:,32);
tp = my_tp(:,32);

% Frequency multipliers (phase unwrapping).
load(path+"fmul.mat", "alpX", "alpY")

% Phase demodulation (slide pixel coords).
[Up, Vp, A] = my_pdem(path, ng, ns, alpX(1), alpY(1));

% Image and slide sizes.
MNc = [2076, 3088]; % Image Resolution.
MNp = [737, 1280]; % Projector Resolution.

% Scaling the v-axis on the slide (projector).
Vp = Vp*MNp(1)/MNp(2);

% Pixel coordinates in the camera.
uc = linspace(-1, 1, MNc(2));
vc = linspace(-1, 1, MNc(1))*MNc(1)/MNc(2);
[Uc, Vc] = meshgrid(uc, vc);

%load("cp_params.mat", "Kc", "Rc", "tc", "Kp", "Rp", "tp");

% Chosing pose 32.
%Rc = Rc(:,:,32);
%Rp = Rp(:,:,32);

%tc = tc(:,32);
%tp = tp(:,32);

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

return 



    figure(1); subplot(1,1,1)
    surf(U(1:dec:end,1:dec:end,g), 'EdgeColor','None')
    colormap default
    light
    title("\U")
    view(10,30)

    figure(2); subplot(1,1,1)
    surf(V(1:dec:end,1:dec:end,g), 'EdgeColor','None')
    colormap default
    light
    title("\V")
    view(10,30)
    
    figure(3); subplot(1,1,1)
    imagesc(A)
    title("Image without fringes")
return

% Fringe patterns.
MN = [2076, 3088]; % Camera resolution.
np = 6; % Number of phase shifts.

w = alpY; % List of frequences.
L = numel(w)+1;

% Matrix.
psi = zeros([MN, L]);
bh = zeros([MN, L]);
ah = zeros([MN, L]);

for g = 1:L
    I = zeros([MN, np]); % Matrix of patterns.
    for k = 1:np
        Ik = imread("patterns\fp_"+num2str((g-1)*np+k)+".jpg");
        I(:,:,k) = im2gray(Ik);
    end
    % Recovering a, b, psi, from fringe patterns.
    [psig, bg, ag] = my_pshift(I);
    psig(bg<12) = NaN;
    psi(:,:,g) = psig;
    bh(:,:,g) = bg;
    ah(:,:,g) = ag;
    figure(g)
    subplot(2,2,1); imagesc(ag); title('ahat'); colorbar
    subplot(2,2,2); imagesc(bg); title('bhat'); colorbar
    subplot(2,2,4); imagesc(I(:,:,1)); title('I1'); colorbar
    colormap gray
end

phi = my_punwrap(psi, w);

dec = 5;
    figure(L+g)
    surf(phi(1:dec:end,1:dec:end,g), 'EdgeColor','None')
    light
    title("\V")
