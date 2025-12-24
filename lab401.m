% 清除工作区变量、命令窗口输出，关闭现有图形窗口
clear; clc; close all;

% 1. 定义实验数据
% 定子A相电流 Ia (A)（含空载电流）
Ia = [0.56, 0.66, 0.76, 0.84, 1.02];
% 对应电流下的实际转速 N (rpm)
N = [999, 995, 999, 1003, 955];
% 给定转速（额定参考值）
N_ref = 1000 * ones(1, length(Ia));

% 2. 绘制稳态机械特性曲线
% 创建图形窗口，设置窗口大小（宽度800像素，高度600像素）
figure('Position', [100, 100, 800, 600]);
% 绘制实际转速曲线：蓝色实心圆点+实线，线宽1.5，标记大小8
plot(Ia, N, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 8, 'DisplayName', '实际转速N');
hold on;
% 绘制给定转速参考线：黑色虚线，线宽1.2，突出额定转速
plot(Ia, N_ref, 'k--', 'LineWidth', 1.2, 'DisplayName', '给定转速n*=1000rpm');
hold off;

% 3. 设置图表标注与样式（符合实验报告规范）
% 图表标题：加粗+字号14
title('磁场定向矢量控制的稳态机械特性曲线', 'FontSize', 14, 'FontWeight', 'bold');
% 横轴标签：定子A相电流 Ia (A)
xlabel('定子A相电流 Ia (A)', 'FontSize', 12);
% 纵轴标签：实际转速 N (rpm)
ylabel('实际转速 N (rpm)', 'FontSize', 12);
% 添加图例：位置设为右上角，字号10
legend('Location', 'northeast', 'FontSize', 10);
% 添加网格线：增强数据可读性
grid on;
% 设置坐标轴刻度字号
set(gca, 'FontSize', 10);
% 强制横轴刻度与实验电流值完全匹配
xticks(Ia);
% 纵轴刻度范围优化（贴合数据区间）
ylim([940, 1010]);