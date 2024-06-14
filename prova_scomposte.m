%% Prova con funzioni scomposte
clear all

Timestamps = [1484.375, 2161.7281436920166, 3578.125, 4363.111972808838, 5217.644691467285, 6119.647979736328, 6950.066566467285, 7803.906440734863, 8635.893821716309, 9433.688163757324, 10274.007797241211, 11123.857498168945, 11936.686515808105, 12816.404342651367, 13706.754684448242, 14555.788040161133, 15462.40234375, 16347.175598144531, 17174.667358398438, 18109.375, 18995.66650390625, 19801.219940185547, 20554.758071899414, 33406.25, 34750.0, 36843.75, 37593.75, 38343.75, 43734.375];

RR_raw=[];
for i = 1:length(Timestamps)-1
    RR_raw(i) = Timestamps(i+1)-Timestamps(i);
end

ind = find(RR_raw>=510 & RR_raw<=990); %750+(4*60)
RR = RR_raw(ind);

N_RR=length(RR);


%% Indici tempo

MEAN = mean(RR);

%scompongo funzione std
sum = 0;
for i = 1:N_RR
    sum = sum + (RR(i)-MEAN)^2;
end
SDNN = sqrt(sum/(N_RR-1));

%scompongo funzioni diff e mean
sum = 0;
for i=2:N_RR
    sum = sum + (RR(i)-RR(i-1))^2; 
end
RMSSD = sqrt(sum/(N_RR-1)); 

cont = 0; 
for i=2:N_RR
    if (abs(RR(i)-RR(i-1)) > 50) 
        cont = cont + 1;
    end
end
PNN50 = cont/(N_RR-1);


%% Time

time(1) = RR(1)/1000; % in [s]
for i=2:N_RR
    time(i) = time(i-1) + RR(i)/1000;
end

fs = 4; %[Hz]
Ts = 1/fs; %0.25s

%% Time_res
%scompongo la costruzione di un vettore data la spaziatura Ts

i = 1;
time_res(1) = time(1); 
while time_res(i)+Ts <= max(time)
    time_res(i+1) = time_res(i) + Ts;
    i=i+1;
end
N = length(time_res);

%% RR_res
%scompongo la funzione interp1

RR_res(1) = RR(1);
j = 1; %j indice del vettore time_res

for i=2:N_RR  %i indice del vettore time
    m = (RR(i)-RR(i-1)) / (time(i)-time(i-1));  %calcola m,q di ogni spezzone di retta tra 2 punti
    q = RR(i-1) - m*time(i-1);                           
    
    while j<=N && time_res(j) < time(i)
        RR_res(j) = m*time_res(j) + q; %calcola il nuovo valore di RR in corrispondenza del nuovo valore di tempo
        j=j+1;
    end
end

%% DFT
%scompongo la funzione fft

if (mod(N,2) == 0) %N pari
    len_stop = N/2 + 1; %lunghezza di arresto
else 
    len_stop = (N+1)/2; 
end


for k=1:len_stop   %k ed n come indici dei cicli per coerenza con la formula

    % dobbiamo costruire cosine e sine, due vettori di lunghezza N con cui, ad ogni k, moltiplicare punto a punto RR_res
    % cosine e sine cambiano ad ogni k e rappresentano le sinusoidi discrete rispetto cui viene confrontato il segnale
    for n=1:N  
        cosine(n) = cos(2*pi/N * (k-1) * (n-1));
    end
    
    for n=1:N
        sine(n) = sin(2*pi/N * (k-1) * (n-1));
    end
    
    %parte reale
    sum = 0;
    for n=1:N
        sum = sum + RR_res(n)*cosine(n);
    end
    Re(k) = sum;

    %parte immaginaria
    sum = 0;
    for n=1:N
        sum = sum + RR_res(n)*sine(n);
    end
    Im(k) = sum;


end


%% PSD
%scompongo la funzione periodogram

for k=1:len_stop 
    PSD(k) = (Re(k)^2 + Im(k)^2) / (N*fs) ;
end

if (mod(N,2) == 0) 
    for k=2:(len_stop-1)  %dal secondo al penultimo termine
        PSD(k) = 2*PSD(k);
    end
else 
    for k=2:len_stop  %dal secondo all'ultimo termine
        PSD(k) = 2*PSD(k);
    end
end

%% Freq
%scompongo la costruzione di un vettore data la spaziatura deltaf

if (mod(N,2) == 0)  
    deltaf = fs/N;
else 
    deltaf = fs/(N-1);
end

freq(1) = 0; %[Hz]
for i=2:len_stop
    freq(i) = freq(i-1) + deltaf;
end

%% Indici di frequenza
%scompongo le funzioni find e trapz

i = 1;

VLF = 0;
while freq(i) < 0.04
    area = (PSD(i)+PSD(i+1))*deltaf/2;  %L'altezza dei trapezi non cambia e coincide con deltaf
    VLF = VLF + area;
    i=i+1;
end

LF = 0;
while freq(i) < 0.15  %l'indice i è in continuità con il ciclo precedente
    area = (PSD(i)+PSD(i+1))*deltaf/2;
    LF = LF + area;
    i=i+1;
end

HF = 0;
while freq(i) < 0.4
    area = (PSD(i)+PSD(i+1))*deltaf/2;
    HF = HF + area;
    i=i+1;
end

%potenza restante
P_rest = 0;
while freq(i) < freq(end)  %fnyq: ultima frequenza rappresentabile
    area = (PSD(i)+PSD(i+1))*deltaf/2;
    P_rest = P_rest + area;
    i=i+1;
end


TOT = VLF + LF + HF + P_rest;

LFn = LF/(TOT - VLF);
HFn = HF/(TOT - VLF);
LF_HF = LF/HF;


disp(table(categorical({'MEAN';'SDNN';'RMSSD'; 'PNN50'; 'LFn'; 'HFn'; 'LF/HF'}),...
    [MEAN; SDNN; RMSSD; PNN50; LFn; HFn; LF_HF],...
    categorical({'[ms]'; '[ms]'; '[ms]'; '[adim]'; '[adim]'; '[adim]'; '[adim]'})));

