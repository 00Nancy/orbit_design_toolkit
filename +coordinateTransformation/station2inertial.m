function C = station2inertial(s,B)
% ��վ��ƽ����ϵ�����Ĺ�������ϵ��ת��,���뵥λΪrad
C=[-sin(s),-cos(s)*sin(B),cos(s)*cos(B);cos(s),-sin(s)*sin(B),sin(s)*cos(B);0,cos(B),sin(B)];
end