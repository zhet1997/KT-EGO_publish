function [y] = PLAYER_MXSR(option,opt)
if nargin==1
    opt = [];% ������ʼģ��
end
dim = size(option.variables,2);
option.max = option.max*dim;
option.sam.initial = option.sam.initial*dim;

if nargin==1
    option.model = 'HierarchicalKriging';
    opt = Iter_EGO(option);% ������ʼģ��
end
%% �ౣ�����
ratio = 0.5;
iterBrk = option.max;
for iter=1:option.max%�����max��ָ����������
    if isfield(option,'save')
        save([option.path,option.name(option.num,option.iter)]);
    end
    x = opt.find_EI();
    opt.Update_HK(x,option.globalfunc);
    opt.record;
    if opt.termination('eimax')==1
        iterBrk = iter;
        break;
    end
end
%% ���ÿռ�����
modHK = opt.Model;
opt.option.model = 'Kriging';
opt.Update([]);
modKR = opt.Model;
opt.border = spaceReduceMM(@(x)modHK.predict(x),@(x)modKR.predict(x),opt.border,ratio,'intersect');
%% ���������
for iter=iterBrk:option.max%�����max��ָ����������
    if isfield(option,'save')
        save([option.path,option.name(option.num,option.iter)]);
    end
    x = opt.find_EI();
    opt.Update(x);
    opt.record;
end

%% ���ÿռ�����
modKR = opt.Model;
 opt.option.model = 'HierarchicalKriging';
opt.Update_HK([],option.globalfunc);
modHK = opt.Model;
opt.borderNewMM = spaceReduceMM(@(x)modHK.predict(x),@(x)modKR.predict(x),opt.border,ratio,'union');


%% ����������
opt.option.globalfunc = [];
opt.option.sam.func = [];
opt.Sample.func = [];
opt.Sample.option.func = [];
y = opt;
save([option.path,option.name(option.num,option.iter)]);
disp('alredy save');
end

