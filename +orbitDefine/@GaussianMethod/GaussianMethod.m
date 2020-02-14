classdef GaussianMethod
    %ʹ�ø�˹����ȷ�����
    
    properties
        a %�볤��
        e %ƫ����
        Omega %�����㾭��
        omega %���ĵ�Ǿ�
        i %������
        tao %�����ĵ�ʱ��
        f0 %��ʼ������
        E0 %��ʼƫ�����
        M0 %��ʼƽ�����
        spacecraftPos %�м�ʱ�̺�����λ������
    end
    
    methods
        %��˹������м�ʱ������λ�á��ٶ�
        function obj = GaussianMethod(R, rh0, s, UTC, eps_kai)
        %%
            DU=6378136.6;                   %��һ����λ���ȣ�������ƽ������          
            TU=806.811048;                  %��һ����λʱ�� 
            R = R/DU;
            s = s/TU;
            tau1=s(1)-s(2);tau3=s(3)-s(2);tau=s(3)-s(1);
            D=rh0\R;%��6-2-32��
            A=(D(2,1)*tau3-D(2,2)*tau-tau1*D(2,3))/tau;%��6-2-36��
            B=(D(2,1)*tau3*(tau^2-tau3^2)-D(2,3)*tau1*(tau^2-tau1^2))/6/tau;
            a=-(A^2+2*A*dot(R(:,2),rh0(:,2))+norm(R(:,2))^2);%��6-2-38��
            b=-2*1*B*(A+dot(R(:,2),rh0(:,2)));
            c=-1^2*B^2;
            %%
            p=[1 0 a 0 0 b 0 0 c];%��6-2-37��
            r=roots(p);
            r2=0;
            for j=1:8
                if imag(r(j))==0
                    if real(r(j))>0
                        r2=[r2 r(j)];
                    end
                end
            end
            r2=r2(2:end);%������ʵ����
            %%
            u2=r2^-3;
            c1=tau3/tau*(1+1/6*u2*(tau^2-tau3^2));%��6-2-28��
            c3=-tau1/tau*(1+1/6*u2*(tau^2-tau1^2));%��6-2-29��
            F1=1-0.5*u2*tau1^2; %��6-2-26��
            F3=1-0.5*u2*tau3^2; 
            G1=tau1-u2/6*tau1^3; 
            G3=tau3-u2/6*tau3^3;
            %%
            k=1;               %��������
            while 1            %����c1��c3�����¼���
              rh1=-D(1,1)+D(1,2)/c1-c3/c1*D(1,3);%��6-2-33��
              rh2=c1*D(2,1)-D(2,2)+c3*D(2,3);
              rh3=-c1/c3*D(3,1)+D(3,2)/c3-D(3,3);
            %%
              r_1=rh1*rh0(:,1)+R(:,1);%��6-2-4��������λ������ڹ���ϵ
              r_2=rh2*rh0(:,2)+R(:,2);
              r_3=rh3*rh0(:,3)+R(:,3);
              v_2=(F1*r_3-F3*r_1)/(F1*G3-F3*G1);%��6-2-44���������ٶ�����ڹ���ϵ
            %%
            %��������ֵ����ĵ����㷨�Ľ�c1��c3��P171��
              sigma2=dot(r_2,v_2); 
              alfha=2/r2-norm(v_2)^2;  

              kai1=0; kai3=0;
              while 1                     %���ݿ����շ��̣�4-3-27������������ʱ���kai1
                  U=universalVariables.fcn_U(kai1,alfha);
                  U0_1=U(1); U1_1=U(2); U2_1=U(3);
                  sigma1=sigma2*U0_1+(1-alfha*r2)*U1_1;
                  kai1_new=alfha*tau1+(sigma1-sigma2);
                  if abs(kai1-kai1_new)<eps_kai
                      break
                  end
                  kai1=kai1_new;
              end
              while 1                      %���ʱ���kai1
                  U=universalVariables.fcn_U(kai3,alfha);
                  U0_3=U(1); U1_3=U(2); U2_3=U(3);
                  sigma3=sigma2*U0_3+(1-alfha*r2)*U1_3;
                  kai3_new=alfha*tau3+(sigma3-sigma2);
                  if abs(kai3-kai3_new)<eps_kai
                      break
                  end
                  kai3=kai3_new;
              end
              F1_new=1-U2_1/r2; G1_new=(r2*U1_1+sigma2*U2_1);%����F1 G1 F3 G3
              F3_new=1-U2_3/r2; G3_new=(r2*U1_3+sigma2*U2_3);

              omega_n=0.7;     %Ȩϵ������F1 G1 F3 G3,ʹ������������
              F1=omega_n*F1+(1-omega_n)*F1_new;
              G1=omega_n*G1+(1-omega_n)*G1_new;
              F3=omega_n*F3+(1-omega_n)*F3_new;
              G3=omega_n*G3+(1-omega_n)*G3_new;
              c1=G3/(F1*G3-F3*G1);%(6-2-25)����c1 c3
              c3=-G1/(F1*G3-F3*G1);
              rh2_new=c1*D(2,1)-D(2,2)+c3*D(2,3);
              if abs(rh2_new-rh2)*DU<1e-4     %��������Ϊrho2���С��1��
                  obj.spacecraftPos = [r_1,r_2,r_3]*DU;
                  break
              end
              k=k+1;
            end
            orbit = orbitDefine.usingSinglePosVel(r_2*DU,v_2*DU/TU,UTC(2));
            obj.a = orbit.a;
            obj.e = orbit.e;
            obj.Omega = orbit.Omega;
            obj.omega = orbit.omega;
            obj.i = orbit.i;
            obj.tao = orbit.tao;
            obj.f0 = orbit.f0;
            obj.E0 = orbit.E0;
            obj.M0 = orbit.M0;
        end
    end
end

