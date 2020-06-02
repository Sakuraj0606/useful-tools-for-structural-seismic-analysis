function [ ]=fourier_real_number( )
%% ������������֤ʵ����ʽ�ĸ���Ҷ�任
clear
clc

%% �ṹ��Ϣ
m=2000; %ԭ�ṹ������kg
omega=2*pi/1.5; %ԭ�ṹƵ�ʣ�rad/s
k=m*omega^2; %ԭ�ṹ�նȣ�N/m
Tg=4; % ���ڼ���������

%% ������Ϣ
Omg=2*pi/Tg; % ���ڼ�����Ƶ��
dt=0.01; % �������
t=0:dt:50; % �����Ĳ���ʱ��
y=ag(Tg,t); % ���ٶ�����
F=-m*ag(Tg,t); % ��������
item=20; % ����Ҷ�任������

%% ��г��ϵ��
t_range=0:0.01:Tg; % ��г��ϵ��ʱ�Ļ�������
p0=1/Tg*trapz(t_range,-m*ag(Tg,t_range));
for i=1:item 
    pc(i)=2/Tg*trapz(t_range,-m*ag(Tg,t_range).*cos(i*Omg*t_range));
    ps(i)=2/Tg*trapz(t_range,-m*ag(Tg,t_range).*sin(i*Omg*t_range));
end
digits(4) % ���ȿ���
rn=(1:item)*Omg/sqrt(k/m);

%% ��任��ļ�������Ӧ
P=p0; % ����
U=p0/k; % ��Ӧ
U_free=p0/k*(1-cos(omega*t));
for i=1:item
    P=P+pc(i)*cos(i*Omg*t)+ps(i)*sin(i*Omg*t);
    U=U+1/k/(1-rn(i)^2)*(pc(i)*cos(i*Omg*t)+ps(i)*sin(i*Omg*t));
    U_free=U_free+1/k/(1-rn(i)^2)*(pc(i)*cos(i*Omg*t)+ps(i)*sin(i*Omg*t)+...
        pc(i)*cos(omega*t)-ps(i)*i*Omg/omega*sin(omega*t));
end

%% ��任ǰ����Ӧ
[u,du,ddu] = Newmark_belta(y,dt,length(y),m,0,k,1);

%% ��ͼ��֤
close all
figure('position',[100 100 700 400])
subplot(2,1,1)
plot(t,F,'linewidth',2)
hold on
plot(t,P,'linewidth',2)
legend('�任ǰ�ĵ������','�任��ĵ������')

subplot(2,1,2)
plot(t,u,'linewidth',2)
hold on
plot(t,U,'-.','linewidth',2)
plot(t,U_free,':','linewidth',2)
legend('�任ǰ����Ӧ��ʱ�̷�����','�任�����Ӧ��δ���������񶯣�','�任�����Ӧ�����������񶯣�')

function [y]=ag(Tg,x)
%% ���弤������
Rem=rem(x,Tg);
Logic1=abs(Rem)>=0 & abs(Rem)<=Tg/2; % �жϴ��ڵ������λ��
Logic2=~Logic1; % �ж�С�����λ��
y=Logic1*1+Logic2*(-1);

% y=sin(2*pi/Tg*x);

% y=2*ones(1,length(x));