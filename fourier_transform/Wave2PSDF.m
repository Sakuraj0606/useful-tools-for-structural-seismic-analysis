function [ ]=Wave2PSDF( ) 
%% ������������������ٶȵĹ������ܶȺ���
clear
clc

%% ������Ϣ����
ug=textread('.\����\RSN12_KERN.PEL_PEL090.AT2', '' ,'headerlines',4); % ��ȡ����
% ug=textread('.\����\RSN17_SCALIF_SLO234.AT2', '' ,'headerlines',4); % ��ȡ����
% ug=textread('.\����\RSN1599_DUZCE_ATS030.txt', '' ,'headerlines',4); % ��ȡ����

ug=ug'; %��ת��
ug=ug(:); %��Ϊһ��
dt=0.02; % ���𲨲��������s��
f=1/dt; % ����Ƶ�ʣ�Hz��
g=9.8; % �������ٶȣ�m/s^2��
ug=ug*g; % ��ʵ��������

ng=length(ug); % ��ǰ��������Ŀ
time=linspace(dt,ng*dt,ng);

n=nextpow2(ng); % ����������������㷽��2^n��|ng|��n����Сֵ
m=2^n; % ��n����n��|ng|������2Ϊ�������ݺ�����Ϊ��չ������������Ŀ
% ��������������2��n����ʱ���ſ�ʹ�ÿ��ٸ���Ҷ�任

%% ���㵥�߹������ܶȺ���
Y=fft(ug,m);       
% ��ʾ���ÿ��ٸ���Ҷ�任�ķ�������ug��������ɢ����Ҷ�任��DFT�����任���ά��Ϊn��������ȡ0��������ض�
Sg=Y.*conj(Y)/m; % �������ܶȣ�m^2/s^3��
P=Y.*conj(Y); % �����ף�m^2/s^3��
Amp=abs(Y); % ����Ҷ�ף�m/s^2��
% ���ݣ�����B, ����MATLAB�ĵ��𲨶������Է���, 2010.

f_range=(1:m/2)/m*f; % Ƶ�����У�Hz��
f_range=f_range';
Sg=Sg(1:m/2);
P=P(1:m/2);
Amp=Amp(1:m/2);

%% ��ͼ
close all
blue=[96 157 202]/256;
orange=[255 160 65]/256;
green=[56 194 93]/256;
pink=[255 91 78]/256;
purple=[184 135 195]/256;
gray=[164 160 155]/256;
fontSize=12;
item=500; % ��������

subplot(2,2,1)
plot(f_range(1:item),Sg(1:item),'linewidth',1.5,'color',blue)
set(xlabel('Frequency \itf \rm(Hz)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(ylabel('PSDF of Acc. (m^2/s^3)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(gca,'Fontname', 'Times New Roman','FontSize',fontSize)

subplot(2,2,2)
plot(time,ug,'linewidth',1.5,'color',blue)
set(xlabel('Time \itt \rm(s)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(ylabel('Acc. (m/s^2)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(gca,'Fontname', 'Times New Roman','FontSize',fontSize)

subplot(2,2,3)
plot(f_range(1:item),P(1:item),'linewidth',1.5,'color',orange)
set(xlabel('Frequency \itf \rm(Hz)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(ylabel('Power spectrum of Acc. (m^2/s^3)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(gca,'Fontname', 'Times New Roman','FontSize',fontSize)

subplot(2,2,4)
plot(f_range(1:item),Amp(1:item),'linewidth',1.5,'color',green)
set(xlabel('Frequency \itf \rm(Hz)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(ylabel('Fourier spectrum of Acc. (m/s^2)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(gca,'Fontname', 'Times New Roman','FontSize',fontSize)

set(gcf,'position',[200,200,900,700])