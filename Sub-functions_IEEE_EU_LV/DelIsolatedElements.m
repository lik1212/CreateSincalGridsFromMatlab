function [Buscoords, Lines] = DelIsolatedElements(Buscoords, Lines)
%DELISOLATEDELEMENTS Summary of this function goes here
%   Detailed explanation goes here
IsolatedBus = [...
     89,...
    103,...
    169,...
    183,...
    201,...
    219,...
    234,...
    290,...
    469,...
    507,...
    566,...
    608,...
    617,...
    681,...
    830,...
    845,...
    851,...
    857,...
    864,...
    869,...
    875,...
    881,...
    ];
Buscoords(ismember(Buscoords.Busname,IsolatedBus),:) = [];
IsolatedLines = {...
    'LINE11' ,...                                           
    'LINE12' ,...
    'LINE16' ,...
    'LINE21' ,...
    'LINE23' ,...
    'LINE25' ,...
    'LINE38' ,...
    'LINE39' ,...
    'LINE67' ,...
    'LINE73' ,...
    'LINE89' ,...
    'LINE96' ,...
    'LINE111',...
    'LINE165',...
    'LINE166',...
    'LINE167',...
    'LINE181',...
    'LINE182',...
    'LINE183',...
    'LINE184',...
    'LINE185',...
    'LINE186',...
    'LINE100',...
    'LINE101',...
    'LINE160',...
    'LINE176',...
    'LINE177',...
    'LINE178',...
    'LINE179',...
    'LINE180',...
    };
Lines(ismember(Lines.Name,IsolatedLines),:) = [];
end