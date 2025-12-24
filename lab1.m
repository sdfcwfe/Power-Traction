clc; clear; close all;

%% 电枢电流
Id = [0.3, 0.4, 0.5, 0.6]; % A

%% 闭环实验数据（实际测量）
n_closed = [545, 530, 516, 505]; % r/min

%% 开环数据（假设线性，初始转速 n0=1006, 斜率 230 r/min·A^-1）
n_open = 1006 - 230*(Id-0.3); % 线性计算, 与闭环数据起点对齐

%% 绘图
figure('Position',[100 100 900 600]);
hold on; grid on;

% 绘制开环和闭环曲线
plot(Id, n_open, '-o', 'LineWidth',2, 'MarkerSize',8, 'DisplayName','开环系统');
plot(Id, n_closed, '-s', 'LineWidth',2, 'MarkerSize',8, 'DisplayName','闭环系统');

% 数据点标注
for i=1:length(Id)
    text(Id(i), n_open(i)+5, num2str(round(n_open(i))), 'HorizontalAlignment','center','FontSize',10);
    text(Id(i), n_closed(i)-15, num2str(n_closed(i)), 'HorizontalAlignment','center','FontSize',10);
end

% 坐标轴、标题、图例
xlabel('电枢电流 I_d (A)','FontSize',12);
ylabel('电机转速 n (r/min)','FontSize',12);
title('开环与闭环直流调速系统机械特性对比', 'FontSize',14);
legend('Location','northeast');

% 添加公式标注
text(0.35, 1000, 'n = (U_d - I_d*R)/(K_e*\phi)','FontSize',12,'Color','r');
hold off;
