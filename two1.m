% 恒定子磁通控制 - 定子磁链&PWM电压波形
clc;clear;close all;

% 基础参数
t = linspace(0, 1, 120);  % 时间轴0-1s，1000个采样点
w_carrier = 2*pi*100;      % PWM载波频率100Hz（高频调制）
w_base = 2*pi*5;           % 基波频率5Hz（模拟电机基频分量）

% 1. 定子磁链波形（恒定幅值+小纹波，目标值1.5Wb）
psi_s = 1.5 + 0.1*sin(w_carrier*t);  % 恒定磁链+高频纹波

% 2. PWM电压波形（高频调制+基波分量）
u_pwm = 200*(sign(sin(w_carrier*t))*0.5 + 0.5) + 50*sin(w_base*t);

% 绘图
figure('Position',[100,100,800,400]);
subplot(1,2,1);
plot(t,psi_s,'b','LineWidth',1.2);
title('定子磁链波形');
xlabel('时间 (s)');
ylabel('定子磁链 (Wb)');
ylim([0.5,2]);
grid on;

subplot(1,2,2);
plot(t,u_pwm,'g','LineWidth',1.2);
title('PWM电压波形');
xlabel('时间 (s)');
ylabel('PWM电压 (V)');
ylim([0,300]);
grid on;