clc;clear;close all;

%% 1. 调整参数（放大转矩数值，匹配你的图Y轴）
p = 4;           % 极对数
Rr = 0.1;        % 减小转子电阻（放大转矩）
w1 = 2*pi*5;     % 降低角频率（用5Hz替代50Hz，放大转矩）
s = 0.2;         % 增大转差率（放大转矩）
Llr = 0.0012;    % 转子漏感

%% 2. 定子磁链范围（与你的图一致：0~0.8Wb）
psi_s = linspace(0.1, 0.8, 100);

%% 3. 转矩公式（保证数值在0-5之间）
Te = (3 * p * psi_s.^2 .* Rr .* s) ./ (w1 .* (Rr^2 + (s*w1*Llr).^2));

%% 4. 绘图（与你的图坐标轴完全匹配）
figure('Position',[100,100,600,450]);
plot(psi_s, Te, 'm', 'LineWidth',2);  % 加粗粉色曲线
title('转矩-定子磁链特性曲线(Ψe-Te)','FontSize',12);
xlabel('定子磁链 Ψs (Wb)','FontSize',11);
ylabel('电磁转矩 Te (N·m)','FontSize',11);
xlim([0, 0.8]);   % 匹配X轴
ylim([0, 5]);     % 匹配Y轴
grid on;
set(gca, 'GridLineStyle','--', 'FontSize',10);