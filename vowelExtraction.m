load mtlb

%% Spectrogram
segmentlen = 100; %window size
noverlap = 90; %overlapping size
NFFT = 128; %sampling points for DFT

spectrogram(mtlb,segmentlen,noverlap,NFFT,Fs,'yaxis')
title('Signal Spectrogram')

%% Long-Time RMS 
% Calculate the power in a given current window, 
% store inside an array long_RMS[]
dt = 1/Fs;
window_len = 200;
% frame_no = length(mtlb)-window_len; %window or frame?
frame_no = ceil(length(mtlb)/window_len);
long_RMS = zeros(frame_no,1);
sq = mtlb.^2; % square of all samples
for i = 1:frame_no-1
    long_RMS(i)= sqrt(mean(sq((i-1)*window_len+1:i*window_len))); 
end
long_RMS(frame_no)=sqrt(mean(sq((frame_no-1)*window_len:end)));

figure;
plot((1:frame_no).*1e3*window_len*1/Fs,long_RMS) 
xlabel("Time(ms)")
ylabel("RMS")
title(['Frame len:',num2str(window_len)])