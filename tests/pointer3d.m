clear; clc
% Leemos las cámaras que tenemos.
% 3D pointer.
vid1 = videoinput('winvideo', 1);
vid2 = videoinput('winvideo', 2);

I1 = getsnapshort(vid1);
I2 = getsnapshort(vid2);

subplot(2, 1, 1); imshow(I1); title("Cam-1")
subplot(2, 1, 2); imshow(I2); title("Cam-2")

load("calib2.mat", "Kc", "Rc", "tc", ...
                   "Kp", "Rp", "tp")
Rc = Rc(:,:,end);
Rp = Rp(:,:,end);
tc = tc(:,end);
tp = tp(:,end);

% Cam1: Selecting a pixel with the color of interest.
subplot(1,1,1); imagesc(I1)
[x1, y1] = getpts;

% Cam2: Selecting a pixel with the color of interest.
subplot(1,1,2); imagesc(I2)
[x2, y2] = getpts;

% Object color from Cam1 and Cam2.
RGB1 = I1(round(x1), round(y1), :);
RGB2 = I2(round(x2), round(y2), :);

for i = 1:10
    I1 = getsnapshort(vid1);
    I2 = getsnapshort(vid2);

    msk1 = sum(abs(I1 - RGB1), 3) > 10;
end
