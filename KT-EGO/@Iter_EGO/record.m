%2019-11-16
%��¼���������ڼ�¼������ÿ�ε�����һЩ���ݽ��%ֻ�����������ֻ�ż�ʱ��Ϣ
%��¼��һ�������table��
%��������¼�������У�
%1.����ֵ 2.EI���ֵ 3.�������������߾��ȣ� 
function  record(obj)
database = zeros(3,1);
%�����������
database(1,1) =obj.Sample.y_min_h;
database(2,1) =obj.EI_max;
database(3,1) =size(obj.Sample.samples_h,1);
%�����������
obj.Database = [obj.Database,database];
%������������%��result��
end

