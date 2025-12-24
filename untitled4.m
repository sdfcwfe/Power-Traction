clc; clear; close all;

%% 电枢电流 (A)
Id = [0.05, 0.12, 0.3, 0.4, 0.5, 0.6];

%% 转速数据 (r/min)
n_85 = [1142, 1083, 1006, 985, 955, 937]; % 占空比 85%
n_70 = [633, 589, 490, 461, 424, 405];    % 占空比 70%

%% 图 1：占空比 85%
figure('Name','占空比85%开环静特性','NumberTitle','off','Position',[100 100 900 600]);
plot(Id, n_85, '-o', 'LineWidth',2, 'MarkerSize',8, 'Color','b'); % 蓝色
grid on; hold on;

% 标注数据点
for i = 1:length(Id)
    text(Id(i), n_85(i)+15, num2str(n_85(i)), 'HorizontalAlignment','center', 'FontSize',9);
end

xlabel('电枢电流 I_d (A)','FontSize',12);
ylabel('电机转速 n (r/min)','FontSize',12);
title('开环静特性曲线（占空比 85%）','FontSize',14);

%% 图 2：占空比 70%
figure('Name','占空比70%开环静特性','NumberTitle','off','Position',[200 150 900 600]);
plot(Id, n_70, '-s', 'LineWidth',2, 'MarkerSize',8, 'Color',[1,0.5,0]); % 橙色
grid on; hold on;

% 标注数据点
for i = 1:length(Id)
    text(Id(i), n_70(i)-20, num2str(n_70(i)), 'HorizontalAlignment','center', 'FontSize',9);
end

xlabel('电枢电流 I_d (A)','FontSize',12);
ylabel('电机转速 n (r/min)','FontSize',12);
title('开环静特性曲线（占空比 70%）','FontSize',14);
