clear; clc
ncal = 11;
folder = "calib\";
MNr = [7, 10];
npts = (MNr(1)-1)*(MNr(2)-1);
ptsr = zeros(npts, 2, ncal);
ptsb = zeros(npts, 2, ncal);
bad = [];
for k = 1:ncal
    Ik = imread(folder + "cb_" + num2str(k) + ".jpg");
    [ptr, br] = detectCheckerboardPoints(Ik(:,:,1));
    [ptb, bb] = detectCheckerboardPoints(Ik(:,:,3));
    fprintf("img %d: red boardSize=[%d %d] (%d pts), blue boardSize=[%d %d] (%d pts)\n", ...
        k, br(1), br(2), size(ptr,1), bb(1), bb(2), size(ptb,1));
    okr = size(ptr,1) == npts;
    okb = size(ptb,1) == npts;
    subplot(1,2,1); imagesc(Ik(:,:,1)); colormap gray
    hold on
    plot(ptr(:,1), ptr(:,2), 'r+', 'MarkerSize', 10, 'LineWidth', 1.5)
    hold off
    title("Red img "+k+" ("+size(ptr,1)+" pts)")
    subplot(1,2,2); imagesc(Ik(:,:,3)); colormap gray
    hold on
    plot(ptb(:,1), ptb(:,2), 'b+', 'MarkerSize', 10, 'LineWidth', 1.5)
    hold off
    title("Blue img "+k+" ("+size(ptb,1)+" pts)")
    drawnow
    if okr && okb
        ptsr(:,:,k) = ptr;
        ptsb(:,:,k) = ptb;
    else
        bad = [bad, k];
        fprintf("  -> imagen %d marcada como problemática, revisar a ojo\n", k);
        pause
    end
end
save(folder+"fp__pts_pyr.mat", "ptsr", "ptsb")