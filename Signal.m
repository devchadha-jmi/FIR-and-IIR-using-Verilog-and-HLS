% Generate a sine wave
close all; clear all;
fs = 5;
Amp = 1;
t = 0:1/fs:2*pi; % time vector
sine_wave = Amp*sin(t);
figure();
plot(t, sine_wave);
xlabel('\bf Time');
ylabel('\bf Amplitude');
title('\bf Sine wave');

% Add a noise
a = 0.3; % upper limit
b = 0; % lower limit
noise = (b-a).*rand(length(sine_wave),1) + a; 
noise = noise';
sine_noise = (sine_wave + noise);
sine_norm = sine_noise / max(abs(sine_noise));
figure();
plot(1:length(sine_norm), sine_norm);
xlabel('\bf Time');
ylabel('\bf Amplitude');
title('\bf Sine wave + Noise');

% Convert from real to integers
total_wordlength = 16;
scaling = 7;
sine_noise_integers = round(sine_norm.*(2^scaling));         %rounding values to the nearest desired value
figure();plot(1:length(sine_noise_integers), sine_noise_integers);
xlabel('\bf Time');
ylabel('\bf Amplitude');
title('\bf Sine wave + Noise : Scaled Signal');

% Convert from integers to binary
sine_noise_in_binary_signed = dec2bin(mod((sine_noise_integers),2^total_wordlength),total_wordlength);        %converts the decimal integer to binary row vector
yy = cellstr(sine_noise_in_binary_signed);        %converting to a cell array of character vectors
fid = fopen('signal.data', 'wt');         %obtaining the file identifier
fprintf(fid, '%8s \n', yy{:});
disp('text file for signal finished');
