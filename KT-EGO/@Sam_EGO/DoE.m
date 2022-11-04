 %2019-11-8
%�������Sam_nash�г�ʼ�ֲ��ĺ���
%�Ƚϸ��ӣ��漰���ּӵ㷽ʽѡ��
function DoE(obj,DoE_type)
%%������������
switch DoE_type
    case 'initial_all'
        obj.addSamHigh(obj.elite);%������ĵ�����
        points = extendSam(obj.dimension,obj.ini_number,obj.elite,obj.border);
        obj.addSamHigh(points);%����samples
    case 'initial_TFA'
        obj.addSamHigh(obj.elite);%������ĵ�����
        points = extendSam(obj.dimension,obj.fea_num,obj.elite);
        obj.addSamHigh(points);%����samples
    case 'extend_unnested'%��ӦHK
        %��Ҫ��������ĳ�ʼ�ӵ�
        points = extendSam(obj.dimension,obj.ini_number,obj.samples_h(:,1:obj.dimension));
        obj.addSamHigh(points);%����samples
    case 'extend_nested'%��ӦCoKriging
        sourceFile = load([obj.fea_index],'opt');%ֱ�Ӷ�ȡ���ݵ��ļ���
        obj.addSamLow(sourceFile.opt.Sample.samples_h);%���ص�samples_l��
        clear('sourceFile');%�����ɾ
        
        %ѡ��Ŀ���ʼ�ӵ�
        points = nestedSam(obj.dimension,obj.ini_number-obj.fea_num,obj.samples_l,2);
        obj.addSamHigh(points);%����samples       
end

end

%%��������ֲ�
%1.����Ϣ��ֱ�ӻ�ȡ
function [y] = optimalLHS(dim,num,border)
%�����Ż�LHS������
ad=3;
lower = border(:,1)';
upper = border(:,2)';
points = lhsdesign(num*ad, dim);%���Ϊn*m�ľ���
points = points.*(upper-lower)+lower;
for i=1:num*(ad-1)
    y = pdist(points,'euclid');
    z = linkage(y,'single');
    p1 = z(1,1);%������ӽ���������֮һ
    p2 = z(1,2);%������ӽ���������֮һ
    d1 = sum((points(p1,:) - linspace(0.5,0.5,dim)).^2);
    d2 = sum((points(p2,:) - linspace(0.5,0.5,dim)).^2);
    if d1<d2%ѡ���������Զ����һ��ȥ��
        points(p2,:) = [];
    else
        points(p1,:) = [];
    end
end
y = points;%���Ϊ���������ֲ��ľ���
end

%2.����Ϣ����������ȡ
function [y] = nestedSam(dim,num,source,addtype)
%infiling base on source%������Ϊsourceͬʱ����point��value
%�������
if dim~=size(source,2)&&dim~=size(source,2)-1
    error("����Դ�޷�����ƥ��");
end
if num>size(source,1)
    error("�߾��ȳ�ʼ������������ڵ;����������޷�����ѡ�񣡣�����")
end

%��ʼѡ��  1.��������� 2.������Ա� 3.��ֵ�Ա�
points_h = source(:,1:dim);
values_h = source(:,dim+1);

for i=1:size(source,1)-num
    %==================================================
    y = pdist(points_h,'euclid');
    z = linkage(y,'single');
    p1 = z(1,1);%������ӽ���������֮һ
    p2 = z(1,2);%������ӽ���������֮һ
    d1 = sum((points_h(p1,:) - linspace(0.5,0.5,dim)).^2);
    d2 = sum((points_h(p2,:) - linspace(0.5,0.5,dim)).^2);
    switch addtype
        case 1
            if d1>d2%ѡ��������Ľ�����һ��ȥ��
                p = p2;
            else
                p = p1;
            end
        case 2
            if values_h(p1)<= values_h(p2)%ѡ��tipֵ�����һ��ȥ��
                p = p2;
            else
                p = p1;
            end
        case 3
            p=find(values_h==max(values_h));%�ҵ�����һ��
            p=p(1);%�����ж����ֻ����һ��
            
    end
    values_h(p,:) = [];
    points_h(p,:) = [];%ȥ����p����
end
[y] = points_h;%���ջ�ã��µ������ֲ�
end

function [y] = extendSam(dim,num,existedPoint,border)
%���Ѿ��в�������������¼����ӵ�
if dim~=size(existedPoint,2)&&dim~=size(existedPoint,2)-1
    error("����Դ�޷�����ƥ��");
end
pointsAll = optimalLHS(dim,num,border);% + size(existedPoint,1));
points = pointsAll;
delList = zeros(1,size(existedPoint,1));
for ii = 1:size(existedPoint,1)
 %������
[~, delList(ii)] = min(sum((points - existedPoint(ii,:)).^2, 2));%ȥ�����������һ��
points(delList(ii),:) = [];
end
%points(delList,:)=[];
y = points;%���ս��������existedPoint����
end

