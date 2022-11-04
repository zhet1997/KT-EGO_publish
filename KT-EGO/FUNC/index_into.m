%2019-12-7
%������Ϊ���Ե�ģ����������ڲ�ͬ�㷨�벻ͬ���Ժ�����������
%�������²��֣�
%1.���Ժ���ѡȡ
%2.�Ż��㷨ѡȡ
%3.�㷨��������
%4.�Ż�������������
function [y] = index_into(put,pathRoot,Name)
%�Բ�����������
option = struct();
%�Բ�����������
option.pathRoot = pathRoot;%����������·��
option.date = datestr(datetime('today'),'yyyy-mm-dd');
%====================================
%nash����
option.func_name = put{1};%���Ժ�������
option.func_dim = put{2};%���Ժ���ά��
option.subset = put{3};%����player����
%====================================
%player����
%ֹͣ����%��������
player.model = 'Kriging';%'HierarchicalKriging';
player.EI = put{4};%�ȽϹؼ�������
player.max =  put{5};
%====================================
%sample����
%��ʼ����
sam.initial =  put{6};%���Ż���ʼ�ӵ���
%feasible����

%�ܽᲿ��
%=========================
player.sam = sam;
players = subPlayerOption(option, player);
option.player = player;
option.players = players;
option.Name = nameForOption(option,Name);
option.tree = setFileTree(option,Name);

y = option;
%==========================
end

function [y] = subPlayerOption(option, player)
players = cell(option.subset,1);%�����������PLAYER��Ԫ������
%player��������
n = floor(option.func_dim/option.subset);
s = linspace(n,n,option.subset);
s = s + double((1:option.subset)<=option.func_dim - n*option.subset);
t = [0,cumsum(s)];
for ii=1:option.subset
    players{ii} = player;%����ͬ�������뵽ÿ��palyer��
    players{ii}.variables = (1:s(ii)) + t(ii);%������䷽��
    players{ii}.num = ii;%����player���
    players{ii}.sam.num = ii;
    %������Ϣ������nash-ego�Ż��в������仯
end
y =  players;
end

function [y] = setFileTree(option,Name)
tree.caseLocation = [nameForCase(option,Name),'\'];%���λ��
%tree.playerLocation =  @(subset)[tree.caseLocation, '\','PLAYER',num2str(subset),'\'];
tree.recordName =  nameForRecord(option);
tree.playerName = @(num,iter)['num',num2str(num),'%'...%player�ı��
    ,'iter',num2str(iter),'.mat'];

y = tree;
end

function [file_name] = nameForOption(option,Name)
file_name = [Name,'%'...
    ,depend(option.func_name) ,'&'...
    ,num2str(option.func_dim),'&'...
    ,num2str(option.subset),'.mat'];
end

function [dir_name] = nameForCase(option,Name)
dir_name = [Name,'%'...
    ,depend(option.func_name),'%'...
    ,num2str(option.func_dim),'%'...
    ,num2str(option.subset),'%'...
    ];
end

function [file_name] = nameForRecord(option)
file_name = [option.date,'%'...
    ,depend(option.func_name),'%'...
    ,num2str(option.func_dim),'%'...
    ,num2str(option.subset),'.mat'];
end

function [nameInOption] = depend(func_name)
if strcmp(class(func_name),'double')
   nameInOption = ['CEC',num2str(func_name)]; 
else
   nameInOption = func_name;
end
end
