




folder = '/home/ksmith/data/sinergia_evaluation/annotations/celltracking/';


FItotal = 0;
FNtotal = 0;
FPtotal = 0;
MOtotal = 0;
MTtotal = 0;
OKtotal = 0;


for i = 1:20

    filename = sprintf('%sannotation%03d.mat', folder, i);
    load(filename);

    
    FItotal = FItotal + sum(FIcount);
    FNtotal = FNtotal + sum(FNcount);
    FPtotal = FPtotal + sum(FPcount);
    MOtotal = MOtotal + sum(MOcount);
    MTtotal = MTtotal + sum(MTcount);
    OKtotal = OKtotal + sum(OKGTcount) + sum(OKESTcount);
    
    
end


CELLtotal = FItotal + FNtotal + FPtotal + MOtotal + MTtotal + OKtotal;


fprintf('Soma tracking summary:\n\n');
fprintf('%d total tracked detections\n',CELLtotal);
fprintf('%1.2f%% correct   (%d)\n', (OKtotal/CELLtotal)*100, OKtotal);
fprintf('%1.2f%% FN errors (%d)\n', (FNtotal/CELLtotal)*100, FNtotal);
fprintf('%1.2f%% FP errors (%d)\n', (FPtotal/CELLtotal)*100, FPtotal);
fprintf('%1.2f%% MO errors (%d)\n', (MOtotal/CELLtotal)*100, MOtotal);
fprintf('%1.2f%% MT errors (%d)\n', (MTtotal/CELLtotal)*100, MTtotal);
fprintf('%1.2f%% FI errors (%d)\n', (FItotal/CELLtotal)*100, FItotal);


