function [DCInfeeder, Terminal, Element, GraphicElement, GraphicTerminal] = PrepDCIFiles(DCIInput)
%PrepDCIFiles Prepare Input for Sincal Database (DB) to add new DCIs
%
%   The Input for the Sincal Database to add new DCI are table entries for
%   the tables DCInfeeder, Terminal, Element, GraphicElement and
%   GraphicTerminal. These are prepared with the function.
%
%   [DCInfeeder, Terminal, Element, GraphicElement, GraphicTerminal] = PrepDCIFiles(DCIInput)
%
%       DCIInput        (Required) - Table with variables:
%                                    .Name         - Name of the new DCIs
%                                    .Node_ID      - ID of the Node DCI is connected to
%                                    .VoltLevel_ID - Voltage Level of the new DCIs
%                                    .SymCenterX   - X-Position of the new DCIs
%                                    .SymCenterY   - Y-Position of the new DCIs
%                                    .Terminal_ID        (primary key)
%                                    .Element_ID         (primary key)
%                                    .GraphicElement_ID  (primary key)
%                                    .GraphicTerminal_ID (primary key)
%                                    ....  - more variables can be added
%       DCInfeeder      (Result)   - Table with required entries for the
%                                    Sincal DB table DCInfeeder to add DCIs
%       Terminal        (Result)   - Table with required entries for the
%                                    Sincal DB table Terminal to add DCIs
%       Element         (Result)   - Table with required entries for the
%                                    Sincal DB table Element to add DCIs
%       GraphicElement  (Result)   - Table with required entries for the
%                                    Sincal DB table GraphicElement to add DCIs
%       GraphicTerminal (Result)   - Table with required entries for the
%                                    Sincal DB table GraphicTerminal to add DCIs
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Standard Setup

num_DCI = size(DCIInput,1);

%% DCInfeeder table with new required entries

