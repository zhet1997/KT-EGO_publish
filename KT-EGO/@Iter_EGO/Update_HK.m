%2019-11-16
%���������Ǽӵ���Զ�����ģ�ͺͼ�¼
%��Ϊ��1.ʶ�����룬�жϷ��ࣻ2.�����������ݣ�3.���´�������
%�ڱ������ڵ���������ֻ����߾�������

function  Update_HK(obj,x,surface)
if isempty(x)==0
obj.Sample.addSamHigh(x);
end
%�ڵ���������ģ�Ϳ��ܻᷢ���仯��
obj.Model = GPfamily(obj.Sample.p, obj.Sample.v,obj.option.model,surface);
obj.get_y_min(); 
end


