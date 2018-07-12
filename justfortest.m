segmentlen = 100; %window size
noverlap = 40; %overlapping size
NFFT = 128; %sampling points for DFT

figure;
spectrogram(y,segmentlen,noverlap,NFFT,Fs,'yaxis')
title('Signal Spectrogram')

