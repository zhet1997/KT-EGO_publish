%����Լ��
function [xx,yy]=find_EI(obj,EIborder)%ѡ�����
if nargin==1
 EIborder = obj.border;
end
ei = @(x)EI(obj,x);
% fei = @()ga(ei,obj.Sample.dimension,[],[],[],[], EIborder(:,1),EIborder(:,2));
% [a,b]= fei();
Seed = lhsdesign(obj.Sample.dimension*500,obj.Sample.dimension);
MaxT = obj.Sample.dimension;
[b,a] = GA_pce(ei,Seed,MaxT,EIborder);
c = obj.Model.predict(a);
obj.EI_max=-min(b);%��EIֵ����
xx = a;
yy = c;
end

function yy=EI(obj,x)
[y,mse2] = obj.Model.predict(x);
s=sqrt(abs(mse2));
if s<=1e-20
    yy=0;
else
    yy=(obj.y_min-y).*normcdf((obj.y_min-y)./s,0,1)+...
    s.*normpdf((obj.y_min-y)./s,0,1);%EI�Ĺ�ʽ
    yy=-yy;  %ʵ���ϼ������-ei 
end
end