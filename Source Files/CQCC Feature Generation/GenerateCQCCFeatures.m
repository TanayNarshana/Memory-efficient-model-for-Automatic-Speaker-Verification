clear;
clc;

addpath(genpath('CQCC_v1.0'));

SUM = zeros(90, 469);
SUM2 = zeros(90, 469);
req_len = 4*16000;

p = dir('LA/train/flac/*.flac'); %%%% Change Here
n = numel(p);
for i = 1:n
    disp(i)
    [x,fs] = audioread(append('LA/train/flac/',p(i).name));
    while size(x) <  req_len
        x = [x; x];
    end
    x = x(1:req_len,1);
    y = cqcc(x, fs, 96, fs/2, fs/2^10, 16, 29, 'ZsdD');
    SUM = SUM + y;
    SUM2 = SUM2 + ((y.^2)/n);
    storeat = append('Features/train/',erase(p(i).name,'.flac'),'.txt'); %%%Change
    writematrix(y, storeat);
end

mean = SUM/numel(p);
writematrix(mean, 'train_mean_CQCC.txt');

stddev = SUM2 - mean.^2;
writematrix(stddev, 'train_stddev_CQCC.txt');