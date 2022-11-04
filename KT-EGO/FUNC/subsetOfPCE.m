%2021-6-9
%����uqlab
%���룺�����ȷֲ��Ĵ�����ά����
%����������������ĸ�άģ����Ӧ��
%����ʹ��Nash-EGO���������ݽ��в��ԡ�
%����������������Ҫ����Ҫ��
%model = @(Xval) uq_evalModel(myPCE,Xval);
%clc;clear;
function [y1,y2] = subsetOfPCE(points,values,border)%Ҫ��֤�����Ѿ�ɸȥ���ظ�����
%% ��������
dim = size(points,2);
if nargin==2
   border =  repmat([0,1],[dim,1]);
end

%% ��������
cof = 0.01;
%index1 = greedyMaxMin(points,cof);
index1 = 1:size(points,1);
index2 = setdiff(1:size(points,1),index1);
X =  points(index1,:);
Y =  values(index1,:);
Xval = points(index2,:);
Yval = values(index2,:);
[y1,y2] = UQpce(X,Y,Xval,Yval,border);
end

function [y1,y2] = UQpce(X,Y,Xval,Yval,border)
rng(100,'twister')
uqlab
for i = 1:size(X,2)
    mid = 0.5*(border(i,1)+border(i,2));
    rnd = 0.5*(border(i,2)-border(i,1));
    
    InputOpts.Marginals(i).Name = sprintf('V%d',i);
    InputOpts.Marginals(i).Type =  'Uniform';    
    InputOpts.Marginals(i).Moments = [mid rnd/sqrt(3)];  
    %InputOpts.Marginals(i).Parameters = [1 1];  
end
% Create an INPUT object based on the specified marginals:
myInput = uq_createInput(InputOpts);

MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'PCE';
%MetaOpts.Method = 'quadrature';
MetaOpts.Method = 'OMP';
MetaOpts.OMP.TargetAccuracy = 1e-4;
MetaOpts.OMP.OmpEarlyStop = false;
MetaOpts.TruncOptions.qNorm = 0.75;
MetaOpts.ExpDesign.X = X;
MetaOpts.ExpDesign.Y = Y;

if ~isempty(Xval)
MetaOpts.ValidationSet.X = Xval;
MetaOpts.ValidationSet.Y = Yval;
end
MetaOpts.Degree = 2:4;
y1 = uq_createModel(MetaOpts);

SobolOpts.Type = 'Sensitivity';
SobolOpts.Method = 'Sobol';
%SobolOpts.PCEBased = true;
SobolOpts.Sobol.Order = 3;
mySobolAnalysisPCE = uq_createAnalysis(SobolOpts);
y2 = mySobolAnalysisPCE.Results;
uq_print(y1)
end

function [y] = greedyMaxMin(points,cof,iniSelect)%����ֻ������������ֵ�޹�
    num = size(points,1);
    dim = size(points,2);
    maxNum = min(num,floor(1000*dim/30));
    threshold = cof *sqrt((1/num)^(2/dim)*dim);
    dist = pdist(points,'euclid');%������������
    distM = squareform(dist);
    if nargin<3
    [temp,~] = find(distM==max(dist));%��õ������ԳƵ�ֵ%����ǳ�ʼ������ѡ�е�ֵ
    iniSelect = temp';%ת��Ϊ������
    end
    
    select = iniSelect;
    while true    
      [select,distNew] =  updateSelect(distM,select);    
       if distNew<threshold || size(select,2)>=maxNum
           disp([num2str(size(select,2)),'//',num2str(num)]);
            break;
       end       
    end
    y = sort(select);%���������
end


function [y1,y2] = updateSelect(distM,select)
num = size(distM,1);
unselect = setdiff(1:num,select);
M = distM(select,unselect);
dist2 = min(M,[],1);
index = find(dist2 == max(dist2));
index = index(1);%��ֹ�ж��
y1 = [select,unselect(1,index)];
y2 = max(dist2);
end


  