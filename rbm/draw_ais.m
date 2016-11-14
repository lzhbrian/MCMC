
close all;clc;clear
figure;

without_base_rate = [214.222571,211.839402,335.389539,453.041485];
with_base_rate = [226.05,221.112333,348.453360,463.250326];

plot(1:4,with_base_rate,'*','MarkerSize',10);hold on;
plot(1:4,without_base_rate,'s','MarkerSize',10);
xlabel('hidden units')
ylabel('logZ(\theta)')
legend('AIS with init','AIS','location','northwest')
grid on
set(gca,'fontsize',12,'xticklabel',{'10','20','100','500'},'xtick',1:4)



