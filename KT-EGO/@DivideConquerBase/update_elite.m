function update_elite(obj)
    [pointsAll,valuesAll,~] = obj.allSample();       
    obj.elite.value = min(valuesAll);%��Сֵ����
    index = find(valuesAll==obj.elite.value);
    new = pointsAll(index(1),:);%��ǰ������������
    if isfield(obj.elite,'point')
    obj.elite_change = obj.elite.point - new;
    end
    obj.elite.point = new;
end

