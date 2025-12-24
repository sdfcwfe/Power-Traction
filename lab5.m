clc; clear; close all;

%% 电枢电流 (A)
Id = [0.04, 0.11, 0.3, 0.4, 0.5, 0.6];

%% 转速数据 (r/min) - 单闭环无静差
n_single_no_error = [1003, 999, 999, 999, 999, 999];

%% 绘图
figure('Name','单闭环无静差开环静特性','NumberTitle','off','Position',[100 100 900 600]);
plot(Id, n_single_no_error, '-o', 'LineWidth',2, 'MarkerSize',8, 'Color','b');
grid on; hold on;

% 标注数据点
for i = 1:length(Id)
    text(Id(i), n_single_no_error(i)+10, num2str(n_single_no_error(i)), 'HorizontalAlignment','center', 'FontSize',9);
end

% 坐标轴和标题
xlabel('电枢电流 I_d (A)','FontSize',12);
ylabel('电机转速 n (r/min)','FontSize',12);
title('单闭环无静差调速系统静特性曲线','FontSize',14);

