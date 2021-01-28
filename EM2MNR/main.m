% This code mainly implements EM2MNR in "Evolutionary multitasking multilayer network reconstruction".
% If you have any questions, please contact my email: Xiao Feng(Email: xiaofengxd@126.com£©

clc,clear all
addpath(genpath('EM2MNR'))
%% parameter settings
N = 100;                                   % Population size
proC = 1;                                  % SBX probability
disC = 2;                                  % SBX parameter
proM = 1;                                  % PM probability
disM = 5;                                  % PM parameter
gen = 1000;                                % Max generation
Gtf = 10;                                  % transfer every few generations
selection_process = 'elitist';             % Option£ºelitist¡¢roulette wheel¡¢Tournament
name = 1;                                  % Test suite£º1~24
NL = 10;                                   % Number of transfer solutions
Nm = 1;                                    %Number of samples, Option:0.4£º0.1£º1
times = 1;                                 % Number of runs

%% Initialization task
Task = TASK();
Task = initTASK(Task,name,Nm);

%% Multiple experiments
EvBestFitness = zeros(gen+1,Task.M);                        %Since the initialization result is also saved, the 0th generation, so gen+1
TotalEvaluations=zeros(Task.M,1);                           %Number of individual evaluations on each task
BestFitness = zeros(times,Task.M);                          %Store the optimal solution for each run

for i =1:times
    disp(['Times = ', num2str(i)]);
    data_results(i) = EM2MNR(proC,disC,proM,disM,selection_process,Task,Gtf,NL,N,gen);%Call algorithm
    EvBestFitness = EvBestFitness + data_results(i).EvBestFitness;
    BestFitness(i,:) = data_results(i).EvBestFitness(end,:);
    TotalEvaluations = max(TotalEvaluations,data_results(i).Evaluations);
    for j = 1:Task.M
        p = data_results(i).bestchromo(j,:)';
        p(p<0) = 0;
        p(p>1) = 1;
        p = reshape(p,[Task.numofnode,Task.numofnode]);
        p = p-diag(diag(p));
        error = round(abs(p-Task.net{j}.w));
        error(error~=0)=1;
        cou = sum(sum(error));
        sr(i,j) = 1-cou/(Task.numofnode*Task.numofnode);
        result1 = sum(sum(abs(p-Task.net{j}.w)));
        realerror = Task.fun(j).fnc(reshape(Task.net{j}.w,[1,Task.numofnode*Task.numofnode]));
    end
end
EvBestFitness = EvBestFitness./times;%Calculate the mean value of fitness for each generation
disp(sr)

%% Drawing
for i=1:Task.M
    figure(i)
    hold on
    plot(log(EvBestFitness(:,i)),'r','LineWidth',2.5);
    xlabel('GENERATIONS');
    ylabel(['TASK ', num2str(i), ' OBJECTIVE']);
%     saveas(gcf,['Data\figure_',num2str(name),'_Task',num2str(i),'_Gtf',num2str(Gtf),'_N',num2str(N),'.jpg']);
end

%% Record multiple average experiment results
data.EvBestFitness=EvBestFitness;
data.BestFitness = BestFitness;
data.TotalEvaluations = TotalEvaluations;
data.sr = sr;
% save(['Data\EM2MNR_Nm_',num2str(Nm),'_',nname3,'_',num2str(name),'_',num2str(Gtf),'_datasum.mat'],'data');