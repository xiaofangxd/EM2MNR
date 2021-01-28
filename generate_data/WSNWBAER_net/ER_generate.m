% clear all;clc;
function [G] = ER_generate(N, pc)
% N=100;
% pc=0.04;
%%<k>=N*pc
G = zeros(N,N);

for i=1:N-1
    for j=i+1:N
        if(i == j)
            continue;
        end
        if(rand() <= pc)
            G(i,j) = 1;
            G(j,i) = 1;
        end
    end
end

%What is saved in G is the undirected ER network
%Write files and use adjacency matrix representation
% str1 = 'ER_N=';
% str2 = num2str(N);
% str3 = '_k=';
% k=N*pc;
% str4 = num2str(k);
% str1 = strcat(str1,str2,str3,str4);
% fp = fopen(str1,'w');
% for i=1:N
%     for j=1:N
%         fprintf(fp,'%d',G(i,j));
%     end
%     fprintf(fp,'\n');
% end
% fclose(fp);
% fprintf('Finish of generating ER!\n');

