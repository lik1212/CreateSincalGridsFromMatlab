function [Load, Terminal, Element, GraphicElement, GraphicTerminal] = PrepLoadFiles(LoadInput)
%PrepLoadFiles Prepare Input for Sincal Database (DB) to add new Loads
%
%   The Input for the Sincal Database to add new Load are table entries for
%   the tables Load, Terminal, Element, GraphicElement and GraphicTerminal.
%   These are prepared with the function.
%
%   [Load, Terminal, Element, GraphicElement, GraphicTerminal] = PrepLoadFiles(LoadInput)
%
%       LoadInput     (Required) - Table with variables:
%                                  .Name         - Name of the new Loads
%                                  .Node_ID      - ID of the Node Load is connected to
%                                  .VoltLevel_ID - Voltage Level ID
%                                  .SymCenterX   - X-Position of the new Loads
%                                  .SymCenterY   - Y-Position of the new Loads
%                                  .Terminal_ID        (primary key)
%                                  .Element_ID         (primary key)
%                                  .GraphicElement_ID  (primary key)
%                                  .GraphicTerminal_ID (primary key)
%                                  ....  - more variables can be added
%       Load            (Result) - Table with required entries for the
%                                  Sincal DB table Load to add Loads
%       Terminal        (Result) - Table with required entries for the
%                                  Sincal DB table Terminal to add Loads
%       Element         (Result) - Table with required entries for the
%                                  Sincal DB table Element to add Loads
%       GraphicElement  (Result) - Table with required entries for the
%                                  Sincal DB table GraphicElement to add Loads
%       GraphicTerminal (Result) - Table with required entries for the
%                                  Sincal DB table GraphicTerminal to add Loads
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Standard Setup

num_Load = size(LoadInput,1);

%% Load table with new required entries

