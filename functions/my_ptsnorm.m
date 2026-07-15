function s = my_ptsnorm(pts, MN)
% Checkerboard points normalization.
sx = 2*pts(:,1,:)/MN(2)-1;
sy = (2*pts(:,2,:)/MN(1)-1)*MN(1)/MN(2);
    s=permute(cat(2, sx, sy), [2,1,3]);
end