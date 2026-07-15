clear; clc

% Checkboard pattern.
MNr = [7 , 10]; % Number of rectangles.
MNb = [157, 225]; % Checkboard size(milimeters).

% Size of each rectangle in the calibration target.
wx = MNb(2) / MNr(2);
wy= MNb(1) / MNr(1);

% rho-coordinates of inner corners.
rx= wx*( -4:4 );
ry= wy*( -2.5:2.5 );

% Coordinates of inner coordinates.
[Rx, Ry]= meshgrid(rx, ry);

% Rho-coordinates.
rho= [Rx(:)'
      Ry(:)'];

n=6; % Number of the checkboard poses.
G= zeros( 3,3,n);

%% Camera-1 calibration
np = 5; % Number of checkerboard poses.
s = zeros(2, prod(MNr));

for i = 1:np
Ii = imread("calib_prop\cam1_" + num2str(i) + ".jpg");
imgPts = detectCheckerboardPoints(Ii);

s(:, :, i) = my_ptsnorm(imgPts, size(Ii));

%MNi = size(Ii, [1,2]);
%sx = linspace(-1, 1, MNi(2));
%sy = linspace(-1, 1, MNi(1))*MNi(1)/MNi(2);

imagesc(Ii)
hold on
    for k = 1:size(imgPts, 1)
        drawpoint("Position", sPts(:, k)',...
            "label", num2str(k))
    end
    hold off
    title("Cam- 1 img-"+ num2str(i))
                      
    G(:,:,i) = my_Gme(rho, sPts);

    drawnow
end
return
%Intrinsic parameter estimation.
K = my_Kme(G)

% Extrinsic parameter estimation.
[R,t] = my_Lme(G, K)


