function  [Omega, Sx, Sigma_X, Sigma_XP]=stochastic_response(lamda1, Phi1, r)

omg1=0.001*2.0*pi; % ������ʼ��ֵ
omg2=30.0*2.0*pi; % ������ֹ��ֵ
n=6000; % ���ֵ����
Omega = linspace(omg1, omg2, n+1);
N=length(lamda1)/2; % ���ɶȸ����������������ɶȣ�
Sg=0.05; % m^2/s^3

%% ��Z����
Z=ones(n+1,1)*r';
Z=Z'./(Omega*sqrt(-1)-lamda1);

% ʹ��Kanai-Tajimi����ģ�ͣ�������˸�˹������ģ�ͣ�
omg_g=9*pi; % ����ͼ�������Ƶ�ʣ�rad/s
xi_g=0.6; % ����ͼ������������
Sg=Sg*(omg_g^4+4*xi_g^2*omg_g^2.*Omega.^2)./((omg_g^2-Omega.^2).^2+4*xi_g^2*omg_g^2.*Omega.^2);
Y=Phi1*Z.*sqrt(Sg);

%% ������
X=Y(N+1:2*N,:); % ȡY���°벿�֣�λ�ƴ��ݺ�����
XP=Y(1:N,:); % ȡY���ϰ벿�֣��ٶȴ��ݺ�����
Sx=conj(X).*X; % λ������
Sxp=conj(XP).*XP; % �ٶ�����
Sx=2*Sx; % ���߹������ܶ�
Sxp=2*Sxp;

%% ��λ�ƺ��ٶ�
dOmega=Omega(2:n+1)-Omega(1:n);
Sum1=dOmega.*Sx(:,2:n+1);
Sigma_X=sqrt(sum(Sum1,2)); %sum(x,2)��ʾ��x�����ÿһ�зֱ���ͣ�������������
Sum2=dOmega.*Sxp(:,2:n+1);
Sigma_XP=sqrt(sum(Sum2,2));

