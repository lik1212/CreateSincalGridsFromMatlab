function Loads = Loads2allPhase(Loads)
%LOADS2ALLPHASE Summary of this function goes here
%   Detailed explanation goes here
num_Loads = size(Loads,1);
Loads = repmat(Loads,3,1);
Loads.phases(                1 :     num_Loads) = {'A'};
Loads.phases(    num_Loads + 1 : 2 * num_Loads) = {'B'};
Loads.phases(2 * num_Loads + 1 : 3 * num_Loads) = {'C'};
Loads.Name(                1 :     num_Loads) = strcat(Loads.Name(                1 :     num_Loads),'L1');
Loads.Name(    num_Loads + 1 : 2 * num_Loads) = strcat(Loads.Name(    num_Loads + 1 : 2 * num_Loads),'L2');
Loads.Name(2 * num_Loads + 1 : 3 * num_Loads) = strcat(Loads.Name(2 * num_Loads + 1 : 3 * num_Loads),'L3');
end

