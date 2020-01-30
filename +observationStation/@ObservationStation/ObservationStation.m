
classdef ObservationStation
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Glatitude %����γ�ȣ�rad
        s %���������ʱ����
        altitude %���غ��Σ�m
        azimuth %��λ�ǣ�rad
        elevation %���ǣ��ߵͽǣ���rad
        distance %���������վ�ľ��룬m
        Dazimuth %��λ�Ǳ仯�ʣ�rad/s
        Delevation %���Ǳ仯�ʣ�rad/s
        Ddistance %���������վ�ľ���仯�ʣ�m/s
        stationPos %���Ĺ���ϵ�²�վλ�ã�m
        C %��վ����ϵ�����Ĺ���ϵ�ķ���������
        spacecraftPos %���Ĺ���ϵ�º�����λ�ã�m
        spacecraftVel %���Ĺ���ϵ�º������ٶȣ�m/s
    end
    
    methods
        function obj = ObservationStation(B,s,H,A,E,D,Adot, Edot,Ddot)
            %���캯��
            %�ѽǶȶ�תΪ����
            obj.Glatitude = B/180*pi;
            obj.s = s/180*pi; 
            obj.altitude = H;
            obj.azimuth = A/180*pi; 
            obj.elevation = E/180*pi; 
            obj.distance = D;
            obj.Dazimuth = Adot;
            obj.Delevation = Edot;
            obj.Ddistance = Ddot;
            obj.stationPos = obj.stationpos();
            obj.C = obj.station2inertial(obj.s,obj.Glatitude);
            obj.spacecraftPos = obj.spacecraftpos();
            obj.spacecraftVel = obj.spacecraftvel();            
        end
        
        function stationpos = stationpos(obj)
            import constants.AstroConstants
            xe = (AstroConstants.ae/sqrt(1-AstroConstants.ee^2*sin(obj.Glatitude)^2)+obj.altitude)*cos(obj.Glatitude);
            ze = (AstroConstants.ae*(1-AstroConstants.ee^2)/sqrt(1-AstroConstants.ee^2*sin(obj.Glatitude)^2)+obj.altitude)*sin(obj.Glatitude);
            stationpos = [xe*cos(obj.s),xe*sin(obj.s),ze]';
        end

        function C = station2inertial(obj,s_,B_)
            % ��վ��ƽ����ϵ�����Ĺ�������ϵ��ת��,���뵥λΪrad
            C=[-sin(s_),-cos(s_)*sin(B_),cos(s_)*cos(B_);cos(s_),-sin(s_)*sin(B_),sin(s_)*cos(B_);0,cos(B_),sin(B_)];
        end
        
        function spacecraftpos = spacecraftpos(obj) 
            rou = obj.distance*[cos(obj.elevation)*sin(obj.azimuth),cos(obj.elevation)*cos(obj.azimuth),sin(obj.elevation)]';
            spacecraftpos = obj.stationPos + obj.C*rou;
        end

        function spacecraftvel = spacecraftvel(obj)
            import constants.AstroConstants
            spacecraftvel = obj.C*[obj.Ddistance*cos(obj.elevation)*sin(obj.azimuth)-obj.distance*obj.Delevation*sin(obj.elevation)*sin(obj.azimuth)+obj.distance*obj.Dazimuth*cos(obj.elevation)*cos(obj.azimuth),obj.Ddistance*cos(obj.elevation)*cos(obj.azimuth)-obj.distance*obj.Delevation*sin(obj.elevation)*cos(obj.azimuth)-obj.distance*obj.Dazimuth*cos(obj.elevation)*sin(obj.azimuth),obj.Ddistance*sin(obj.elevation)+obj.distance*obj.Delevation*cos(obj.elevation)]'+cross([0,0,AstroConstants.we]',obj.spacecraftPos);
        end
    end
end

