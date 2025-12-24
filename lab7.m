clc; clear; close all;

%% 电枢电流 (A)
Id = [0.05, 0.12, 0.3, 0.4, 0.5, 0.6]; % 开环数据
Id_cl = [0.04, 0.11, 0.3, 0.4, 0.5, 0.6]; % 闭环数据

%% 转速数据 (r/min)
% 开环静特性
n_open_85 = [1142, 1083, 1006, 985, 955, 937]; % 占空比 85%
n_open_70 = [633, 589, 490, 461, 424, 405];    % 占空比 70%

% 单闭环无静差
n_single_no_error = [1003, 999, 999, 999, 999, 999];

% 双闭环无静差
n_double_no_error = [999, 999, 999, 1003, 1003, 897];

%% 绘制四条曲线
figure('Position',[100 100 1000 600]);
hold on; grid on;

% 开环 85%
plot(Id, n_open_85, '-o', 'LineWidth',2, 'MarkerSize',8, 'Color','b', 'DisplayName','开环 85%');
% 开环 70%
plot(Id, n_open_70, '-s', 'LineWidth',2, 'MarkerSize',8, 'Color','r', 'DisplayName','开环 70%');
% 单闭环无静差
plot(Id_cl, n_single_no_error, '-d', 'LineWidth',2, 'MarkerSize',8, 'Color','g', 'DisplayName','单闭环无静差');
% 双闭环无静差
plot(Id_cl, n_double_no_error, '-^', 'LineWidth',2, 'MarkerSize',8, 'Color','m', 'DisplayName','双闭环无静差');

%% 坐标轴、标题和图例
xlabel('电枢电流 I_d (A)','FontSize',12);
ylabel('电机转速 n (r/min)','FontSize',12);
title('直流调速系统静特性曲线对比','FontSize',14);
legend('Location','northeast');
hold off;
