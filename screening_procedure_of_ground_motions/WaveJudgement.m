function []=WaveJudgement()
%% �����������б��������Ƿ���Ͽ���Ҫ��

% ���ߣ���Ӣ�� ����
% ʱ�䣺2018/12/06
% ���ݣ���GB 50011-2010����������ƹ淶��(2016���)
%      ���Ǻ�ŵ���ظ߲���-����ǽ�Ƶ���ƣ���������ѧ���Ʊ�ҵ��ƣ���-��Ӣ��
% ˵��������Ե��𲨵�Ҫ�����5�����棺��1�����ڵ�����2���ײ���������3����ʱ��
%     ��4����������5����ֵ����������б�1�����ڵ����ͣ�3����ʱҪ��

clear
clc
close all

%% �ṹ��Ϣ
T=[5.6 5.2 4.1]; % ��������(s)
% T=[0.746 0.734 0.553]; % ��������(s)
ksi=0.05; % �����

%% ������Ϣ
switch 2
    case 1 % ���ݳ�����Ϣ���м���
        group=1; % ���ط��飺 1,2,3
        category=4; % ������� 10,11,2,3,4
        impact='����'; % ����Ҷȣ� '����','����'
        intensity=7; % ����Ҷȣ�6,7,7.5,8,8.5,9
        Tg=site(group,category); % ��������(s)
        alpha_max=situation(impact,intensity); % Ӱ��ϵ����ֵ(g)
    case 2 % ֱ�Ӹ�ֵ
        Tg=0.45;
        alpha_max=2.25; % ƽ̨�Ŵ�ϵ��
end

%% ������Ϣ
data_wave=textread('.\EQSignal-AW2-Acc.txt', '' , 'headerlines',0); % ��ȡ��������
data_spectra=textread('.\EQSignal-AW2-Acc-SP.txt', '' , 'headerlines',1); % ��ȡ���𲨷�Ӧ��

% time=data_wave(:,1);
dt=0.02;
time=(1:length(data_wave))*dt; % ʱ������

acc=data_wave(:,1); % ���ٶ�����
period=data_spectra(:,1); % ����
alpha=data_spectra(:,2); % Ӱ��ϵ��

%% ���ڵ����Ҫ��
T_range=0:0.1:6; % ��������
alphas_range=arrayfun(@(Ts)StandardSpectrum(Ts,ksi,alpha_max,Tg),T_range); % ��׼��Ӧ��

alphas_standard=arrayfun(@(Ts)StandardSpectrum(Ts,ksi,alpha_max,Tg),T) % �������ڶ�Ӧ�ı�׼����Ӱ��ϵ��
alphas_calculate=arrayfun(@(Ts)CalculateAlpha(Ts,period,alpha),T) % �������ڶ�Ӧ�ĵ�������Ӱ��ϵ��

err=(alphas_calculate-alphas_standard)./alphas_standard
if sum(abs(err)<=repmat(0.20,[1,3]))==3
    disp('�����㡿���ڵ����Ҫ��')
else
    disp('�������㡿���ڵ����Ҫ��')
end

%% ��ʱҪ��
item1=find(abs(acc)>0.1*max(abs(acc)),1,'first'); % �״δﵽPGA��10%
item2=find(abs(acc)>0.1*max(abs(acc)),1,'last'); % ���һ�δﵽPGA��10%
tc=time(item2)-time(item1);
if tc>=max(15,5*max(T))
    disp('�����㡿��ʱҪ��')
else
    disp('�������㡿��ʱҪ��')
end

%% ��ͼ
blue=[96 157 202]/256;
orange=[255 160 65]/256;
green=[56 194 93]/256;
pink=[255 91 78]/256;
purple=[184 135 195]/256;
gray=[164 160 155]/256;
fontsize=20;

figure('position',[100 100 1000 600])
subplot(2,1,1)
plot(T_range,alphas_range,'linewidth',3)
hold on
plot(period,alpha,'linewidth',3)
limit1=max(max(alphas_range),max(alpha));
plot([T(1),T(1)],[0,limit1*1.2],'linewidth',3)
plot([T(2),T(2)],[0,limit1*1.2],'linewidth',3)
plot([T(3),T(3)],[0,limit1*1.2],'linewidth',3)
set(legend('\alpha standard','\alpha calculate','\itT\rm1','\itT\rm2','\itT\rm3'),...
    'Fontname', 'Times New Roman','FontSize',fontsize,'EdgeColor',gray,'linewidth',1.5)
