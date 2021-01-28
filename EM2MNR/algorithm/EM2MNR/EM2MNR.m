function data_EM2MNR = EM2MNR(proC,disC,proM,disM,selection_process,Task,Gtf, NL,N,gen)
    % This code mainly implements EM2MNR
    % Input:  proC,disC,proM,disM,
    %         selection_process:elitist,roulette wheel,Tournament,
    %         Gtf:transfer every few generations,NL:Number of transfer solutions
    % Output: data_EM2MNR£¨run time,Best value for each generation,Best individual,the number of Evaluation£©
    tic
    %% 0.Record the optimal solution matrix
    EvBestFitness = zeros(gen+1,Task.M);                       %The best fitness value of each generation
    EvBestFitness_evn = inf(Task.M,1);                         %The best fitness value after each evaluation
    bestchromo = zeros(Task.M,Task.D_multitask);               %Optimal chromosome
    Evaluations=zeros(Task.M,1);                               %Number of individual evaluations on each task
    bestSolution = zeros(NL,Task.D_multitask,Task.M);          %Excellent solution of the top NL on each task
    rand('twister',sum(100*clock));
    %% 1.Initial population
    Population = INDIVIDUAL();
    Population = initPOP(Population,N,Task);
    %% 2.Evaluate the objective function value of each individual
    for j = 1:Population.P
            [Population.factorial_costs(Population.flag == j,:),Population.rnvec(Population.flag == j,:),Evaluations,EvBestFitness_evn]=CalObj(Task,Population.rnvec(Population.flag == j,:),j,Evaluations,EvBestFitness_evn);
            EvBestFitness(1,j) = EvBestFitness_evn(j);
            [~,y] = sort(Population.factorial_costs(Population.flag == j,:));
            trnvec = Population.rnvec(Population.flag == j,:);
            bestSolution(:,:,j) = trnvec(y(1:NL),:);
            bestchromo(j,:) = trnvec(y(1),:);
    end
    %% 3.optimization process
    for i = 1:gen
        for j = 1:Population.P
            if (EvBestFitness_evn(j) >= 1e-06)             
                % Knowledge transfer
                if mod(i,Gtf) == 0
                    % 3.0 Obtain transferred solutions
                    tfsol = [];
                    for k = 1:Population.P
                        if k ~= j
                            tftemp = mDA(bestSolution(:,1:Task.Tdims(j),j), bestSolution(:,1:Task.Tdims(k),k), bestSolution(:,1:Task.Tdims(k),k));
                            tfsol = [tfsol;tftemp];
                        end
                    end
                    % 3.1 Generate offspring
                    Offspring = Population;
                    [Offspring.rnvec(Offspring.flag == j,1:Task.Tdims(j)),tfsoln] = tfGA(Population.rnvec(Population.flag == j,1:Task.Tdims(j)),Task,j,{proC,disC,proM,disM},i,gen,Population.factorial_costs(Population.flag == j,:),tfsol);
                    
                    % 3.2 Evaluation of individual offspring and candidate transferred solutions
                    [Offspring.factorial_costs(Offspring.flag == j,:),Offspring.rnvec(Offspring.flag == j,:),Evaluations,EvBestFitness_evn]=CalObj(Task,Offspring.rnvec(Offspring.flag == j,:),j,Evaluations,EvBestFitness_evn);
                    [factorial_costs,tfsol,Evaluations,EvBestFitness_evn]=CalObj(Task,tfsol,j,Evaluations,EvBestFitness_evn);
                    [factorial_costsn,tfsoln,Evaluations,EvBestFitness_evn]=CalObj(Task,tfsoln,j,Evaluations,EvBestFitness_evn);

                    % 3.3 Merge parent,offspring and candidate transferred solutions
                    Population = tfES(Population,Offspring,[tfsol;tfsoln],[factorial_costs;factorial_costsn],selection_process,N,j);
                % No knowledge transfer
                else
                    % 3.1 Generate offspring
                    Offspring = Population;
                    Offspring.rnvec(Offspring.flag == j,1:Task.Tdims(j)) = GA(Population.rnvec(Population.flag == j,1:Task.Tdims(j)),Task,j,{proC,disC,proM,disM},i,gen,Population.factorial_costs(Population.flag == j,:));
                    % 3.2 Evaluation of individual offspring
                    [Offspring.factorial_costs(Offspring.flag == j,:),Offspring.rnvec(Offspring.flag == j,:),Evaluations,EvBestFitness_evn]=CalObj(Task,Offspring.rnvec(Offspring.flag == j,:),j,Evaluations,EvBestFitness_evn);

                    % 3.3 Merge the parents and the children
                    Population = EnvironmentalSelection(Population,Offspring,selection_process,N,j);

                end
                % 3.4 Record the optimal solution of the current task
                [~,y] = sort(Population.factorial_costs(Population.flag == j,:));
                trnvec = Population.rnvec(Population.flag == j,:);
                bestSolution(:,:,j) = trnvec(y(1:NL),:);
                bestchromo(j,:) = trnvec(y(1),:);
                EvBestFitness(i+1,j) = EvBestFitness_evn(j);               
            end
        end
        disp(['EM2MNR Gen = ', num2str(i), ' BFit = ', num2str(EvBestFitness(i+1,:))]);
    end

    %% Record algorithm results
    data_EM2MNR.wall_clock_time=toc;
    data_EM2MNR.EvBestFitness=EvBestFitness;
    data_EM2MNR.EvBestFitness_evn=EvBestFitness_evn;
    data_EM2MNR.Evaluations=Evaluations;
    data_EM2MNR.bestchromo = bestchromo;