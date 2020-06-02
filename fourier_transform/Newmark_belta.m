function [u,du,ddu] = Newmark_belta(wave,dt,n,M,C,K,E)
N=length(M); % ���ɶ�����
% ��λ�ơ��ٶȡ����ٶȺ͵�����ٶ��������󸳳�ֵ0
u(:,1)=zeros(N,1); 
du(:,1)=zeros(N,1);
ddu(:,1)=-ones(N,1)*wave(1);
delta_ddy(:,1)=zeros(N,1);
for i=1:(n-1)
    % �����˶����ٶ�����
    delta_ddy(:,1)=wave(i+1)-wave(i);
    % ��Ч�ն�
    Ke=K+2*C/dt+4*M/dt^2;
    % ��������
    delta_P=M*(-E.*delta_ddy+4*du(:,i)/dt+2*ddu(:,i))+2*C*du(:,i);      
    %λ������
    delta_u=Ke^(-1)*delta_P;
    %�ٶ�����
    delta_du=2*delta_u/dt-2*du(:,i);
    %���ٶ�����
    delta_ddu=4*delta_u/dt^2-4*du(:,i)/dt-2*ddu(:,i);
    %������������������ֵ
    u(:,i+1)=u(:,i)+delta_u;
    du(:,i+1)=du(:,i)+delta_du;
    ddu(:,i+1)=ddu(:,i)+delta_ddu;
end