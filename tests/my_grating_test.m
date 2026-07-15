clear; clc

path = "proj1\patterns\fp_";
ng = 4;
ns = 6;

% Image and slide sizes.
MNc = [2076, 3088]; % Image Resolution.
MNp = [1080, 1920]; % Projector Resolution.
MNr = [  7,  10]; % Number of rectangles
MNb = [161, 230]; % Checkerboard size (millimeters)

ppf = 25;
my_grating(ng, ns, ppf, MNp, path)

return
