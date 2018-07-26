clear variables
addpath('vowelExtraction')
% load mtlb
load('\\wcs-cifs\wc\smng\experiments\stroopVOT\acousticdata\sp008\neutralWord\data.mat')
load('\\wcs-cifs\wc\smng\experiments\stroopVOT\acousticdata\sp008\neutralWord\expt.mat')

idx = 2;
word = expt.words(expt.allWords(idx));
M = 4; %downsample factor
y = downsample(data(idx).signalIn,M);
Fs = data(idx).params.fs/M;
F0 = 162; %Pitch period(Fundamental frequency)
window_len = 2/F0*Fs;

frame_len = 100; % for vowel detection
half_window = round(window_len/2); % window size for LPC analysis
p = 12; % LPC order

[voiced_segment,~] = vowelExtraction(y,Fs,frame_len);
dt = 1/Fs;
% takes in a segment of vowel, return its formants
sample_no = length(y);
voiced_no = size(voiced_segment,1);
formants_all = zeros(sample_no,3);


fn = zeros(length(y),3);
m = 0.5;

for seg = 1:voiced_no
%     I0 = 9000;
I0 = voiced_segment(seg,1)+half_window;
Iend = voiced_segment(seg,2)-half_window;
    for i = I0:Iend
%         head = max(i-half_window,I0);
%         tail = min(i+half_window,Iend);
        head = i-half_window;
        tail = i+half_window;
        data_win = y(head:tail);    
        formants = formantsWindow(data_win,Fs,p);

        
        % formant range
        range_min = [100,500,1000];
        range_max = [1500,3500,4500];
        for f = 1:3
        for c = 1:length(formants)
            if range_min(f)<formants(c)<range_max(f)
                formants_all(i,f) = formants(f);
            else
                formants_all(i,f) = formants_all(i-1,f);
            end
     
        end
       
    end
    end    

end 


%% formant smoothing
formants_smoothed = zeros(size(formants_all));
k = 5;  %half window size
movingWindow = dsp.MovingAverage(2*k+1);

for f = 1:3
    formants_smoothed(:,f) = movingWindow(formants_all(:,f));
end


% formants_time = zeros(length(data),3);
% for i=1:voiced_no
%     head = voiced_segment(i,1);
%     tail = voiced_segment(i,2);
%     for f = 1:size(formants_all,2)
%         formants_time(head:tail,f) = formants_all(i,f);
%     end  
% end


%% plot
figure;
segmentlen = 100; %window size
noverlap = 90; %overlapping size
NFFT = 128; %sampling points for DFT

spectrogram(y,segmentlen,noverlap,NFFT,Fs,'yaxis')
hold on
formants_no = 3;
for f = 1:formants_no
%     subplot(3,1,f);
    time_line = (1:length(y)).*dt;
    scatter(time_line,formants_all(:,f)./1e3,'.');
    hold on
%     xlabel("Time(ms)")
%     ylabel(['Formant ', num2str(f)])
end
hold off
% suptitle(['Window length ', num2str(half_window*2+1),' LPC order ', num2str(p)]);
title(['Window ', num2str(half_window*2+1),' Order ', num2str(p)]);
text(1.5,5,word,'Color','white','FontSize',14)





