function [voiced_segment,voiced_logic] = vowelExtraction(data,Fs,frame_len)
%% parameters
min_duration = 0.1;

%% Spectrogram
% segmentlen = 100; %window size
% noverlap = 0.9*segmentlen; %overlapping size
% NFFT = 128; %sampling points for DFT
% %
% figure;
% spectrogram(data,segmentlen,noverlap,NFFT,Fs,'yaxis')
% title('Signal Spectrogram')

%% Long-Time RMS 
% Calculate the power in a given current window, 
% store inside an array long_RMS[]

%frame method (no smoothing)
lambda = 0.4; %smoothing factor
dt = 1/Fs;
% frame_len = 100;
% frame_no = length(data)-window_len; %window or frame?
frame_no = ceil(length(data)/frame_len);
long_RMS = zeros(frame_no,1);
sq = data.^2; % square of all samples
for i = 1:frame_no-1
    long_RMS(i)= sqrt(mean(sq((i-1)*frame_len+1:i*frame_len))); 
end
long_RMS(frame_no)=sqrt(mean(sq((frame_no-1)*frame_len:end)));

long_RMS_prev = long_RMS(1:frame_no-1).*lambda;
long_RMS_curr = long_RMS(2:frame_no).*(1-lambda);
long_RMS(2:frame_no) = long_RMS_prev + long_RMS_curr;

% %window method (doesn't seem to have good performance)
% dt = 1/Fs;
% half_window = 100;
% window_len = half_window*2+1;
% frame_no = length(data); %a window for every sample
% long_RMS = zeros(frame_no,1);
% sq = data.^2; % square of all samples
% for i = 1:frame_no
%     head = max(i-half_window,1);
%     tail = min(i+half_window,frame_no);
%     long_RMS(i)= sqrt(mean(sq(head:tail))); 
% end
% 
% figure;
% time_line = (1:frame_no).*frame_len*1e3*dt;
% plot(time_line,long_RMS) 
% xlabel("Time(ms)")
% ylabel("RMS")
% title(['Frame len: ',num2str(frame_len),' Lambda: ',num2str(lambda)])

%% thresholding
thres = 0.4;
vowel_frame= zeros(frame_no,1);
RMS_thres = max(long_RMS)*thres;
vowel_frame(long_RMS>=RMS_thres) = 1;

diff = zeros(frame_no,1);
diff(2:end) = vowel_frame(2:end)-vowel_frame(1:end-1);

for i = 1:frame_no
 if(diff(i)<-0.9)
     if(diff(i+1)>0.9)
         vowel_frame(i) = 1;
     end
 end
end
     

% figure;
% time_line = (1:frame_no).*frame_len*1e3*dt;
% plot(time_line,vowel_frame);
% axis([0 inf 0 1.5]);
% yticks([0 1]);
% yticklabels({'not vowel','vowel'});
% xlabel("Time(ms)")
% title("Vowel Detection")

%% return voiced sample range
% we do not know how many voiced segments our record has
min_length = ceil(min_duration*Fs);
diff = zeros(frame_no,1);
diff(2:end) = vowel_frame(2:end)-vowel_frame(1:end-1);
voiced_head = (find(diff==1)-1)*frame_len;
voiced_tail = (find(diff==-1)-1)*frame_len;
if length(voiced_tail)<length(voiced_head)
    voiced_tail = [voiced_tail;length(data)];
end

voiced_segment = [voiced_head,voiced_tail];
voiced_length = voiced_tail-voiced_head;
voiced_segment(voiced_length < min_length,:)=[];
voiced_logic = zeros(length(data),1);
for i=1:size(voiced_segment,1)
    head = voiced_segment(i,1);
    tail = voiced_segment(i,2);
    voiced_logic(head:tail) = 1;
end


% figure;
% time_line = (1:length(data)).*1e3*dt;
% plot(time_line,voiced_logic);
% axis([0 inf 0 1.5]);
% yticks([0 1]);
% yticklabels({'not vowel','vowel'});
% xlabel("Time(ms)")
% title("Vowel Detection")
end