%2021-1-5
%��ԭ��PLAYER�Ĳ�ͬ���������playerֱ��ʹ��ȫ��ģ�͵���Ƭ����Ϊ�;���
function [y] = PLAYER_MX(option)%���������option��ʵ��player
dim = size(option.variables,2);
option.max = option.max*dim;
option.sam.initial = option.sam.initial*dim;


opt = Iter_nash(option);% ������ʼģ��%��ʼģ����krigingģ��
%% ��ʼ�ӵ�
%ʹ��HKģ��
opt.option.model = 'HierarchicalKriging';
opt.Update_HK([],option.globalfunc);

%% ����
for iter=1:floor(option.max*0.33)%�����max��ָ����������
    x = opt.find_EI(); %����EI�������ɱ���ܸߣ���Ϊÿ��ȡֵҪ��globalModȥ��һ����
    opt.Update_HK(x,option.globalfunc);
    opt.record;
    if opt.termination('eimax')==1
        break;
    end
    
end

y = opt.best;
y_min_co = y.point;
wid = 0.2;
temp1 = max(y_min_co' - wid,0);
temp2 = min(y_min_co' + wid,1);
EIborder = [temp1,temp2];

opt.option.model = 'Kriging';
for iter=1:floor(option.max*0.33)%�����max��ָ����������
    x = opt.find_EI(EIborder); %����EI�������ɱ���ܸߣ���Ϊÿ��ȡֵҪ��globalModȥ��һ����
    opt.Update(x);
    opt.record;
    if opt.termination('eimax')==1
        break;
    end
    
end

y = opt.best;
if y.point==option.sam.elite
    opt.option.model = 'Kriging';
    for iter=1:floor(option.max*0.33)%�����max��ָ����������
        x = opt.find_EI(EIborder); %����EI�������ɱ���ܸߣ���Ϊÿ��ȡֵҪ��globalModȥ��һ����
        opt.Update(x);
        opt.record;
    end
    y = opt.best;
end

clear('x','iter');
%% ����������
opt.option.globalfunc = [];
opt.option.sam.func = [];
opt.Sample.func = [];
opt.Sample.option.func = [];
opt.Model = opt.Model.hyperparameters;
save([option.path,option.name(option.num,option.iter)],'opt');
%option.name�ǹ̶���ʽ����������������ֻ��Ҫ����ź͵����������뼴��
disp('alredy save');
end