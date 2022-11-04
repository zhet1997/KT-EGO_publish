%2019-9-21
clc;clear;
% pathRoot = 'E:\Nash_EGO_wqn\TestDemo\';%'E:\dataset_20200722\';
% pathExcel = 'E:\Nash_EGO_wqn\TestDemo\';%'E:\dataset_20200722\';
pathRoot = 'D:\CODE\Test\mkOptionFile\Rotor37_SRDA\';
pathExcel = 'D:\CODE\Test\mkOptionFile\Rotor37_SRDA\';
nameRaw = 'Rotor37_SRDADM_';
% nameRaw = @(x) [num2str(x),'D_BS_'];
%��ȡexcel���
[~,~,tableOption] = xlsread([pathExcel,'testOption.xlsx'],1);
%У�Ա�ͷ��ȷ�����ݵĶ�Ӧ��ϵ
proof = zeros(6,1);
header = {'option.func_name',...
    'option.func_dim',...
    'option.subset',...
    'player.EI',...
    'player.max',...
    'sam.initial'};
for ii = 1:6
    proof(ii,1) = strcmp(tableOption{ii,1},header{ii});
end

if prod(proof) == 1
    tableOption = tableOption(1:end,2:end);%ȥ����ͷ;
else
    error('����ı������,����');
end

%�������ݣ�����option�ļ�  
if exist([pathRoot,'optionList.txt'],'file')==2
    fid  = fopen([pathRoot,'optionList.txt'],'wt');
    fclose(fid);
end
fid  = fopen([pathRoot,'optionList.txt'],'at');
for ii = 1:size(tableOption,2)
put = tableOption(:,ii);

% name = [nameRaw(put{2,1}),num2str(put{6,1}),'-',num2str(put{5,1})];
name = [nameRaw,num2str(put{6,1}),'-',num2str(put{5,1})];
option = index_into(put, pathRoot,name);
save([pathRoot,option.Name], 'option');
fprintf(fid,'%s\n',option.Name);
end

fclose(fid);


