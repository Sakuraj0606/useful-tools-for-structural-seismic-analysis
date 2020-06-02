function [ ]=fourier_fft( )
%% ʹ��fft�����⼤�����и���Ҷ�任
wave=textread('.\GM1-TH.txt', '' ,'headerlines',1); % ��ȡ������Ϣ
time=wave(:,1);
acc=wave(:,2);
dt=time(2)-time(1); % �������

% Tg=2;
% dt=0.001; % �������
% time=0:dt:20; % �����Ĳ���ʱ��
% acc=ag(Tg,time); % �任ǰ�ļ���

n=length(acc); % ���������

df=1/time(end); % Ƶ�ʼ��
f=0:df:(n-1)*df'; % Ƶ������

%% FFT�任
y=fft(acc,n); % ������Ҷ�任
amp=abs(y); % ���������ʵ�����
amp=amp/(n/2); % ��ʵ���

%% ��任
sum=0;
for item=1:n
    sum=sum+y(item)*exp(i*2*pi*f(item)*time);
end

%% ��ͼ
close
subplot(2,1,1)
plot(f(1:n/2),amp(1:n/2))

subplot(2,1,2)
plot(time,acc)
hold on
plot(time,sum/n)

function [y]=ag(Tg,x)
%% ���弤������
Rem=rem(x,Tg);
Logic1=abs(Rem)>=0 & abs(Rem)<=Tg/2; % �жϴ��ڵ������λ��
Logic2=~Logic1; % �ж�С�����λ��
y=Logic1*1+Logic2*(-1);
