function [Buscoords, Lines]        = CorrectionAssumption(Buscoords, Lines)
%CORRECTIONASSUMPTION Summary of this function goes here
%   Detailed explanation goes here
% Buscoords(Buscoords.Busname == 606,:) = [];
% Lines(605,:).Bus2 = 596;
% Lines(594,:) = [];
% Lines(594,:).Bus2 = 606;
% Lines(594,:).Length = Lines(595,:).Length;
% Lines = [Lines;Lines(594,:)];
% Lines(906,:).Bus1 = 596;
% Lines(906,:).Bus2 = 595;
% Lines(594,:).Name = {'LINE594a'};
% Lines(906,:).Name = {'LINE594b'};
Lines(ismember(Lines.Name,'LINE107'),:) = [];
Lines(ismember(Lines.Name,'LINE90'),:).Length = ...
    Lines(ismember(Lines.Name,'LINE90'),:).Length + ...
    Lines(ismember(Lines.Name,'LINE103'),:).Length/2;
Lines(ismember(Lines.Name,'LINE103'),:) = [];
Lines(ismember(Lines.Name,'LINE90'),:).Bus2 = 596;
Buscoords(Buscoords.Busname == 587,:) = [];
Lines(ismember(Lines.Name,'LINE95'),:).Length = ...
    Lines(ismember(Lines.Name,'LINE95'),:).Length/2;
end

