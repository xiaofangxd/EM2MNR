function [objective,rnvec,calls,EvBestFitness_evn] = CalObj(Task,rnvec,i,calls,EvBestFitness_evn)
% Calculate the objective function value of the i-th population£¨factorial_costs£©

    d = Task.Tdims(i);
    nvars = rnvec(:,1:d);
    NN = size(rnvec,1);
    minrange = Task.Lb(i,1:d);
    maxrange = Task.Ub(i,1:d);
    y=repmat(maxrange-minrange,[NN,1]);
    x = y.*nvars + repmat(minrange,[NN,1]);%decoding
    objective=Task.fun(i).fnc(x);
    for j=1:NN 
        calls(i) = calls(i) + 1;
        if calls(i)==1
            EvBestFitness_evn(i,:) = objective(j,:);
        else
            EvBestFitness_evn(i,:) = min(EvBestFitness_evn(i,:),objective(j,:));
        end
    end
end