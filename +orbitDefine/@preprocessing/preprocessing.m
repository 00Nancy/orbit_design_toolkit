
classdef Preprocessing 
    %�۲�����Ԥ����
    
    properties
        Glatitude %����γ�ȣ�������deg
        s %���������ʱ�����飬��
        altitude %���غ��Σ�������m
        azimuth %��λ�ǣ����飬deg
        elevation %���ǣ��ߵͽǣ������飬deg
        distance %���������վ�ľ��룬���飬m
        Dazimuth %��λ�Ǳ仯�ʣ����飬rad/s
        Delevation %���Ǳ仯�ʣ����飬rad/s
        Ddistance %���������վ�ľ���仯�ʣ����飬m/s
        stationPos %��վλ�ã��ڵ��Ĺ���ϵ�£������飬m
        spacecraftDir %�������������ң���վ��ƽ����ϵ�£�������
        spacecraftPos %������λ�ã��ڵ��Ĺ���ϵ�£������飬m
        spacecraftVel %�������ٶȣ��ڵ��Ĺ���ϵ�£������飬m/s
    end
    
    methods
        function obj = Preprocessing (B,s,H,A,E,D,Adot, Edot,Ddot)
            %���캯��
            %�ѽǶȶ�תΪ����
            %�����Ĵ�����Ϊ�˽������������ά���ĺ�����
            for i=1:length(A)
                obj.Glatitude = B/180*pi;
                obj.s = s(i)/180*pi; 
                obj.altitude = H;
                obj.azimuth = A(i)/180*pi; 
                obj.elevation = E(i)/180*pi; 
                obj.distance = D(i);
                obj.Dazimuth = Adot(i);
                obj.Delevation = Edot(i);
                obj.Ddistance = Ddot(i);
                obj.stationPos(:,i) = obj.stationpos();
                obj.spacecraftDir(:,i) = obj.spacecraftdir();
                C = coordinateTransformation.station2inertial(obj.s,obj.Glatitude);
                obj.spacecraftPos(:,i) = obj.spacecraftpos(C,i);
                obj.spacecraftVel(:,i) = obj.spacecraftvel(C,i);   
            end         
            obj.Glatitude = obj.Glatitude*180/pi;
            obj.s = s; 
            obj.azimuth = A; 
            obj.elevation = E; 
            obj.distance = D;
            obj.Dazimuth = Adot;
            obj.Delevation = Edot;
            obj.Ddistance = Ddot;
            obj.stationPos = obj.stationPos';
            obj.spacecraftDir = obj.spacecraftDir';
            obj.spacecraftPos = obj.spacecraftPos';
            obj.spacecraftVel = obj.spacecraftVel';
        end
        
        function stationpos = stationpos(obj)
            import constants.AstroConstants
            xe = (AstroConstants.ae/sqrt(1-AstroConstants.ee^2*sin(obj.Glatitude)^2)+obj.altitude)*cos(obj.Glatitude);
            ze = (AstroConstants.ae*(1-AstroConstants.ee^2)/sqrt(1-AstroConstants.ee^2*sin(obj.Glatitude)^2)+obj.altitude)*sin(obj.Glatitude);
            stationpos = [xe*cos(obj.s),xe*sin(obj.s),ze]';
        end

        function spacecraftdir = spacecraftdir(obj)
            spacecraftdir = [cos(obj.elevation)*sin(obj.azimuth);cos(obj.elevation)*cos(obj.azimuth);sin(obj.elevation)];
        end
        
        function spacecraftpos = spacecraftpos(obj,C,i) 
            rou = obj.distance*obj.spacecraftDir(:,i);
            spacecraftpos = obj.stationPos(:,i) + C*rou;
        end

        function spacecraftvel = spacecraftvel(obj,C,i)
            import constants.AstroConstants
            spacecraftvel = C*[obj.Ddistance*cos(obj.elevation)*sin(obj.azimuth)-obj.distance*obj.Delevation*sin(obj.elevation)*sin(obj.azimuth)+obj.distance*obj.Dazimuth*cos(obj.elevation)*cos(obj.azimuth),obj.Ddistance*cos(obj.elevation)*cos(obj.azimuth)-obj.distance*obj.Delevation*sin(obj.elevation)*cos(obj.azimuth)-obj.distance*obj.Dazimuth*cos(obj.elevation)*sin(obj.azimuth),obj.Ddistance*sin(obj.elevation)+obj.distance*obj.Delevation*cos(obj.elevation)]'+cross([0,0,AstroConstants.we]',obj.spacecraftPos(:,i));
        end
    end
end

