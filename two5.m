% --------------------- 5. 生成实际的Te-s数据（核心：添加变换）---------------------
% 5.1 生成转差率范围（覆盖线性段+临界段+饱和段，0~1）
s_range = linspace(0, 1, 500); % 原转差率s从0到1
Te_range = zeros(size(s_range));
% 5.2 计算临界转差率和最大转矩（异步电机关键参数）
s_m = Rr / sqrt(Rs^2 + X_l^2); % 原最大转矩对应的临界转差率
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
% 5.4 核心变换：s_new = 1 - s（对称+平移）
s_new_range = 1 - s_range;
% 仿真数据的变换
Te_sim = Te(Te > 0 & Te <= T_emax*1.2);
s_sim = s(Te > 0 & Te <= T_emax*1.2);
s_sim_new = 1 - s_sim;
% 最大转矩点的变换
s_m_new = 1 - s_m;

% --------------------- 7. 新增：类似图二的独立Te-s特性曲线（变换后）---------------------
figure('Position', [200, 200, 600, 500]);
% 绘制变换后的特性曲线（Te为X，s_new为Y）
plot(Te_range, s_new_range, 'k', 'LineWidth', 2);
hold on;
% 叠加仿真数据点（变换后）
plot(Te_sim, s_sim_new, 'ro', 'MarkerSize', 4, 'DisplayName', '仿真数据');
% 线性段近似（变换后）
Te_linear = Te_range(Te_range <= T_emax*0.5);
s_linear = s_range(Te_range <= T_emax*0.5);
s_linear_new = 1 - s_linear; % 线性段也做变换
p_fit = polyfit(Te_linear, s_linear_new, 1);
s_fit = polyval(p_fit, Te_linear);
plot(Te_linear, s_fit, 'r--', 'LineWidth', 1.5, 'DisplayName', '线性段近似');
% 最大转矩点（变换后）
plot(T_emax, s_m_new, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g', 'DisplayName', '最大转矩点');
% 标注（变换后）
text(T_emax+5, s_m_new, ['s_{m(new)}=' num2str(round(s_m_new,3))], 'FontSize', 10);
text(T_emax+5, s_m_new-0.05, ['T_{emax}=' num2str(round(T_emax,1)) 'N·m'], 'FontSize', 10);
% 坐标轴配置
xlabel('电磁转矩 T_e (N·m)', 'FontSize', 12);
ylabel('变换后转差率 s_{new}', 'FontSize', 12); % 可选：修改Y轴标签
title('异步电机恒定子磁通控制Te-s特性曲线（变换后）', 'FontSize', 12);
xlim([0, T_emax*1.2]);
ylim([0, 1]);
grid on;
legend('Location', 'best');