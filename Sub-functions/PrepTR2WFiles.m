function [TwoWindingTransformer, Terminal, Element, GraphicElement, GraphicTerminal] = PrepTR2WFiles(TR2WInput)
%PrepTR2WFiles Prepare Input for Sincal Database (DB) to add new
%TwoWindingTransformers
%
%   The Input for the Sincal Database to add new TwoWindingTransformer are
%   table entries for the tables TwoWindingTransformer, Terminal, Element,
%   GraphicElement and GraphicTerminal. These are prepared with the
%   function.
%
%   [TwoWindingTransformer, Terminal, Element, GraphicElement, GraphicTerminal] = PrepTR2WFiles(TR2WInput)
%
%       TR2WInput           (Required)  - Table with variables:
%                                         .Name       - Name of the new TR2Ws
%                                         .Node1_ID   - ID of the 1. Node TR2W is connected to
%                                         .Node2_ID   - ID of the 2. Node TR2W is connected to
%                                         .SymCenterX - X-Position of the new TR2Ws
%                                         .SymCenterY - Y-Position of the new TR2Ws
%                                         .Un1        - Nominal voltage on primary   TR side
%                                         .Un2        - Nominal voltage on secondary TR side
%                                         .VoltLevel_ID - Voltage Level ID
%                                         .Terminal_ID1        (primary key) - related to Node1
%                                         .Terminal_ID2        (primary key) - related to Node2
%                                         .Element_ID          (primary key)
%                                         .GraphicElement_ID   (primary key)
%                                         .GraphicTerminal_ID1 (primary key) - related to Node1
%                                         .GraphicTerminal_ID2 (primary key) - related to Node2
%                                         ....  - more variables can be added
%       TwoWindingTransformer (Result)  - Table with required entries for the
%                                         Sincal DB table TwoWindingTransformer to add TR2Ws
%       Terminal              (Result)  - Table with required entries for the
%                                         Sincal DB table Terminal to add TR2Ws
%       Element               (Result)  - Table with required entries for the
%                                         Sincal DB table Element to add TR2Ws
%       GraphicElement        (Result)  - Table with required entries for the
%                                         Sincal DB table GraphicElement to add TR2Ws
%       GraphicTerminal       (Result)  - Table with required entries for the
%                                         Sincal DB table GraphicTerminal to add TR2Ws
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Standard Setup

num_TR2W = size(TR2WInput,1);

%% TwoWindingTransformer table with new required entries

