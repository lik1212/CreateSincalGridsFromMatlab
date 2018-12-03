function [Buscoords, Lines]        = MergeUnnecessaryElements(Buscoords, Lines)
%MERGEUNNECESSARYELEMENTS Summary of this function goes here
%   Detailed explanation goes here MAYBE NOT CORRECT!
% clear;
% load('temp.mat')
NodeOccurInLines = [Lines.Bus1; Lines.Bus2];
AllNodesID       = unique(NodeOccurInLines);
AllNodesCount    = histc(NodeOccurInLines(:), AllNodesID);

Lines2Del = cell(0);
k_Line2Del = 0;
for k_Line = 1 : size(Lines,1)
    if (sum(all(ismember(Lines{:,{'Bus1','Bus2'}},Lines{k_Line,{'Bus1','Bus2'}}),2)) == 2)
        Lines2Merge = ...
            Lines(all(ismember(Lines{:,{'Bus1','Bus2'}},Lines{k_Line,{'Bus1','Bus2'}}),2),:);        
        Lines.Length(ismember(Lines.Name,Lines2Merge.Name(1))) = ...
            Lines.Length(ismember(Lines.Name,Lines2Merge.Name(1))) / 2;        
        Lines.Bus1(ismember(Lines.Name,Lines2Merge.Name(2))) = k_Line2Del;
        Lines.Bus2(ismember(Lines.Name,Lines2Merge.Name(2))) = k_Line2Del;
        k_Line2Del = k_Line2Del + 1;
        Lines2Del(k_Line2Del,1) = Lines2Merge.Name(2);
    end
end
Lines(ismember(Lines.Name,Lines2Del),:) = [];

NodesOccurTwice = AllNodesID(AllNodesCount == 2);

while numel(NodesOccurTwice) > 0
    NodeToDel = NodesOccurTwice(1);
    Lines2Merge = Lines(ismember(Lines.Bus1,NodeToDel) | ismember(Lines.Bus2,NodeToDel),:);
%     Lines2Merge = sortrows(Lines2Merge,'Name','ascend');
%     if any(ismember(Lines2Del,Lines2Merge.Name(2)))
%         Lines2Merge = sortrows(Lines2Merge,'Name','descend');
%     end
    if ~all(Lines2Merge{1,{'Bus1','Bus2'}} == Lines2Merge{2,{'Bus1','Bus2'}})
        Lines.Length(ismember(Lines.Name,Lines2Merge.Name(1))) = sum(Lines2Merge.Length);
        if find(ismember(Lines2Merge{1,{'Bus1','Bus2'}},NodeToDel)) == 2
            Lines.Bus2(ismember(Lines.Name,Lines2Merge.Name(1))) = Lines.Bus2(ismember(Lines.Name,Lines2Merge.Name(2)));
        else
            Lines.Bus1(ismember(Lines.Name,Lines2Merge.Name(1))) = Lines.Bus1(ismember(Lines.Name,Lines2Merge.Name(2)));
        end
    else % merge parralel lines
        Lines.Length(ismember(Lines.Name,Lines2Merge.Name(1))) = ...
            Lines.Length(ismember(Lines.Name,Lines2Merge.Name(1))) / 2;
    end
    Lines(ismember(Lines.Name,Lines2Merge.Name(2)),:) = [];
    NodeOccurInLines = [Lines.Bus1; Lines.Bus2];
    AllNodesID       = unique(NodeOccurInLines);
    AllNodesCount    = histc(NodeOccurInLines(:), AllNodesID);
    NodesOccurTwice  = AllNodesID(AllNodesCount == 2);
end
Buscoords(~ismember(Buscoords.Busname,AllNodesID),:) = [];

end

