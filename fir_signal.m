clear all;
close all;
clc;

Fs = 34.56e6;
F1 = 2e6;
F2 = 5e6;
F3 = 8e6;

%Time 200 milliseconds
t = 0:1/Fs:0.001-1/Fs;

%Create the signals
x1 = cos(2*pi*F1*t);
x2 = cos(2*pi*F2*t);
x4 = cos(2*pi*F3*t);
x3 = x1 + x2 + x4;

%Create Nfft
Nfft = length(t);
f = (-Nfft/2:Nfft/2-1)*Fs/Nfft;

X3 = fft(x3, Nfft);

#figure
#plot(f, 20*log10(abs(fftshift(X3))))
#xlabel('Frequency in [Hz]')
#xlabel('Frequency in [Hz]')
#grid on
#title('Signal')

pkg load signal
# Bandfilter vom 02.05.2022
#lpcoeff = fir1(63, [4e6/Fs,21e6/Fs], 'bandpass' , 'blackman');#, hann(64+1));
# Test mit Bandfilter 30 khz, 02.05.2022
lpcoeff = fir1(63, [5.0e6/Fs,5.030e6/Fs], 'bandpass' , 'blackman');#, hann(64+1));
#lpcoeff = fir1(63, 1e6/Fs);#, hann(64+1));
#lpcoeff = [-4, -6, -37, 35, 186, 86, -284, -315, 107, 219, -4, 271, 558, -307, -1182, -356, 658, 157, 207, 1648, 790, -2525, -2553, 748, 865, -476, 3737, 6560, -3583, -14731, -5278, 14819, 14819, -5278, -14731, -3583, 6560, 3737, -476, 865, 748, -2553, -2525, 790, 1648, 207, 157, 658, -356, -1182, -307, 558, 271, -4, 219, 107, -315, -284, 86, 186, 35, -37, -6, -4];

# Convert the fixed point Coefficients to INT16 Coefficients
numberOfBits = 16;
L = floor(log2((2^(numberOfBits-1)-1)/max(lpcoeff)));
bsc = int16(lpcoeff*2^L);


#lpcoeff_floatingPoint = int16(lpcoeff);
#y = filter(lpcoeff, 1, x3); %only nominator, no denominator

#Y = fft(y,Nfft);
Y = fft(bsc,Nfft);
#Y = fft(lpcoeff,Nfft);

figure
plot(f, 20*log10(abs(fftshift(Y))))
xlabel('Frequency in [Hz]')
ylabel('Amplitude in [dB]')
grid on
title('Filtered Signal')
 ##Ende
