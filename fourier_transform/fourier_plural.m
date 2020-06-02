function []=fourier_plural()
%% ������������֤������ʽ�ĸ���Ҷ�任
% �������п����˽ṹ���ᣨ����ʵ����ʽ�ĸ���Ҷ�任Ҳ���Կ��ǣ���ʵ����ʽ�޷��������⼤����
clear
clc

%% �ṹ��Ϣ
m=2000; %ԭ�ṹ������kg
omega=2*pi/1.5; %ԭ�ṹƵ�ʣ�rad/s
k=m*omega^2; %ԭ�ṹ�նȣ�N/m
ksi=0.03; %ԭ�ṹ�����
c=2*ksi*omega;
Tg=4; % ���ڼ���������ega*m; %ԭ�ṹ����ϵ����N��s/m

%% ������Ϣ
Omg=2*pi/Tg; % ���ڼ�����Ƶ��
dt=0.01; % �������
t=0:dt:50; % �����Ĳ���ʱ��
y=ag(Tg,t); % ���ٶ�����
F=-m*ag(Tg,t); % ��������
item=5; % ����Ҷ�任������

t_range=0:0.01:Tg; % ��г��ϵ��ʱ�Ļ�������

item_cn=0; % г��ϵ��������
for n=-item:item % ��г��ϵ��
    item_cn=item_cn+1;
    cn(item_cn)=1/Tg*trapz(t_range,-m*ag(Tg,t_range).*exp(-i*n*Omg*t_range)); % ǰ��-m�ǽ����ٶ�ת��Ϊ��
end

%% �任��ĺ��غ���Ӧ
item_cn=0;
P=0;
U=0;
u_free=0;
omegad=omega*sqrt(1-ksi^2);
rn=(-item:item)*Omg/omega;
H=1./(1-rn.^2+2*ksi*rn*i)/k;
B=(-c-sqrt(c^2+4*m*k))/2/m;

for n=-item:item
    item_cn=item_cn+1;
    P=P+cn(item_cn)*exp(i*n*Omg*t); % �任��ĺ���
    U=U+cn(item_cn)*H(item_cn)*exp(i*n*Omg*t); % �任�����Ӧ
end


%% �任ǰ����Ӧ
[u1,~,ddu] = Newmark_belta(y,dt,length(y),m,c,k,1); % �Լ��ĳ���
[u2,~,~] = SDOF_time_history_Newmark(m,c,k,y,dt); % ����ʦ�ĳ���

%% ��ͼ��֤
close all
figure('position',[100 100 700 400])
subplot(3,1,1)
plot(t,F,'linewidth',2)
hold on
plot(t,P,'linewidth',2)
legend('�任ǰ�ĵ������','�任��ĵ������')

subplot(3,1,2)
plot(t,u1,'linewidth',2)
hold on
plot(t,U,':','linewidth',2)
legend('�任ǰ����Ӧ��ʱ�̷�����','�任�����Ӧ��δ���������񶯣�')

subplot(3,1,3)
plot(t,U-u1,'linewidth',2)
legend('������')

function [y]=ag(Tg,x)
%% ���弤������
Rem=rem(x,Tg);
Logic1=abs(Rem)>=0 & abs(Rem)<=Tg/2; % �жϴ��ڵ������λ��
Logic2=~Logic1; % �ж�С�����λ��
y=Logic1*1+Logic2*(-1);