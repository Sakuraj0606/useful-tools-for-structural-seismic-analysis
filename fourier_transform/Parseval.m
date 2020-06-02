function [ ] = Parseval( )
%% ������������֤Parseval��s theorem��ʱ���Ƶ���������ȣ�
% �ö������ѧ�����ʽΪsigma^2=integral(0,Tg,x(t)^2/Td)=integral(-��,+��,S(omega))
% sigma^2Ϊ����x(t)�ķ��x(t)Ӧ�����ֵΪ0��������S(omega)Ϊx(t)�Ĺ������ܶȺ�����TgΪx(t)�ĳ�ʱ
% �ο���https://blog.csdn.net/enjoy_learn/article/details/60978606

clear
clc

%% ������Ϣ����
switch 2
    case 1 % ��Ϊ����
        dt = 0.001; % ���������s
        fs = 1/dt; % ����Ƶ�ʣ�Hz
        Td = 30;
        t = 0:dt:Td; % ʱ������
        N = length(t); % ��������
        fx = 15*cos(0.5*pi*t)+8*cos(1*pi*t); % ��������
    case 2 % ��ȡ���е���
        dt = 0.005;
        fs = 1/dt; % ����Ƶ�ʣ�Hz
%         fx=textread('.\����\RSN17_SCALIF_SLO234.AT2', '' ,'headerlines',4); % ��ȡ����
%         fx=textread('.\����\RSN1599_DUZCE_ATS030.txt', '' ,'headerlines',4); % ��ȡ����
%         fx=textread('.\����\RSN1540_CHICHI_TCU115-N.AT2', '' ,'headerlines',4); % ��ȡ����
%         fx=textread('.\����\RSN718_SUPER.A_A-IVW090.AT2', '' ,'headerlines',4); % ��ȡ����
        fx=textread('.\����\RSN16_NCALIF.AG_A-FRN044.AT2', '' ,'headerlines',4); % ��ȡ����

        fx = fx'; % ��ת��
        g = 9.8; % m/s^2
        fx = fx(:)*g;
        N = length(fx); % ��������
        Td = (N-1)*dt;
        t = 0:dt:Td; % ʱ������
end

%% ʱ����⼤������
disp('ʱ��Ƕ���������')
variance_time = sum(fx.^2)/Td*dt % ʱ��Ƕ��󷽲�

%% Ƶ����⼤������
n=nextpow2(N); % ����������������㷽��2^n��|N|��n����Сֵ
m=2^n; % ��չ��������Ŀ����n����n��|ng|������2Ϊ�������ݺ�����Ϊ��չ������������Ŀ
% ��������������2��n����ʱ���ſ�ʹ�ÿ��ٸ���Ҷ�任

window = hanning(N); % ����������
[Pxx_period,f_period] = periodogram(fx,[],m,fs); % periodogram��pwelch��������PSD�Ĺ��ƣ����б�Ҫ�����Խ��ڶ����Ϊwindow
df = f_period(2)-f_period(1); % ���Ƶ�ʵļ������ͬ�ڲ���Ƶ��fs
S = Pxx_period/m/dt/df; % ���Ƿ�ֵ������PSD

disp('Ƶ��Ƕ���������')
variance_frequency = sum(S)*df % Ƶ��Ƕ��󷽲�

%% ʱ��Ƕ������Ӧ����
m = 200e3; % ԭ�ṹ������kg
Ts = 1.5; % ԭ�ṹ���ڣ�s
omega = 2*pi/Ts; % ԭ�ṹƵ�ʣ�rad/s
k = m*omega^2; % ԭ�ṹ�նȣ�N/m
zeta = 0.03; % ԭ�ṹ�����
c = 2*zeta*omega*m; %ԭ�ṹ����ϵ����N��s/m

[u,du,ddu] = Newmark_belta(fx,dt,N,m,c,k,1);
disp('ʱ��Ƕ�����Ӧ����')
variance_time_response = sum(u.^2)/Td*dt
% variance_time_response = rms(u)^2

%% Ƶ��Ƕ�����Ӧ����
[lamda, Phi, r] = complex_modes(m,c,k,1);
S = S/(2*pi); % ���Ƿ�ֵ������PSD���Ե�Ƶ�ʵ�λΪrad/s
Omega = f_period*2*pi; % ԲƵ�ʣ���λΪrad/s
[Omega, Sx, Sigma_X, Sigma_XP] = stochastic_response_Sg(lamda, Phi, r, S, Omega);
Sx = Sx*2*pi; % ��S(omega)תδS(f)
disp('Ƶ��Ƕ�����Ӧ����')
variance_frequency_response = Sigma_X^2

%% ��ͼ
close all
blue=[96 157 202]/256;
orange=[255 160 65]/256;
green=[56 194 93]/256;
pink=[255 91 78]/256;
purple=[184 135 195]/256;
gray=[164 160 155]/256;
fontSize=15;

set(gcf,'position',[200,200,900,700])
subplot(2,2,1)
plot(t,fx,'-','linewidth',2,'color',blue)
set(xlabel('Time \itt \rm(s)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(ylabel('Acc. \ita \rm(m/s^2)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(gca,'Fontname', 'Times New Roman','FontSize',fontSize)

subplot(2,2,2)
plot(f_period,S,'-','linewidth',3,'color',pink)
set(xlabel('Frequency \itf \rm(Hz)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(ylabel('PSDF of Acc. \itS \rm(m^2/s^3)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(gca,'Fontname', 'Times New Roman','FontSize',fontSize)
xlim([0,20])

subplot(2,2,3)
plot(t,u,'-','linewidth',2,'color',green)
set(xlabel('Time \itt \rm(s)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(ylabel('Disp. response \itu \rm(m)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(gca,'Fontname', 'Times New Roman','FontSize',fontSize)

subplot(2,2,4)
plot(f_period,Sx,'-','linewidth',3,'color',pink)
set(xlabel('Frequency \itf \rm(Hz)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(ylabel('PSDF of Acc. \itS \rm(m^2/s^3)'),'Fontname', 'Times New Roman','FontSize',fontSize)
set(gca,'Fontname', 'Times New Roman','FontSize',fontSize)
xlim([0,20])