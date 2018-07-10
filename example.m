load mtlb

% play the audio segment
% y = audioplayer(mtlb,Fs);
% play(y);

%% extract the segment with voiced sound 
% can use LS
%identify voiced segment

% segmentlen = 100; %window size
% noverlap = 90; %overlapping size
% NFFT = 128; %sampling points for DFT
% 
% spectrogram(mtlb,segmentlen,noverlap,NFFT,Fs,'yaxis')
% title('Signal Spectrogram')

%%  extract first vowel
dt = 1/Fs;
I0 = round(0.1/dt);
Iend = round(0.25/dt);
x = mtlb(I0:Iend);

x1 = x.*hamming(length(x));
preemph = [1 0.63];
x1 = filter(1,preemph,x1);

% figure;
% spectrogram(x,segmentlen,noverlap,NFFT,Fs,'yaxis')
% figure;
% spectrogram(x1,segmentlen,noverlap,NFFT,Fs,'yaxis')

A = lpc(x1,8); %lpc order
rts = roots(A); 

rts = rts(imag(rts)>=0);  %retain only roots with one sign
angz = atan2(imag(rts),real(rts)); %angles

[frqs, indices] = sort(angz.*(Fs/(2*pi)));
bw = -1/2*(Fs/(2*pi))*log(abs(rts(indices))); % ?

nn = 1;
for kk = 1:length(frqs)
    if (frqs(kk) > 90 && bw(kk) <400)
        formants(nn) = frqs(kk);
        nn = nn+1;
    end
end

formants







