%% Demo Matlab2Sincal add files in Sincal
%
% Demo script that shows how to add Nodes, DCInfeeder etc... from Matlab
% into a Sincal grid
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Clear start

clear, close, clc, path(pathdef);

%% User Path and File Setup

SinName     = 'TempEmpty';
store_orig  = true;                 % Option to save original(initial) grid

%% Standard Path Setup

path_split = strsplit(pwd,'\');
SinPath    = [strjoin(path_split(1:end-1),'\'),'\SincalGrid\'  ];
addpath(     [strjoin(path_split(1:end-1),'\'),'\Sub-functions']);

%% Save the original(initial) grid by user's wish
%  In this way a copy of the original grid will be made with the prefix
%  "_original". It is suggested to use this option.
if store_orig
    FileExist = CopySinFile(SinName, [SinName,'_original'], SinPath);
    if FileExist
        return;     % Stop the scipt if new (copy) file exists.
    end
end

%% Prepare new (to be added) Nodes 

NodeInput = table;
NodeInput.Name = {'N1'; 'N5'; 'N9'; 'N13'};
NodeInput.PosX = [0.10; 0.15; 0.20; 0.25];      % NodeStartX & NodeEndX
NodeInput.PosY = [0.20; 0.20; 0.20; 0.20];      % NodeStartY & NodeEndY
NodeInput.Un   = [20  ; 10  ;    1;    1];      % Nominal voltage

%% Function to add Nodes

Mat2Sin_AddNode(NodeInput, SinName, SinPath)

%% Check if Nodes are added

SinInfo  = Mat2Sin_GetSinInfo(SinName, SinPath);

%% Prepare new (to be added) TwoWindingTransformer (TR2W)

TR2WInput = table;
TR2WInput.Name  = {'2T1'; '2T2'};
TR2WInput.Node1 = {'N1' ; 'N5' };
TR2WInput.Node2 = {'N5' ; 'N9' };

%% Function to add TwoWindingTransformer

Mat2Sin_AddTR2W(TR2WInput, SinName, SinPath)

%% Prepare new (to be added) Infeeder

InfeederInput = table;
InfeederInput.Name = 'I1';
InfeederInput.Node     = NodeInput.Name(1);
InfeederInput.LengthY  = 0.04 * ones(1,1); 

%% Function to add Infeeder Files

Mat2Sin_AddInfeeder(InfeederInput, SinName, SinPath)

%% Prepare new (to be added) Lines

LineInput = table;
LineInput.Name  = { 'L1'};
LineInput.Node1 = { 'N9'};
LineInput.Node2 = {'N13'};

%% Function to add Line Files

Mat2Sin_AddLine(LineInput, SinName, SinPath)

%% Prepare new (to be added) DC_Infeeders

DCIInput = table;
DCIInput.Name    = strrep(cellstr(strcat('DCI',num2str(reshape(1:size(SinInfo.Node,1),[],1)))),' ','');
DCIInput.Node    = SinInfo.Node.Name;
DCIInput.LengthY = 0.02 * ones(size(SinInfo.Node,1),1); 
% DCIInput(strcmp(DCIInput.Node, 'N1'),:) = [];           % An ONS kein DCI

%% Function to add DC_Infeeder Files

Mat2Sin_AddDCI(DCIInput, SinName, SinPath)

%% Prepare new (to be added) Loads

LoadInput = table;
LoadInput.Name    = strrep(cellstr(strcat('LO',num2str(reshape(1:size(SinInfo.Node,1),[],1)))),' ','');
LoadInput.Node    = SinInfo.Node.Name;
LoadInput.LengthY = - 0.02 * ones(size(SinInfo.Node,1),1); 

%% Function to add Load Files

Mat2Sin_AddLoad(LoadInput, SinName, SinPath)