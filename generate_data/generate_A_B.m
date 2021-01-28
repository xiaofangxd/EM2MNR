clear all
clc
%This function is used to generate the matrices A and B needed for optimization
name1 = ['WS';'NW';'BA';'ER'];%WS or NW or BA or ER
name2 = ['20';'40'];%20or40
name3 = 'L-L';%L-L or R-L or L-R

t0 = 1e-03;
t = 0:t0:(30-t0);
for Nmm = 0.2:0.2:4
    for k = 1:4
        for l = 1:2
            disp([num2str(k),' ',num2str(l)]);
            load(['WSNWBAER_timeseries/',name1(k,:), '_N_',name2(l,:),'_',name3,'.mat']);
    %         load([name1(k,:), '_N_',name2(l,:),'_',name3,'.mat']);
            r=3;N = size(X,2)/(2*r);Nr = N*r; Nm = floor(Nmm*Nr);%the number of sample data
            D1 = 1;D2 = D1;%intralayer coupling strength
            D12 = 1;D21 = 1;
            if strcmp(name3, 'L-L')
                daota = zeros(r,r);daota(3,1) = 1;%inner coupling matrix L-L
            elseif strcmp(name3, 'R-L')
                daota = eye(r,r);%inner coupling matrix R-L
            elseif strcmp(name3, 'L-R')
                daota = zeros(r,r);daota(1,1) = 1;daota(2,2) = 1;%inner coupling matrix L-R
            end

            load(['WSNWBAER_net/1_',name1(k,:),'_N_',name2(l,:),'.mat']);
            L1 = diag(sum(G,2))-G;
            C1 = -kron(L1,daota);
            load(['WSNWBAER_net/2_',name1(k,:),'_N_',name2(l,:),'.mat']);
            L2 = diag(sum(G,2))-G;
            C2 = -kron(L2,daota);

%                 index = 100:100:size(X,1);
            index = randi([1,size(X,1)],[1,Nm]);
            A1 = [];B1 = [];
            A2 = [];B2 = [];
            for i = 1:Nm
                disp(i);
                X1 = X(index(i),1:Nr)';%Time series of the first network at time t
                X2 = X(index(i),Nr+1:end)';%Time series of the second network at time t
                F1 = zeros(size(X1));
                for j = 1:N
                    if strcmp(name3, 'L-L')
                        F1((r*(j-1)+1):(j*r)) = lorenz(X1((r*(j-1)+1):(j*r)));
                    elseif strcmp(name3, 'R-L')
                        F1((r*(j-1)+1):(j*r)) = rossler(X1((r*(j-1)+1):(j*r)));
                    elseif strcmp(name3, 'L-R')
                        F1((r*(j-1)+1):(j*r)) = lorenz(X1((r*(j-1)+1):(j*r)));
                    end
                end
                F2 = zeros(size(X2));
                for j = 1:N
                    if strcmp(name3, 'L-L')
                        F2((r*(j-1)+1):(j*r)) = lorenz(X2((r*(j-1)+1):(j*r)));
                    elseif strcmp(name3, 'R-L')
                        F2((r*(j-1)+1):(j*r)) = lorenz(X2((r*(j-1)+1):(j*r)));
                    elseif strcmp(name3, 'L-R')
                        F2((r*(j-1)+1):(j*r)) = rossler(X2((r*(j-1)+1):(j*r)));
                    end
                end
                XX1 = (X(index(i)+1,1:Nr)'-X(index(i)-1,1:Nr)')./(2*t0);%The approximate differential corresponding to the time series of the first network at time t, using the central difference quotient formula
                XX2 = (X(index(i)+1,Nr+1:end)'-X(index(i)-1,Nr+1:end)')./(2*t0);%The approximate differential corresponding to the time series of the second network at time t, using the central difference quotient formula
                Y1 = XX1 - F1 - kron(D12*eye(N),daota)*(X2-X1);
                Y2 = XX2 - F2 - kron(D21*eye(N),daota)*(X1-X2);
                A1 = [A1,X1];A2 = [A2,X2];
                B1 = [B1,Y1];B2 = [B2,Y2];
            end
            A1 = [A1,ones(Nr,1)]';A2 = [A2,ones(Nr,1)]';
            B1 = [B1,zeros(Nr,1)]';B2 = [B2,zeros(Nr,1)]';
            net1.A = A1;net1.B = B1;
            net2.A = A2;net2.B = B2;

            result1 = sum(sum(abs(net1.A*C1'-net1.B)))
            result2 = sum(sum(abs(net2.A*C2'-net2.B)))
            save(['WSNWBAER_A_B/',name1(k,:), '_N_',name2(l,:),'_',name3,'_Nm_',num2str(Nmm),'_net1.mat'],'net1');
            save(['WSNWBAER_A_B/',name1(k,:), '_N_',name2(l,:),'_',name3,'_Nm_',num2str(Nmm),'_net2.mat'],'net2');
        end
    end
end