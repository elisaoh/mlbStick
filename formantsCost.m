function M = formantsCost(fp, fc)
%UNTITLED7 Summary of this function goes here
% function M = formantsCost(fp, fc, bw)
%   fc candidate
%   fp formants of previous frame a 1*3 vector

% cost matrix
M = zeros(length(fc),length(fp));
tran = 1; %weights for transition cost
rang = 1e4;
% 
for c = 1:length(fc)
    for f = 1:length(fp)
       M(c,f) = tran*(fc(c)-fp(f))^2;
    end
end

f_min = [100,500,1000];
f_max = [1500,3500,4500];
for f = 1:length(fp)
   M((M(:,f)<f_min(f)) | (M(:,f)>f_max(f)),f) = rang;
end

end

