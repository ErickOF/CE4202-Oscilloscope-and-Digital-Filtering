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

structData = load("samples.txt", "fixedY");
data = structData.fixedY;

% Frecuencia de corte = Frec. corte real / sf2
[b_1, a_1] = butter(1, fc_1/sf2);
filtered_1 = filter(b_1, a_1, data);
[b_2, a_2] = butter(1 , fc_2/sf2, "high");
filtered_2 = filter(b_2, a_2, data);

clf;

subplot(4, 1, 1);
plot(data, "; Entrada; ");
axis([0 fc_1*400]);
subplot(4, 1, 2);
plot(filtered_1, " ;Filtro pasa bajas; ")
axis([0 fc_1*400])
subplot(4, 1, 3)
plot(filtered_2, " ; Filtro pasa altas; ")
axis([0 fc_1*400])
subplot(4, 1, 4)
plot(filtered_2, " ;Filtro pasa altas; ")
axis([0 fc_1*10])
