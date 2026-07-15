function [U, V, A] = my_pdem(path, ng, ns, alpx, alpy)
% Phase demodulation 
% * n-step phase shifting  least squares (wrapped phase extraction)
% * 

% Syntax:
% [U, V, A] = my_pdem(path, ng, ns, alpx, alpy)

% Reading first image.
Ik = imread(path+num2str(1)+".jpg");

% Image size.
MN = size(Ik, 1:2);

% Allocating memory for image reading
I = zeros([MN, ns]);

% Allocating memory for wrapped phase and fringe amplitude.
psi = zeros([MN, ng]);
b = zeros([MN, ng]);

% Processing U-axis.
for g=1:ng
    % Read fringe patterns.
    for k=1:ns
        Ik = imread(path + num2str((g-1)*ns+k)+".jpg");
        I(:,:,k) = im2gray(Ik);
    end
    % Wrapped phase extraction.
    [psik, b(:,:,g)] = my_pshift(I);
    % Removing useless pixels.
    psik(b(:,:,1)<12) = NaN;
    
    psi(:,:,g) = psik;
end

% Phase unwrapping for U-axis
U = my_punwrap(psi, alpx);

% Processing V-axis.
for g=ng+1:2*ng
    % Read fringe patterns.
    for k=1:ns
        Ik = imread(path + num2str((g-1)*ns+k)+".jpg");
        I(:,:,k) = im2gray(Ik);
    end

    % Wrapped phase extraction.
    psik = my_pshift(I);
    % Removing useless pixels
    psik(b(:,:,1)<12) = NaN;
    
    psi(:,:,g-ng) = psik;
end

% Phase unwrapping for V-axis
V = my_punwrap(psi, alpy);

% Obtaining an image without fringes
A = zeros([MN, 3]);

for g=1:ng
    % Read fringe patterns.
    for k=1:ns
        Ik = imread(path + num2str((g-1)*ns+k)+".jpg");
        Ik = im2double(Ik);
        % Averaging 
        A = A + Ik/(ng*ns);
    end
end
end