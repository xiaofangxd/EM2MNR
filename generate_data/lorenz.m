%Differential equation
function dy=lorenz(y)
a = 10;
b = 28;
c = 8/3;

dy=[a.*(y(2)-y(1));
    b.*y(1)-y(1).*y(3)-y(2);
    y(1).*y(2)-c.*y(3)];

% dy=[a.*(y(2)-y(3));
%     b.*y(1)-c.*y(1).*y(3)-y(2);
%     y(1).*y(2)-c.*y(3)];
end