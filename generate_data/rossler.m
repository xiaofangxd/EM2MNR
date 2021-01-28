%Differential equation
function dy=rossler(y)
a = 0.2;
b = 5.7;

% dy=[-y(2)-y(1);
%     y(1)+a*y(2);
%     a+y(3)*(y(1)-b)];

dy=[-y(2)-y(3);
    y(1)+a*y(2);
    a+y(3)*(y(1)-b)];

end