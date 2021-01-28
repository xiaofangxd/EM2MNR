classdef TASK    
    %This class is the task information to be processed, 
    %including the number of tasks, dimension of tasks, unified search space, task upper and lower bounds and task functions.
    %This class needs to be initialized with initTASK.
    properties
        M;%number of tasks
        Tdims;%dimension of tasks
        D_multitask;%unified search space
        Lb;%task lower bounds
        Ub;%task upper bounds
        fun;%task functions
        numofnode;%the number of node
        net;%Real network, used for evaluation, not involved in the optimization process
    end    
    methods        
        function object = initTASK(object,name,Nm)
            nname1 = ['WS';'NW';'BA';'ER'];
            nname2 = ['L-L';'R-L';'L-R'];
            NN = [20,40];
            switch name
                case 1
                    name1 = nname1(1,:);name2 = nname2(1,:);N = NN(1);
                case 2
                    name1 = nname1(1,:);name2 = nname2(2,:);N = NN(1);
                case 3
                    name1 = nname1(1,:);name2 = nname2(3,:);N = NN(1);
                case 4
                    name1 = nname1(1,:);name2 = nname2(1,:);N = NN(2);
                case 5
                    name1 = nname1(1,:);name2 = nname2(2,:);N = NN(2);
                case 6
                    name1 = nname1(1,:);name2 = nname2(3,:);N = NN(2);
                case 7
                    name1 = nname1(2,:);name2 = nname2(1,:);N = NN(1);
                case 8
                    name1 = nname1(2,:);name2 = nname2(2,:);N = NN(1);
                case 9
                    name1 = nname1(2,:);name2 = nname2(3,:);N = NN(1);
                case 10
                    name1 = nname1(2,:);name2 = nname2(1,:);N = NN(2);
                case 11
                    name1 = nname1(2,:);name2 = nname2(2,:);N = NN(2);
                case 12
                    name1 = nname1(2,:);name2 = nname2(3,:);N = NN(2);
                case 13
                    name1 = nname1(3,:);name2 = nname2(1,:);N = NN(1);
                case 14
                    name1 = nname1(3,:);name2 = nname2(2,:);N = NN(1);
                case 15
                    name1 = nname1(3,:);name2 = nname2(3,:);N = NN(1);
                case 16
                    name1 = nname1(3,:);name2 = nname2(1,:);N = NN(2);
                case 17
                    name1 = nname1(3,:);name2 = nname2(2,:);N = NN(2);
                case 18
                    name1 = nname1(3,:);name2 = nname2(3,:);N = NN(2);
                case 19
                    name1 = nname1(4,:);name2 = nname2(1,:);N = NN(1);
                case 20
                    name1 = nname1(4,:);name2 = nname2(2,:);N = NN(1);
                case 21
                    name1 = nname1(4,:);name2 = nname2(3,:);N = NN(1);
                case 22 
                    name1 = nname1(4,:);name2 = nname2(1,:);N = NN(2);
                case 23 
                    name1 = nname1(4,:);name2 = nname2(2,:);N = NN(2);
                case 24 
                    name1 = nname1(4,:);name2 = nname2(3,:);N = NN(2);
            end
            D1=1;D2=1;
            if strcmp(name2,'L-L')
                daota = [0,0,0;0,0,0;1,0,0];
            elseif strcmp(name2,'R-L')
                daota = eye(3,3);
            elseif strcmp(name2,'L-R')
                daota = [1,0,0;0,1,0;0,0,0];
            end
            load(['WSNWBAER_net/1_',name1,'_N_',num2str(N),'.mat']) %Import the real network 1
            object.net{1}.w = G;
            load(['WSNWBAER_net/2_',name1,'_N_',num2str(N),'.mat']) %Import the real network 2
            object.net{2}.w = G;
            load(['WSNWBAER_A_B/',name1,'_N_',num2str(N),'_',name2,'_Nm_',num2str(Nm),'_net1.mat'])%Import A1 and B1, this is used to construct the first network fitness function
            load(['WSNWBAER_A_B/',name1,'_N_',num2str(N),'_',name2,'_Nm_',num2str(Nm),'_net2.mat'])%Import A1 and B1, this is used to construct the second network fitness function
            object.M = 2;%Number of initialization tasks
            object.numofnode = N;%Number of nodes
            object.net{1}.net = net1;
            object.net{2}.net = net2;
            object.Tdims = zeros(object.M,1);%Initialize dimension of tasks
            object.Tdims(1) = object.numofnode*object.numofnode;%First layer network
            object.Tdims(2) = object.numofnode*object.numofnode;%Second layer network
            object.D_multitask = max(object.Tdims);%unified search space
            object.Lb = zeros(object.M,object.D_multitask);%Initialize the lower bound
            object.Ub = ones(object.M,object.D_multitask);%Initialize the upper bound 
            lambda = 0.0001;
            object.fun(1).fnc=@(x)two_network_identification(x,object.net{1}.net.A,object.net{1}.net.B,D1,daota,lambda);
            object.fun(2).fnc=@(x)two_network_identification(x,object.net{2}.net.A,object.net{2}.net.B,D2,daota,lambda);
        end  
    end
end
