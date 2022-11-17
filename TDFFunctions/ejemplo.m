Fs = 60;
i = 3;
Ts = 1/Fs;
L = size(emgData(i,:));
t = (0:L-1)*Ts;
s = emgData(i,:);
figure
hold on
plot(s)

F = fft(s);
figure
hold on
plot(abs(F))