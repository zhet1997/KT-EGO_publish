%2019-11-19
%��ֹ��������
function [y] = termination(obj,type)
switch type
    case 'eimax'
        y= eimax(obj);
    case 'sla'
        if size(obj.Database,1)>=2*obj.Sample.dimension
            y= sla(obj);
        else
            y=0;
        end
        
    case 'iter'
        if size(obj.Database,1)>=obj.option.max
            y= 1;
        else
            y=0;
        end
    case 'cost'
        y= cost(obj);
        
end
end


%EI���ֵС��һ����Χ
function  bool = eimax(obj)
if obj.eimax<obj.option.EI
    disp("����EI����ֹͣ����")
    bool = 1;
else
    bool= 0;
end

end

%sla��׼
function bool=sla(obj)
a_number = 2*(obj.Sample.dimension);
if obj.sla<=a_number
    bool=0;
else
    disp("����sla����ֹͣ����")
    bool = 1;
end
end

%���ӵ�������һ������ֹͣ
function  bool = cost(obj)
if obj.Database(3,end)>obj.option.cost
    disp("�����ۺϼӵ���ֹͣ����")
    bool = 1;
else
    bool= 0;
end
end
