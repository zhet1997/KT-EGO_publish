function [y] = PLAYER_SF(option,opt)
if nargin==1
    opt = [];% ������ʼģ��
end
dim = size(option.variables,2);
option.max = option.max*dim;
option.sam.initial = option.sam.initial*dim;

if nargin==1
    opt = Iter_EGO(option);% ������ʼģ��
end
%% ����
for iter=1:option.max%�����max��ָ����������
    if isfield(option,'save')
        save([option.path,option.name(option.num,option.iter)]);
    end
    x = opt.find_EI();
    opt.Update(x);
    opt.record;
    if opt.termination('eimax')==1
        break;
    end
end
y = opt;
%% ����������
save([option.path,option.name(option.num,option.iter)]);
disp('alredy save');
end

