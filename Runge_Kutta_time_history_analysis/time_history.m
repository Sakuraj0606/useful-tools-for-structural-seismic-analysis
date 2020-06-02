function []=time_history()
%% ��Newmark���Խṹ��ϵ����ʱ�̷���
clear
clc
%% ����ṹ��Ϣ
m=2000; %ԭ�ṹ������kg
omega=2*pi/1.5; %ԭ�ṹƵ�ʣ�rad/s
k=m*omega^2; %ԭ�ṹ�նȣ�N/m
ksi=0.03; %ԭ�ṹ�����
c=2*ksi*omega*m; %ԭ�ṹ����ϵ����N��s/m

%% �������
[M,C,K,E] = matrix_shear_building(m, c, k);

%% ��ȡ����
wave=textread('.\����\RSN12_KERN.PEL_PEL090.AT2', '' ,'headerlines',4); % ��ȡ����

dt=0.005; % ����ʱ����(s)

wave=wave'; %��ת��
wave=wave(:); %��Ϊһ��
wave=wave'*9.8; % m/s^2
n=length(wave);

%% Newmark���λ��ʱ����Ӧ
[u,du,ddu] = Newmark_belta(wave,dt,n,M,C,K,E);
[u1,du1] = Runge_Kutta(wave,dt,n,M,C,K,E);

t=linspace(0.005,n*0.005,n);

%% ����
close all
green=[64/256,116/256,52/256];
blue=[7/256,151/256,237/256];
orange=[248/256,147/256,29/256];
red=[219/256,69/256,32/256];
brown=[107/256,90/256,92/256];
gray=[151/256,151/256,151/256];

figure('position',[300,300,1200,600]) % λ��

subplot(2,1,1)
plot(t,u,'linewidth',2,'color',orange)
set(xlabel('Time (s)'),'Fontname', 'Times New Roman','FontSize',15)
set(ylabel('Displacement (m)'),'Fontname', 'Times New Roman','FontSize',15)
set(legend('Newmark-\beta'),'Fontname', 'Times New Roman','FontSize',15)
set(gca,'Fontname', 'Times New Roman','FontSize',15)

subplot(2,1,2)
plot(t,u1,'linewidth',2,'color',blue)
set(xlabel('Time (s)'),'Fontname', 'Times New Roman','FontSize',15)
set(ylabel('Displacement (m)'),'Fontname', 'Times New Roman','FontSize',15)
set(legend('Runge-Kutta'),'Fontname', 'Times New Roman','FontSize',15)
set(gca,'Fontname', 'Times New Roman','FontSize',15)
