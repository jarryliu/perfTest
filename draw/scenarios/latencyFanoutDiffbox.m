clear all;

f1 = figure;
hold on;

tcp_64 =[];
tcp_128 = [];
tcp_256 = [];
tcp_512 = [];
udp_64 = [];
udp_128 = [];
udp_256 = [];
udp_512 = [];

for k = 1:2
    tcp_64 = [tcp_64; load(strcat('log_3/tcp_fanout_oneway_64_',num2str(k*2)))];
    tcp_128 = [tcp_128; load(strcat('log_3/tcp_fanout_oneway_128_',num2str(k*4)))];
    tcp_256 = [tcp_256; load(strcat('log_3/tcp_fanout_oneway_256_',num2str(k*8)))];
    tcp_512 = [tcp_512; load(strcat('log_3/tcp_fanout_oneway_512_',num2str(k*16)))];
    udp_64 = [udp_64; load(strcat('log_3/udp_fanout_oneway_64_',num2str(k*2)))];
    udp_128 = [udp_128; load(strcat('log_3/udp_fanout_oneway_128_',num2str(k*4)))];
    udp_256 = [udp_256; load(strcat('log_3/udp_fanout_oneway_256_',num2str(k*8)))];
    udp_512 = [udp_512; load(strcat('log_3/udp_fanout_oneway_512_',num2str(k*16)))];
end


M = [tcp_64 udp_64 tcp_128 udp_128 tcp_256 udp_256 tcp_512 udp_512]/1000000;



h1 = boxplot(M, 'colors', 'kbkbkbkb', 'notch', 'on', 'labels',...
    {'TCP 64','UDP 64', 'TCP 128','UDP 128','TCP 256','UDP 256','TCP 512','UDP 512'});

tx = [2.5 2.5];
ty = [-10 200000];
h = line(tx, ty, 'color', 'k', 'linewidth', 2);

tx = [4.5 4.5];
h = line(tx, ty, 'color', 'k', 'linewidth', 2);

tx = [6.5 6.5];
h = line(tx, ty, 'color', 'k', 'linewidth', 2);

% tx = [2.5 2.5];
% ty = [-10 200000];
% h = line(tx, ty, 'color', 'k', 'linewidth', 2);
% 
% tx = [4.5 4.5];
% h = line(tx, ty, 'color', 'k', 'linewidth', 2);
% 
% tx = [6.5 6.5];
% h = line(tx, ty, 'color', 'k', 'linewidth', 2);

xlabel('Protocol and Number of Concurrent Connections');
ylabel('Latency (ms)', 'fontsize', 15);
%xlabel('Number of Subscribers', 'fontsize', 15);
%title('Time spent in loop from step3 to step7, 2k-payload packets sent fro m Domain2 and Domain3 ', 'fontsize', 20);

grid on;
ylim([0 5]);

mean(tcp_64)
mean(tcp_128)
mean(tcp_256)
mean(tcp_512)
mean(udp_64)
mean(udp_128)
mean(udp_256)
mean(udp_512)


