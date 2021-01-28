%First construct a regular network
%Each node is connected to its left and right neighboring K/2 nodes (K is an even number), and the probability of edge reconnection is p
function [G] = NW_generate(N, K, p)
% K = 4;
% N = 100;
% p = 0.1;
G = zeros(N,N);
for i=1:N-1
    G(i,i+1) = 1;
    G(i+1,i) = 1;
end
G(1,N) = 1;G(N,1) = 1;

for edge=2:K/2
    for i=1:N-edge
        G(i,i+edge) = 1;
        G(i+edge,i) = 1;
        if i > edge
            G(i-edge,i) = 1;
            G(i,i-edge) = 1;
        else
            G(N+i-edge,i) = 1;
            G(i,N+i-edge) = 1;
        end
    end
end

for i=1:N*K/2
    node1 = round(rand()*N);
    while(~node1)
        node1 = round(rand()*N);
    end
    node2 = round(rand()*N);
    while(~node2 || node1 == node2 || G(node1,node2))
        node2 = round(rand()*N);
    end
    if(rand() < p)
        G(node1,node2) = 1;G(node2,node1) = 1;
    end
end    
%What is stored in G is the generated undirected NW network
%Write files and use adjacency matrix representation
% str1 = 'NW_N=';
% str2 = num2str(N);
% % str3 = '_k=';
% % str4 = num2str(K);
% str1 = strcat(str1,str2);
% fp = fopen(str1,'w');
% for i=1:N
%     for j=1:N
%         fprintf(fp,'%d',G(i,j));
%     end
%     fprintf(fp,'\n');
% end
% fclose(fp);
% fprintf('Finish of generating NW!\n');
    
                  
                    

        
    
        