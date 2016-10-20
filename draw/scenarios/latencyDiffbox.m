clear all;

f1 = figure;
hold on;

% M1=[tcp_oneway_64(1:4000,:)/1000000 tcp_oneway_128(1:4000,:)/1000000 tcp_oneway_256(1:4000,:)/1000000 tcp_oneway_512(1:4000, :)/1000000];
% 
% M2=[tcp_oneway_64_2(1:4000,:)/1000000 tcp_oneway_64_3(1:4000,:)/1000000 tcp_oneway_64_5(1:4000,:)/1000000 tcp_oneway_64_9(1:4000, :)/1000000];
% 
% M2=[tcp_oneway_64(1:4000,:)/1000000 tcp_oneway_128(1:4000,:)/1000000 tcp_oneway_256(1:4000,:)/1000000 tcp_oneway_512(1:4000, :)/1000000];

% load tcp_fanout_oneway_64_1;
% load tcp_fanout_oneway_128_1;
% load tcp_fanout_oneway_256_1;
% load tcp_fanout_oneway_512_1;
% 
% load tcp_fanout_oneway_64_33;
% load tcp_fanout_oneway_128_65;
% load tcp_fanout_oneway_256_129;
% load tcp_fanout_oneway_512_257;
% 
% load tcp_fanout_oneway_64_64;
% load tcp_fanout_oneway_128_128;
% load tcp_fanout_oneway_256_256;
% load tcp_fanout_oneway_512_512;
% 
% 
% % load tcp_oneway_64;
% % load tcp_oneway_128;
% % load tcp_oneway_256;
% % load tcp_oneway_512;
% 
%  
%  M = [tcp_fanout_oneway_64_1(1:4000,:)/1000000 tcp_fanout_oneway_64_33(1:4000,:)/1000000 tcp_fanout_oneway_64_64(1:4000,:)/1000000 ...
%      tcp_fanout_oneway_128_1(1:4000,:)/1000000 tcp_fanout_oneway_128_65(1:4000,:)/1000000 tcp_fanout_oneway_128_128(1:4000,:)/1000000 ...
%      tcp_fanout_oneway_256_1(1:4000,:)/1000000 tcp_fanout_oneway_256_129(1:4000,:)/1000000 tcp_fanout_oneway_256_256(1:4000,:)/1000000 ...
%      tcp_fanout_oneway_512_1(1:4000, :)/1000000 tcp_fanout_oneway_512_257(1:4000, :)/1000000 tcp_fanout_oneway_512_512(1:4000,:)/1000000 ];

% M = [tcp_oneway_64(1:4000,:)/1000000 tcp_oneway_64(1:4000,:)/1000000  ...
%     tcp_oneway_128(1:4000,:)/1000000 tcp_oneway_128(1:4000,:)/1000000  ...
%     tcp_oneway_256(1:4000,:)/1000000 tcp_oneway_256(1:4000,:)/1000000  ...
%     tcp_oneway_512(1:4000, :)/1000000 tcp_oneway_512(1:4000, :)/1000000 ];


load tcp_fanin_oneway_64_1;
load tcp_fanin_oneway_128_1;
load tcp_fanin_oneway_256_1;
load tcp_fanin_oneway_512_1;

load udp_fanin_oneway_64_1;
load udp_fanin_oneway_128_1;
load udp_fanin_oneway_256_1;
load udp_fanin_oneway_512_1;

load udt_fanin_oneway_64_1;
load udt_fanin_oneway_128_1;
load udt_fanin_oneway_256_1;
load udt_fanin_oneway_512_1;


M = [tcp_fanin_oneway_64_1(1:4000,:)/1000000 udp_fanin_oneway_64_1(1:4000,:)/1000000 udt_fanin_oneway_64_1(1:4000,:)/1000000 ...
    tcp_fanin_oneway_128_1(1:4000,:)/1000000 udp_fanin_oneway_128_1(1:4000,:)/1000000 udt_fanin_oneway_128_1(1:4000,:)/1000000 ...
    tcp_fanin_oneway_256_1(1:4000,:)/1000000 udp_fanin_oneway_256_1(1:4000,:)/1000000 udt_fanin_oneway_256_1(1:4000,:)/1000000 ...
    tcp_fanin_oneway_512_1(1:4000,:)/1000000 udp_fanin_oneway_512_1(1:4000,:)/1000000 udt_fanin_oneway_512_1(1:4000,:)/1000000]


