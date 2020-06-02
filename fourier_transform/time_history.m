function []=time_history()
%% ��Newmark���Զ����ɶȹ��������ʱ�̷���
clear
clc
%% ����ṹ��Ϣ
m=2000; %ԭ�ṹ������kg
omega=2*pi/1.5; %ԭ�ṹƵ�ʣ�rad/s
k=m*omega^2; %ԭ�ṹ�նȣ�N/m
ksi=0.03; %ԭ�ṹ�����
c=2*ksi*omega*m; %ԭ�ṹ����ϵ����N��s/m

%% �������
% �޿ؽṹ
[M,C,K,E] = matrix_shear_building(m, c, k);
% ��ͳTVMD(SPIS-III��)
[M3,C3,K3,E3] = matrix_shear_building_with_SPISIII(m, c, k, 0.100, 0.029, 0.500);
% SPIS-I��SMA-TVMD
ke=10;
ce=50;
gap_k=ke;
gap_c=ce;
error=10^(-6);   
[MS1, CS1, KS1, ES1]=matrix_shear_building_with_SPISI(m, c, k, 0.500, 0.054, 0);
while rms(gap_k)>error & rms(gap_c)>error
	temp_k=ke;
    temp_c=ce;
    [ke,ce,Sigma_XS1,Sigma_XdS1,FsS1,SxS1,SxpS1,KeS1,CeS1]=...
        damper_MDOF_SPISI(MS1, CS1, KS1, ES1,ke,ce,0.100*k);
    gap_k=ke-temp_k;
    gap_c=ce-temp_c;
end
KS1=KS1+KeS1;
CS1=CS1+CeS1;

%% ��ȡ����
wave{1}=textread('F:\SMA-TVMD(SDOF)\����\RSN12_KERN.PEL_PEL090.AT2', '' ,'headerlines',4); %����������洢��Ԫ����
wave{2}=textread('F:\SMA-TVMD(SDOF)\����\RSN17_SCALIF_SLO234.AT2', '' , 'headerlines',4);
wave{3}=textread('F:\SMA-TVMD(SDOF)\����\RSN1599_DUZCE_ATS030.txt', '' , 'headerlines',4);
dt=0.005;
for i=1:3
    wave{i}=wave{i}'; %��ת��
    wave{i}=wave{i}(:); %��Ϊһ��
    wave{i}=wave{i}'/max(wave{i})*3; % ����300gal(300cm/s2)�ķ�ֵ
    n(i)=length(wave{i});
end

%% Newmark���λ��ʱ����Ӧ
for i=1:3
    [u{i},du{i},ddu{i}] = Newmark_belta(wave{i},dt,n(i),M,C,K,E);
    [u3{i},du3{i},ddu3{i}] = Newmark_belta(wave{i},dt,n(i),M3,C3,K3,E3);
    [uS1{i},duS1{i},dduS1{i}] = Newmark_belta(wave{i},dt,n(i),MS1,CS1,KS1,ES1);
    t{i}=linspace(0.005,n(i)*0.005,n(i));
    u_SMA{i}=uS1{i}(1,:)-uS1{i}(2,:); % SMA��λ�Ƶ��ڲ�λ�������λ��֮��
    du_SMA{i}=duS1{i}(1,:)-duS1{i}(2,:); % SMA���ٶȵ��ڲ���ٶ�������ٶ�֮��
    ud{i}=uS1{i}(1,:)-uS1{i}(2,:); % SMA��λ�Ƶ��ڲ�λ�������λ��֮��
end

%% ���SMA����λ������
xd1=0.005;
xd2=0.04; %����������λ��, m
alpha=0.0214; %������������Ϊ�����նȱ�
kd=0.010*k;
k1=kd;
k3=k1;
k2=alpha*kd;
k4=k2;
A=xd1;
B=xd2;
C=A+0.1;
D=B+0.1;
x1=0;
x2=0;
FF1=0;
FF2=0;
flag1=1;

