%%Э������ʱ��UTC��ת��������ԭ��ʱ��TAI��
function TAI = UTC2TAI(UTC)
%�����������https://www.iers.org/IERS/EN/DataProducts/EarthOrientationData/eop.html#BulC�л��
%2017��1��1�գ�leapsecond=37s
leapsecond = 37;
TAI = UTC + leapsecond; 
end