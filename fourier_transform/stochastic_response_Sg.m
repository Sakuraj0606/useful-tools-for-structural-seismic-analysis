function  [Omega, Sx, Sigma_X, Sigma_XP]=stochastic_response_Sg(lamda1, Phi1, r, Sg, Omega)

Omega=Omega';
N=length(lamda1)/2; % ���ɶȸ����������������ɶȣ�
n=length(Omega); % �������ܶȵĳ���

% Omega=Omega';

%% ��Z����
Z=ones(n,1)*r';
Z=Z'./(Omega*sqrt(-1)-lamda1);
Sg=Sg';
Y=Phi1*Z.*sqrt(Sg);

%% ������
X=Y(N+1:2*N,:); % ȡY���°벿�֣�λ�ƴ��ݺ�����
XP=Y(1:N,:); % ȡY���ϰ벿�֣��ٶȴ��ݺ�����
Sx=conj(X).*X; % λ������
Sxp=conj(XP).*XP; % �ٶ�����
Sx=1*Sx; % ���߹������ܶ�
Sxp=1*Sxp;

%% ��λ�ƺ��ٶ�
dOmega=Omega(2:n)-Omega(1:n-1);
Sum1=dOmega.*Sx(:,2:n);
Sigma_X=sqrt(sum(Sum1,2)); %sum(x,2)��ʾ��x�����ÿһ�зֱ���ͣ�������������
Sum2=dOmega.*Sxp(:,2:n);
Sigma_XP=sqrt(sum(Sum2,2));