k5=0;
ks(1)=k1;
for j=1:3
    F2{j}(1)=0;
    for i=1:(n(j)-1)
        [ks(i+1),F2{j}(i+1),flag1,x1,x2,FF1,FF2,k5]=...
            SMA_austenite_spring(u_SMA{j}(i),du_SMA{j}(i),F2{j}(i),flag1,x1,x2,FF1,FF2,k5,u_SMA{j}(i+1)-u_SMA{j}(i),k1,k2,k3,k4,A,B,C,D);
    end
    F1{j}=u3{j}(2,:)*0.500*k;
end


%% �󶥲�λ�ƾ�����
% RMS=rms(u{2}(1,:)) % �޿ؽṹ����λ�ƾ�����
% disp('�����')
% sigma1=rms(u1(1,:))/RMS % ��ͳTVMD����λ�ƾ�����
% sigma2=rms(u2(1,:))/RMS % SMA-TVMD����λ�ƾ�����
% sigma3=rms(u3(1,:))/RMS % ��ͳTVMD����λ�ƾ�����
% sigmaS1=rms(uS1(1,:))/RMS % SMA-TVMD����λ�ƾ�����
% sigmaS2=rms(uS2(1,:))/RMS % SMA-TVMD����λ�ƾ�����
%% ����
close all
green=[64/256,116/256,52/256];
blue=[7/256,151/256,237/256];
orange=[248/256,147/256,29/256];
red=[219/256,69/256,32/256];
brown=[107/256,90/256,92/256];
gray=[151/256,151/256,151/256];

% figure(1) % ��������
% plot(t{i},wave{i},'linewidth',1.5,'color',blue)
% set(title('Time history of the white noise'),'Fontname', 'Times New Roman','FontSize',15)
% set(xlabel('Time (s)'),'Fontname', 'Times New Roman','FontSize',15)
% set(ylabel('Amplitude (m/s^2)]'),'Fontname', 'Times New Roman','FontSize',15)
% set(gca,'Fontname', 'Times New Roman','FontSize',15)
% set(gcf,'position',[300,300,900,280])
% set(gca,'looseInset',[0 0 0 0]);

% figure('position',[300,300,1200,600]) % ��������
% for i=1:3
% subplot(3,1,i)
% plot(t{i},wave{i}(1,:),'linewidth',1.5,'color',blue)
% if i==1
% set(title('Time histories of the excitation'),'Fontname', 'Times New Roman','FontSize',15)
% set(legend('LA - Hollywood Stor FF'),'Fontname', 'Times New Roman','FontSize',15)
% end
% if i==2
% set(legend('San Luis Obispo'),'Fontname', 'Times New Roman','FontSize',15)
% end
% if i==3
% set(xlabel('Time (s)'),'Fontname', 'Times New Roman','FontSize',15)
% set(legend('Ambarli'),'Fontname', 'Times New Roman','FontSize',15)
% end
% set(ylabel('Accel. (m/s^2)'),'Fontname', 'Times New Roman','FontSize',15)
% set(gca,'Fontname', 'Times New Roman','FontSize',15)
% end
% saveas(gcf,'F:\SMA-TVMD(SDOF)\���Ĳ�ͼ\Excitation.jpg')