% load tcp_roundtrip_64;
% load tcp_roundtrip_128;
% load tcp_roundtrip_256;
% load tcp_roundtrip_512;
% 
% M = [tcp_oneway_64(1:4000,:)/1000000 tcp_roundtrip_64(1:4000,:)/2000000 ...
%     tcp_oneway_128(1:4000,:)/1000000 tcp_roundtrip_128(1:4000,:)/2000000 ...
%     tcp_oneway_256(1:4000,:)/1000000 tcp_roundtrip_256(1:4000,:)/2000000 ...
%     tcp_oneway_512(1:4000, :)/1000000 tcp_roundtrip_512(1:4000, :)/2000000];


% load tcp_oneway_64;
% load tcp_oneway_128;
% load tcp_oneway_256;
% load tcp_oneway_512;
% 
% load tcp_roundtrip_64;
% load tcp_roundtrip_128;
% load tcp_roundtrip_256;
% load tcp_roundtrip_512;

% M = [tcp_oneway_64(1:4000,:)/1000000 tcp_roundtrip_64(1:4000,:)/2000000 ...
%     tcp_oneway_128(1:4000,:)/1000000 tcp_roundtrip_128(1:4000,:)/2000000 ...
%     tcp_oneway_256(1:4000,:)/1000000 tcp_roundtrip_256(1:4000,:)/2000000 ...
%     tcp_oneway_512(1:4000, :)/1000000 tcp_roundtrip_512(1:4000, :)/2000000];
% 
% M = [tcp_roundtrip_64(1:4000,:)/2000000 tcp_roundtrip_64(1:4000,:)/2000000 ...
%     tcp_roundtrip_128(1:4000,:)/2000000 tcp_roundtrip_128(1:4000,:)/2000000 ...
%     tcp_roundtrip_256(1:4000,:)/2000000 tcp_roundtrip_256(1:4000,:)/2000000 ...
%     tcp_roundtrip_512(1:4000,:)/2000000 tcp_roundtrip_512(1:4000, :)/2000000];

% M1=[ee_1_350_1d_1r(3000:13000,:)/1000000 ee_1_350_1d_2r(3000:13000,:)/1000000 ...
%     ee_1_350_1d_1_16(3000:13000,:)/1000000 ee_1_350_1d_2_16(3000:13000,:)/1000000];

%h1 = boxplot(M,  'notch', 'on');
h1 = boxplot(M, 'colors', 'kbrkbrkbr', 'notch', 'on');

tx = [3.5 3.5];
ty = [-10 200000];
h = line(tx, ty, 'color', 'k', 'linewidth', 2);

tx = [6.5 6.5];
h = line(tx, ty, 'color', 'k', 'linewidth', 2);

tx = [9.5 9.5];
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


ylabel('Latency (ms)', 'fontsize', 15);
%xlabel('Number of Subscribers', 'fontsize', 15);
%title('Time spent in loop from step3 to step7, 2k-payload packets sent fro m Domain2 and Domain3 ', 'fontsize', 20);

grid on;
ylim([0 2])
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


