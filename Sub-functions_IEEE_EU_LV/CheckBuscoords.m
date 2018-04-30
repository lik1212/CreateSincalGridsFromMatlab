function [Buscoords_new, Lines_new, Loads_new] = CheckBuscoords(Buscoords, Lines, Loads)

%% It seems that in Buscoords come Nodes occur twice
%  This script will check that

%% Main

% clear;

% GridInfoPath = [pwd,'\European_LV_CSV\'];
% Buscoords    = readtable([GridInfoPath, 'Buscoords.csv'  ],'HeaderLines',1);
% Lines        = readtable([GridInfoPath, 'Lines.csv'      ],'HeaderLines',1);

%%

temp1 = unique(Buscoords{:,2:3},'rows');
Buscoords_double = zeros((size(Buscoords,1) - size(temp1,1)),2);
Lines_double = cell((size(Buscoords,1) - size(temp1,1)),2);
k_double = 0;
for k_t = 1 : size(temp1,1)
    if sum(all(ismember(Buscoords{:,2:3},temp1(k_t,:)),2)) ~= 1
        k_double = k_double + 1;
        Buscoords_double(k_double,1:2) = ...
            Buscoords.Busname(all(ismember(Buscoords{:,2:3},temp1(k_t,:)),2))';
        Lines_double(k_double,1:2) = ...
            Lines(ismember(Lines.Bus2,Buscoords_double(k_double,:)),:).Name';
    end
end

Buscoords_new = Buscoords;
Lines_new     = Lines;
Loads_new = Loads;
Buscoords_new(ismember(Buscoords_new.Busname,Buscoords_double(:,2)),:) = [];

for k = 1 : size(Buscoords_double,1)
    Lines_new.Bus2(Lines_new.Bus2 == Buscoords_double(k,2)) = Buscoords_double(k,1);
    Loads_new.Bus(Loads_new.Bus == Buscoords_double(k,2)) = Buscoords_double(k,1);
end




