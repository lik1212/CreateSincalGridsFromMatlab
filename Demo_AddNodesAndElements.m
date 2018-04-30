%% Demo Matlab2Sincal add files in Sincal
%
% Demo script that shows how to add Nodes, DCInfeeder etc... from Matlab
% into a Sincal grid
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Clear start

clear, close, clc, path(pathdef);

%% User Path and File Setup

SinPath     = [pwd,'\SincalGrid\'];
SinName     = 'TempEmpty';
store_orig  = true;                 % Option to save original(initial) grid

%% Standard Path Setup

path_split  = strsplit(pwd,'\');
addpath([strjoin(path_split,'\'),'\Sub-functions']);

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
NodeInput.Name       = {'N1'; 'N5'; 'N9'; 'N13'};
NodeInput.NodeStartX = [0.10; 0.15; 0.20; 0.25];      % NodeStartX & NodeEndX
NodeInput.NodeStartY = [0.20; 0.19; 0.20; 0.18];      % NodeStartY & NodeEndY
NodeInput.Un         = [20  ; 10  ; 1   ; 1   ];      % Nominal voltage
NodeInput.NodeEndX   = [0.10; 0.14; 0.21; 0.26];      % NodeEndX       (optional)
NodeInput.NodeEndY   = [0.20; 0.21; 0.20; 0.22];      % NodeEndY       (optional)
NodeInput.Uref       = [20.5; 10.5; 1.1 ; 1.1 ];      % Target voltage (optional)
NodeInput.PenWidth   = [1   ; 2   ; 3   ; 4   ];      % Node Size      (optional)
NodeInput.SymType    = [1   ; 3   ; 3   ; 3   ];      % Symbol Type    (optional)

%% Function to add Nodes

Mat2Sin_AddNode(NodeInput, SinName, SinPath)

%% Prepare new (to be added) TwoWindingTransformer (TR2W)

TR2WInput = table;
TR2WInput.Name       = {'2T1'   ; '2T2'};
TR2WInput.Node1      = {'N1'    ; 'N5' };
TR2WInput.Node2      = {'N5'    ; 'N9' };
TR2WInput.Sn         = {0.63    ; 0.4  }; % Rated Apparent Power  (optional)
TR2WInput.VecGrp     = {6       ; 52   }; % Vector Group          (optional)
TR2WInput.Ir         = {24      ; 22   }; % Rated current         (optional)
TR2WInput.TextVal    = {'Ja'    ; '3PO'}; % Comment               (optional)
TR2WInput.SymbolSize = {100     ; 200  }; % Symbol Size Factor    (optional)
TR2WInput.FrgndColor = {16711680; 255  }; % Line Color            (optional)
TR2WInput.Un1        = {20.5    ; 10.1 }; % Rated Voltage, Side 1 (optional)
TR2WInput.Un2        = {10.4    ; 0.9  }; % Rated Voltage, Side 2 (optional)

%% Function to add TwoWindingTransformer

Mat2Sin_AddTR2W(TR2WInput, SinName, SinPath)

%% Prepare new (to be added) Infeeder

InfeederInput = table;
InfeederInput.Name       = 'I1';
InfeederInput.Node       = NodeInput.Name(1);
InfeederInput.LengthY    = 0.04; 
InfeederInput.R          = 0.22;      % Active Resistance  (optional)
InfeederInput.Ir         = 50.9;      % Rated current      (optional)
InfeederInput.TextVal    = 'MS-Netz'; % Comment            (optional)
InfeederInput.SymbolSize = 20;        % Symbol Size Factor (optional)
InfeederInput.FrgndColor = 65280;     % Line Color         (optional)

%% Function to add Infeeder Files

Mat2Sin_AddInfeeder(InfeederInput, SinName, SinPath)

%% Prepare new (to be added) Lines

LineInput = table;
LineInput.Name       = { 'L1' };
LineInput.Node1      = { 'N9' };
LineInput.Node2      = {'N13' };
LineInput.r          = {0.179 }; % Resistance         (optional)
LineInput.Ir         = {24.7  }; % Rated current      (optional)
LineInput.TextVal    = {'R2D2'}; % Comment            (optional)
LineInput.PenWidth   = {5     }; % Symbol Size Factor (optional)
LineInput.FrgndColor = {161231}; % Line Color         (optional)

%% Function to add Line Files

Mat2Sin_AddLine(LineInput, SinName, SinPath)

%% Prepare new (to be added) DC_Infeeders

DCIInput = table;
DCIInput.Name       = {'DCI1'; 'DCI2'; 'DCI3'};
DCIInput.Node       = {'N5'  ; 'N9'  ; 'N13' };
DCIInput.LengthY    = [0.02  ; 0.02  ; 0.02  ];
DCIInput.P          = {0.05  ; 0.11  ; 0.01  }; % Active Power       (optional)
DCIInput.Ir         = {1     ; 9     ; 5     }; % Rated current      (optional)
DCIInput.TextVal    = {'One' ; 'Two' ; 'Ze'  }; % Comment            (optional)
DCIInput.SymbolSize = {10    ; 30    ; 50    }; % Symbol Size Factor (optional)
DCIInput.FrgndColor = {156335; 9006  ; 54368 }; % Line Color         (optional)

%% Function to add DC_Infeeder Files

Mat2Sin_AddDCI(DCIInput, SinName, SinPath)

%% Prepare new (to be added) Loads

LoadInput = table;
LoadInput.Name       = {'LO1' ; 'LO2' ; 'LO3'; 'LO4'};
LoadInput.Node       = {'N1'  ; 'N5'  ; 'N9' ; 'N13'};
LoadInput.LengthY    = - 0.02 * ones(size(LoadInput,1),1); 
LoadInput.P          = {0.05  ; 0.11  ; 0.01 ; 0.01 };      % Active Power       (optional)
LoadInput.Ir         = {1     ; 9     ; 5    ; 20   };      % Rated current      (optional)
LoadInput.TextVal    = {'One' ; 'Two' ; 'Ze' ; 'Uno'};      % Comment            (optional)
LoadInput.SymbolSize = {40    ; 60    ; 100   ; 200 };      % Symbol Size Factor (optional)
LoadInput.FrgndColor = {156335; 9006  ; 54368; 5    };      % Line Color         (optional)

%% Function to add Load Files

Mat2Sin_AddLoad(LoadInput, SinName, SinPath)