function index = RouletteWheelSelection(N,Fitness)
% RouletteWheelSelection£¨The smaller the fitness value, the greater the probability of being selected£©

    Fitness = reshape(Fitness,1,[]);
    Fitness = Fitness + min(min(Fitness),0);
    Fitness = cumsum(1./Fitness);
    Fitness = Fitness./max(Fitness);
    index   = arrayfun(@(S)find(rand<=Fitness,1),1:N);
end