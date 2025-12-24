clc; clear; close all;

%% 实验数据
Id = [0.05, 0.12, 0.3, 0.4, 0.5, 0.6]; % 电枢电流 A
n_85 = [1142, 1083, 1006, 985, 955, 937]; % 占空比 85% 对应转速
n_70 = [633, 589, 490, 461, 424, 405];   % 占空比 70% 对应转速

%% 绘制曲线
figure('Position',[100 100 900 600]);
hold on; grid on;

% 占空比 85%
plot(Id, n_85, '-o', 'LineWidth',2, 'MarkerSize',8, 'DisplayName','占空比 85%');
% 占空比 70%
plot(Id, n_70, '-s', 'LineWidth',2, 'MarkerSize',8, 'DisplayName','占空比 70%');

% 标注数据点数值
for i = 1:length(Id)
    text(Id(i), n_85(i)+15, num2str(n_85(i)),'HorizontalAlignment','center','FontSize',10);
    text(Id(i), n_70(i)-20, num2str(n_70(i)),'HorizontalAlignment','center','FontSize',10);
end

%% 坐标轴、标题和图例
xlabel('电枢电流 I_d (A)','FontSize',12);
ylabel('电机转速 n (r/min)','FontSize',12);
title('占空比与电机转速关系曲线','FontSize',14);
legend('Location','northwest');

%% 添加公式标注
text(0.35, 1050, 'n = (U_d - I_d*R)/(K_e*\phi)','FontSize',12,'Color','r');
text(0.35, 1020, 'U_d = p*U_s','FontSize',12,'Color','r');

hold off;
