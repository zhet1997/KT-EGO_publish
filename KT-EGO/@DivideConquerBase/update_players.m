function update_players(obj)
for ii=1:obj.subset%�����Ż��Ĳ������и���
    obj.player_option{1,ii} = obj.player_template;
    obj.player_option{1,ii}.variables = obj.subsetPlayer{1,ii};
    
    obj.player_option{1,ii}.sam.func = @(x)Testmodel_player(x,obj.func_name,obj.elite.point,obj.player_option{ii}.variables);%�޸��Ӻ���
    obj.player_option{1,ii}.elite = obj.elite.point(obj.player_option{ii}.variables);%�޸ľ�Ӣ����
    obj.player_option{1,ii}.sam.elite = obj.player_option{ii}.elite;
    obj.player_option{1,ii}.iter = obj.iter;
    obj.player_option{1,ii}.start = obj.player_start(ii);
    obj.player_option{1,ii}.num = ii;
    obj.player_option{1,ii}.border = obj.border(obj.subsetPlayer{1,ii},:);
    if strcmp(obj.subOptimizer,'PLAYER_MXSR')
        obj.player_option{1,ii}.globalfunc = @(x) pceCut(obj.modGlobal,obj.elite.point,obj.player_option{1,ii}.variables,x);%����Ƭ���ȫ��ģ������ 
    end
end
end

