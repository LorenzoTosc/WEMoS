%% Analisi HRV PROVA
close all
clear all
clc

%% Costruisco un segnale artificiale per capire tutti i passaggi di analisi tempo e frequenza

%parto costruendo artificialmente un 
%vettore RR con la funzione randn. Degli RR ipotizzo media e deviazione
%standard, che servono per costruire valori ragionevoli in ms, altrimenti randn da sola dà valori
%casuali da distribuzione normale standard (media 0, dev_st=1). Media e
%devst ipotizzate dalla tabella di classificazione emozioni.
%La lunghezza è 400 perchè considero 5 min di registrazione
 

N_RR = 400;
media_hp = 750; %media teorica ipotizzata con freq media di 80bpm
devst_hp = 40; %deviazione std teorica ipotizzata
RR = randn(1,N_RR)*devst_hp + media_hp;


%% Rappresentazione

figure(1) 
stem(1:50, RR(1:50));
title('HRV(n) as function of beats')
xlabel('Beat number')
ylabel('RR intervals [ms]')
axis([0 50 0 1000]) %limito i valori degli assi per maggiore chiarezza, fino al 50esimo battito


%vettore time
time(1) = RR(1)/1000; % in [s]
for i=2:N_RR
    time(i) = time(i-1) + RR(i)/1000;
end

figure(2) 
plot(time, RR)
title('HRV(t) as function of time', 'FontSize', 20)
xlabel('Time [s]', 'FontSize', 18)
ylabel('RR intervals [ms]', 'FontSize', 18)
set(gca, 'FontSize', 16)
axis([0 300 400 1000]) %asse x con tutta la durata del segnale 


%% Indici nel tempo

%Dato RR casuale, media campionaria (mean) e deviazione standard
%campionaria (SDNN) sono calcolate a posteriori e tenderanno ai valori
%teorici impostati

MEAN = mean(RR);

SDNN = std(RR);

RMSSD = sqrt(mean(diff(RR).^2));

PNN50 = length(find(abs(diff(RR))>50)) / (N_RR-1);


%% Interpolazione e ricampionamento

% siccome l'HRV è un segnale non uniformemente campionato, bisogna...
% approssimarlo con un interpolatore e poi ricampionarlo

fs = 4; %[Hz]
Ts = 1/fs; %0.25s
time_res = min(time):Ts:max(time); 

RR_res = interp1(time, RR, time_res);


figure(3) 
%zoom in dei primi 5 sec di HRV. Sopra le proiezioni verticali sono di
%diversa ampiezza, mentre sotto dopo il ricampionamento sono uniformi e più
%fitte. NB il ricampionamento aumenta il numero di campioni di un segnale
%aumentando la risoluzione in frequenza

subplot(2,1,1)
stem(time, RR)
title('HRV before resampling', 'FontSize', 14)
xlabel('Time [s]', 'FontSize', 12)
ylabel('RR intervals [ms]', 'FontSize', 12)
axis([0.5 6 400 1000]) %primi 10 secondi
set(gca, 'FontSize', 12)
%hold on
%plot(time_res, RR_res)

subplot(2,1,2)
stem(time_res, RR_res)
title('Resampled HRV', 'FontSize', 14)
xlabel('Time [s]', 'FontSize', 12)
ylabel('RR intervals [ms]', 'FontSize', 12)
axis([0.5 6 400 1000]) %primi 10 secondi
set(gca, 'FontSize', 12)
%hold on
%plot(time_res, RR_res)


%% DFT e PSD

N = length(RR_res);
DFT = abs(fft(RR_res));
PSD = (N*fs)\DFT.^2;

if (mod(N,2)==0) %numero pari di campioni
    PSD = PSD(2:N/2+1);
    PSD(2:end-1) = 2*PSD(2:end-1);
else %numero dispari di campioni
    PSD = PSD(2:(N+1)/2);
    PSD(2:end) = 2*PSD(2:end);
end

freq = fs/N:fs/N:fs/2; %l'inizio non è 0 perché ho tolto la componente continua, per chiarezza nel grafico
%oppure freq = linspace(0,fs/2,length(PSD));


figure(4)
plot(freq, PSD)
xlabel('Frequencies [Hz]', 'Fontsize', 22)
ylabel('Amplitude  [ms^2 / Hz]', 'Fontsize', 22)
title('POWER SPECTRAL DENSITY', 'FontSize', 26)
xlim([0 1])
set(gca, 'FontSize', 20)

hold on
x_VLF = [0:fs/N:0.04, 0.04];
l1 = length(x_VLF);
y_VLF = [0, PSD(1:l1-2), 0];
fill(x_VLF, y_VLF, 'y')

hold on
x_LF = [0.04, x_VLF(end-1):fs/N:0.15, 0.15];
l2 = length(x_LF);
y_LF = [0, PSD(l1-2 : l1+l2-5), 0];
fill(x_LF, y_LF, 'g')

hold on
x_HF = [0.15, x_LF(end-1):fs/N:0.4, 0.4];
l3 = length(x_HF);
y_HF = [0, PSD(l1+l2-5 : l1+l2+l3-8), 0];
fill(x_HF, y_HF, 'r')

legend('', 'VLF', 'LF', 'HF')
legend('FontSize', 32)


%% Indici in frequenza

max_indVLF = find(freq<=0.04, 1, 'last');
max_indLF = find(freq<=0.15, 1, 'last');
max_indHF = find(freq<=0.4, 1, 'last');

TOT = trapz(PSD);
VLF = trapz(PSD(1:max_indVLF+1));
LF = trapz(PSD(max_indVLF+1 : max_indLF+1));
HF = trapz(PSD(max_indLF+1 : max_indHF+1));
LFn = LF/(TOT-VLF);
HFn = HF/(TOT-VLF);
LF_HF = LF/HF;

disp(table(categorical({'MEAN';'SDNN';'RMSSD'; 'PNN50'; 'LFn'; 'HFn'; 'LF/HF'}),...
    [MEAN; SDNN; RMSSD; PNN50; LFn; HFn; LF_HF],...
    categorical({'[ms]'; '[ms]'; '[ms]'; '[adim]'; '[adim]'; '[adim]'; '[adim]'})));
