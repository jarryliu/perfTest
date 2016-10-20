clear all;

f1 = figure;
hold on;

load go_udp_latency.log;
load go_tcp_latency.log;
load udp_latency.log;
load tcp_latency.log;


M = [go_tcp_latency(1:9000,:) go_udp_latency(1:9000,:) ... 
    tcp_latency(1:9000,:) udp_latency(1:9000,:)];
M = M/1000000;

h1 = boxplot(M, 'colors', 'kbkb', 'notch', 'on', 'Labels', {'Go TCP', 'GO UDP', 'C TCP', 'C UDP'});

tx = [2.5 2.5];
ty = [-10 200000];
h = line(tx, ty, 'color', 'k', 'linewidth', 2);


xlabel('Implementation Language and Protocol', 'fontsize', 20)
ylabel('Latency (ms)', 'fontsize', 20);
%xlabel('Number of Subscribers', 'fontsize', 15);
%title('Time spent in loop from step3 to step7, 2k-payload packets sent fro m Domain2 and Domain3 ', 'fontsize', 20);

grid on;
ylim([0 0.5]);


