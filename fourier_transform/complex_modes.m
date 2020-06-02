function [lamda, Phi, r]=complex_modes(M,C,K,E)

[~,N]= size(M); % ���ɶ���
A=[zeros(N,N),M;M,C];
B=[-M,zeros(N,N);zeros(N,N),K];

F=[zeros(N,1);-M*E];
[Phi,lamda]=eig(-B, A);
% [Phi�ϰ벿�ֳ��Թ�lamda�����Թ�����ʽ���֣�Ӧ����˳��

lamda=diag(lamda);

% ��һ��
Sum=conj(Phi).*Phi;
Phi=Phi./sqrt(sum(Sum,1));
% python�����е�eig���������Ǿ�����һ������ģ�����matlab��Ӧ��ÿһ���ϵ�
% Ԫ�ؾ����Ը�������Ԫ�ص�ģ���ĺ͵�ƽ����������ʵ��Ϊ�������������ڸ������ԣ�
% ģ�����ڸ�����������乲�����

A1=Phi.'*A*Phi; % �˴���������ķǹ���ת��Ӧ�á�.'����ʾ��
% ��'��Ϊ���ת�ã�����
AD=diag(A1); %�������
r=Phi.'*F./AD; %��Ч�ͺ�������