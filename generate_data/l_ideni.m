function dy = l_ideni( t,y,name1,name2,name3 )
% Two-layer network
%     name1 = 'WS';%the name of net
%     name2 = '10';%the number of net
%     name3 = 'L-L';%the name of node dynamics
    r = 3; 
    N = length(y)/(2*r);% the number of node
    D1 = 1;D2 = D1;%intralayer coupling strength
    D12 = 1;D21 = 1;
    if strcmp(name3,'L-L')
        daota = zeros(r,r);daota(3,1) = 1;%inner coupling matrix L-L
    elseif strcmp(name3,'R-L')
        daota = eye(r,r);%inner coupling matrix R-L
    elseif strcmp(name3,'L-R')
        daota = zeros(r,r);daota(1,1) = 1;daota(2,2) = 1;%inner coupling matrix L-R
    end
    load(['WSNWBAER_net\1_',name1,'_N_',name2,'.mat']);
    A = G;
    load(['WSNWBAER_net\2_',name1,'_N_',name2,'.mat']);
    B = G;
     L1 = diag(sum(A,2))-A;% the Laplacian matrix of A
     L2 = diag(sum(B,2))-B;% the Laplacian matrix of B
     X = y;
     F = X;
     X1 = X(1:r*N);F1 = F(1:r*N);
     for i = 1:N
         if strcmp(name3,'L-L') || strcmp(name3,'L-R')
            F1((r*(i-1)+1):(i*r)) = lorenz(X1((r*(i-1)+1):(i*r)));
         elseif strcmp(name3,'R-L')
            F1((r*(i-1)+1):(i*r)) = rossler(X1((r*(i-1)+1):(i*r)));
         end
     end
     X2 = X(r*N+1:2*r*N);F2 = F(r*N+1:2*r*N);
     for i = 1:N
         if strcmp(name3,'L-L') || strcmp(name3,'R-L')
            F2((r*(i-1)+1):(i*r)) = lorenz(X2((r*(i-1)+1):(i*r)));
         elseif strcmp(name3,'L-R')
            F2((r*(i-1)+1):(i*r)) = rossler(X2((r*(i-1)+1):(i*r)));
         end
     end
     F = [F1;F2];
     L = [D1*L1+D12*eye(N),-D12*eye(N);-D21*eye(N),D2*L2+D21*eye(N)];
     X = F - kron(L,daota)*X;
     dy = X;
%      X11 = F1 - kron((D1*L1+D12*eye(N)),daota)*X1 + kron(D12*eye(N),daota)*X2;
%      X22 = F2 - kron((D2*L2+D21*eye(N)),daota)*X2 + kron(D21*eye(N),daota)*X1;
%      dy = [X11;X22];
    
end