Load = table;
Load.Element_ID        	= LoadInput.Element_ID;
Load.Typ_ID            	= NaN   (num_Load,1);
Load.Flag_Load         	= ones  (num_Load,1);
Load.Flag_LoadType     	= ones  (num_Load,1) * 2;
Load.Flag_Lf           	= ones  (num_Load,1);
Load.P                 	= zeros (num_Load,1);
Load.Q                 	= zeros (num_Load,1);
Load.u                 	= ones  (num_Load,1) * 100;
Load.Ul                	= zeros (num_Load,1);
Load.S                 	= zeros (num_Load,1);
Load.I                 	= zeros (num_Load,1);
Load.cosphi            	= zeros (num_Load,1);
Load.E                 	= zeros (num_Load,1);
Load.t                 	= zeros (num_Load,1);
Load.Eap               	= zeros (num_Load,1);
Load.Erp               	= zeros (num_Load,1);
Load.Eapcon            	= zeros (num_Load,1);
Load.Erpcon            	= zeros (num_Load,1);
Load.fP                	= ones  (num_Load,1);
Load.fQ                	= ones  (num_Load,1);
Load.fS                	= ones  (num_Load,1);
Load.fI                	= ones  (num_Load,1);
Load.fE                	= ones  (num_Load,1);
Load.fEap              	= ones  (num_Load,1);
Load.fErp              	= ones  (num_Load,1);
Load.fEapcon           	= ones  (num_Load,1);
Load.fErpcon           	= ones  (num_Load,1);
Load.Flag_I            	= ones  (num_Load,1);
Load.Mpl_ID            	= NaN   (num_Load,1);
Load.Gang_ID           	= zeros (num_Load,1);
Load.Load_ID           	= zeros (num_Load,1);
Load.Flag_Typified     	= zeros (num_Load,1);
Load.Flag_Z0           	= ones  (num_Load,1);
Load.Flag_Z0_Input     	= ones  (num_Load,1);
Load.Z0_Z1             	= zeros (num_Load,1);
Load.R0_X0             	= zeros (num_Load,1);
Load.R0                	= zeros (num_Load,1);
Load.X0                	= zeros (num_Load,1);
Load.Ireg              	= zeros (num_Load,1);
Load.pk                	= zeros (num_Load,1);
Load.Flag_Har          	= ones  (num_Load,1);
Load.qr                	= ones  (num_Load,1);
Load.ql                	= zeros (num_Load,1);
Load.HarImp_ID         	= NaN   (num_Load,1);
Load.HarVolt_ID        	= NaN   (num_Load,1);
Load.HarCur_ID         	= NaN   (num_Load,1);
Load.Flag_LP           	= ones  (num_Load,1) * 3;
Load.SatChar_ID        	= NaN   (num_Load,1);
Load.IncrSer_ID        	= NaN   (num_Load,1);
Load.DayOpSer_ID       	= NaN   (num_Load,1);
Load.WeekOpSer_ID      	= NaN   (num_Load,1);
Load.YearOpSer_ID      	= NaN   (num_Load,1);
Load.P1                	= zeros (num_Load,1);
Load.Q1                	= zeros (num_Load,1);
Load.P2                	= zeros (num_Load,1);
Load.Q2                	= zeros (num_Load,1);
Load.P3                	= zeros (num_Load,1);
Load.Q3                	= zeros (num_Load,1);
Load.P12               	= zeros (num_Load,1);
Load.Q12               	= zeros (num_Load,1);
Load.P23               	= zeros (num_Load,1);
Load.Q23               	= zeros (num_Load,1);
Load.P31               	= zeros (num_Load,1);
Load.Q31               	= zeros (num_Load,1);
Load.Imax              	= zeros (num_Load,1);
Load.cos_phi_imax      	= ones  (num_Load,1);
Load.CustCnt           	= ones  (num_Load,1);
Load.I_min             	= zeros (num_Load,1);
Load.cos_phi_imin      	= ones  (num_Load,1);
Load.TransformerTap_ID 	= NaN   (num_Load,1);
Load.Flag_Macro        	= zeros (num_Load,1);
Load.Macro_ID          	= NaN   (num_Load,1);
Load.Flag_Variant      	= ones  (num_Load,1);
Load.Variant_ID        	= ones  (num_Load,1);
Load.du_min            	= zeros (num_Load,1);
Load.du_max            	= zeros (num_Load,1);
Load.Flag_ShdU         	= zeros (num_Load,1);
Load.Flag_ShdP         	= zeros (num_Load,1);
Load.tShd              	= zeros (num_Load,1);
Load.ResFlux1          	= zeros (num_Load,1);
Load.ResFlux2          	= zeros (num_Load,1);
Load.ResFlux3          	= zeros (num_Load,1);
Load.Pneg              	= zeros (num_Load,1);
Load.Qneg              	= zeros (num_Load,1);
Load.Stp_ID            	= NaN   (num_Load,1);
Load.Flag_Measure      	= ones  (num_Load,1);
Load.P_max             	= zeros (num_Load,1);
Load.P_min             	= zeros (num_Load,1);

%% Terminal table with new required entries

Terminal = table;
Terminal.Terminal_ID  		= LoadInput.Terminal_ID;
Terminal.Element_ID   		= LoadInput.Element_ID;
Terminal.Node_ID      		= LoadInput.Node_ID;
Terminal.Variant_ID   		= ones  (num_Load,1);
Terminal.TerminalNo   		= ones  (num_Load,1);
Terminal.Flag_State   		= ones  (num_Load,1);
Terminal.Ir           		= zeros (num_Load,1);
Terminal.Ik2          		= zeros (num_Load,1);
Terminal.Flag_Terminal		= ones  (num_Load,1) * 7;
Terminal.Report_No   		= ones  (num_Load,1);
Terminal.Flag_Cur    		= zeros (num_Load,1);
Terminal.Flag_Switch 		= zeros (num_Load,1);
Terminal.Flag_Variant		= ones  (num_Load,1);
Terminal.Flag_Obs			= zeros (num_Load,1);

%% Element table with new required entries

