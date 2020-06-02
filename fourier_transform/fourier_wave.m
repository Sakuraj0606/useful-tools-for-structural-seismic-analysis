function [ ]=fourier_wave()
%% ��������������𲨵Ĺ�����
clear
clc

%% ��ȡ����
wave=textread('.\����\RSN12_KERN.PEL_PEL090.AT2', '' ,'headerlines',4); % ��ȡ����

dt=0.005; % ����ʱ����(s)

wave=wave'; %��ת��
wave=wave(:); %��Ϊһ��
wave=wave'*9.8; % m/s^2

%% ����Ҷ�任
Omg=0:0.1:20; % Ƶ��Χ(Hz)
item=length(Omg)-1; % г��ϵ��������
for n=-item:item % ��г��ϵ��
    item=item+1;
    cn(item)=1/Tg*trapz(t_range,wave.*exp(-i*n*Omg*t_range));
end