% % level 0
% f1 = figure;
% hold on;
% 
% %h2 = cdfplot( base_min(:, 1)+base_min(:, 2)+base_min(:, 3));
% %h2 = cdfplot( base_min(:, 5)+base_min(:, 6)+base_min(:, 7)+base_min(:, 8));
% h2 = cdfplot( base_min(:, 5));
% %h2 = cdfplot( base_max(:, 5)+base_max(:, 6)+base_max(:, 7)+base_max(:, 8));
% %h2 = cdfplot( base_max(:, 5));
% %h2 = cdfplot( base_max(:, 1)+base_max(:, 2)+base_max(:, 3));
% %h2 = cdfplot( base_max(:, 3));
% 
% 
% %h6 = cdfplot( rt_min(:,1)+rt_min(:,2)+rt_min(:,3));
% %h6 = cdfplot( rt_min(:,3));
% %h6 = cdfplot( rt_min(:,5)+rt_min(:,6)+rt_min(:,7)+rt_min(:,8));
% %h6 = cdfplot( rt_min(:,5));
% %h6 = cdfplot( rt_min(:,8));
% %h6 = cdfplot( rt_max(:,5)+rt_max(:,6)+rt_max(:,7)+rt_max(:,8));
% %h6 = cdfplot( rt_max(:,8));
% %h6 = cdfplot( rt_max(:,1)+rt_max(:,2)+rt_max(:,3));
% 
% 
% %h10 = cdfplot( tc_min(:, 1)+tc_min(:, 2)+tc_min(:, 3));
% %h10 = cdfplot( tc_min(:, 3));
% %h10 = cdfplot( tc_min(:, 5)+tc_min(:, 6)+tc_min(:, 7)+tc_min(:, 8));
% %h10 = cdfplot( tc_min(:, 5));
% %h10 = cdfplot( tc_min(:, 8));
% %h10 = cdfplot( tc_max(:,5)+tc_max(:,6)+tc_max(:,7)+tc_max(:,8));
% %h10 = cdfplot( tc_max(:,8));
% %h10 = cdfplot( tc_max(:,1)+tc_max(:,2)+tc_max(:,3));
% 
% 
% %h14 = cdfplot( rtca_base_min(:, 1)+rtca_base_min(:, 2)+rtca_base_min(:, 3)+rtca_base_min(:, 4));
% %h14= cdfplot(rtca_2_4(:,5)+rtca_2_4(:,6)+rtca_2_4(:,7)+rtca_2_4(:,8));
% %h14= cdfplot(rtca_2_4(:,5));
% %h14= cdfplot(rtca_3_4(:,5)+rtca_3_4(:,6)+rtca_3_4(:,7)+rtca_3_4(:,8));
% %h14= cdfplot(rtca_3_4(:,5));
% 
% % h6 = cdfplot( rtca_1_1(:, 5));
% % h10 = cdfplot( rtca_3(:, 5));
% % h14 = cdfplot( rtca_5(:, 5));
% % h16= cdfplot(rtca_5_8(:,5));
% 
% %h16 = cdfplot( rtca_min(:, 1)+rtca_min(:, 2)+rtca_min(:, 3));
% %h16 = cdfplot( rtca_min(:, 5)+rtca_min(:, 6)+rtca_min(:, 7)+rtca_min(:, 8));
% %h16 = cdfplot( rtca_min(:, 5));
% %h16 = cdfplot( rtca_max(:,5)+rtca_max(:,6)+rtca_max(:,7)+rtca_max(:,8));
% %h16 = cdfplot( rtca_max(:,1)+rtca_max(:,2)+rtca_max(:,3));
% %h16 = cdfplot( rtca_max(:,5));
% %h16 = cdfplot( rtca_max(:,3));
% 
% 
% set(h2, 'color', 'r', 'linewidth', 2, 'displayname', 'No interference', 'linestyle', '-');
% 
% set(h6, 'color', 'k', 'linewidth', 2, 'displayname', 'Original Domain0', 'linestyle', '-');
% 
% set(h10, 'color', 'b', 'linewidth', 2, 'displayname', 'Traffic Control', 'linestyle', '-');
% 
% set(h14, 'color', 'c', 'linewidth', 2, 'displayname', 'RTCA, revised net-recv-kthread', 'linestyle', '-');
% 
% set(h16, 'color', 'm', 'linewidth', 2, 'displayname', 'RTCA', 'linestyle', '-');
% 
% 
% xlabel('Micro Seconds', 'fontsize', 20);
% ylabel('CDF Plot', 'fontsize', 20);
% %title('Packet recv latency, min-size tcp Packet, interference=(1,50)', 'fontsize', 20);
% set(gca, 'fontsize', 20);
% 
% %xlim([0 600])
% 
% grid off;
% legend('show', 'location', 'SE');
% 
% %set(f1, 'position', [0 0 1920 1200]);
% set(gcf, 'Paperpositionmode', 'auto');
% print -depsc fig/latency_0;
% 
% close(gcf);



% 
% 
% 
% 