TwoWindingTransformer = table;
TwoWindingTransformer.Element_ID        	= TR2WInput.Element_ID;
TwoWindingTransformer.Typ_ID            	= zeros (num_TR2W,1);
TwoWindingTransformer.Flag_Typ_ID       	= zeros (num_TR2W,1);
TwoWindingTransformer.Un1               	= TR2WInput.Un1;
TwoWindingTransformer.Un2               	= TR2WInput.Un2;
TwoWindingTransformer.Sn                	= ones  (num_TR2W,1) * 0.4;
TwoWindingTransformer.Smax              	= zeros (num_TR2W,1);
TwoWindingTransformer.uk                	= ones  (num_TR2W,1) * 8;
TwoWindingTransformer.ur                	= zeros (num_TR2W,1);
TwoWindingTransformer.Vfe               	= zeros (num_TR2W,1);
TwoWindingTransformer.i0                	= zeros (num_TR2W,1);
TwoWindingTransformer.c                 	= ones  (num_TR2W,1) * 1.1;
TwoWindingTransformer.UnG               	= zeros (num_TR2W,1);
TwoWindingTransformer.UnN               	= zeros (num_TR2W,1);
TwoWindingTransformer.UGmax             	= ones  (num_TR2W,1) * 100;
TwoWindingTransformer.cosphiG           	= ones  (num_TR2W,1) * 0.9;
TwoWindingTransformer.VecGrp            	= ones  (num_TR2W,1) * 6;
TwoWindingTransformer.Flag_Side         	= ones  (num_TR2W,1);
TwoWindingTransformer.Flag_Z0_Input     	= ones  (num_TR2W,1);
TwoWindingTransformer.Z0_Z1             	= zeros (num_TR2W,1);
TwoWindingTransformer.R0_X0             	= zeros (num_TR2W,1);
TwoWindingTransformer.R0_R1             	= zeros (num_TR2W,1);
TwoWindingTransformer.X0_X1             	= zeros (num_TR2W,1);
TwoWindingTransformer.R0                	= zeros (num_TR2W,1);
TwoWindingTransformer.X0                	= zeros (num_TR2W,1);
TwoWindingTransformer.ZABNL             	= zeros (num_TR2W,1);
TwoWindingTransformer.ZBANL             	= zeros (num_TR2W,1);
TwoWindingTransformer.ZABSC             	= zeros (num_TR2W,1);
TwoWindingTransformer.Stp_ID1           	= NaN   (num_TR2W,1);
TwoWindingTransformer.Stp_ID2           	= NaN   (num_TR2W,1);
TwoWindingTransformer.Flag_ConNode      	= ones  (num_TR2W,1);
TwoWindingTransformer.ukl               	= zeros (num_TR2W,1);
TwoWindingTransformer.uku               	= zeros (num_TR2W,1);
TwoWindingTransformer.roh               	= zeros (num_TR2W,1);
TwoWindingTransformer.Flag_roh          	= ones  (num_TR2W,1);
TwoWindingTransformer.rohl              	= zeros (num_TR2W,1);
TwoWindingTransformer.rohu              	= zeros (num_TR2W,1);
TwoWindingTransformer.alpha             	= zeros (num_TR2W,1);
TwoWindingTransformer.ukr               	= zeros (num_TR2W,1);
TwoWindingTransformer.Node_ID           	= NaN   (num_TR2W,1);
TwoWindingTransformer.uul               	= ones  (num_TR2W,1) * 103;
TwoWindingTransformer.ull               	= ones  (num_TR2W,1) * 98;
TwoWindingTransformer.Flag_Har          	= ones  (num_TR2W,1);
TwoWindingTransformer.qr                	= ones  (num_TR2W,1);
TwoWindingTransformer.ql                	= zeros (num_TR2W,1);
TwoWindingTransformer.HarImp_ID         	= NaN   (num_TR2W,1);
TwoWindingTransformer.Flag_Reliability  	= zeros (num_TR2W,1);
TwoWindingTransformer.Flag_SF1          	= zeros (num_TR2W,1);
TwoWindingTransformer.Flag_SF2          	= zeros (num_TR2W,1);
TwoWindingTransformer.TransformerType_ID	= NaN   (num_TR2W,1);
TwoWindingTransformer.Overload_ID       	= NaN   (num_TR2W,1);
TwoWindingTransformer.V_S               	= zeros (num_TR2W,1);
TwoWindingTransformer.Flag_ZU           	= zeros (num_TR2W,1);
TwoWindingTransformer.Flag_ZUP          	= ones  (num_TR2W,1) * 3;
TwoWindingTransformer.T_ZU              	= zeros (num_TR2W,1);
TwoWindingTransformer.AddRotate         	= zeros (num_TR2W,1);
TwoWindingTransformer.SatChar_ID        	= NaN   (num_TR2W,1);
TwoWindingTransformer.MasterElm_ID      	= NaN   (num_TR2W,1);
TwoWindingTransformer.roh1              	= zeros (num_TR2W,1);
TwoWindingTransformer.roh2              	= zeros (num_TR2W,1);
TwoWindingTransformer.roh3              	= zeros (num_TR2W,1);
TwoWindingTransformer.Flag_Ct           	= zeros (num_TR2W,1);
TwoWindingTransformer.uk_Ct             	= ones  (num_TR2W,1) * 16;
TwoWindingTransformer.ur_Ct             	= zeros (num_TR2W,1);
TwoWindingTransformer.StpCt_ID          	= NaN   (num_TR2W,1);
TwoWindingTransformer.CompImp_ID        	= NaN   (num_TR2W,1);
TwoWindingTransformer.Flag_CompNode     	= ones  (num_TR2W,1) * 2;
TwoWindingTransformer.Smax1             	= zeros (num_TR2W,1);
TwoWindingTransformer.Smax2             	= zeros (num_TR2W,1);
TwoWindingTransformer.Smax3             	= zeros (num_TR2W,1);
TwoWindingTransformer.Flag_Inrush       	= zeros (num_TR2W,1);
TwoWindingTransformer.U_inrush          	= zeros (num_TR2W,1);
TwoWindingTransformer.I_inrush          	= ones  (num_TR2W,1) * 0.1;
TwoWindingTransformer.t_inrush          	= ones  (num_TR2W,1) * 0.05;
TwoWindingTransformer.InCur_ID          	= zeros (num_TR2W,1);
TwoWindingTransformer.rohm              	= zeros (num_TR2W,1);
TwoWindingTransformer.TransformerTap_ID 	= NaN   (num_TR2W,1);
TwoWindingTransformer.Proh              	= zeros (num_TR2W,1);
TwoWindingTransformer.Qroh              	= zeros (num_TR2W,1);
TwoWindingTransformer.phi               	= zeros (num_TR2W,1);
TwoWindingTransformer.Flag_Macro        	= zeros (num_TR2W,1);
TwoWindingTransformer.Macro_ID          	= NaN   (num_TR2W,1);
TwoWindingTransformer.Flag_Variant      	= ones  (num_TR2W,1);
TwoWindingTransformer.Variant_ID        	= ones  (num_TR2W,1);
TwoWindingTransformer.ResFlux1          	= zeros (num_TR2W,1);
TwoWindingTransformer.ResFlux2          	= zeros (num_TR2W,1);
TwoWindingTransformer.ResFlux3          	= zeros (num_TR2W,1);
TwoWindingTransformer.Proh2             	= zeros (num_TR2W,1);
TwoWindingTransformer.Qroh2             	= zeros (num_TR2W,1);
TwoWindingTransformer.RX_ZABNL          	= zeros (num_TR2W,1);
TwoWindingTransformer.RX_ZBANL          	= zeros (num_TR2W,1);
TwoWindingTransformer.RX_ZABSC          	= zeros (num_TR2W,1);
TwoWindingTransformer.TransformerCon_ID 	= NaN   (num_TR2W,1);
TwoWindingTransformer.Flag_Tap          	= zeros (num_TR2W,1);
TwoWindingTransformer.Flag_Step         	= zeros (num_TR2W,1);
TwoWindingTransformer.Flag_Ph           	= ones  (num_TR2W,1) * 8;
TwoWindingTransformer.Flag_Boost        	= zeros (num_TR2W,1);
TwoWindingTransformer.CtrlRange_ID      	= NaN   (num_TR2W,1);
TwoWindingTransformer.Flag_Damage       	= ones  (num_TR2W,1);
TwoWindingTransformer.Ctrl_OpSer_ID     	= zeros (num_TR2W,1);
TwoWindingTransformer.Ctrl_OpPnt_ID     	= zeros (num_TR2W,1);

