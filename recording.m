clear variables
recObj = audiorecorder;
disp('Start speaking.');
recordblocking(recObj, 5);
disp('End of Recording.');
y = getaudiodata(recObj);
plot(y);