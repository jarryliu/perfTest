clear all;

f1 = figure;
hold on;

load go_udp_latency.log;
load go_tcp_latency.log;
load udp_latency.log;
load tcp_latency.log;


M = [go_tcp_latency(1:9000,:) go_udp_latency(1:9000,:) ... 
    tcp_latency(1:9000,:) udp_latency(1:9000,:)]
M = M/1000

h1 = boxplot(M, 'colors', 'kbkb', 'notch', 'on');

tx = [2.5 2.5];
ty = [-10 200000];
h = line(tx, ty, 'color', 'k', 'linewidth', 2);



ylabel('Latency (us)', 'fontsize', 15);
%xlabel('Number of Subscribers', 'fontsize', 15);
%title('Time spent in loop from step3 to step7, 2k-payload packets sent fro m Domain2 and Domain3 ', 'fontsize', 20);

grid on;
ylim([0])
  set(gca, 'XTick', [64 64 128 128 256 256 512 512]);
 set(gca, 'FontSize', 15);
 %set(gca,'XTickLabel',{'1-d, normal','1-d, rr','2-d, rr'});
set(gca,'XTickLabel',{'a','b', 'c','d', 'e', 'f'});
 %set(gca,'XTickLabel',{'1-d','1-d, diff buffer'});
%set(gca,'XTickLabel',{'1-daemon, 256 producers'});

% for i = 1:5
% text(i,data(i),num2str(data(i)),'fontsize',20,'HorizontalAlignment','center','VerticalAlignment','bottom');
% end
% set(gcf, 'Position', [0 0 940 1058]);
set(gcf, 'PaperPositionMode', 'auto');
%legend('Default Domain0', 'Traffic Control');
print -depsc fig/old;
close(gcf);



