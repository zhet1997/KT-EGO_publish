clc;clear;
warning('off');
dbstop if error;
pathRoot = 'D:\CODE\Test\mkOptionFile\30D_SRKT\';
pathSam = 'D:\DATA\IniSam\';
optionList = importdata([pathRoot,'optionList.txt']);
ii = 6;
option = updateOption(pathRoot,optionList{ii,:},1,pathSam);
option.subset = 10;
option.player.EI = 1e-4;
option.borderStr = 'Reduce';
option.decomposeStr = 'randomGroup';
option.subOptimizer = 'PLAYER_MF';
option.SAVE_MODE=0;
option.IniSam = lhsdesign(150,30);
opt = DCBwithSurrogate(option);
opt.coreNum = 1;
% opt.decomposeStr = 'randomGroup';
% opt.subOptimizer = 'PLAYER_SF';

for i=1:10
    opt.Update();
    ld = load(opt.record);
    if sum(ld.record.cost)>=5000
        disp('样本总数已经达到上限')
        break;
    end
    save([option.pathRoot,option.tree.caseLocation,'Result',option.tree.recordName],'opt');
end