DCInfeeder = table;
DCInfeeder.Element_ID      	= DCIInput.Element_ID;
DCInfeeder.Flag_DCtyp      	= ones  (num_DCI,1);
DCInfeeder.DC_power        	= zeros (num_DCI,1);
DCInfeeder.DC_losses       	= ones  (num_DCI,1) * 15;
DCInfeeder.Eta_Inverter    	= ones  (num_DCI,1) * 97;
DCInfeeder.Q_Inverter      	= ones  (num_DCI,1) * 2;
DCInfeeder.Ur_Inverter     	= ones  (num_DCI,1);
DCInfeeder.Ctrl_power      	= zeros (num_DCI,1);
DCInfeeder.Flag_Connect    	= ones  (num_DCI,1);
DCInfeeder.Tr_UrNet        	= ones  (num_DCI,1);
DCInfeeder.Tr_Sr           	= ones  (num_DCI,1) * 25;
DCInfeeder.Tr_uk           	= zeros (num_DCI,1) * 10;
DCInfeeder.Tr_rx           	= zeros (num_DCI,1);
DCInfeeder.Umin_Inverter   	= zeros (num_DCI,1) * 80;
DCInfeeder.Umax_Inverter   	= zeros (num_DCI,1) * 110;
DCInfeeder.t_off           	= ones  (num_DCI,1) * 0.01;
DCInfeeder.DayOpSer_ID     	= NaN   (num_DCI,1);
DCInfeeder.WeekOpSer_ID    	= NaN   (num_DCI,1);
DCInfeeder.YearOpSer_ID    	= NaN   (num_DCI,1);
DCInfeeder.HarCur_ID       	= NaN   (num_DCI,1);
DCInfeeder.HarVolt_ID      	= NaN   (num_DCI,1);
DCInfeeder.Flag_Reliability	= zeros (num_DCI,1);
DCInfeeder.Flag_RelElement	= ones  (num_DCI,1);
DCInfeeder.SupplyType_ID  	= NaN   (num_DCI,1);
DCInfeeder.Flag_Macro     	= zeros (num_DCI,1);
DCInfeeder.Macro_ID       	= NaN   (num_DCI,1);
DCInfeeder.Variant_ID     	= ones  (num_DCI,1);
DCInfeeder.Flag_Variant   	= ones  (num_DCI,1);
DCInfeeder.fDC_power      	= ones  (num_DCI,1);
DCInfeeder.Mpl_ID         	= NaN   (num_DCI,1);
DCInfeeder.Flag_ShdU      	= zeros (num_DCI,1);
DCInfeeder.Flag_ShdP      	= zeros (num_DCI,1);
DCInfeeder.tShd           	= zeros (num_DCI,1);
DCInfeeder.Qctrl_U1       	= ones  (num_DCI,1) * 103;
DCInfeeder.Qctrl_U2       	= ones  (num_DCI,1) * 108;
DCInfeeder.Qctrl_cosphi   	= ones  (num_DCI,1) * 0.95;
DCInfeeder.Flag_Qctrl     	= zeros (num_DCI,1);
DCInfeeder.EnergyStorage_ID	= zeros (num_DCI,1);
DCInfeeder.Flag_Lf        	= ones  (num_DCI,1);
DCInfeeder.P              	= zeros (num_DCI,1);
DCInfeeder.Q              	= zeros (num_DCI,1);
DCInfeeder.cosphi         	= zeros (num_DCI,1);
DCInfeeder.fP             	= ones  (num_DCI,1);
DCInfeeder.fQ             	= ones  (num_DCI,1);
DCInfeeder.Flag_I         	= ones  (num_DCI,1);
DCInfeeder.Ireg           	= zeros (num_DCI,1);
DCInfeeder.pk             	= zeros (num_DCI,1);
DCInfeeder.fSC            	= ones  (num_DCI,1);
DCInfeeder.Qctrl_U1_c     	= ones  (num_DCI,1) * 97;
DCInfeeder.Qctrl_U2_c     	= ones  (num_DCI,1) * 92;
DCInfeeder.Qctrl_cosphi_c 	= ones  (num_DCI,1) * -0.95;
DCInfeeder.Qctrl_PF_U_ID  	= NaN   (num_DCI,1);
DCInfeeder.Qctrl_Pmax     	= ones  (num_DCI,1) * 0.85;
DCInfeeder.Qctrl_Pmin     	= ones  (num_DCI,1) * -0.85;
DCInfeeder.Qctrl_Pstd     	= zeros (num_DCI,1);
DCInfeeder.Qctrl_PF_Pmax  	= ones  (num_DCI,1)* 0.95;
DCInfeeder.Qctrl_PF_Pmin  	= ones  (num_DCI,1)* -0.95;
DCInfeeder.Qctrl_PF_P_ID  	= NaN   (num_DCI,1);
DCInfeeder.Flag_PhiSC     	= zeros (num_DCI,1);
DCInfeeder.PhiSC          	= zeros (num_DCI,1);
DCInfeeder.Qctrl_Qmax     	= ones  (num_DCI,1) * 0.25;
DCInfeeder.Qctrl_Qmin     	= ones  (num_DCI,1) * 0.25;
DCInfeeder.Qctrl_U_Q_ID   	= NaN   (num_DCI,1);
DCInfeeder.Flag_Converter 	= zeros (num_DCI,1);
DCInfeeder.IskPF          	= zeros (num_DCI,1);
DCInfeeder.Isk2PF         	= zeros (num_DCI,1);
DCInfeeder.Isk1PF         	= zeros (num_DCI,1);
DCInfeeder.IkPF           	= zeros (num_DCI,1);
DCInfeeder.R2_PF          	= zeros (num_DCI,1);
DCInfeeder.X2_PF          	= zeros (num_DCI,1);

%% Terminal table with new required entries

Terminal = PrepTerminal(DCIInput, 1);

%% Element table with new required entries

