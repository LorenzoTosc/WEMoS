%% Prova con funzioni built-in 
close all
clear all


Timestamps = [1484.375, 2161.7281436920166, 3578.125, 4363.111972808838, 5217.644691467285, 6119.647979736328, 6950.066566467285, 7803.906440734863, 8635.893821716309, 9433.688163757324, 10274.007797241211, 11123.857498168945, 11936.686515808105, 12816.404342651367, 13706.754684448242, 14555.788040161133, 15462.40234375, 16347.175598144531, 17174.667358398438, 18109.375, 18995.66650390625, 19801.219940185547, 20554.758071899414, 33406.25, 34750.0, 36843.75, 37593.75, 38343.75, 43734.375];

RR_raw=[];
for i = 1:length(Timestamps)-1
    RR_raw(i) = Timestamps(i+1)-Timestamps(i);
end

ind = find(RR_raw>=510 & RR_raw<=990); %750+(4*60) escludo valori anomali che considero oltre 4 dev standard dalla media
RR = RR_raw(ind);

N_RR=length(RR);


MEAN = mean(RR);
SDNN = std(RR);
RMSSD = sqrt(mean(diff(RR).^2));
PNN50 = length(find(abs(diff(RR))>50)) / (N_RR-1);


%% Interpolazione e ricampionamento

time(1) = RR(1)/1000; % in [s]
for i=2:N_RR
    time(i) = time(i-1) + RR(i)/1000;
end

fs = 4; %[Hz]
Ts = 1/fs; %0.25s

time_res = min(time):Ts:max(time);
N = length(time_res);

RR_res = interp1(time, RR, time_res);
RR_res = [RR_res, 750];

%% DFT e PSD

DFT = abs(fft(RR_res));
PSD = (N*fs)\DFT.^2;

if (mod(N,2)==0) %numero pari di campioni
    PSD = PSD(1:N/2+1);
    PSD(2:end-1) = 2*PSD(2:end-1);
else %numero dispari di campioni
    PSD = PSD(1:(N+1)/2);
    PSD(2:end) = 2*PSD(2:end);
end

freq = 0:fs/N:fs/2;

%% Indici

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

disp(table(categorical({'MEAN';'SDNN';'RMSSD';'PNN50';'LFn';'HFn';'LF/HF'}),...
    [MEAN; SDNN; RMSSD; PNN50; LFn; HFn; LF_HF],...
    categorical({'[ms]'; '[ms]'; '[ms]'; '[-]'; '[-]'; '[-]'; '[-]'})));