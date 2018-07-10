clear variables
addpath('vowelExtraction')
load mtlb
data = mtlb;
frame_len = 100; % for vowel detection
half_window = 200; % window size for LPC analysis
p = 8; % LPC order

[voiced_segment,~] = vowelExtraction(data,Fs,frame_len);
dt = 1/Fs;
% takes in a segment of vowel, return its formants
sample_no = length(data);
voiced_no = size(voiced_segment,1);
formants_all = zeros(sample_no,3);




for seg = 1:voiced_no
I0 = voiced_segment(seg,1)+half_window;
Iend = voiced_segment(seg,2)-half_window;
    for i = I0:Iend
%         head = max(i-half_window,I0);
%         tail = min(i+half_window,Iend);
        head = i-half_window;
        tail = i+half_window;
        data_win = data(head:tail);    
        formants = formantsWindow(data_win,Fs,p);

        for f = 1:length(formants)
        formants_all(i,f) = formants(f);
        end
    end
end

% formants_time = zeros(length(data),3);
% for i=1:voiced_no
%     head = voiced_segment(i,1);
%     tail = voiced_segment(i,2);
%     for f = 1:size(formants_all,2)
%         formants_time(head:tail,f) = formants_all(i,f);
%     end  
% end

figure;
formants_no = 3;
for f = 1:formants_no
    subplot(3,1,f);
    time_line = (1:length(data)).*1e3*dt;
    scatter(time_line,formants_all(:,f),'.');
    xlabel("Time(ms)")
    ylabel(['Formant ', num2str(f)])
end
suptitle(['Window length ', num2str(half_window*2+1),' LPC order ', num2str(p)]);