Element = table;
Element.Element_ID   	= DCIInput.Element_ID;
Element.VoltLevel_ID 	= DCIInput.VoltLevel_ID;
Element.Variant_ID   	= ones  (num_DCI,1);
Element.Group_ID     	= ones  (num_DCI,1);
Element.Report_No    	= ones  (num_DCI,1);
Element.Name         	= cellstr(DCIInput.Name);
Element.ShortName    	= cellstr(DCIInput.Name);
Element.Type         	= repmat(cellstr('DCInfeeder'),num_DCI,1);
Element.Flag_Input   	= ones  (num_DCI,1) * 3;
Element.Flag_Variant 	= ones  (num_DCI,1);
Element.Flag_State   	= ones  (num_DCI,1);
Element.EcoStation_ID	= NaN   (num_DCI,1);
Element.EcoField_ID     = NaN   (num_DCI,1);
Element.ci              = zeros (num_DCI,1);
Element.Cs              = zeros (num_DCI,1);
Element.cm              = zeros (num_DCI,1);
Element.coo             = zeros (num_DCI,1);
Element.Ti              = NaN   (num_DCI,1);
Element.Tl              = zeros (num_DCI,1);
Element.Ts              = NaN   (num_DCI,1);
Element.Theta_i         = zeros (num_DCI,1);
Element.Theta_u         = zeros (num_DCI,1);
Element.Flag_Calc       = zeros (num_DCI,1);
Element.Metered         = zeros (num_DCI,1);
Element.Zone_ID         = NaN   (num_DCI,1);
Element.Flag_Private	= zeros (num_DCI,1);
Element.Description 	= repmat(cellstr(''),num_DCI,1);
Element.TextVal     	= NaN   (num_DCI,1);

%% GraphicElement table with new required entries

GraphicElement = table;
GraphicElement.GraphicElement_ID	= DCIInput.GraphicElement_ID;
GraphicElement.GraphicLayer_ID  	= ones  (num_DCI,1);
GraphicElement.GraphicType_ID   	= ones  (num_DCI,1);
GraphicElement.GraphicText_ID1  	= ones  (num_DCI,1);
GraphicElement.GraphicText_ID2  	= NaN   (num_DCI,1);
GraphicElement.Element_ID       	= DCIInput.Element_ID;
GraphicElement.SymbolDef        	= ones  (num_DCI,1);
GraphicElement.FrgndColor       	= zeros (num_DCI,1);
GraphicElement.BkgndColor       	= ones  (num_DCI,1) * -1;
GraphicElement.PenStyle         	= zeros (num_DCI,1);
GraphicElement.PenWidth         	= ones  (num_DCI,1);
GraphicElement.SymbolSize       	= ones  (num_DCI,1) * 100;
GraphicElement.SymCenterX       	= DCIInput.SymCenterX;
GraphicElement.SymCenterY       	= DCIInput.SymCenterY;
GraphicElement.SymbolType       	= ones  (num_DCI,1) * 193;
GraphicElement.SymbolNo         	= zeros (num_DCI,1);
GraphicElement.Flag             	= zeros (num_DCI,1);
GraphicElement.Variant_ID       	= ones  (num_DCI,1);
GraphicElement.Flag_Variant     	= ones  (num_DCI,1);
GraphicElement.GraphicArea_ID   	= ones  (num_DCI,1);
% GraphicElement.ReducedGraphicType   = zeros (num_DCI,1);

%% GraphicTerminal table with new required entries