%% Terminal table with new required entries

Terminal = table;
Terminal.Terminal_ID  		= [TR2WInput.Terminal_ID1; TR2WInput.Terminal_ID2];
Terminal.Element_ID   		= repmat(TR2WInput.Element_ID, 2, 1);
Terminal.Node_ID      		= [TR2WInput.Node1_ID; TR2WInput.Node2_ID];
Terminal.Variant_ID   		= ones  (num_TR2W * 2, 1);
Terminal.TerminalNo   		= repelem([1; 2] , num_TR2W, 1);
Terminal.Flag_State   		= ones  (num_TR2W * 2, 1);
Terminal.Ir           		= zeros (num_TR2W * 2, 1);
Terminal.Ik2          		= zeros (num_TR2W * 2, 1);
Terminal.Flag_Terminal		= ones  (num_TR2W * 2, 1) * 7;
Terminal.Report_No   		= ones  (num_TR2W * 2, 1);
Terminal.Flag_Cur    		= zeros (num_TR2W * 2, 1);
Terminal.Flag_Switch 		= zeros (num_TR2W * 2, 1);
Terminal.Flag_Variant		= ones  (num_TR2W * 2, 1);
Terminal.Flag_Obs			= zeros (num_TR2W * 2, 1);

%% Element table with new required entries

