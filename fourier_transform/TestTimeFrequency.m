function [ ]=TestTimeFrequency()
%% ������������֤ʱ���Ƶ����Ǻ���
clear
clc

%% �ṹ��Ϣ
m=200; % ԭ�ṹ������kg
T=1.5; % ԭ�ṹ����,s
omega=2*pi/T; % ԭ�ṹƵ�ʣ�rad/s
k=m*omega^2; % ԭ�ṹ�նȣ�N/m
zeta=0.03; % ԭ�ṹ�����
c=2*zeta*omega*m; %ԭ�ṹ����ϵ����N��s/m

%% ��ȡ����
ug=textread('F:\D-SMA-TMD\����\GM2-TH.txt', '' ,'headerlines',1); % ��ȡ����
ug=ug(:,2);
ug=ug(:); % ��Ϊһ��
ug=ug'; 
ug=ug(1:1000);
dt=0.02;
n=length(ug);
t=linspace(dt,n*dt,n);
[Sg,Omega]=Wave2PSDF(ug,dt);

%% Ƶ����Ӧ���
[M,C,K,E] = matrix_shear_building(m, c, k);
[lamda, Phi, r] = complex_modes(M,C,K,E);
[~, Sx, Sigma_X, Sigma_XP] = stochastic_response_Sg(lamda, Phi, r, Sg, Omega);

disp('Ƶ������λ�ƾ�����')
Sigma_X

%% ʱ����Ӧ���
[u,du,ddu] = Newmark_belta(ug,dt,length(ug),m,c,k,1);
disp('ʱ������λ�ƾ�����')
rms(u)


close all
subplot(5,1,1)
plot(Omega,Sg)
subplot(5,1,2)
plot(t,ug)
subplot(5,1,3)
plot(t,ddu)
subplot(5,1,4)
plot(t,du)
subplot(5,1,5)
plot(t,u)
set(gcf,'position',[200,200,900,700])

function [Sg,Omega]=Wave2PSDF(ug,dt) 
%% ������Ϣ����
% ug--------------------���ٶ�����
% dt--------------------���𲨲��������s��
ug=ug'; %��ת��
ug=ug(:); %��Ϊһ��
f=1/dt; % ����Ƶ�ʣ�Hz��

ng=length(ug); % ��ǰ��������Ŀ
time=linspace(dt,ng*dt,ng);

n=nextpow2(ng); % ����������������㷽��2^n��|ng|��n����Сֵ
m=2^n; % ��n����n��|ng|������2Ϊ�������ݺ�����Ϊ��չ������������Ŀ
% ��������������2��n����ʱ���ſ�ʹ�ÿ��ٸ���Ҷ�任

%% ���㵥�߹������ܶȺ���
Y=fft(ug,m);       
% ��ʾ���ÿ��ٸ���Ҷ�任�ķ�������ug��������ɢ����Ҷ�任��DFT�����任���ά��Ϊn��������ȡ0��������ض�
Sg=Y.*conj(Y)/m; % �������ܶȣ�m^2/s^3��
Sg=abs(Y)/m;
% ���ݣ�����B, ����MATLAB�ĵ��𲨶������Է���, 2010.
f_range=(1:m/2)/m*f; % Ƶ�����У�Hz��
f_range=f_range';
Sg=Sg(1:m/2);
Omega=f_range*2*pi;