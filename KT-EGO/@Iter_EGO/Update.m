%2019-11-16
%���������Ǽӵ���Զ�����ģ�ͺͼ�¼
%��Ϊ��1.ʶ�����룬�жϷ��ࣻ2.�����������ݣ�3.���´�������
%�ڱ������ڵ���������ֻ����߾�������

function  Update(obj,x)
if isempty(x)==0
obj.Sample.addSamHigh(x);
end

%�ڵ���������ģ�Ϳ��ܻᷢ���仯��
obj.Model = GPfamily(obj.Sample.p, obj.Sample.v,obj.option.model);

obj.get_y_min();
%obj.add_record = [obj.add_record;size(x_1,1),size(x_2,1)];
end


