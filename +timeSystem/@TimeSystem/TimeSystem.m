classdef TimeSystem
    %ʱ��ϵͳ�࣬��ʼ������Э������ʱ��UTC�������԰�������ʱ��
    %   Detailed explanation goes here
    
    properties
        UTC %Э������ʱ
        lambdaG % ������
        lambda %����������ľ��ȣ����ڼ������ݲ��׻�ȡ��������Ϊ���ڵ�����
        TAI %����ԭ��ʱ
        TT %����ʱ
        TDT %������ʱ
        ET %����ʱ
        %TDB�����Ķ���ʱ��������
        %TCG����������ʱ��������
        %TCB����������ʱ��������
        UT1 %����ʱ, UT0��UT2������
        Smean %��������ƽ����ʱ
        S %�������������ʱ
        smean %����ƽ����ʱ
        s %���������ʱ
    end
    
    methods
        function obj = TimeSystem(UTC_,lambdaG_)
            %���캯��
            obj.UTC = UTC_;
            obj.lambdaG = lambdaG_; 
            obj.lambda = obj.lambdaG ; %���ڼ������ݲ��׻�ȡ��������Ϊ���ڵ�����
            obj.TAI = obj.UTC2TAI(obj.UTC);
            obj.TT = obj.TAI2TT(obj.TAI);
            obj.TDT = obj.TT;
            obj.ET = obj.TT;
            obj.UT1 = obj.UTC2U1(obj.UTC);
            obj.Smean = obj.UT12Smean(obj.UT1,obj.TT);
            obj.S = obj.Smean2S(obj.Smean);
            obj.smean = obj.Smean2smean(obj.Smean,obj.lambda);
            obj.s = obj.S2s(obj.S,obj.lambda);
            
        end
        
        function  TAI_ = UTC2TAI(obj,UTC_)
            %����DAI�����룩����Ҫ֮�������������ݣ�������ָ��һ��ֵ
            DAI_ = 1/3600/24; %��λ����
            TAI_ = UTC_ + DAI_;
        end
        
        function TT_ = TAI2TT(obj,TAI_)
            TT_ = TAI_+32.184;
        end
        
        function UT1_ = UTC2U1(obj,UTC_)
            %����DUT1����Ҫ֮�������������ݣ���������һֵ
            DUT1_ = 0.2/3600/24;
            UT1_ = UTC_ + DUT1_;
        end
        
        function Smean_ = UT12Smean(obj,UT1_,TT_)
            Du = juliandate(UT1_)-2451545; 
            theta = 0.7790572732640+1.00273781191135448*Du; %����ת���ǣ���λ�ǵ���ת����Ȧ��
            T = (juliandate(TT_)-2451545)/36525;
            Smean_=86400*theta+(0.014506+4612.156534*T+1.3915817*T^2-0.00000044*T^3-0.000029956*T^4-0.0000000368*T^5)/15;   
        end
        
        function S_ = Smean2S(obj,Smean_)
            %��r��Ҫ�ɳྭ�¶����𣬻���Ҫ����һЩ�߾��Ȳ���������Ⱥ���
            epsilonr = 0;
            S_ = Smean_+epsilonr/15;
        end
        
        function smean_ = Smean2smean(obj,Smean_,lambda_)
            smean_ = Smean_ + 3600/15*lambda_;
        end
        
        function s_ = S2s(obj,S_,lambda_)
            s_ = S_ + 3600/15*lambda_;
        end
    end  
        
end