% 清除工作区变量、命令窗口输出和关闭现有图形窗口
clear; clc; close all;

% 1. 定义实验原始数据
% 直流母线电压Udc (V)（原始递减顺序）
Udc_ori = [280, 260, 240, 220, 200, 180];
% SPWM控制下的实际转速N (rpm)（对应原始Udc顺序）
N_SPWM_ori = [907, 889, 860, 805, 751, 545];
% SVPWM控制下的实际转速N (rpm)（对应原始Udc顺序）
N_SVPWM_ori = [970, 941, 933, 933, 915, 871];

% 2. 对Udc升序排序，并同步调整转速数据顺序（解决xticks递增要求）
[Udc, idx] = sort(Udc_ori); % 升序排序Udc，返回排序后的值和索引
N_SPWM = N_SPWM_ori(idx);  % 按排序索引调整SPWM转速顺序
N_SVPWM = N_SVPWM_ori(idx);% 按排序索引调整SVPWM转速顺序
% 额定转速 (rpm)（匹配排序后Udc的长度）
N_rated = 1000 * ones(1, length(Udc));

% 3. 绘制曲线图
% 创建图形窗口，设置窗口大小（宽度，高度，单位：像素）
figure('Position', [100, 100, 800, 600]);
% 绘制SPWM转速曲线：蓝色实线+圆形标记，线宽1.5，标记大小6
plot(Udc, N_SPWM, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'SPWM调速');
hold on; % 保持当前图形，继续绘制其他曲线
% 绘制SVPWM转速曲线：品红色实线+方形标记，线宽1.5，标记大小6
plot(Udc, N_SVPWM, 'm-s', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'SVPWM调速');
% 绘制额定转速参考线：黑色虚线，线宽1.2
plot(Udc, N_rated, 'k--', 'LineWidth', 1.2, 'DisplayName', '额定转速(1000rpm)');
hold off; % 结束绘图保持

% 4. 设置图表标注和样式
% 设置图表标题
title('SPWM与SVPWM调速方式的电压调制比实验曲线', 'FontSize', 14, 'FontWeight', 'bold');
% 设置横轴标签
xlabel('直流母线电压Udc (V)', 'FontSize', 12);
% 设置纵轴标签
ylabel('实际转速N (rpm)', 'FontSize', 12);
% 添加图例，位置设为右下角
legend('Location', 'southwest', 'FontSize', 10);
% 添加网格线，增强可读性
grid on;
% 设置坐标轴刻度字体大小
set(gca, 'FontSize', 10);
% 设置横轴刻度为排序后的Udc（递增，符合xticks要求）
xticks(Udc);