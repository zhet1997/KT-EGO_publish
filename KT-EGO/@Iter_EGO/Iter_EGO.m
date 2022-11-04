%2019-9-25
%�������һ��Nash-EGO�����Ż�����
%���໹��������һЩ��Ҫ�ڶ�ε����д��ݵ���Ϣ
classdef Iter_EGO<handle
    properties
        Sample
        Model
        option
    end
    
    properties
        border
        y_min_co
        y_min%����������Сֵ
        y_min_res%��Ӧ�����Сֵ
    end
    
    properties %record
        EI_max
        Database
        ano_ax
        ano_a0
    end
    
    properties(Dependent,Hidden)
        eimax
        sla
    end
    properties(Dependent,Hidden)%analysis
        best
        borderNew
        sensitive
        R2
        anova
        improve
    end
    properties %record
        borderNewMM%only for KT-EGO
    end
    methods
        
        function obj = Iter_EGO(option)
            %����һ��������Ԫ�ص�option
            %1.���Ժ���(������������)2.ֹͣ����
            obj.option = option;%��¼����
            
            %ȷ���߽�
            if isfield(option,'border')
                obj.border=option.border;
            else
                g_down=zeros(obj.Sample.dimension,1);
                g_up=ones(obj.Sample.dimension,1);
                obj.border=[g_down,g_up];%�����Χֻ�������й�
            end
            
            option.sam.border=obj.border;
            obj.Sample = Sam_EGO(option.sam);%�趨�ӵ�����
            if strcmp(option.model,'HierarchicalKriging')%&&isexist(option.globalfunc)
                obj.Model = GPfamily( obj.Sample.p, obj.Sample.v ,option.model,option.globalfunc);%һ��ʼ��ֱ�ӽ���HKģ��
            else
                obj.Model = GPfamily( obj.Sample.p, obj.Sample.v ,option.model);
            end
            
            %===========================
            obj.get_y_min;%���㸴�Ӳ���
            %����ano
        end
        %================================================================================
        %���������������µ������㲢����ģ��״̬��
        Update(obj,x_1)%
        Update_HK(obj,x_1,surface)%ֱ�Ӽ������ģ��
        %==================================================================================================
        %��������
        function get_y_min(obj)
            func = @(x)obj.Model.predict(x);
            %[obj.y_min_co,obj.y_min_res] = ga(func,obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
            Seed = lhsdesign(obj.Sample.dimension*500,obj.Sample.dimension);
            MaxT = obj.Sample.dimension;
            [obj.y_min_res,obj.y_min_co] = GA_pce(func,Seed,MaxT,obj.border);
            obj.y_min  = obj.Sample.y_min_h;
        end
        
        %==================================================================================================
        %ѡ��ӵ㺯��
        %GEI����
        [xx,yy]=find_GEI(obj,gmax)
        %EI����
        [xx,yy]=find_EI(obj,EIborder)
        %==================================================================================================
        %ֹͣ��������
        [y]=termination(obj,type)
        %num1
        function [y] = get.eimax(obj)
            y = obj.EI_max;
        end
        %num2
        function [y] = get.sla(obj)
            s = obj.Database(3,:);
            t = size(s,1);
            ii = 0;
            if t==1
                y = 0;
            else
                while ii<t-1&&s(t-ii)==s(t-ii-1)
                    ii = ii+1;
                end
                y = ii;
            end
        end
        %===================================================================================================
        %��¼����%�Զ���¼����������һЩ�м�ֵ��ֵ
        record(obj)
        %=======================================================================================
        %������%���Ż���ɺ���㷨���к��������
        %��������ֵ
        function [y] =get.best(obj)   %get the best value and its location
            y.value = obj.Sample.y_min_h;
            temp = obj.Sample.samples_h==y.value;%��¼����
            temp = repmat(temp(:,obj.Sample.dimension+1),1,obj.Sample.dimension);
            y.point = obj.Sample.samples_h(:,1:obj.Sample.dimension).*temp;
            y.point(temp(:,1)==0,:)=[];
            y.point = y.point(1,:);
        end
        %�����±߽�
        function [y] =get.borderNew(obj)
            ratio = 0.5;
            y = spaceReduce(@(x)obj.Model.predict(x),obj.border,ratio);
        end
        
        %�������ж�(�㶯��)
        function [y] =get.sensitive(obj)
            if obj.Sample.dimension==1
                y=[];
            else
                y = iteraction(obj.Model,obj.borderNew);
            end
        end
        %����ģ�;���
        function [y] =get.R2(obj)
            list = LooCV(obj.Model);
            y= list.R2;
        end
        %���㹱�׶�
        function [y] =get.anova(obj)
            if obj.Sample.dimension==1
                y=[];
            else
                ano= ANOVA(obj.Model);
                temp = ano.contribution();
                %             temp = temp.AllOrders{1,1};
                %             if sum(temp<=0)% if there are any minus in temp
                %                 temp = temp*0 + 1;
                %             end
                %             temp = temp/sum(temp);
                y = temp';
            end
        end
        %��������
        function [y] =get.improve(obj)
            y = obj.Database(1,1)-obj.Database(1,end);
        end
        %����
        %=======================================================================================
    end
end

