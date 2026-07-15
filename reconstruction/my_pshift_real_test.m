clear; clc;

folder = 'patterns';
n = 6;

files = dir(fullfile(folder, 'fp_*.jpg'));
nums = zeros(numel(files),1);
for k = 1:numel(files)
    tok = regexp(files(k).name, 'fp_(\d+)\.jpg', 'tokens');
    nums(k) = str2double(tok{1}{1});
end

[nums, order] = sort(nums);
files = files(order);

total = numel(files);
ngroups = floor(total/n);

psi_all = cell(ngroups,1);
b_all   = cell(ngroups,1);
a_all   = cell(ngroups,1);

delta = 2*pi*(0:n-1)/n;

for g = 1:ngroups
    idx = (g-1)*n + (1:n);

    I0 = imread(fullfile(folder, files(idx(1)).name));
    if size(I0,3) == 3
        I0 = rgb2gray(I0);
    end
    [rows, cols] = size(I0);

    I = zeros(rows, cols, n);
    I(:,:,1) = im2double(I0);
    for k = 2:n
        Ik = imread(fullfile(folder, files(idx(k)).name));
        if size(Ik,3) == 3
            Ik = rgb2gray(Ik);
        end
        I(:,:,k) = im2double(Ik);
    end

    [psi, b, a] = my_pshift(I, delta);

    psi_all{g} = psi;
    b_all{g}   = b;
    a_all{g}   = a;

    figure('Name', sprintf('Grupo %d', g));
    subplot(1,3,1); imagesc(a);   axis image off; colorbar; title('a');
    subplot(1,3,2); imagesc(b);   axis image off; colorbar; title('b');
    subplot(1,3,3); imagesc(psi); axis image off; colorbar; title('\psi');
    colormap gray
end