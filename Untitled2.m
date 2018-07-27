figure;
plot(y)
hold on
v = zeros(length(y),1);
v(8300:12300) = 1;
plot(v)
hold off