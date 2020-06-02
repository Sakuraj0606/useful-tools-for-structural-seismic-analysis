%�����ɶ����ṹʱ�̷���
function [d,v,a] = SDOF_time_history_Newmark(m,c,k,acc,dt)

    long=length(acc);         %���ڼ���������𲨵ĳ���
    time=0:dt:(long-1)*dt;
    
    %����TVMD��������������ͬ�����ɶȶ�1��
    F=-m*acc;
    
    %�����ʼλ�ƣ��ٶȺͼ��ٶ�
    y(:,1)=zeros(1,1);      %��ʼλ��
   dy(:,1)=zeros(1,1);      %��ʼ�ٶ�
  ddy(:,1)=zeros(1,1);      %��ʼ���ٶ�
 
  beta=1/4;
 for n=2:long;
    
    %��������˶����ٶ�����
	zacc=acc(n)-acc(n-1);
    
    dF_=-m.*zacc+m*(1./beta.*dy(:,n-1)./dt+1/2./beta.*ddy(:,n-1))+1/2./beta*c*dy(:,n-1);
    dk_=k+2.*c./dt+4.*m./(dt.^2);
    
     %������Ӧλ������
    zy(:,n)=dk_\dF_;        
    %������Ӧλ��
    y(:,n)=y(:,n-1)+zy(:,n); 
    
    %������Ӧ�ٶ�����
    zdy(:,n)=1/2./beta.*zy(:,n)./dt-1/2./beta.*dy(:,n-1);
    %������Ӧ�ٶ�
    dy(:,n)=dy(:,n-1)+zdy(:,n);
 
    %���ٶ���Ӧ
    Fs(:,n)=k*y(:,n);
    ddy(:,n)=m\(F(:,n)-c*dy(:,n)-Fs(:,n));
    
	
 end
a=ddy;            %��Լ��ٶ�
v=dy;             %����ٶ�
d=y;              %���λ��
