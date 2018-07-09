clear variables
addpath('vowelExtraction')
load mtlb
data = mtlb;
[voiced_segment,~] = vowelExtraction(data,Fs);
dt = 1/Fs;
% takes in a segment of vowel, return its formants
voiced_no = size(voiced_segment,1);
formants_all = zeros(voiced_no,3);

for seg = 1:voiced_no


I0 = voiced_segment(seg,1);
Iend = voiced_segment(seg,2);
x = data(I0:Iend);

x1 = x.*hamming(length(x));
preemph = [1 0.63];
x1 = filter(1,preemph,x1);



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

for f = 1:length(formants)
formants_all(seg,f) = formants(f);
end
end

formants_time = zeros(length(data),3);
for i=1:voiced_no
    head = voiced_segment(i,1);
    tail = voiced_segment(i,2);
    for f = 1:size(formants_all,2)
        formants_time(head:tail,f) = formants_all(i,f);
    end  
end


figure;
for f = 1:length(formants)
    subplot(3,1,f);
    time_line = (1:length(data)).*1e3*dt;
    plot(time_line,formants_time(:,f));
    xlabel("Time(ms)")
    ylabel(["Formant ", num2str(f)])
end





