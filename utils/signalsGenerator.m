clc;
clear;
close all;


maxTime = 0.5;
f1 = 20;
f2 = 2e3;
oscilloscopeFrequency = 40e3;

t = linspace(0, maxTime, oscilloscopeFrequency);
y1 = 1 + 0.05*sin(2*pi*f1*t);
y2 = -2 + sin(2*pi*f2*t);

fixedY1 = 25*(y1 - 1);
fixedY2 = 1.25*(y2 + 2);
fixedY = fixedY1 + fixedY2 ;

#plot(t, fixedY);

filename = "samples.txt";
save(filename, "fixedY");
