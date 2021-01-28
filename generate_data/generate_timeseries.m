clear all;
clc;
% This function is used to generate time series
name1 = ['WS';'NW';'BA';'ER'];%WS or NW or BA or ER
name2 = ['20';'40'];%10or20or40
name3 = 'L-L';%L-L or R-L or L-R
t0=1e-03;
t=0:t0:(30-t0);

initrr = 10;%Different name3 needs to be given different initrr. Need multiple attempts.
for i = 2
    for j = 1
        disp([num2str(i),' ',num2str(j)]);
        N=str2num(name2(j,:))*3;
        [T,X]=ode45(@(t,y)l_ideni(t,y,name1(i,:),name2(j,:),name3),t,initrr*randn(1,2*N));
        figure(1);
        plot(T,X,'LineWidth',2);
        save(['WSNWBAER_timeseries/',name1(i,:), '_N_',name2(j,:),'_',name3,'.mat'],'X');
    end
end