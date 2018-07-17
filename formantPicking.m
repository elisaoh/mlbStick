% formant picking

% give formants_all; output formants_new
fp = formants_all;
fn = zeros(length(y),3);
M = 2;

for k = 2:length(y)
    for i = 1:2
    if fp(k,i)-fn(k-1,i) > M*(fp(k,i)-fn(k-1,i+1))
        fn(k,i+1) = fp(k,i);
        fn(k,i) = fp(k-1,i);
    end
    end
end

figure;
formants_no = 3;
for f = 1:formants_no
%     subplot(3,1,f);
    time_line = (1:length(y)).*dt;
    scatter(time_line,fn(:,f)./1e3,'.');
    hold on
%     xlabel("Time(ms)")
%     ylabel(['Formant ', num2str(f)])
end
hold off
% suptitle(['Window length ', num2str(half_window*2+1),' LPC order ', num2str(p)]);
title(['Window ', num2str(half_window*2+1),' Order ', num2str(p)]);
text(1.5,5,word,'Color','white','FontSize',14)
    