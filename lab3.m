clc; clear; close all;

%% 电枢电流
Id_with_error = [0.3, 0.4, 0.5, 0.6]; % 有静差闭环比例控制
n_with_error = [545, 530, 516, 505];  % r/min

Id_no_error = [0.04, 0.11, 0.3, 0.4, 0.5, 0.6]; % 无静差积分控制
n_no_error = [1003, 999, 999, 999, 999, 999];   % r/min

%% 绘图
figure('Position',[100 100 1000 600]);
hold on; grid on;

% 绘制有静差闭环曲线
plot(Id_with_error, n_with_error, '-o', 'LineWidth',2, 'MarkerSize',8, 'DisplayName','闭环有静差 (比例控制)');

% 绘制无静差闭环曲线
plot(Id_no_error, n_no_error, '-s', 'LineWidth',2, 'MarkerSize',8, 'DisplayName','闭环无静差 (积分控制)');

% 标注数据点
for i = 1:length(Id_with_error)
    text(Id_with_error(i), n_with_error(i)-10, num2str(n_with_error(i)), 'HorizontalAlignment','center','FontSize',9);
end
for i = 1:length(Id_no_error)
    text(Id_no_error(i), n_no_error(i)+10, num2str(n_no_error(i)), 'HorizontalAlignment','center','FontSize',9);
end

%% 坐标轴、标题和图例
xlabel('电枢电流 I_d (A)','FontSize',12);
ylabel('电机转速 n (r/min)','FontSize',12);
title('单闭环有静差与无静差调速系统机械特性对比', 'FontSize',14);
legend('Location','southwest');

%% 添加公式标注
% text(0.35, 1020, 'n = (U_d - I_d*R)/(K_e*\phi)','FontSize',12,'Color','r');
% text(0.35, 995, 'U_d = p*U_s (比例控制)','FontSize',12,'Color','r');
% text(0.35, 985, '积分控制保持恒定转速','FontSize',12,'Color','r');

hold off;

