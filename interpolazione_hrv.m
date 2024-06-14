%% Interpolazione
close all
clear all
clc

%dati con nodi di tempo non equispaziati

RR = [780 820 730 690 650 810 870 780 730 700 690 650 600 700 720];

time(1) = RR(1)/1000; % in [s]
for i=2:length(RR)
    time(i) = time(i-1) + RR(i)/1000;
end

figure(1)
%scatter(time, RR, 'filled');
stem(time,RR);
title('HRV: unevenly sampled signal','FontSize',20)
xlabel('time [s]', 'FontSize',18);
ylabel('RR intervals [ms]','FontSize',18);
ylim([300 1000]);

tq = linspace(min(time), max(time), 500); %vettore di istanti di query di 100 punti di default


%% Interpolatore lagrangiano

deg = length(time)-1;
coeff = polyfit(time, RR, deg);
interp_lag = polyval(coeff, tq);

figure(2)
subplot(2,2,1)
plot(tq, interp_lag);
title('Lagrange interpolator','FontSize',18);
xlabel('time [s]');
ylabel('RR intervals [s]');
ylim([300 1000]);
hold on
scatter(time, RR, 'filled');

%problema: oscillazione all'estremità


%% Interpolatore composito lineare (~ spline lineare)

interp_comp_lin = interp1(time, RR, tq); %defualt 'linear'

subplot(2,2,2)
plot(tq, interp_comp_lin);
title('Linear interpolator','FontSize',18);
xlabel('time [s]');
ylabel('RR intervals [s]');
ylim([300 1000]);
hold on
scatter(time, RR, 'filled');


%% Interpolatore spline cubico 

interp_spline_cub = spline(time, RR, tq);

subplot(2,2,3)
plot(tq, interp_spline_cub);
title('Cubic spline interpolator','FontSize',18);
xlabel('time [s]');
ylabel('RR intervals [s]');
ylim([300 1000]);
hold on
scatter(time, RR, 'filled');

% ha meno oscillazioni che lagrangiano
% NB l'interpolatore composito non lo uso perché spezzato


%% Interpolatore a mantenimento nearest

interp_mant1 = interp1(time, RR, tq, 'nearest'); 

subplot(2,2,4)
plot(tq, interp_mant1);
title('Hold interpolator','FontSize',18);
xlabel('time [s]');
ylabel('RR intervals [s]');
ylim([300 1000]);
hold on
scatter(time, RR, 'filled');


