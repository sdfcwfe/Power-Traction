% 恒定子磁通控制离线仿真（含类似图二的Te-s特性曲线：Te为X轴，s为Y轴）
clear; clc; close all;

% --------------------- 1. 仿真参数设置 ---------------------
Ts = 1e-5; % 仿真步长（s）
t_total = 1; % 总仿真时间（s）
t = 0:Ts:t_total; % 时间向量
Rs = 1.405; % 定子电阻（Ω）
psi_ref = 1.27; % 定子磁链参考值（Wb）
Kp = 200; % PI比例增益
Ki = 500; % PI积分增益

% 电机参数（补充漏抗，用于实际Te-s公式）
f = 50; % 电源频率（Hz）
p = 4; % 极对数
n0 = 60*f/p; % 同步转速（r/min），如50Hz/4极：750r/min
Rr = 1.2; % 转子电阻（Ω）
Lm = 0.1; % 互感（H，参考值）
X_ls = 2*pi*f*0.0012; % 定子漏抗（Ω），对应Lls=0.0012H
X_lr = 2*pi*f*0.0012; % 转子漏抗（Ω），对应Llr=0.0012H
X_l = X_ls + X_lr; % 总漏抗（Ω）
U_s = 400; % 定子线电压（V，恒定子磁通下的等效电压）

% --------------------- 2. 生成模拟的三相电压/电流（50Hz）---------------------
U_amp = 220*sqrt(2); % 相电压幅值（V）
ua = U_amp * sin(2*pi*f*t);
ub = U_amp * sin(2*pi*f*t - 2*pi/3);
uc = U_amp * sin(2*pi*f*t + 2*pi/3);

% 模拟定子电流（幅值10A，滞后电压30°）
I_amp = 10;
ia = I_amp * sin(2*pi*f*t - pi/6);
ib = I_amp * sin(2*pi*f*t - pi/6 - 2*pi/3);
ic = I_amp * sin(2*pi*f*t - pi/6 + 2*pi/3);

% --------------------- 3. 初始化变量 ---------------------
psi_alpha = zeros(size(t));
psi_beta = zeros(size(t));
psi_s = zeros(size(t));
error = zeros(size(t));
u_out = zeros(size(t));
integrator_alpha = 0;
integrator_beta = 0;
integrator_pi = 0;

% 新增：转速、转矩、转差率变量
n_rpm = zeros(size(t)); % 实际转速（r/min）
Te = zeros(size(t)); % 电磁转矩（N·m）
s = zeros(size(t)); % 转差率

% --------------------- 4. 逐步仿真（保留原有磁链估算和PI调节）---------------------
for k = 1:length(t)
    % ------------ Clark变换 ------------
    clark_matrix = [2/3, -1/3, -1/3;
                    0,    1/sqrt(3), -1/sqrt(3)];
    u_abc = [ua(k); ub(k); uc(k)];
    i_abc = [ia(k); ib(k); ic(k)];
    u_alpha_beta = clark_matrix * u_abc;
    i_alpha_beta = clark_matrix * i_abc;
    u_alpha = u_alpha_beta(1);
    u_beta = u_alpha_beta(2);
    i_alpha = i_alpha_beta(1);
    i_beta = i_alpha_beta(2);

    % ------------ 磁链估算 ------------
    integrator_alpha = integrator_alpha + (u_alpha - Rs * i_alpha) * Ts;
    integrator_beta = integrator_beta + (u_beta - Rs * i_beta) * Ts;
    psi_alpha(k) = integrator_alpha;
    psi_beta(k) = integrator_beta;
    psi_s(k) = sqrt(psi_alpha(k)^2 + psi_beta(k)^2);

    % ------------ PI调节（磁链偏差补偿）------------
    error(k) = psi_ref - psi_s(k);
    integrator_pi = integrator_pi + error(k) * Ts;
    u_out(k) = Kp * error(k) + Ki * integrator_pi;
    u_out(k) = max(min(u_out(k), 400), 0); % 限幅

    % ------------ 模拟电机转速和转矩（简化模型）------------
    Te(k) = 1.5 * p * (psi_alpha(k)*i_beta - psi_beta(k)*i_alpha); % 电磁转矩公式
    n_rpm(k) = n0 - (Te(k) / 10) * 50; % 简化：转矩越大，转速越低
    n_rpm(k) = max(n_rpm(k), 0); % 转速不能为负

    % ------------ 计算转差率s ------------
    s(k) = (n0 - n_rpm(k)) / n0;
end

