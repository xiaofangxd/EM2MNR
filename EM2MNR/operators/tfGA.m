function [Offspring,tfsoln] = tfGA(Parent,Task,j,Parameter,igen,gen,fitness,tfsol)
%GA - Genetic operators for real, binary, and permutation based encodings.
%--------------------------------------------------------------------------

    %% Parameter setting
    if nargin > 1
        [proC,disC,proM,disM] = deal(Parameter{:});
    else
        [proC,disC,proM,disM] = deal(1,20,1,20);
    end
%     index = TournamentSelection(2,size(Parent,1),fitness);
%     Parent = Parent(index,:);
    numparent = size(Parent,1);
    Parent = [Parent;tfsol];
    Parent1 = Parent(1:floor(end/2),:);
    Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
    [N,D]   = size(Parent1);

    %% Genetic operators for real encoding
    % Simulated binary crossover
    beta = zeros(N,D);
    mu   = rand(N,D);
    beta(mu<=0.5) = (2*mu(mu<=0.5)).^(1/(disC+1));
    beta(mu>0.5)  = (2-2*mu(mu>0.5)).^(-1/(disC+1));
    beta = beta.*(-1).^randi([0,1],N,D);
    beta(rand(N,D)<0.5) = 1;
    beta(repmat(rand(N,1)>proC,1,D)) = 1;
    Offspring = [(Parent1+Parent2)/2+beta.*(Parent1-Parent2)/2
                 (Parent1+Parent2)/2-beta.*(Parent1-Parent2)/2];
    % BLX-alpha
%     flag = rand(N,D) > 0.8;
%     X1 = Parent1;X2 = Parent2;
%     ALPHA_crossover = rand(N,D);
%     differ = Parent1 - Parent2;
%     di = abs(differ);min_differ = min(Parent1,Parent2);
%     X1(flag) = min_differ(flag) - ALPHA_crossover(flag).*di(flag);
%     X2(flag) = min_differ(flag) + ALPHA_crossover(flag).*di(flag);
%     Offspring = [X1 
%                  X2];
             
    % Polynomial mutation

    Lower = zeros(2*N,D);
    Upper = ones(2*N,D);
    
    Site  = rand(2*N,D) < proM/D;
    mu    = rand(2*N,D);
    temp  = Site & mu<=0;
    Offspring       = min(max(Offspring,Lower),Upper);
    Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*...
                      (1-(Offspring(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1))-1);
    temp = Site & mu>0.5; 
    Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*...
                      (1-(Upper(temp)-Offspring(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1)));
    % variable swap
    swap_indicator  = rand(N,D) < 0.5;
    temp1 = Offspring(1:floor(end/2),:);temp2 = Offspring(floor(end/2)+1:floor(end/2)*2,:);
    temp3 = temp2;
    temp3(swap_indicator) = temp1(swap_indicator);
    temp1(swap_indicator) = temp2(swap_indicator);
    Offspring(1:floor(end/2),:) = temp1;Offspring(floor(end/2)+1:floor(end/2)*2,:) = temp3;
    
% %     nonuniform mutation
%     Pm = 0.01;
%     temp2 = rand(N*2,D);
%     yita = 1 - temp2.^((1-igen/gen).^2);
%     temp3 = rand(N*2,D);temp3(temp3>=0.5)=1;temp3(temp3<0.5)=0;
%     Offspring(temp2 < Pm & temp3 == 0) = Offspring(temp2 < Pm & temp3 == 0) + (1 - Offspring(temp2 < Pm & temp3 == 0)).*yita(temp2 < Pm & temp3 == 0);
%     Offspring(temp2 < Pm & temp3 == 1) = Offspring(temp2 < Pm & temp3 == 1) - (1 + Offspring(temp2 < Pm & temp3 == 1)).*yita(temp2 < Pm & temp3 == 1);

    Offspring       = min(max(Offspring,Lower),Upper);
    %     Offspring(rand(2*N,D)<0.0001) = 0;
    tfsoln = Offspring(((numparent+1):end),:);
    Offspring = Offspring(1:numparent,:);
end