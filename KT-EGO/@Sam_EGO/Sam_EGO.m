%2019-10-1
%��������������Ϊnash-EGO�����Ż��ṩ��ʼ�ӵ�
%1��forrester����
%2��branin����
%3hartmann-3D  y_min=-3.86278 at(0.114614,0.555649,0.852547)
%4colville    y_min=0 at(1,1,1,1)
%5shekel    m=5 y_min=-10.1532 at��4,4,4,4��
classdef Sam_EGO<handle
    properties%������ӵ���Դ
        func %���Ժ�������
        dimension %���Ժ���ά��
        ini_number
        elite
        type
        border
        option
    end
    
    properties %������%���ڴ����ʷ�ӵ���Ϣ
        samples_l
        samples_h
    end
    
    properties(Dependent,Hidden)
      y_min_l
      y_min_h
      p
      v
    end
    
    properties%feasible ���
        fea_num
        fea_index
    end
    
    %===============================================================================
    methods
        %===============================================================================
        function obj=Sam_EGO(option)%%construct
            %�����������
            obj.func = option.func;%��Ҫ����ĺ���ֱ����������������ʽ����
            obj.dimension = size(option.elite,2);
            obj.elite = option.elite;
            obj.ini_number = option.initial;%���������������������ʽ����
            obj.option = option;%����option
            
             if isfield(option,'border')
             obj.border=option.border;
             else
            g_down=zeros(obj.dimension,1);
            g_up=ones(obj.dimension,1);
            obj.border=[g_down,g_up];%�����Χֻ�������й�
             end
            
            obj.DoE('initial_all');%��������µĳ�ʼ�ӵ�
            
        end%construct
        
        function [y] = readin(obj,source)%����ֱ�Ӷ�����������ֵ%����ֱ�Ӵ��浽samples
            dim = obj.dimension;
            if dim==size(source,2)%points only
                y = [source,obj.evaluate(source)];
            elseif dim==size(source,2)-1 %points & values;
                y = source;
            else
                error("�����������ʽ����")
            end
        end
        
        function [y] = evaluate(obj,points) %���������ֲ���ȡֵ��������
%             num = size(points,1);            
            b = obj.func(points);%��̬�;���
            y = b;
        end
        
        %��ʼ�ֲ�����
        DoE(obj,DoE_type)
        
        %update
        function addSamHigh(obj,add)
            obj.samples_h = [obj.samples_h;obj.readin(add)];
            %�����жϷ�ֹ�ظ��ӵ�
            obj.samples_h = unique(obj.samples_h,'rows');%ȥ���ظ��ӵ�%��������������
        end
        
        function addSamLow(obj,add)
            obj.samples_l = [obj.samples_l;obj.readin(add)];
            %�����жϷ�ֹ�ظ��ӵ�
            obj.samples_l = unique(obj.samples_l,'rows');%ȥ���ظ��ӵ�%��������������
        end
        
        function y_min_h = get.y_min_h(obj)
            y_min_h = min(obj.samples_h(:,obj.dimension + 1));
        end
        
        function y_min_l = get.y_min_l(obj)
            y_min_l = min(obj.samples_l(:,obj.dimenson + 1));
        end
        
        function [y] = get.p(obj)
        if isempty(obj.samples_l)==1
            y = obj.samples_h(:,1:obj.dimension);
        else
            y{1,1}=obj.samples_l(:,1:obj.dimension);
            y{2,1}=obj.samples_h(:,1:obj.dimension);
        end
        end
        
        function [y] = get.v(obj)
        if isempty(obj.samples_l)==1
            y = obj.samples_h(:,obj.dimension+1);
        else
            y{1,1}=obj.samples_l(:,obj.dimension+1);
            y{2,1}=obj.samples_h(:,obj.dimension+1);
        end
        end
        
        
        
    end
end


