%% Script to create the IEEE LV EU Test Feeder
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Clear start

clear, close, clc, path(pathdef);

%% User Path and File Setup

SinPath      = [pwd,'\SincalGrid\'     ];
GridInfoPath = [pwd,'\European_LV_CSV\'];
SinName      = 'IEEE_LV_EU_TestFeeder';
store_orig   = false;                % Option to save original(initial) grid
add_DCInfeed = false;

%% Standard Path Setup

path_split  = strsplit(pwd,'\');
addpath([strjoin(path_split,'\'),'\Sub-functions'           ]);
addpath([strjoin(path_split,'\'),'\Sub-functions_IEEE_EU_LV']);

%% Save the original(initial) grid by user's wish
%  In this way a copy of the original grid will be made with the prefix
%  "_original". It is suggested to use this option.
if store_orig
    FileExist = CopySinFile(SinName, [SinName,'_original'], SinPath);
    if FileExist
        return;     % Stop the scipt if new (copy) file exists.
    end
end

%% Read in Grid Information

% Suppress small warnings in the readtable part
warning('off','MATLAB:table:ModifiedAndSavedVarnames')
Buscoords   = readtable([GridInfoPath, 'Buscoords.csv'  ],'HeaderLines',1);
LineCodes   = readtable([GridInfoPath, 'LineCodes.csv'  ],'HeaderLines',1);
Lines       = readtable([GridInfoPath, 'Lines.csv'      ],'HeaderLines',1);
Loads       = readtable([GridInfoPath, 'Loads.csv'      ],'HeaderLines',2);
LoadShapes  = readtable([GridInfoPath, 'LoadShapes.csv' ],'HeaderLines',1);
Transformer = readtable([GridInfoPath, 'Transformer.csv'],'HeaderLines',1);
Source      = readtable([GridInfoPath, 'Source.csv'     ],'ReadVariableNames', 0,'Delimiter', '=');
warning('on','MATLAB:table:ModifiedAndSavedVarnames')

%% TODO -> Reduce num of Nodes

[Buscoords, Lines]        = ReduceNumNodes(Buscoords, Lines);
[Buscoords, Lines, Loads] = CheckBuscoords(Buscoords, Lines, Loads);
[Loads]                   = Loads2allPhase(Loads);
[Buscoords, Lines]        = DelIsolatedElements(Buscoords, Lines);
[Buscoords, Lines]        = MergeUnnecessaryElements(Buscoords, Lines);
[Buscoords, Lines]        = CorrectionAssumption(Buscoords, Lines);

add_DCInfeed = true;

%%

% Add Infeeder (Source) Node
Buscoords{size(Buscoords,1) + 1,:} = [0, Buscoords.x(1), Buscoords.y(1) + 4];
Buscoords = [Buscoords(end,:); Buscoords(1 : end -1,:)];

Transformer.bus1 = 0;

Source = cell2table(Source.Var2','VariableNames',Source.Var1');

%% Assumptions for I_th

LineCodes.Ith(:) = 0;
LineCodes.Ith(ismember(LineCodes.Name,'4c_.35'))       = 0.150; % No Type, but 35
LineCodes.Ith(ismember(LineCodes.Name,'4c_185'))       = 0.322; % NAKLEY 185
LineCodes.Ith(ismember(LineCodes.Name,'4c_.1'))        = 0.213; % NKLEY 70
LineCodes.Ith(ismember(LineCodes.Name,'4c_95_SAC_XC')) = 0.203; % NAKLEY 95
LineCodes.Ith(ismember(LineCodes.Name,'4c_70'))        = 0.236; % NA2XSY 70
LineCodes.Ith(ismember(LineCodes.Name,'4c_.06'))       = 0.236; % NA2XSY 70       
LineCodes.Ith(ismember(LineCodes.Name,'35_SAC_XSC'))   = 0.136; % NA2XY 35
LineCodes.Ith(ismember(LineCodes.Name,'2c_16'))        = 0.102; % NYY 16
LineCodes.Ith(ismember(LineCodes.Name,'2c_.0225'))     = 0.135; % F-AL 25
LineCodes.Ith(ismember(LineCodes.Name,'2c_.007'))      = 0.059; % NYY 4

%% Prepare new (to be added) Nodes 

Page_XRange = [0 0.420];
Page_YRange = [0 0.297];
Buscoords.x = 0.005 + ...
    (    Buscoords.x -  min(Buscoords.x)) /...
    (max(Buscoords.x) - min(Buscoords.x)) * (Page_XRange(2) - 0.01);
Buscoords.y = 0.005 + ...
    (    Buscoords.y -  min(Buscoords.y)) /...
    (max(Buscoords.y) - min(Buscoords.y)) * (Page_YRange(2) - 0.01);

NodeInput = table;
NodeInput.Name         = ...
    strrep(cellstr(strcat(...
    'N',num2str(reshape(Buscoords.Busname,[],1)))),' ','');
NodeInput.NodeStartX   = Buscoords.x;
NodeInput.NodeStartY   = Buscoords.y;
NodeInput.Un           = [11  ; 0.4 * ones(size(Buscoords,1) - 1, 1)];	% Nominal voltage
NodeInput.Flag_Diagram = ones(size(Buscoords,1),1);                   	% Marked (optional)

%% Function to add Nodes

Mat2Sin_AddNode(NodeInput, SinName, SinPath)

%% Prepare new (to be added) Lines

LineInput = table;
% LineInput.Name       = ...
%     strrep(cellstr(strcat(...
%     'L',num2str(reshape(1:size(Lines,1),[],1)))),' ','');
LineInput.Name       = Lines.Name;
LineInput.Node1      = ...
    strrep(cellstr(strcat(...
    'N',num2str(Lines.Bus1))),' ','');
LineInput.Node2      = ...
    strrep(cellstr(strcat(...
    'N',num2str(Lines.Bus2))),' ','');
LineInput.l             = Lines.Length * 10^-3;             % km
LineInput.Flag_Input    = 7 * ones(size(LineInput,1),1);    % with zero-phase
LineInput.Flag_Z0_Input = 2 * ones(size(LineInput,1),1);    % zero-phase as r0 and x0
LineInput.Flag_Cur      = ones(size(LineInput,1),1);     	% Marked (optional)
for k_LCod = 1 : size(LineCodes,1)
    LineInput.r  (strcmp(Lines.LineCode,LineCodes.Name{k_LCod})) = LineCodes.R1 (k_LCod);
    LineInput.x  (strcmp(Lines.LineCode,LineCodes.Name{k_LCod})) = LineCodes.X1 (k_LCod);
    LineInput.c  (strcmp(Lines.LineCode,LineCodes.Name{k_LCod})) = LineCodes.C1 (k_LCod);
    LineInput.r0 (strcmp(Lines.LineCode,LineCodes.Name{k_LCod})) = LineCodes.R0 (k_LCod);
    LineInput.x0 (strcmp(Lines.LineCode,LineCodes.Name{k_LCod})) = LineCodes.X0 (k_LCod);
    LineInput.c0 (strcmp(Lines.LineCode,LineCodes.Name{k_LCod})) = LineCodes.C0 (k_LCod);
    LineInput.Ith(strcmp(Lines.LineCode,LineCodes.Name{k_LCod})) = LineCodes.Ith(k_LCod);
    LineInput.X0_X1 = LineInput.x0 ./ LineInput.x;
    LineInput.R0_R1 = LineInput.r0 ./ LineInput.r;
end
    
%% Function to add Line Files

Mat2Sin_AddLine(LineInput, SinName, SinPath)

%% Prepare new (to be added) Loads

LoadInput = table;
LoadInput.Name       = Loads.Name;
LoadInput.Node       =  ...
    strrep(cellstr(strcat(...
    'N',num2str(Loads.Bus))),' ','');             % To check later
LoadInput.LengthY    = - 0.0025  * ones(size(LoadInput,1),1);
LoadInput.SymbolSize = 25        * ones(size(LoadInput,1),1);
LoadInput.P          = 2 * 10^-3 * ones(size(LoadInput,1),1);   % Temp
LoadInput.cosphi     = 0.95      * ones(size(LoadInput,1),1);   % Temp 
LoadInput.Flag_Lf    = 11        * ones(size(LoadInput,1),1);   % Temp (P, cosphi)
LoadInput.Flag_Cur   = zeros(size(LoadInput,1),1);              % Not Marked (optional)

% For phases:

LoadInput.Flag_Terminal(strcmp(Loads.phases,'A')) = 1;
LoadInput.Flag_Terminal(strcmp(Loads.phases,'B')) = 2;
LoadInput.Flag_Terminal(strcmp(Loads.phases,'C')) = 3;

%% Function to add Load Files

Mat2Sin_AddLoad(LoadInput, SinName, SinPath)

%%  Prepare and add new (to be addes) DCInfeeders (Optional)

if add_DCInfeed
    DCIInput = LoadInput;
    DCIInput.Name          = strrep(DCIInput.Name,'LOAD','PV'); % Adjust names
    DCIInput.LengthY       = - DCIInput.LengthY;                % DC symbol up
    DCIInput.SymbolType(:) = 193;                               % PV system symbol
    DCIInput.SymbolDef(:)  = 2;                                 % PV system symbol
    DCIInput.Flag_Lf       = [];
    DCIInput.cosphi        = [];
    Mat2Sin_AddDCI(DCIInput, SinName, SinPath);
end

%% Prepare new (to be added) TwoWindingTransformer (TR2W)

TR2WInput = table;
TR2WInput.Name       = Transformer.Name;
TR2WInput.Node1      = strcat('N',num2str(Transformer.bus1));
TR2WInput.Node2      = strcat('N',num2str(Transformer.bus2));
TR2WInput.Sn         = Transformer.MVA;
TR2WInput.Un1        = Transformer.kV_pri;
TR2WInput.Un2        = Transformer.kV_sec;
TR2WInput.VecGrp     = 24;                          % DYN5
TR2WInput.uk         = Transformer.x_XHL;
TR2WInput.ur         = Transformer.x_Resistance;
TR2WInput.SymbolSize = 25;
TR2WInput.Flag_Cur = 1;                           % Marked

%% Function to add TwoWindingTransformer

Mat2Sin_AddTR2W(TR2WInput, SinName, SinPath)

%% Prepare new (to be added) Infeeder

% Prepare parameters

Source.cu_max   = str2double(strrep(Source.pu     {:},' '  ,''));  % Voltage factor for short circuit min. value
Source.cu_min   = 0.95;                                            % No information in input table
Source.Un       = str2double(strrep(Source.Voltage{:},' kV',''));  % Nominal voltage of Source
Source.ISC3_abs = str2double(strrep(Source.ISC3   {:},' A' ,''));  % 3-phase short circuit current (max)
Source.ISC1_abs = str2double(strrep(Source.ISC1   {:},' A' ,''));  % 1-phase short circuit current (min)
Source.u        = str2double(Source.pu{:}) * 100;                  % Voltage of Infeeder

% I_sc = (cu * U_n) / (sqrt(3) * X )    % Assumption Z = X, since:

Source.Xmax = (Source.cu_max * Source.Un * 10^3) / Source.ISC3_abs;
Source.Xmin = (Source.cu_min * Source.Un * 10^3) / Source.ISC1_abs;

InfeederInput = table;
InfeederInput.Name          = 'I1';
InfeederInput.Node          = NodeInput.Name(1);
InfeederInput.LengthY       = 0.04;
InfeederInput.Flag_Typ      = 1;                    % State - Input as R and X
InfeederInput.X             = Source.Xmax;
InfeederInput.Xmax          = Source.Xmax;
InfeederInput.Xmin          = Source.Xmin;
InfeederInput.LengthY       = 0.0025;
InfeederInput.SymbolSize    = 25;
InfeederInput.Flag_Z0       = 1;                    % Fixed grounded
InfeederInput.Flag_Z0_Input = 1;                    % Zero-Phase Sequence Input Data ->  Z0/Z1 and R0/X0
InfeederInput.Z0_Z1         = 1;
InfeederInput.R0_X0         = 0.1;
InfeederInput.u             = Source.u;             
InfeederInput.Flag_Cur      = 1;                 	% Marked (optional)
% InfeederInput.Sk2max     = 3000 * 11 * 10^-3 * 1.05;   % Temp
% InfeederInput.Sk2min     =    5 * 11 * 10^-3 * 0.95;   % Temp

%% Function to add Infeeder Files

Mat2Sin_AddInfeeder(InfeederInput, SinName, SinPath)