% --------------------- 5. 生成实际的Te-s数据（核心：替换简化模型）---------------------
% 5.1 生成转差率范围（覆盖线性段+临界段+饱和段，0~1）
s_range = linspace(0, 1, 500); % 转差率s从0到1
Te_range = zeros(size(s_range));
% 5.2 计算临界转差率和最大转矩（异步电机关键参数）
s_m = Rr / sqrt(Rs^2 + X_l^2); % 最大转矩对应的临界转差率
T_emax = (3*p*U_s^2) / (4*pi*f*(Rs + sqrt(Rs^2 + X_l^2))); % 最大转矩
% 5.3 遍历计算每个s对应的Te（异步电机实际公式）
for k = 1:length(s_range)
    if s_range(k) == 0
        Te_range(k) = 0; % s=0时转矩为0
    else
        % 异步电机电磁转矩公式（恒定子磁通下）
        numerator = 3 * p * U_s^2 * Rr / s_range(k);
        denominator = 2 * pi * f * ((Rs + Rr/s_range(k))^2 + X_l^2);
        Te_range(k) = numerator / denominator;
    end
end
% 5.4 提取仿真中的有效Te和s（过滤0值）
Te_sim = Te(Te > 0 & Te <= T_emax*1.2);
s_sim = s(Te > 0 & Te <= T_emax*1.2);

% --------------------- 6. 绘图：保留原有子图 + 新增类似图二的Te-s图（坐标修正）---------------------
% 原有仿真子图（磁链+PI输出+n-Te）
figure('Position', [100, 100, 1000, 600]);
% 子图1：磁链幅值
subplot(2,2,1);
plot(t, psi_s, 'b', 'LineWidth', 1.5);
hold on;
plot(t, ones(size(t))*psi_ref, 'r--', 'LineWidth', 1);
xlabel('时间 t (s)');
ylabel('定子磁链 ψ_s (Wb)');
title('定子磁链幅值');
legend('实际','参考');
grid on;

% 子图2：PI补偿输出
subplot(2,2,2);
plot(t, u_out, 'g', 'LineWidth', 1.5);
xlabel('时间 t (s)');
ylabel('PI输出 (V)');
title('PI电压补偿');
grid on;

% 子图3：n-Te图
subplot(2,2,3);
plot(Te, n_rpm, 'c', 'LineWidth', 1.5);
xlabel('转矩 T_e (N·m)');
ylabel('转速 n (r/min)');
title('n-T_e特性曲线');
grid on;

% 子图4：原仿真数据s-Te曲线（可选保留）
subplot(2,2,4);
plot(Te, s, 'm', 'LineWidth', 1.5); % 同样修正坐标
xlabel('转矩 T_e (N·m)');
ylabel('转差率 s');
title('仿真数据Te-s曲线');
grid on;

% 调整子图间距
sgtitle('恒定子磁通控制仿真结果');

% --------------------- 7. 新增：类似图二的独立Te-s特性曲线（坐标修正：Te为X，s为Y）---------------------
figure('Position', [200, 200, 600, 500]); % 独立窗口，匹配图二尺寸
% 绘制实际Te-s特性曲线（黑色实线，主曲线：Te为X轴，s为Y轴）
plot(Te_range, s_range, 'k', 'LineWidth', 2);
hold on;
% 叠加仿真数据点（红色圆点，可选）
plot(Te_sim, s_sim, 'ro', 'MarkerSize', 4, 'DisplayName', '仿真数据');
% 绘制线性段近似（红色虚线：小Te时s与Te线性相关）
% 提取线性段的Te和s（Te <= T_emax*0.5）
Te_linear = Te_range(Te_range <= T_emax*0.5);
s_linear = s_range(Te_range <= T_emax*0.5);
% 线性拟合
p_fit = polyfit(Te_linear, s_linear, 1);
s_fit = polyval(p_fit, Te_linear);
plot(Te_linear, s_fit, 'r--', 'LineWidth', 1.5, 'DisplayName', '线性段近似');
% 标注最大转矩点（绿色实心圆，关键拐点）
plot(T_emax, s_m, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g', 'DisplayName', '最大转矩点');
% 标注最大转矩和临界转差率
text(T_emax+5, s_m, ['s_m=' num2str(round(s_m,3))], 'FontSize', 10);
text(T_emax+5, s_m-0.05, ['T_{emax}=' num2str(round(T_emax,1)) 'N·m'], 'FontSize', 10);
% 坐标轴设置（匹配图二的简洁样式）
xlabel('电磁转矩 T_e (N·m)', 'FontSize', 12);
ylabel('转差率 s', 'FontSize', 12);
title('异步电机恒定子磁通控制Te-s特性曲线', 'FontSize', 12);
xlim([0, T_emax*1.2]); % 转矩范围到最大转矩的1.2倍
ylim([0, 1]); % 转差率范围0~1
grid on; % 保留网格（图二若没有可删除grid on）
legend('Location', 'best'); % 图例位置

% 可选：隐藏网格（若图二无网格，添加以下代码）
% grid off;