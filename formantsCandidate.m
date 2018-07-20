function [frqs, bw] = formantsCandidate( data_win, Fs, p)
%formantsCandidate find formants for a given window
%   data_win is a pre-cropped window size data;
%   p is the order of LPC estimator

%%
dt = 1/Fs;
x = data_win;

x1 = x.*hamming(length(x));
preemph = [1 0.63];
x1 = filter(1,preemph,x1);

A = lpc(x1,p); %lpc order
rts = roots(A); 

rts = rts(imag(rts)>=0);  %retain only roots with one sign
angz = atan2(imag(rts),real(rts)); %angles

[frqs, indices] = sort(angz.*(Fs/(2*pi)));
bw = -1/2*(Fs/(2*pi))*log(abs(rts(indices))); % bandwidth radius of the poles

end

