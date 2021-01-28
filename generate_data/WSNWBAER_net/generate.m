clc,clear
%This function is used to generate the network
name = '1';%the first net('1') or the second net('2')
N = 20;K = 2;p=0.1;m0=4;m=2;
G = WS_generate(N, K, p);
G1 = G;
sum(sum(G))/(size(G,1)*size(G,2))
% save([name,'_WS_N_',num2str(N),'.mat'],'G');

G = NW_generate(N, K, p);
G2 = G;
sum(sum(G))/(size(G,1)*size(G,2))
% save([name,'_NW_N_',num2str(N),'.mat'],'G');

G = BA_generate(N, m0, m);
G3 = G;
sum(sum(G))/(size(G,1)*size(G,2))
% save([name,'_BA_N_',num2str(N),'.mat'],'G');

G = ER_generate(N,0.04);
G4 = G;
sum(sum(G))/(size(G,1)*size(G,2))
% save([name,'_ER_N_',num2str(N),'.mat'],'G');