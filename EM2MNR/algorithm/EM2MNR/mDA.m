function [inj_solution] = mDA(curr_pop, his_pop, his_bestSolution)

    inj_solution = [];
    curr_popl = curr_pop;his_popl = his_pop; his_bestSolutionl = his_bestSolution;
    curr_popl(curr_popl<=0.05) = 0;curr_popl(curr_popl>0.05) = 1;
    his_popl(his_popl<=0.05) = 0;his_popl(his_popl>0.05) = 1;
    his_bestSolutionl(his_bestSolutionl<=0.05) = 0;his_bestSolutionl(his_bestSolutionl>0.05) = 1;

    % Determine the size of hidden layers
    allZero = all(~curr_popl,1);
    allOne  = all(curr_popl,1);
    RBM_solution = zeros(1,size(his_bestSolutionl,2));
    RBM_solution(allZero) = 0;
    RBM_solution(allOne) = 1;
    RBM_solution = repmat(RBM_solution,[size(his_bestSolutionl,1),1]);

    other   = ~allZero & ~allOne;
    K       = sum(mean(abs(curr_popl(:,other))>1e-6,1)>rand());
    K       = min(max(K,1),size(curr_popl,1));
    % train model
    rbmc = RBM(sum(other),K,2,1,0,0.5,0.1);
    rbmc.train(curr_popl(:,other));
    rbmh = RBM(sum(other),K,2,1,0,0.5,0.1);
    rbmh.train(his_popl(:,other));
    % transfer
    his_b = rbmh.reduce(his_bestSolutionl(:,other));
    his_b1 = rbmc.recover(his_b);
    RBM_solution(:,other) = his_b1;
    RBM_solution = RBM_solution.*his_bestSolution;
    inj_solution = [inj_solution;RBM_solution];
end






