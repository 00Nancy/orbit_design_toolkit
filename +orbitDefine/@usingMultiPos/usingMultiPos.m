classdef usingMultiPos
    %�����ڹ۲���Ϊ��λ�ǡ����Ǻ;�����������ʼ������Ϊ���Ĺ���ϵ�º�������ά�������С�
    %   ��һ����ȷ������棨�����㾭�Ⱥ͹������ǣ�
    %   �ڶ���ȷ��Բ׶���ߣ��볤�ᡢƫ���ʺͽ��ĵ�Ǿࣩ
    
    properties
        a %�볤��
        e %ƫ����
        Omega %�����㾭��
        omega %���ĵ�Ǿ�
        i %������
        tao %�����ĵ�ʱ��
        f0 %��������Ԫ��������
        E0 %��������Ԫ��ƫ�����
        M0 %��������Ԫ��ƽ�����
        p %��ͨ��
    end
    
    methods
        function obj = usingMultiPos(spacecraftpos,UTC)
            %���캯��
            import constants.AstroConstants
            %1.ȷ�������
            %������С���˷�������淨����
            %����ƽ�棺nx*x+ny*y+z=0,(nx,ny,1)Ϊ������
            A = [spacecraftpos(:,1),spacecraftpos(:,2)];
            b = -spacecraftpos(:,3);
            n_xy = lsqminnorm(A,b,'warn');
            n = [n_xy;1];
            obj.i = acos(1/norm(n));
            obj.Omega = atan(-n(1)/n(2));
            
            %2.ȷ��Բ׶���ߣ��볤�ᡢƫ���ʺͽ��ĵ�Ǿࣩ
            %�������ھ���ǰ������ת�������ϵ�µ�����
            transform = coordinateTransformation.inertial2orbit(obj.Omega,obj.i,0);
            Mi1= transform.Mi1;
            MOmega3 = transform.MOmega3;
            newpos = (Mi1*MOmega3*spacecraftpos')';
            newpos = newpos(:,1:2);
            %������С���˷���ƫ����ʸ���Ͱ�ͨ��
            A = [newpos,-ones(length(newpos(:,1)),1)];
            b = -vecnorm(newpos')';
            tmp = lsqminnorm(A,b,'warn');
            e2_ = tmp(1:2);
            obj.e = norm(e2_);
            obj.omega = atan2(e2_(2),e2_(1));
            obj.p = tmp(3);
            obj.a = obj.p/(1-obj.e^2);
            tmp = cross([e2_;0],[newpos(1,1:2),0]);
            if(sign(tmp(3))>0)
                obj.f0 = acos(dot(e2_,newpos(1,1:2))/norm(e2_)/norm(newpos(1,1:2)));
            else
                obj.f0 = 2*pi-acos(dot(e2_,newpos(1,1:2))/norm(e2_)/norm(newpos(1,1:2)));
            end
            obj.E0 = 2*atan(tan(obj.f0/2)*sqrt((1-obj.e)/(1+obj.e)));
            if(abs(obj.E0-obj.f0)>pi/2)
                if(abs(obj.E0+pi-obj.f0)>pi/2)
                    obj.E0 = obj.E0 + 2*pi;
                else
                    obj.E0 = obj.E0 + pi;
                end
            end
            obj.M0 = obj.E0-obj.e*sin(obj.E0);
            obj.tao = UTC(1)-obj.M0*sqrt(obj.a^3/AstroConstants.GM)/3600/24;

            %��λת��
            obj.i = obj.i*180/pi;
            obj.Omega = obj.Omega*180/pi;
            obj.omega = obj.omega*180/pi;
            obj.f0 = obj.f0*180/pi;
            obj.E0 = obj.E0*180/pi;
            obj.M0 = obj.M0*180/pi;
        end
       
    end
end

