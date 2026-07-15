function phi = my_punwrap(psi, w)
% Phase unwrapping using the multi-frequency approach
%
% Syntax:
% phi = my_punwrap(psi, w)
n = size(psi, 3);
phi = zeros(size(psi));
phi(:,:,1) = psi(:,:,1);
for i = 2:n
    num = w*phi(:,:,i-1) - psi(:,:,i);
    hk = round(num/(2*pi));
    phi(:,:,i) = psi(:,:,i) + 2*pi*hk;
end

phi = phi(:,:,end)/(pi*w^(n-1));
end