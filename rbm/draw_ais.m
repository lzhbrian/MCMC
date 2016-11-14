
close all;clc;clear

%% +/- 3 sd
a = [226.05 221.112333 348.453360 463.250326]; % mean
upper = [226.2125, 221.318383, 348.669414, 464.575756];
lower = [225.86, 220.852507, 348.177384, 463.817798];
std = upper - lower; % std
figure();
bar(a(1:2),'b');hold on;
errorbar(a(1:2),std(1:2),'rx');
set(gca,'fontsize',16,'ylim',[220 227])

a = [226.05 221.112333 348.453360 463.250326]; % mean
upper = [226.2125, 221.318383, 348.669414, 464.575756];
lower = [225.86, 220.852507, 348.177384, 463.817798];
std = upper - lower; % std
figure();
bar(a(3:4),'b');hold on;
errorbar(a(3:4),std(3:4),'rx');
set(gca,'fontsize',16,'ylim',[340 470])


%% base rate compare
figure
without_base_rate = [214.222571,211.839402,335.389539,453.041485];
with_base_rate = [226.05,221.112333,348.453360,463.250326];

plot(1:4,with_base_rate,'*','MarkerSize',10);hold on;
plot(1:4,without_base_rate,'s','MarkerSize',10);
xlabel('hidden units')
ylabel('logZ(\theta)')
legend('AIS with init','AIS','location','northwest')
grid on
set(gca,'fontsize',12,'xticklabel',{'10','20','100','500'},'xtick',1:4)