Element = table;
Element.Element_ID   	= LoadInput.Element_ID;
Element.VoltLevel_ID 	= LoadInput.VoltLevel_ID;
Element.Variant_ID   	= ones  (num_Load,1);
Element.Group_ID     	= ones  (num_Load,1);
Element.Report_No    	= ones  (num_Load,1);
Element.Name         	= cellstr(LoadInput.Name);
Element.ShortName    	= cellstr(LoadInput.Name);
Element.Type         	= repmat(cellstr('Load'),num_Load,1);
Element.Flag_Input   	= ones  (num_Load,1) * 3;
Element.Flag_Variant 	= ones  (num_Load,1);
Element.Flag_State   	= ones  (num_Load,1);
Element.EcoStation_ID	= NaN   (num_Load,1);
Element.EcoField_ID     = NaN   (num_Load,1);
Element.ci              = zeros (num_Load,1);
Element.Cs              = zeros (num_Load,1);
Element.cm              = zeros (num_Load,1);
Element.coo             = zeros (num_Load,1);
Element.Ti              = NaN   (num_Load,1);
Element.Tl              = zeros (num_Load,1);
Element.Ts              = NaN   (num_Load,1);
Element.Theta_i         = zeros (num_Load,1);
Element.Theta_u         = zeros (num_Load,1);
Element.Flag_Calc       = zeros (num_Load,1);
Element.Metered         = zeros (num_Load,1);
Element.Zone_ID         = NaN   (num_Load,1);
Element.Flag_Private	= zeros (num_Load,1);
Element.Description 	= repmat(cellstr(''),num_Load,1);
Element.TextVal     	= NaN   (num_Load,1);

%% GraphicElement table with new required entries

GraphicElement = table;
GraphicElement.GraphicElement_ID	= LoadInput.GraphicElement_ID;
GraphicElement.GraphicLayer_ID  	= ones  (num_Load,1);
GraphicElement.GraphicType_ID   	= ones  (num_Load,1);
GraphicElement.GraphicText_ID1  	= ones  (num_Load,1);
GraphicElement.GraphicText_ID2  	= NaN   (num_Load,1);
GraphicElement.Element_ID       	= LoadInput.Element_ID;
GraphicElement.SymbolDef        	= ones  (num_Load,1);
GraphicElement.FrgndColor       	= zeros (num_Load,1);
GraphicElement.BkgndColor       	= ones  (num_Load,1) * -1;
GraphicElement.PenStyle         	= zeros (num_Load,1);
GraphicElement.PenWidth         	= ones  (num_Load,1);
GraphicElement.SymbolSize       	= ones  (num_Load,1) * 100;
GraphicElement.SymCenterX       	= LoadInput.SymCenterX;
GraphicElement.SymCenterY       	= LoadInput.SymCenterY;
GraphicElement.SymbolType       	= ones  (num_Load,1) * 13;
GraphicElement.SymbolNo         	= zeros (num_Load,1);
GraphicElement.Flag             	= zeros (num_Load,1);
GraphicElement.Variant_ID       	= ones  (num_Load,1);
GraphicElement.Flag_Variant     	= ones  (num_Load,1);
GraphicElement.GraphicArea_ID   	= ones  (num_Load,1);
% GraphicElement.ReducedGraphicType   = zeros (num_Load,1);

%% GraphicTerminal table with new required entries

