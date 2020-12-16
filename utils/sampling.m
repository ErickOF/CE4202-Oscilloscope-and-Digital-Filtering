clc;
clear;
close all;

%pkg install -forge control;
%pkg install -forge signal;

pkg load signal;

% sf = Frecuencia de muestreo
sf = 40e3;
sf2 = sf/2;

fc_1 = 20;
fc_2 = 2e3;

% Read CSV
M = csvread("ChannelD.csv", 1, 0);

% Get Data
t = M(:, 1);
_samples = M(:, 2);
_samples -= max(_samples)/2;

% Choose samples
data = [];
new_time = [];
current_time = 0;
time_step = 1/sf;

for i=1:size(_samples)
  if current_time <= t(i)
    data(end + 1) = _samples(i);
    new_time(end + 1) = t(i);
  end
end


% Frecuencia de corte = Frec. corte real / sf2
[b_1, a_1] = butter(1, fc_1/sf2)
filtered_1 = filter(b_1, a_1, data);
[b_2, a_2] = butter(1 , fc_2/sf2, "high")
filtered_2 = filter(b_2, a_2, data);

clf;

subplot(4, 1, 1);
plot(new_time, data, "; Entrada; ");
axis([0 0.5]);
subplot(4, 1, 2);
plot(new_time, filtered_1, " ;Filtro pasa bajas; ")
axis([0 0.5])
subplot(4, 1, 3)
plot(new_time, filtered_2, " ; Filtro pasa altas; ")
axis([0 0.5])
subplot(4, 1, 4)
plot(new_time, filtered_2, " ;Filtro pasa altas; ")
axis([0 0.005])
