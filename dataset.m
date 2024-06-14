%% DATASET 
clear all
load DREAMER.mat

% ricaviamo la matrice di riferimento da questo database


%% CALCOLO DEGLI INDICI

fs=256;

indici_hap=[];
indici_anger=[];
indici_fear=[];
indici_sad=[];
indici_calm=[];

for i=1:23  %calcolo indici relativi ai partecipanti

    %%%%%%%% felicità - filmato 7 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:2
        ECG=DREAMER.Data{1,i}.ECG.stimuli{7,1}(:,j);
        %salvo valori del database in una variabile ECG

        [~,R_peaks,~]=pan_tompkin(ECG,256,0);
        %applico pan tompkins per trovare posizione picchi r

        RR=[];  %ora estraggo il vettore delle distanze tra picchi r consecutivi

        for z=1:length(R_peaks)-1
            RR=[RR, (R_peaks(z+1)-R_peaks(z))/fs*1000];
        end

        [RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF]=calcoloindici(RR);
        %calcolo indici tempo-frequenza e li salvo in una matrice
        indici_hap=[indici_hap; RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF];

    end

    %%%%%%%%%% felicità - filmato 13 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:2
        ECG=DREAMER.Data{1,i}.ECG.stimuli{13,1}(:,j);
        [~,R_peaks,~]=pan_tompkin(ECG,256,0);
        RR=[]; 

        for z=1:length(R_peaks)-1
            RR=[RR, (R_peaks(z+1)-R_peaks(z))/fs*1000];
        end

        [RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF]=calcoloindici(RR);
        indici_hap=[indici_hap; RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF];

    end

    %%%%%%%%%% paura - filmato 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:2
        ECG=DREAMER.Data{1,i}.ECG.stimuli{4,1}(:,j);
        [~,R_peaks,~]=pan_tompkin(ECG,256,0);
        RR=[];  

        for z=1:length(R_peaks)-1
            RR=[RR, (R_peaks(z+1)-R_peaks(z))/fs*1000];
        end

        [RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF]=calcoloindici(RR);
        indici_fear=[indici_fear; RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF];

    end

    %%%%%%%% paura - filmato 15 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:2
        ECG=DREAMER.Data{1,i}.ECG.stimuli{15,1}(:,j);
        [~,R_peaks,~]=pan_tompkin(ECG,256,0);
        RR=[];  

        for z=1:length(R_peaks)-1
            RR=[RR, (R_peaks(z+1)-R_peaks(z))/fs*1000];
        end

        [RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF]=calcoloindici(RR);
        indici_fear=[indici_fear; RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF];

    end

    %%%%%%%%%% rabbia - filmato 8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:2
        ECG=DREAMER.Data{1,i}.ECG.stimuli{8,1}(:,j);
        [~,R_peaks,~]=pan_tompkin(ECG,256,0);
        RR=[];  

        for z=1:length(R_peaks)-1
            RR=[RR, (R_peaks(z+1)-R_peaks(z))/fs*1000];
        end

        [RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF]=calcoloindici(RR);
        indici_anger=[indici_anger; RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF];

    end

    %%%%%%%%%% rabbia - filmato 14 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:2
        ECG=DREAMER.Data{1,i}.ECG.stimuli{14,1}(:,j);
        [~,R_peaks,~]=pan_tompkin(ECG,256,0);
        RR=[];  

        for z=1:length(R_peaks)-1
            RR=[RR, (R_peaks(z+1)-R_peaks(z))/fs*1000];
        end

        [RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF]=calcoloindici(RR);
        indici_anger=[indici_anger; RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF];

    end

    %%%%%%%%% tristezza - filmato 9 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:2
        ECG=DREAMER.Data{1,i}.ECG.stimuli{9,1}(:,j);
        [~,R_peaks,~]=pan_tompkin(ECG,256,0);
        RR=[];  

        for z=1:length(R_peaks)-1
            RR=[RR, (R_peaks(z+1)-R_peaks(z))/fs*1000];
        end

        [RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF]=calcoloindici(RR);
        indici_sad=[indici_sad; RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF];

    end

    %%%%%%%%%% tristezza - filmato 17 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:2
        ECG=DREAMER.Data{1,i}.ECG.stimuli{17,1}(:,j);
        [~,R_peaks,~]=pan_tompkin(ECG,256,0);
        RR=[];  

        for z=1:length(R_peaks)-1
            RR=[RR, (R_peaks(z+1)-R_peaks(z))/fs*1000];
        end

        [RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF]=calcoloindici(RR);
        indici_sad=[indici_sad; RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF];

    end


    %%%%%%%% calma - filmato 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:2
        ECG=DREAMER.Data{1,i}.ECG.stimuli{1,1}(:,j);
        [~,R_peaks,~]=pan_tompkin(ECG,256,0);
        RR=[];  
        for z=1:length(R_peaks)-1
            RR=[RR, (R_peaks(z+1)-R_peaks(z))/fs*1000];
        end

        [RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF]=calcoloindici(RR);
        indici_calm=[indici_calm; RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF];

    end

    %%%%%%%%%% calma - filmato 11 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=1:2
        ECG=DREAMER.Data{1,i}.ECG.stimuli{11,1}(:,j);
        [~,R_peaks,~]=pan_tompkin(ECG,256,0);
        RR=[];  

        for z=1:length(R_peaks)-1
            RR=[RR, (R_peaks(z+1)-R_peaks(z))/fs*1000];
        end

        [RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF]=calcoloindici(RR);
        indici_calm=[indici_calm; RRMean,SDNN,RMSSD,PNN50,LFn,HFn,LF_HF];

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

matrTot= [indici_hap; indici_fear; indici_anger; indici_sad; indici_calm];



%% Assegnamento labels

classificazione=[];

emozioni = categorical(["happiness", "fear", "anger", "sadness", "calm"]);

for i=1:5
    for j=1:92
        classificazione = [classificazione; emozioni(i)];
    end
end

clear RRMean SDNN RMSSD PNN50 LFn HFn LF_HF R_peaks RR i j z ECG


%% PREPROCESSING DELLA MATRICE

% standardizzazione

mean_Std=[];
std_Std=[];

matrStd = matrTot;

for i=1:7
    mean_Std(i) = mean(matrTot(:,i));
    std_Std(i) = std(matrTot(:,i));
    matrStd(:,i) = (matrTot(:,i)-mean_Std(i))./std_Std(i);
end


% LDA

[W, L] = lda(matrStd, classificazione);

matrLDA = matrStd*W;