Element = table;
Element.Element_ID   	= TR2WInput.Element_ID;
Element.VoltLevel_ID 	= TR2WInput.VoltLevel_ID;
Element.Variant_ID   	= ones  (num_TR2W,1);
Element.Group_ID     	= ones  (num_TR2W,1);
Element.Report_No    	= ones  (num_TR2W,1);
Element.Name         	= cellstr(TR2WInput.Name);
Element.ShortName    	= cellstr(TR2WInput.Name);
Element.Type         	= repmat(cellstr('TwoWindingTransformer'),num_TR2W,1);
Element.Flag_Input   	= ones  (num_TR2W,1) * 3;
Element.Flag_Variant 	= ones  (num_TR2W,1);
Element.Flag_State   	= ones  (num_TR2W,1);
Element.EcoStation_ID 	= NaN   (num_TR2W,1);
Element.EcoField_ID  	= NaN   (num_TR2W,1);
Element.ci           	= zeros (num_TR2W,1);
Element.Cs           	= zeros (num_TR2W,1);
Element.cm           	= zeros (num_TR2W,1);
Element.coo          	= zeros (num_TR2W,1);
Element.Ti           	= NaN   (num_TR2W,1);
Element.Tl           	= zeros (num_TR2W,1);
Element.Ts           	= NaN   (num_TR2W,1);
Element.Theta_i      	= zeros (num_TR2W,1);
Element.Theta_u      	= zeros (num_TR2W,1);
Element.Flag_Calc    	= zeros (num_TR2W,1);
Element.Metered      	= zeros (num_TR2W,1);
Element.Zone_ID      	= NaN   (num_TR2W,1);
Element.Flag_Private 	= zeros (num_TR2W,1);
Element.Description  	= repmat(cellstr(''),num_TR2W,1);
Element.TextVal      	= NaN   (num_TR2W,1);

%% GraphicElement table with new required entries

GraphicElement = table;
GraphicElement.GraphicElement_ID 	= TR2WInput.GraphicElement_ID;
GraphicElement.GraphicLayer_ID   	= ones  (num_TR2W,1);
GraphicElement.GraphicType_ID    	= ones  (num_TR2W,1);
GraphicElement.GraphicText_ID1   	= ones  (num_TR2W,1);
GraphicElement.GraphicText_ID2   	= NaN   (num_TR2W,1);
GraphicElement.Element_ID        	= TR2WInput.Element_ID;
GraphicElement.SymbolDef         	= ones  (num_TR2W,1) * 16777730;
GraphicElement.FrgndColor        	= zeros (num_TR2W,1);
GraphicElement.BkgndColor        	= ones  (num_TR2W,1) * -1;
GraphicElement.PenStyle          	= zeros (num_TR2W,1);
GraphicElement.PenWidth          	= ones  (num_TR2W,1);
GraphicElement.SymbolSize        	= ones  (num_TR2W,1) * 100;
GraphicElement.SymCenterX        	= TR2WInput.SymCenterX;
GraphicElement.SymCenterY        	= TR2WInput.SymCenterY;
GraphicElement.SymbolType        	= ones  (num_TR2W,1) * 20;
GraphicElement.SymbolNo          	= zeros (num_TR2W,1);
GraphicElement.Flag              	= zeros (num_TR2W,1);
GraphicElement.Variant_ID        	= ones  (num_TR2W,1);
GraphicElement.Flag_Variant      	= ones  (num_TR2W,1);
GraphicElement.GraphicArea_ID    	= ones  (num_TR2W,1);
% GraphicElement.ReducedGraphicType	= zeros (num_TR2W,1);

%% GraphicTerminal table with new required entries

