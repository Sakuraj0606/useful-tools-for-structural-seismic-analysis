function [ ]=test()
clear
clc

%% ������������֤����Ҷ�任
m=2000; %ԭ�ṹ������kg
omega=2*pi/1.5; %ԭ�ṹƵ�ʣ�rad/s
k=m*omega^2; %ԭ�ṹ�նȣ�N/m
Tg=4; % ���ڼ���������
1/k
Omg=2*pi/Tg; % ���ڼ�����Ƶ��
dt=0.01; % �������
t=0:dt:20; % �����Ĳ���ʱ��
y=ag(Tg,t);
item=1; % ����Ҷ�任������

t_range=0:0.01:Tg; % ��г��ϵ��ʱ�Ļ�������
p0=1/Tg*trapz(t_range,ag(Tg,t_range));
for i=1:item % ��г��ϵ��
    pc(i)=2/Tg*trapz(t_range,ag(Tg,t_range).*cos(i*Omg*t_range));
    ps(i)=2/Tg*trapz(t_range,ag(Tg,t_range).*sin(i*Omg*t_range));
end
digits(4) % ���ȿ���
rn=(1:item)*Omg/sqrt(k/m);

%% ��任��ļ�������Ӧ
P=p0; % ����
U=p0/k; % ��Ӧ
% for i=1:item
%     P=P+pc(i)*cos(i*Omg*t)+ps(i)*sin(i*Omg*t);
%     U=U+(pc(i)*cos(i*Omg*t)+ps(i)*sin(i*Omg*t))/k/(1-rn(i)^2);
% end
% U1=1/k/(1-Omg^2/omega^2)*(sin(Omg*t)-Omg/omega*sin(omega*t));
% U2=1/k/(1-Omg^2/omega^2)*(cos(Omg*t)-cos(omega*t));
U3=1/k*(1-cos(omega*t));

%% ��任ǰ����Ӧ
[u,du,ddu] = Newmark_belta(y,dt,length(y),m,0,k,1);

%% ��ͼ��֤
close all
figure('position',[100 100 700 400])
subplot(4,1,1)
plot(y)
hold on
plot(P)
ylim([-2,2])
legend('�任ǰ','�任��')

subplot(4,1,2)
% plot(u)
% hold on
plot(U*m)
% legend('�任ǰ','�任��')


subplot(4,1,3)
plot(U3*m)

subplot(4,1,4)
plot(-u)

function [y]=ag(Tg,x)
%% ���弤������
% y=cos(2*pi/Tg*x);
y=ones(1,length(x));