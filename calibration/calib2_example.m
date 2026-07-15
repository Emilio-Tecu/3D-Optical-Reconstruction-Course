clear; clc

% Checkerboard pattern
MNr = [  7,  10]; % Number of rectangles
MNb = [157, 225]; % Checkerboard size (millimeters)

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


n = 6; % Number of the checkerboard poses
G = zeros(3,3,n);

%% Camera-1 calibration

np = 5; % Number of checkerboard poses
s1 = zeros(2, prod(MNr-1), np );
s2 = zeros(2, prod(MNr-1), np );

for i = 1 : np
    Ii1 = imread( "calib_prop\cam1_" + num2str(i) + ".jpg" );
    Ii2 = imread( "calib_prop\cam2_" + num2str(i) + ".jpg" );
    
    pt1 = detectCheckerboardPoints( Ii1 );
    pt2 = detectCheckerboardPoints( Ii2 );
    
    s1(:,:,i) = my_ptsnorm( pt1, size(Ii1) );
    s2(:,:,i) = my_ptsnorm( pt2, size(Ii2) );

    subplot(2,1,1); imagesc(Ii1)
    hold on
    for k = 1:size(pt1,1)
        drawpoint("Position", pt1(k,:), ...
                     "Label", num2str(k) );
    end
    hold off
    title("Cam-1, img-" + num2str(i) )
    
    subplot(2,1,2); imagesc(Ii2)
    hold on
    for k = 1:size(pt2,1)
        drawpoint("Position", pt2(k,:), ...
                     "Label", num2str(k) );
    end
    hold off
    title("Cam-2, img-" + num2str(i) )
    
    drawnow
end

[Kc, Rc, tc] = my_devcalib(rho, s1)
[Kp, Rp, tp] = my_devcalib(rho, s2)

% Saving calibration parameters.
save("calib2.mat", "Kc", "Rc", "tc", ...
                   "Kp", "Rp", "tp")




