classdef Inertial2Orbit
    %����ϵ�����ϵ������任
    %   ����ΪOmega�������㾭�ȣ���i�������ǣ���omega�����ĵ�Ǿࣩ����λΪdeg
    %   ���԰���������������ת������ܵ���ת����
    
    properties
        MOmega3 %��z����תOmega
        Mi1 %��x����תi
        Momega3 %��z����תomega
        Minertial2orbit %����ϵ�����ϵ������任
        Morbit2inertal %���ϵ������ϵ������任
    end
    
    methods
        function obj = Inertial2Orbit(Omega,i,omega)
            Omega = Omega*pi/180;
            i = i*pi/180;
            omega = omega*pi/180;
            obj.MOmega3 = [cos(Omega),sin(Omega),0;-sin(Omega),cos(Omega),0;0,0,1];
            obj.Mi1 = [1,0,0;0,cos(i),sin(i);0,-sin(i),cos(i)]; 
            obj.Momega3 = [cos(omega),sin(omega),0;-sin(omega),cos(omega),0;0,0,1];
            obj.Minertial2orbit = obj.Momega3*obj.Mi1*obj.MOmega3;
            obj.Morbit2inertal = obj.Minertial2orbit';
        end
        
    end
end

