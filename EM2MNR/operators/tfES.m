function Population = tfES(Population,Offspring,tfsol,factorial_costs,selection_process,N,M)
% EnvironmentalSelection

%--------------------------------------------------------------------------
    nvec = [Population.rnvec(Population.flag == M,:);Offspring.rnvec(Offspring.flag == M,:);tfsol];
    fitness = [Population.factorial_costs(Population.flag == M,:);Offspring.factorial_costs(Offspring.flag == M,:);factorial_costs];
    if strcmp(selection_process,'elitist')
        [~,index]=sort(fitness);
    elseif strcmp(selection_process,'roulette wheel')
            index = RouletteWheelSelection(N,fitness);
    elseif strcmp(selection_process,'Tournament')
            index = TournamentSelection(2,N,fitness);
    end
    Population.rnvec(Population.flag == M,:) = nvec(index(1:N),:);
    Population.factorial_costs(Population.flag == M,1) = fitness(index(1:N),1);    
end