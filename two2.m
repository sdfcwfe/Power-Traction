% 恒定子磁通 vs 恒压频比 - 机械特性曲线(n-Te)
clc;clear;close all;

% 电机核心参数
n0 = 750;        % 同步转速(r/min)
p = 4;           % 极对数
Rr = 1.2;        % 转子电阻(Ω)
psi_s_ref = 0.733; % 额定定子磁链(Wb)，由U_s/(√3*ω1)计算
w1 = 2*pi*50;    % 额定角频率(rad/s)

% 转矩范围0-100N·m
Te = linspace(0,100,100);

% 1. 恒定子磁通控制：转差s与转矩近似线性，机械特性硬
s_psi = (Te .* w1 .* Rr) ./ (3*p*psi_s_ref^2);  % 由转矩公式反推转差
n_psi = n0 .* (1 - s_psi);

% 2. 恒压频比控制：忽略压降，磁链随负载下降，特性软
s_uf = (Te .* w1 .* Rr) ./ (3*p*(psi_s_ref*0.8).^2); % 磁链衰减20%
n_uf = n0 .* (1 - s_uf);

figure('Position',[100,100,600,400]);
plot(Te,n_psi,'b','LineWidth',1.5,'DisplayName','恒定子磁通');
hold on;
plot(Te,n_uf,'r--','LineWidth',1.5,'DisplayName','恒压频比(U/f)');
title('异步电机机械特性曲线(n-Te)');
xlabel('电磁转矩 Te (N·m)');
ylabel('转速 n (r/min)');
ylim([500,760]);  % 聚焦有效转速范围
grid on;
legend('Location','best');