GraphicTerminal = table;
GraphicTerminal.GraphicTerminal_ID	= LoadInput.GraphicTerminal_ID;
GraphicTerminal.GraphicElement_ID 	= LoadInput.GraphicElement_ID;
GraphicTerminal.GraphicText_ID    	= ones  (num_Load,1) * 2;
GraphicTerminal.Terminal_ID       	= LoadInput.Terminal_ID;
GraphicTerminal.PosX              	= LoadInput.SymCenterX;
GraphicTerminal.PosY              	= LoadInput.SymCenterY;
GraphicTerminal.FrgndColor        	= zeros (num_Load,1);
GraphicTerminal.PenStyle          	= zeros (num_Load,1);
GraphicTerminal.PenWidth          	= ones  (num_Load,1);
GraphicTerminal.SwtType           	= zeros (num_Load,1);
GraphicTerminal.SwtAlign          	= ones  (num_Load,1) * 4;
GraphicTerminal.SwtNodePos        	= ones  (num_Load,1) * 20;
GraphicTerminal.SwtFactor         	= ones  (num_Load,1) * 80;
GraphicTerminal.SwtFrgndColor     	= ones  (num_Load,1) * -1;
GraphicTerminal.SwtPenStyle       	= zeros (num_Load,1);
GraphicTerminal.SwtPenWidth       	= zeros (num_Load,1);
GraphicTerminal.SymbolType        	= zeros (num_Load,1);
GraphicTerminal.SymbolAlign       	= ones  (num_Load,1) * 4;
GraphicTerminal.SymbolNodePos     	= ones  (num_Load,1) * 0.4;
GraphicTerminal.SymbolFactor      	= zeros (num_Load,1);
GraphicTerminal.SymbolFrgndColor  	= ones  (num_Load,1) * -1;
GraphicTerminal.SymbolPenStyle    	= zeros (num_Load,1);
GraphicTerminal.SymbolPenWidth    	= zeros (num_Load,1);
GraphicTerminal.TextAlign         	= ones  (num_Load,1) * 292;
GraphicTerminal.Flag              	= zeros (num_Load,1);
GraphicTerminal.Variant_ID        	= ones  (num_Load,1);
GraphicTerminal.Flag_Variant      	= ones  (num_Load,1);
GraphicTerminal.GraphicArea_ID    	= ones  (num_Load,1);
GraphicTerminal.GraphicNode_ID    	= NaN   (num_Load,1);

%% Consideration of additional input variables

AddInpVar = setdiff(...                                                     % Additional input variables (AIV)
    LoadInput.Properties.VariableNames,...                                  % All        input variables
    {'Name','Node','LengthY','Terminal_ID'  ,'Element_ID',...               % Default    input variables 
    'GraphicElement_ID','GraphicTerminal_ID','Node_ID'   ,...
    'VoltLevel_ID'     ,'SymCenterX'        ,'SymCenterY'});

AddVarMain = intersect(AddInpVar, Load.           Properties.VariableNames);  % In Load
AddVarTerm = intersect(AddInpVar, Terminal.       Properties.VariableNames);  % In Terminal
AddVarElem = intersect(AddInpVar, Element.        Properties.VariableNames);  % In Element
AddVarGrEl = intersect(AddInpVar, GraphicElement. Properties.VariableNames);  % In GraphicElement
AddVarGrTe = intersect(AddInpVar, GraphicTerminal.Properties.VariableNames);  % In GraphicTerminal

for k_AIV = 1 : numel(AddVarMain)                                           % Consideration of changes in AIV
    Load.           (AddVarMain{k_AIV}) = LoadInput.(AddVarMain{k_AIV});
end
for k_AIV = 1 : numel(AddVarTerm)                                       	% Consideration of changes in AIV
    Terminal.       (AddVarTerm{k_AIV}) = LoadInput.(AddVarTerm{k_AIV});
end
for k_AIV = 1 : numel(AddVarElem)                                           % Consideration of changes in AIV
    Element.        (AddVarElem{k_AIV}) = LoadInput.(AddVarElem{k_AIV});
end
for k_AIV = 1 : numel(AddVarGrEl)                                           % Consideration of changes in AIV
    GraphicElement.	(AddVarGrEl{k_AIV}) = LoadInput.(AddVarGrEl{k_AIV});
end
for k_AIV = 1 : numel(AddVarGrTe)                                           % Consideration of changes in AIV
    GraphicTerminal.(AddVarGrTe{k_AIV}) = LoadInput.(AddVarGrTe{k_AIV});
end