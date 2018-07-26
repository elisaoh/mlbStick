%% formant smoothing

k = 5;  %half window size

%window method (doesn't seem to have good performance)
dt = 1/Fs;
half_window = 5;
window_len = half_window*2+1;
frame_no = length(y); %a window for every sample
long_RMS = zeros(frame_no,1);
sq = y.^2; % square of all samples
for i = 1:frame_no
    head = max(i-half_window,1);
    tail = min(i+half_window,frame_no);
    long_RMS(i)= sqrt(mean(sq(head:tail))); 
end

figure;
time_line = (1:frame_no).*frame_len*1e3*dt;
plot(time_line,long_RMS) 
xlabel("Time(ms)")
ylabel("RMS")
title(['Frame len: ',num2str(frame_len),' Lambda: ',num2str(lambda)])
