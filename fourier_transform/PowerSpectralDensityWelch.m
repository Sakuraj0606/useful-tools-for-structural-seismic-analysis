function [ ]=PowerSpectralDensityWelch()
%% ������ʹ��Τ���湦�����ܶȹ��Ʒ����Ӵ��������������𲨵Ĺ�����
% �ο�����
% https://www.ilovematlab.cn/thread-492083-1-1.html
% https://wenku.baidu.com/view/5bcd1214fad6195f312ba641.html
clc
clear

%% ��ȡ�����ź�
file=textread('.\GM6-TH.txt', '' , 'headerlines',1);
g=9.8; % �������ٶ� m/s^2
ug=file(:,2)*g;
dt=0.005; % ������� s
fs=1/dt; % ����Ƶ�� Hz
N=length(ug); % �źų���
t=(1:N)*dt; % ʱ��ʸ��


%% �������ܶ�PSD
ug = ug - mean(ug); % ȥ��ֱ���ɷ�
win = hanning(512, 'periodic'); % ����������������һ��512��ĶԳ�����

[PSD, f] = pwelch(ug, win, 256, N, fs, 'twosided'); % Τ���湦�����ܶȹ���
% [PSD,F] = PWELCH(X,WINDOW,NOVERLAP,NFFT,Fs)
% PSD--------------------�����źŵĹ������ܶȵĹ���ֵ
% f----------------------Ƶ�����У���fs�ĵ�λΪ����/sʱ��f�ĵ�λΪHz
% X----------------------�����ź�
% WINDOW-----------------���ڻ����źŵĴ��ڣ��źŻᱻ����Ϊ���ɶΣ��������ڴ��ڳ���
% NOVERLAP---------------�ص������ĳ��ȣ�Ĭ��Ϊ���ڳ��ȵ�50%
% N----------------------��ɢ����Ҷ�任DFT�е������
% fs---------------------����Ƶ��
% 'twosided''onesided'---˫�߹�����or���߹����ף����߷�ֵ��ǰ������

%% ����
disp('Ƶ�����ķ���')
sum(PSD(1:end-1).*diff(f))

disp('ʱ�����ķ���')
rms(ug)^2 % ��������ƽ��
sum(ug.^2*dt)/dt/N; % �ȶ�ƽ�����֣��ٳ��Գ�ʱ

%% ��ͼ
close all


figure('position',[100 100 900 700])
blue=[96 157 202]/256;
orange=[255 160 65]/256;
green=[56 194 93]/256;
pink=[255 91 78]/256;
purple=[184 135 195]/256;
gray=[164 160 155]/256;

fontsize=15;
subplot(2,1,1)
plot(t,ug,'linewidth',2,'color',orange)
title('Time history of acceleration','Fontname', 'Times New Roman','FontSize',fontsize)
set(xlabel('Time [s]'),'Fontname', 'Times New Roman','FontSize',fontsize)
set(ylabel('Acceleration [m/s^2]'),'Fontname', 'Times New Roman','FontSize',fontsize)
grid on

subplot(2,1,2)
plot(f,PSD,'linewidth',2,'color',green);
title('Power spectral density (PSD)','Fontname', 'Times New Roman','FontSize',fontsize)
set(xlabel('Frequency [Hz]'),'Fontname', 'Times New Roman','FontSize',fontsize)
set(ylabel({'Power spectral density (PSD)';'[m^2/s^3] or [(m/s^2)^2/Hz]'}),'Fontname', 'Times New Roman','FontSize',fontsize)
% xlim([0 10])
grid on