clc;
clear;
close all;


pkg load signal;

% sf = Frecuencia de muestreo
sf = 40e3;
sf2 = sf/2;

fc_1 = 20;
fc_2 = 2e3;

% Read CSV
[lp, hp] = textread("../digital_filter/output.txt", "%s,%s");

% Scale factor
sf = 5.0/(2.0**23);

lp_values = [];
hp_values = [];

for i=1:size(lp)
    if (size(lp(i)) == 32 && lp(i)(1) == "1")
        for j=1:size(lp(i))
            if (lp(i)(j) == "1")
                lp(i)(j) = "0";
            else
                lp(i)(j) = "1";
            end
        end

        lp_values(end + 1) = -(bin2dec(lp(i)) + 1)*sf;
    else
        lp_values(end + 1) = bin2dec(lp(i))*sf;
    end
    
    if (size(hp(i)) == 32 && hp(i)(1) == "1")
        for j=1:size(hp(i))
            if (hp(i)(j) == "1")
                hp(i)(j) = "0";
            else
                hp(i)(j) = "1";
            end
        end

        hp_values(end + 1) = -(bin2dec(hp(i)) + 1)*sf;
    else
        hp_values(end + 1) = bin2dec(hp(i))*sf;
    end
end

clf;

subplot(4, 1, 2);
plot(lp_values, " ;Filtro pasa bajas; ")
#axis([0 0.5])
subplot(4, 1, 3)
plot(hp_values, " ; Filtro pasa altas; ")
#axis([0 0.5])
subplot(4, 1, 4)
plot(hp_values, " ;Filtro pasa altas; ")
#axis([0 0.005])
