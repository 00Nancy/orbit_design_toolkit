classdef usingMultiPos_contrast
    %�����ڹ۲���Ϊ��λ�ǡ����Ǻ;�����������ʼ������Ϊ���Ĺ���ϵ�º�������ά�������С�
    %   ��һ������άƫ����ʸ���Ͱ�ͨ��
    %   �ڶ������ݹ������������淨����
    %   ������������������
    
    properties
        a %�볤��
        e %ƫ����
        omega %���ĵ�Ǿ�
        Omega %�����㾭��
        i %������
        tao %�����ĵ�ʱ��
        f0 %��������Ԫ��������
        E0 %��������Ԫ��ƫ�����
        M0 %��������Ԫ��ƽ�����
        p %��ͨ��
    end
    
    methods
        function obj = usingMultiPos_contrast(spacecraftpos,UTC)
            %���캯��
            import constants.AstroConstants
            %����άƫ����ʸ���Ͱ�ͨ��
            A = [spacecraftpos,-ones(length(spacecraftpos(:,1)),1)];
            b = -vecnorm(spacecraftpos')';
            tmp = lsqminnorm(A,b,'warn');
            e = tmp(1:3);
            obj.e = norm(e);
            obj.p = tmp(4);
            %���ݹ������������淨����
            A = spacecraftpos(:,1)-e(1)/e(2)*spacecraftpos(:,2);
            b = e(3)/e(2)*spacecraftpos(:,2)-spacecraftpos(:,3);
            nx = lsqminnorm(A,b,'warn');
            n = [nx,-e(1)/e(2)*nx-e(3)/e(2),1];
            %������������
            obj.a = obj.p/(1-obj.e^2);
            obj.i = acos(1/norm(n));
            obj.Omega = atan(-n(1)/n(2));
            obj.omega = atan(e(3)/(e(2)*sin(obj.Omega)+e(1)*cos(obj.Omega))/sin(obj.i));
            u0 = atan2(spacecraftpos(1,3),(spacecraftpos(1,2)*sin(obj.Omega)+spacecraftpos(1,1)*cos(obj.Omega))*sin(obj.i));
            obj.f0 = u0 - obj.omega;
            if(obj.f0<0)
                obj.f0=2*pi+obj.f0;
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