GraphicTerminal = table;
GraphicTerminal.GraphicTerminal_ID	= [TR2WInput.GraphicTerminal_ID1; TR2WInput.GraphicTerminal_ID2];
GraphicTerminal.GraphicElement_ID 	= repmat(TR2WInput.GraphicElement_ID, 2, 1);
GraphicTerminal.GraphicText_ID    	= ones  (num_TR2W * 2, 1) * 2;
GraphicTerminal.Terminal_ID       	= [TR2WInput.Terminal_ID1; TR2WInput.Terminal_ID2];
GraphicTerminal.PosX              	= repmat(TR2WInput.SymCenterX, 2, 1);
GraphicTerminal.PosY              	= repmat(TR2WInput.SymCenterY, 2, 1);
GraphicTerminal.FrgndColor        	= zeros (num_TR2W * 2, 1);
GraphicTerminal.PenStyle          	= zeros (num_TR2W * 2, 1);
GraphicTerminal.PenWidth          	= ones  (num_TR2W * 2, 1);
GraphicTerminal.SwtType           	= zeros (num_TR2W * 2, 1);
GraphicTerminal.SwtAlign          	= ones  (num_TR2W * 2, 1) * 4;
GraphicTerminal.SwtNodePos        	= ones  (num_TR2W * 2, 1) * 20;
GraphicTerminal.SwtFactor         	= ones  (num_TR2W * 2, 1) * 80;
GraphicTerminal.SwtFrgndColor     	= ones  (num_TR2W * 2, 1) * -1;
GraphicTerminal.SwtPenStyle       	= zeros (num_TR2W * 2, 1);
GraphicTerminal.SwtPenWidth       	= zeros (num_TR2W * 2, 1);
GraphicTerminal.SymbolType        	= zeros (num_TR2W * 2, 1);
GraphicTerminal.SymbolAlign       	= ones  (num_TR2W * 2, 1) * 4;
GraphicTerminal.SymbolNodePos     	= ones  (num_TR2W * 2, 1) * 0.4;
GraphicTerminal.SymbolFactor      	= zeros (num_TR2W * 2, 1);
GraphicTerminal.SymbolFrgndColor  	= ones  (num_TR2W * 2, 1) * -1;
GraphicTerminal.SymbolPenStyle    	= zeros (num_TR2W * 2, 1);
GraphicTerminal.SymbolPenWidth    	= zeros (num_TR2W * 2, 1);
GraphicTerminal.TextAlign         	= ones  (num_TR2W * 2, 1) * 292;
GraphicTerminal.Flag              	= zeros (num_TR2W * 2, 1);
GraphicTerminal.Variant_ID        	= ones  (num_TR2W * 2, 1);
GraphicTerminal.Flag_Variant      	= ones  (num_TR2W * 2, 1);
GraphicTerminal.GraphicArea_ID    	= ones  (num_TR2W * 2, 1);
GraphicTerminal.GraphicNode_ID    	= NaN   (num_TR2W * 2, 1);

%% Consideration of additional input variables

AddInpVar = setdiff(...                                                     % Additional input variables (AIV)
    TR2WInput.Properties.VariableNames,...                                  % All        input variables
    {'Name', 'Node1', 'Node2', 'Terminal_ID1',...                           % Default    input variables 
    'Terminal_ID2'          ,'Element_ID'          ,'GraphicElement_ID',...
    'GraphicTerminal_ID1'   ,'GraphicTerminal_ID2' ,...
    'Node1_ID','Node2_ID'   ,'VoltLevel_ID', 'Un1', 'Un2'...
    'SymCenterX'            ,'SymCenterY'});

AddVarMain = intersect(AddInpVar, TwoWindingTransformer.Properties.VariableNames);	% In TwoWindingTransformer
AddVarTerm = intersect(AddInpVar, Terminal.             Properties.VariableNames);	% In Terminal
AddVarElem = intersect(AddInpVar, Element.              Properties.VariableNames);  % In Element
AddVarGrEl = intersect(AddInpVar, GraphicElement.      	Properties.VariableNames);  % In GraphicElement
AddVarGrTe = intersect(AddInpVar, GraphicTerminal.      Properties.VariableNames);  % In GraphicTerminal

for k_AIV = 1 : numel(AddVarMain)                                               % Consideration of changes in AIV
    TwoWindingTransformer.(AddVarMain{k_AIV}) = TR2WInput.(AddVarMain{k_AIV});
end
for k_AIV = 1 : numel(AddVarTerm)                                               % Consideration of changes in AIV
    Terminal.             (AddVarTerm{k_AIV}) = repmat(TR2WInput.(AddVarTerm{k_AIV}),2,1);
end
for k_AIV = 1 : numel(AddVarElem)                                               % Consideration of changes in AIV
    Element.              (AddVarElem{k_AIV}) = TR2WInput.(AddVarElem{k_AIV});
end
for k_AIV = 1 : numel(AddVarGrEl)                                               % Consideration of changes in AIV
    GraphicElement.	      (AddVarGrEl{k_AIV}) = TR2WInput.(AddVarGrEl{k_AIV});
end
for k_AIV = 1 : numel(AddVarGrTe)                                               % Consideration of changes in AIV
    GraphicTerminal.      (AddVarGrTe{k_AIV}) = repmat(TR2WInput.(AddVarGrTe{k_AIV}),2,1);
end