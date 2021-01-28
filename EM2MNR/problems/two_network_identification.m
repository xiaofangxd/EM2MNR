function obj = two_network_identification(x,A,Y,D,daota,lambda)
%||AX-Y||2+||X||0
%   - x: design variable vector
    popsize = size(x,1);
    numofnode = sqrt(size(x,2));
    obj = zeros(size(x,1),1);
    for i = 1:popsize
        net = reshape(x(i,:),[numofnode,numofnode]);
        net = diag(sum(net,2))-net;
        M = kron(-D*net,daota);
        obj(i,1) = 0.5*(1/size(A,1))*sum(sum((A*M'-Y).^2));
    end
%         obj(:,1) = obj(:,1) + lambda*sum(abs(x),2);%1 norm
%         obj(:,1) = obj(:,1) + lambda*((sum(sqrt(abs(x)),2)).^2);%1/2 norm
    e=zeros(size(x));
    e(x~=0)=1;
    obj(:,1) = obj(:,1) + lambda*sum(e,2);%0 norm
end