GraphicTerminal = table;
GraphicTerminal.GraphicTerminal_ID	= DCIInput.GraphicTerminal_ID;
GraphicTerminal.GraphicElement_ID 	= DCIInput.GraphicElement_ID;
GraphicTerminal.GraphicText_ID    	= ones  (num_DCI,1) * 2;
GraphicTerminal.Terminal_ID       	= DCIInput.Terminal_ID;
GraphicTerminal.PosX              	= DCIInput.SymCenterX;
GraphicTerminal.PosY              	= DCIInput.SymCenterY;
GraphicTerminal.FrgndColor        	= zeros (num_DCI,1);
GraphicTerminal.PenStyle          	= zeros (num_DCI,1);
GraphicTerminal.PenWidth          	= ones  (num_DCI,1);
GraphicTerminal.SwtType           	= zeros (num_DCI,1);
GraphicTerminal.SwtAlign          	= ones  (num_DCI,1) * 4;
GraphicTerminal.SwtNodePos        	= ones  (num_DCI,1) * 20;
GraphicTerminal.SwtFactor         	= ones  (num_DCI,1) * 80;
GraphicTerminal.SwtFrgndColor     	= ones  (num_DCI,1) * -1;
GraphicTerminal.SwtPenStyle       	= zeros (num_DCI,1);
GraphicTerminal.SwtPenWidth       	= zeros (num_DCI,1);
GraphicTerminal.SymbolType        	= zeros (num_DCI,1);
GraphicTerminal.SymbolAlign       	= ones  (num_DCI,1) * 4;
GraphicTerminal.SymbolNodePos     	= ones  (num_DCI,1) * 0.4;
GraphicTerminal.SymbolFactor      	= zeros (num_DCI,1);
GraphicTerminal.SymbolFrgndColor  	= ones  (num_DCI,1) * -1;
GraphicTerminal.SymbolPenStyle    	= zeros (num_DCI,1);
GraphicTerminal.SymbolPenWidth    	= zeros (num_DCI,1);
GraphicTerminal.TextAlign         	= ones  (num_DCI,1) * 292;
GraphicTerminal.Flag              	= zeros (num_DCI,1);
GraphicTerminal.Variant_ID        	= ones  (num_DCI,1);
GraphicTerminal.Flag_Variant      	= ones  (num_DCI,1);
GraphicTerminal.GraphicArea_ID    	= ones  (num_DCI,1);
GraphicTerminal.GraphicNode_ID    	= NaN   (num_DCI,1);

%% Consideration of additional input variables

AddInpVar = setdiff(...                                                     % Additional input variables (AIV)
    DCIInput.Properties.VariableNames,...                                   % All        input variables
    {'Name','Node','LengthY','Terminal_ID'  ,'Element_ID',...               % Default    input variables 
    'GraphicElement_ID','GraphicTerminal_ID','Node_ID'   ,...
    'VoltLevel_ID'     ,'SymCenterX'        ,'SymCenterY'});

AddVarMain = intersect(AddInpVar, DCInfeeder.     Properties.VariableNames);  % In DCInfeeder
AddVarTerm = intersect(AddInpVar, Terminal.       Properties.VariableNames);  % In Terminal
AddVarElem = intersect(AddInpVar, Element.        Properties.VariableNames);  % In Element
AddVarGrEl = intersect(AddInpVar, GraphicElement. Properties.VariableNames);  % In GraphicElement
AddVarGrTe = intersect(AddInpVar, GraphicTerminal.Properties.VariableNames);  % In GraphicTerminal

for k_AIV = 1 : numel(AddVarMain)                                           % Consideration of changes in AIV
    DCInfeeder.     (AddVarMain{k_AIV})	= DCIInput.(AddVarMain{k_AIV});
end
for k_AIV = 1 : numel(AddVarTerm)                                       	% Consideration of changes in AIV
    Terminal.       (AddVarTerm{k_AIV}) = DCIInput.(AddVarTerm{k_AIV});
end
for k_AIV = 1 : numel(AddVarElem)                                           % Consideration of changes in AIV
    Element.        (AddVarElem{k_AIV})	= DCIInput.(AddVarElem{k_AIV});
end
for k_AIV = 1 : numel(AddVarGrEl)                                           % Consideration of changes in AIV
    GraphicElement.	(AddVarGrEl{k_AIV}) = DCIInput.(AddVarGrEl{k_AIV});
end
for k_AIV = 1 : numel(AddVarGrTe)                                           % Consideration of changes in AIV
    GraphicTerminal.(AddVarGrTe{k_AIV}) = DCIInput.(AddVarGrTe{k_AIV});
end