set(gca,'linewidth',2,'Fontname','Times New Roman','FontSize',fontsize)
set(title('Acceleration response spectrum'),'Fontname', 'Times New Roman','FontSize',fontsize)
set(xlabel('Period (s)'),'Fontname', 'Times New Roman','FontSize',fontsize)
set(ylabel('\alpha (g)'),'Fontname', 'Times New Roman','FontSize',fontsize)

subplot(2,1,2)
plot(time,acc,'linewidth',1.5)
hold on
limit2=max(abs(acc))*1.1;
plot([time(item1),time(item1)],[-limit2,limit2],'linewidth',3,'color',pink)
plot([time(item2),time(item2)],[-limit2,limit2],'linewidth',3,'color',pink)
plot([0,max(time)],[0.1*max(abs(acc)),0.1*max(abs(acc))],'linewidth',3,'color',pink)
plot([0,max(time)],[-0.1*max(abs(acc)),-0.1*max(abs(acc))],'linewidth',3,'color',pink)
set(gca,'linewidth',2,'Fontname','Times New Roman','FontSize',fontsize)
set(title('Acceleration history'),'Fontname', 'Times New Roman','FontSize',fontsize)
set(xlabel('Time (s)'),'Fontname', 'Times New Roman','FontSize',fontsize)
set(ylabel('Acc. (g)'),'Fontname', 'Times New Roman','FontSize',fontsize)

function alphas=CalculateAlpha(Ts,period,alpha)
alpha1=alpha(find(period>Ts,1,'first')); % �״δ���Tsʱ��alphaֵ
alpha2=alpha(find(period>Ts,1,'first')-1); % �״�С��Tsʱ��alphaֵ
alphas=(alpha1+alpha2)/2; % ȡƽ��ֵ

function alphas=StandardSpectrum(Ts,ksi,alpha_max,Tg)
% �����׼��Ӧ��
gamma=0.9+(0.05-ksi)/(0.3+6*ksi); % �����½��ε�˥��ָ��
yta1=0.02+(0.05-ksi)/(4+32*ksi); % ֱ���½��ε��½�б�ʵ���ϵ��
yta2=1+(0.05-ksi)/(0.08+1.6*ksi); % �������ϵ��
if yta1<0
    yta1=0;
end
if yta2<0.55
    yta2=0.55;
end
if Ts<=0.1
    alphas=alpha_max*(0.45*(0.1-Ts)/0.1+yta2*Ts/0.1);
elseif Ts<=Tg
    alphas=yta2*alpha_max;
elseif Ts<=5*Tg
    alphas=(Tg/Ts)^gamma*yta2*alpha_max;
else
    alphas=(yta2*0.2^gamma-yta1*(Ts-5*Tg))*alpha_max;
end
    
function Tg=site(group,category)
% ȷ��������������
switch category
    case 10
        category=1;
    case 11
        category=2;
    case 2
        category=3;
    case 3
        category=4;
    case 4
        category=5;
end
data_site=...
    [0.20 0.25 0.35 0.45 0.65;
    0.25 0.30 0.40 0.55 0.75;
    0.30 0.35 0.45 0.65 0.90];
Tg=data_site(group,category);

function alpha_max=situation(impact,intensity)
% ȷ��Ӱ��ϵ����ֵ
switch impact
    case '����'
        impact=1;
    case '����'
        impact=2;
end
switch intensity
    case 6
        intensity=1;
    case 7
        intensity=2;
    case 7.5
        intensity=3;
    case 8
        intensity=4;
    case 8.5
        intensity=5;
    case 9
        intensity=6;
end
data_alpha=...
    [0.04 0.08 0.12 0.16 0.24 0.32;
    0.28 0.50 0.72 0.90 1.20 1.40];
alpha_max=data_alpha(impact,intensity);