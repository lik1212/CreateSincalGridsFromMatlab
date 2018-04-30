function [Buscoords_new, Lines_new] = ReduceNumNodes(Buscoords, Lines)

%% Connect Lines that arr part of the same Line to one Line
% In the initial IEEE LV Test Feeder, they are additional Nodes at most
% Lines, that split the Lines in smaller Line-part. In this Script this
% Nodes are deleted and the Lines-parts put into one Line

%%

% dbstop in ReduceNumNodes if error

Nd_in_Li  = [Lines.Bus1; Lines.Bus2];                     	% All Nodes (Nd) in Lines (Li)
uni_Nd    = unique(Nd_in_Li);                               % Unique (uni) Nodes in Lines  occurrence (oc)
Nd_oc     = histc(Nd_in_Li, uni_Nd);                        % Number of occurrence (oc) of each Node
Nd_oc_set = ...                                             % Set of unique num and there occurrence
    table(uni_Nd, Nd_oc,'VariableNames',{'Node','Occur'});
Main_Nds  = Nd_oc_set(Nd_oc_set.Occur ~= 2,:);              % Main Nodes (that should not be connected)
% Redu_Nds  = Nd_oc_set(Nd_oc_set.Occur == 2,:);              % Redundant Nodes (that should be connected)

Li_S  = struct;                                             % Final Line struct
Nd_S  = struct;                                             % Final Node struct
k_f   = 0;                                                  % Number of struct field

Lines_cut = Lines;

ft_Main_Node = Main_Nds.Node(find(Main_Nds.Occur ~= 0,1)); 	% First node of line
while ~isempty(ft_Main_Node)                                % While Main Nodes occur
    k_f = k_f + 1;                                          % New struct field (new full line)
    k_N_e = 1;                                              % Element No. in Node struct
    k_L_e = 0;                                              % Element No. in Line struct
    ft_Nd = ft_Main_Node;
    Nd_S.(['Group',num2str(k_f)])(k_N_e,1) = ...              % First Node
        ft_Nd;
    nw_Li_pos = find(any(Lines_cut{:,2:3} == ft_Nd,2),1);               % New Line position
    nw_Li = Lines_cut(nw_Li_pos,:);                          % New Line
    while ~isempty(nw_Li)         % Element in Line struct
        k_L_e = k_L_e + 1;
        if k_L_e == 1
            Li_S.(['Group',num2str(k_f)]) = nw_Li;
        else
            Li_S.(['Group',num2str(k_f)]) = [...
                Li_S.(['Group',num2str(k_f)]);...
                nw_Li];      % Add new Line
        end
        sd_Nd = setdiff(Lines_cut{nw_Li_pos,2:3}, ft_Nd);      % Find second Node of line
        k_N_e = k_N_e + 1;
        ft_Nd = sd_Nd;
        Nd_S.(['Group',num2str(k_f)])(k_N_e,1) = ft_Nd;       % Add second Node
        Lines_cut(nw_Li_pos,:) = [];
        nw_Li_pos = find(any(Lines_cut{:,2:3} == ft_Nd,2),1);               % New Line position
        if ismember(ft_Nd,Main_Nds.Node)
            break;
        end
        nw_Li = Lines_cut(nw_Li_pos,:);                          % New Line
    end
    Main_Nds.Occur(ismember(Main_Nds.Node,[ft_Main_Node,sd_Nd])) = ...
        Main_Nds.Occur(ismember(Main_Nds.Node,[ft_Main_Node,sd_Nd])) - 1;
    ft_Main_Node = Main_Nds.Node(find(Main_Nds.Occur == 1,1)); 	% First node of line
end

%% Check if Lines are not cut, but different type...

num_fields = numel(fields(Li_S));
for k = 1:num_fields
    group_parameters = unique(Li_S.(['Group',num2str(k)]).LineCode);
    group_size       = size(group_parameters,1);
    if group_size ~= 1
        num_new_groups = group_size - 1;
        for k_new = 1 : num_new_groups
            num_fields = num_fields + 1;
            Li_S.(['Group',num2str(num_fields)]) = ...
                Li_S.(['Group',num2str(k)])(ismember(Li_S.(['Group',num2str(k)]).LineCode,group_parameters(k_new)),:);
            Li_S.(['Group',num2str(k)])(ismember(Li_S.(['Group',num2str(k)]).LineCode,group_parameters(k_new)),:) = [];
            Nd_S.(['Group',num2str(num_fields)]) = unique((Li_S.(['Group',num2str(num_fields)]){:,2:3}))';
            Nd_S.(['Group',num2str(k)]) = unique((Li_S.(['Group',num2str(k)]){:,2:3}))';
        end
    end
end

%%
num_fields = numel(fields(Li_S));

Lines_new     = Lines(1:num_fields,:);
Buscoords_new = Buscoords;

for k = 1:num_fields
    Nd_in_Group = Li_S.(['Group',num2str(k)]){:,2:3}(:);
    Nd_in_Group_uq = unique(Nd_in_Group);
    Nd_oc_in_Group = histc(Nd_in_Group,Nd_in_Group_uq);
    main_node = Nd_in_Group_uq(Nd_oc_in_Group == 1);
    redundant_node = Nd_in_Group_uq(Nd_oc_in_Group ~= 1);
    Lines_new.Bus1(k) = main_node(1);
    Lines_new.Bus2(k) = main_node(2);
    Lines_new.Length(k) = sum(Li_S.(['Group',num2str(k)]).Length);
    Lines_new.LineCode(k) = unique(Li_S.(['Group',num2str(k)]).LineCode);
    Buscoords_new(ismember(Buscoords_new.Busname,redundant_node),:) = [];
end