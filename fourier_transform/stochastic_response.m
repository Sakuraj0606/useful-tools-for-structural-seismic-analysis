function  [Omega, Sx, Sigma_X, Sigma_XP]=stochastic_response(lamda1, Phi1, r)

omg1=0.001*2.0*pi; % 积分起始数值
omg2=30.0*2.0*pi; % 积分终止数值
n=6000; % 积分点个数
Omega = linspace(omg1, omg2, n+1);
N=length(lamda1)/2; % 自由度个数（包含惯容自由度）
Sg=0.05; % m^2/s^3

%% 求Z向量
Z=ones(n+1,1)*r';
Z=Z'./(Omega*sqrt(-1)-lamda1);

% 使用Kanai-Tajimi过滤模型（金井清过滤高斯白噪声模型）
omg_g=9*pi; % 覆盖图层的特征频率，rad/s
xi_g=0.6; % 覆盖图层的特征阻尼比
Sg=Sg*(omg_g^4+4*xi_g^2*omg_g^2.*Omega.^2)./((omg_g^2-Omega.^2).^2+4*xi_g^2*omg_g^2.*Omega.^2);
Y=Phi1*Z.*sqrt(Sg);

%% 求自谱
X=Y(N+1:2*N,:); % 取Y的下半部分（位移传递函数）
XP=Y(1:N,:); % 取Y的上半部分（速度传递函数）
Sx=conj(X).*X; % 位移自谱
Sxp=conj(XP).*XP; % 速度自谱
Sx=2*Sx; % 单边功率谱密度
Sxp=2*Sxp;

%% 求位移和速度
dOmega=Omega(2:n+1)-Omega(1:n);
Sum1=dOmega.*Sx(:,2:n+1);
Sigma_X=sqrt(sum(Sum1,2)); %sum(x,2)表示对x矩阵的每一行分别求和，并存入列向量
Sum2=dOmega.*Sxp(:,2:n+1);
Sigma_XP=sqrt(sum(Sum2,2));