figure('position',[300,300,1200,600]) % λ��
for i=1:3
subplot(3,1,i)
plot(t{i},u{i}(1,:),'linewidth',2,'color',gray)
hold on
plot(t{i},u3{i}(1,:),'linewidth',2,'color',blue)
hold on
plot(t{i},uS1{i}(1,:),'linewidth',2,'color',orange)
if i==1
set(title('Time histories of the displacement'),'Fontname', 'Times New Roman','FontSize',15)
end
if i==3
set(xlabel('Time (s)'),'Fontname', 'Times New Roman','FontSize',15)
end
set(ylabel('Displacement (m)'),'Fontname', 'Times New Roman','FontSize',15)
set(legend('Original Structure','SPIS-III','SMA-I'),'Fontname', 'Times New Roman','FontSize',15)
set(gca,'Fontname', 'Times New Roman','FontSize',15)
end
% saveas(gcf,'F:\SMA-TVMD(SDOF)\���Ĳ�ͼ\Displacement.jpg')
% 
% figure('position',[300,300,1200,600]) % �ٶ�
% for i=1:3
% subplot(3,1,i)
% plot(t{i},du{i}(1,:),'linewidth',2,'color',gray)
% hold on
% plot(t{i},du3{i}(1,:),'linewidth',2,'color',blue)
% hold on
% plot(t{i},duS1{i}(1,:),'linewidth',2,'color',orange)
% if i==1
% set(title('Time histories of the velocity'),'Fontname', 'Times New Roman','FontSize',15)
% end
% if i==3
% set(xlabel('Time (s)'),'Fontname', 'Times New Roman','FontSize',15)
% end
% set(ylabel('Velocity (m/s)'),'Fontname', 'Times New Roman','FontSize',15)
% set(legend('Original Structure','SPIS-III','SMA-I'),'Fontname', 'Times New Roman','FontSize',15)
% set(gca,'Fontname', 'Times New Roman','FontSize',15)
% end
% saveas(gcf,'F:\SMA-TVMD(SDOF)\���Ĳ�ͼ\Veclocity.jpg')

% figure('position',[300,300,1200,600]) % ���ٶ�
% for i=1:3
% subplot(3,1,i)
% plot(t{i},ddu{i}(1,:),'linewidth',2,'color',gray)
% hold on
% plot(t{i},ddu3{i}(1,:),'linewidth',2,'color',blue)
% hold on
% plot(t{i},dduS1{i}(1,:),'linewidth',2,'color',orange)
% if i==1
% set(title('Time histories of the acceleration'),'Fontname', 'Times New Roman','FontSize',15)
% end
% if i==3
% set(xlabel('Time (s)'),'Fontname', 'Times New Roman','FontSize',15)
% end
% set(ylabel('Acceleration (m/s)'),'Fontname', 'Times New Roman','FontSize',15)
% set(legend('Original Structure','SPIS-III','SMA-I'),'Fontname', 'Times New Roman','FontSize',15)
% set(gca,'Fontname', 'Times New Roman','FontSize',15)
% end
% saveas(gcf,'F:\SMA-TVMD(SDOF)\���Ĳ�ͼ\Acceleration.jpg')

% figure('position',[0,300,1200,500]) % ��������
% for i=1:3
% subplot(1,3,i)
% plot(u_SMA{i}, F2{i},'linewidth',2,'color',red)
% % grid on
% if i==1
% set(legend('LA - Hollywood Stor FF'),'Fontname', 'Times New Roman','FontSize',15)
% end
% if i==2
% set(title('Force-displacement curve of the SMA spring'),'Fontname', 'Times New Roman','FontSize',15)
% set(legend('San Luis Obispo'),'Fontname', 'Times New Roman','FontSize',15)
% end
% if i==3
% set(legend('Ambarli'),'Fontname', 'Times New Roman','FontSize',15)
% end
% set(xlabel('Displacement (m)'),'Fontname', 'Times New Roman','FontSize',15)
% set(ylabel('Force (kN)'),'Fontname', 'Times New Roman','FontSize',15)
% set(gca,'Fontname', 'Times New Roman','FontSize',15)
% end
% saveas(gcf,'F:\SMA-TVMD(SDOF)\���Ĳ�ͼ\Force-displacement.jpg')

% figure(6) % ����λ��
% plot(t{i},u3{i}(2,:),'linewidth',2,'color',blue)
% hold on
% plot(t{i},uS1{i}(2,:),'linewidth',2,'color',orange)
% set(title('Time histories of the TVMD displacement'),'Fontname', 'Times New Roman','FontSize',15)
% set(xlabel('Time (s)'),'Fontname', 'Times New Roman','FontSize',15)
% set(ylabel('Displacement (m)'),'Fontname', 'Times New Roman','FontSize',15)
% set(legend('SPIS-III','SMA-I'),'Fontname', 'Times New Roman','FontSize',15)
% set(gca,'Fontname', 'Times New Roman','FontSize',15)
% set(gcf,'position',[300,300,1300,300])
% set(gca,'looseInset',[0 0 0 0])
