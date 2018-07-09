clear variables

recObj = audiorecorder;
disp('Start speaking.');
recordblocking(recObj, 5);
disp('End of Recording.');
Fs = recObj.SampleRate;
y = getaudiodata(recObj);
figure;
plot(y);

voiced = vowelExtraction(y,Fs);
segment_total = size(voiced,1);
for i=1:segment_total
    sound(y(voiced(i,1):voiced(i,2)),Fs)
    pause(1)
    beep
    pause(1)
end