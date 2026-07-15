function [K, R, t, G] = my_devcalib(rho, s)
% Device calibration.
if size(rho,3)<size(s, 3)
    % Camera calibration. 
    rho = repmat(rho, 1, 1, size(s, 3));
else 
    % Projector calibration.
    s = repmat(s, 1, 1, size(rho, 3));
end
n = size(rho, 3);
% Homography estimation.
G = zeros(3, 3, n);
for i = 1:n
    G(:,:,i) = my_Gme(rho(:,:,i), s(:,:,i));
end

% Intrinsic parameter estimation
K = my_Kme(G)

% Extrinsic parameter estimation
[R, t] = my_Lme(G, K)
end