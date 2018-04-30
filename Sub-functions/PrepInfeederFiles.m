function [Infeeder, Terminal, Element, GraphicElement, GraphicTerminal] = PrepInfeederFiles(InfeederInput)
%PrepInfeederFiles Prepare Input for Sincal Database (DB) to add new
%Infeeder(s)
%
%   The Input for the Sincal Database to add new Infeeder(s) are table
%   entries for the tables Infeeder, Terminal, Element, GraphicElement and
%   GraphicTerminal. These are prepared with the function.
%
%   [Infeeder, Terminal, Element, GraphicElement, GraphicTerminal] = PrepInfeederFiles(InfeederInput)
%
%       InfeederInput   (Required) - Table with variables:
%                                    .Name         - Name of the new Infeeder(s)
%                                    .Node_ID      - ID of the Node Infeeder(s) is connected to
%                                    .VoltLevel_ID - Voltage Level of the new Infeeder(s)
%                                    .SymCenterX   - X-Position of the new Infeeder(s)
%                                    .SymCenterY   - Y-Position of the new Infeeder(s)
%                                    .Terminal_ID        (primary key)
%                                    .Element_ID         (primary key)
%                                    .GraphicElement_ID  (primary key)
%                                    .GraphicTerminal_ID (primary key)
%                                    ....  - more variables can be added
%       Infeeder        (Result)   - Table with required entries for the
%                                    Sincal DB table Infeeder to add Infeeder(s)
%       Terminal        (Result)   - Table with required entries for the
%                                    Sincal DB table Terminal to add Infeeder(s)
%       Element         (Result)   - Table with required entries for the
%                                    Sincal DB table Element to add Infeeder(s)
%       GraphicElement  (Result)   - Table with required entries for the
%                                    Sincal DB table GraphicElement to add Infeeder(s)
%       GraphicTerminal (Result)   - Table with required entries for the
%                                    Sincal DB table GraphicTerminal to add Infeeder(s)
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Standard Setup

num_Infeeder = size(InfeederInput,1);

%% Infeeder table with new required entries

Infeeder = table;
Infeeder.Element_ID       	= InfeederInput.Element_ID;
Infeeder.Typ_ID           	= zeros (num_Infeeder,1);
Infeeder.Flag_Typ_ID      	= zeros (num_Infeeder,1);
Infeeder.Flag_Typ         	= ones  (num_Infeeder,1) * 2;
Infeeder.Flag_MaxMin      	= zeros (num_Infeeder,1);
Infeeder.Sk2              	= ones  (num_Infeeder,1) * 1000;
Infeeder.cact             	= ones  (num_Infeeder,1);
Infeeder.R                	= zeros (num_Infeeder,1);
Infeeder.X                	= zeros (num_Infeeder,1);
Infeeder.R_X              	= ones  (num_Infeeder,1) * 0.1;
Infeeder.Sk2max           	= ones  (num_Infeeder,1) * 1000;
Infeeder.cmax             	= ones  (num_Infeeder,1) * 1.1;
Infeeder.Rmax             	= zeros (num_Infeeder,1);
Infeeder.Xmax             	= zeros (num_Infeeder,1);
Infeeder.R_Xmax           	= ones  (num_Infeeder,1) * 0.1;
Infeeder.Sk2min           	= ones  (num_Infeeder,1) * 1000;
Infeeder.cmin             	= ones  (num_Infeeder,1);
Infeeder.Rmin             	= zeros (num_Infeeder,1);
Infeeder.Xmin             	= zeros (num_Infeeder,1);
Infeeder.R_Xmin           	= ones  (num_Infeeder,1) * 0.1;
Infeeder.Flag_Lf          	= ones  (num_Infeeder,1) * 3;
Infeeder.P                	= zeros (num_Infeeder,1);
Infeeder.Q                	= zeros (num_Infeeder,1);
Infeeder.u                	= ones  (num_Infeeder,1) * 100;
Infeeder.Ug               	= zeros (num_Infeeder,1);
Infeeder.delta            	= zeros (num_Infeeder,1);
Infeeder.phi              	= zeros (num_Infeeder,1);
Infeeder.I                	= zeros (num_Infeeder,1);
Infeeder.S                	= zeros (num_Infeeder,1);
Infeeder.cosphi           	= ones  (num_Infeeder,1);
Infeeder.xi               	= zeros (num_Infeeder,1);
Infeeder.fP               	= ones  (num_Infeeder,1);
Infeeder.fQ               	= ones  (num_Infeeder,1);
Infeeder.fS               	= ones  (num_Infeeder,1);
Infeeder.fI               	= ones  (num_Infeeder,1);
Infeeder.Mpl_ID           	= NaN   (num_Infeeder,1);
Infeeder.Flag_Z0          	= zeros (num_Infeeder,1);
Infeeder.Flag_Z0_Input    	= ones  (num_Infeeder,1);
Infeeder.Z0_Z1            	= zeros (num_Infeeder,1);
Infeeder.R0_X0            	= zeros (num_Infeeder,1);
Infeeder.R0               	= zeros (num_Infeeder,1);
Infeeder.X0               	= zeros (num_Infeeder,1);
Infeeder.Stp_ID           	= NaN   (num_Infeeder,1);
Infeeder.Z0_Z1max         	= zeros (num_Infeeder,1);
Infeeder.Z0_Z1min         	= zeros (num_Infeeder,1);
Infeeder.R0_X0max         	= zeros (num_Infeeder,1);
Infeeder.R0_X0min         	= zeros (num_Infeeder,1);
Infeeder.ull              	= ones  (num_Infeeder,1) * 98;
Infeeder.uul              	= ones  (num_Infeeder,1) * 103;
Infeeder.Pmin             	= zeros (num_Infeeder,1);
Infeeder.Pmax             	= zeros (num_Infeeder,1);
Infeeder.Qmin             	= zeros (num_Infeeder,1);
Infeeder.Qmax             	= zeros (num_Infeeder,1);
Infeeder.Flag_Har         	= ones  (num_Infeeder,1);
Infeeder.qr               	= ones  (num_Infeeder,1);
Infeeder.ql               	= zeros (num_Infeeder,1);
Infeeder.HarImp_ID        	= NaN   (num_Infeeder,1);
Infeeder.HarVolt_ID       	= NaN   (num_Infeeder,1);
Infeeder.HarCur_ID        	= NaN   (num_Infeeder,1);
Infeeder.Flag_Reliability 	= zeros (num_Infeeder,1);
Infeeder.SupplyType_ID    	= NaN   (num_Infeeder,1);
Infeeder.Flag_ZU          	= zeros (num_Infeeder,1);
Infeeder.Flag_ZUP         	= ones  (num_Infeeder,1) * 3;
Infeeder.T_ZU             	= zeros (num_Infeeder,1);
Infeeder.Start_P          	= zeros (num_Infeeder,1);
Infeeder.Start_Q          	= zeros (num_Infeeder,1);
Infeeder.Kr               	= zeros (num_Infeeder,1);
Infeeder.R0min            	= zeros (num_Infeeder,1);
Infeeder.X0min            	= zeros (num_Infeeder,1);
Infeeder.R0max            	= zeros (num_Infeeder,1);
Infeeder.X0max            	= zeros (num_Infeeder,1);
Infeeder.Flag_LfCtrl      	= zeros (num_Infeeder,1);
Infeeder.Flag_LfLimit     	= zeros (num_Infeeder,1);
Infeeder.MasterElm_ID     	= NaN   (num_Infeeder,1);
Infeeder.cosphi_lim       	= ones  (num_Infeeder,1) * 0.85;
Infeeder.Node_ID          	= NaN   (num_Infeeder,1);
Infeeder.IncrSer_ID       	= NaN   (num_Infeeder,1);
Infeeder.DayOpSer_ID      	= NaN   (num_Infeeder,1);
Infeeder.WeekOpSer_ID     	= NaN   (num_Infeeder,1);
Infeeder.YearOpSer_ID     	= NaN   (num_Infeeder,1);
Infeeder.PowerLimit_ID    	= NaN   (num_Infeeder,1);
Infeeder.Flag_Macro       	= zeros (num_Infeeder,1);
Infeeder.Macro_ID         	= NaN   (num_Infeeder,1);
Infeeder.Flag_Variant     	= ones  (num_Infeeder,1);
Infeeder.Variant_ID       	= ones  (num_Infeeder,1);
Infeeder.Flag_ShdU        	= zeros (num_Infeeder,1);
Infeeder.Flag_ShdP        	= zeros (num_Infeeder,1);
Infeeder.tShd             	= zeros (num_Infeeder,1);
Infeeder.Qctrl_U1         	= ones  (num_Infeeder,1) * 103;
Infeeder.Qctrl_U2         	= ones  (num_Infeeder,1) * 108;
Infeeder.Qctrl_cosphi     	= ones  (num_Infeeder,1) * 0.95;
Infeeder.Flag_Qctrl       	= zeros (num_Infeeder,1);
Infeeder.u_node           	= zeros (num_Infeeder,1);
Infeeder.Qctrl_U1_c       	= ones  (num_Infeeder,1) * 97;
Infeeder.Qctrl_U2_c       	= ones  (num_Infeeder,1) * 92;
Infeeder.Qctrl_cosphi_c   	= ones  (num_Infeeder,1) * -0.95;
Infeeder.Qctrl_PF_U_ID    	= zeros (num_Infeeder,1);
Infeeder.Qctrl_Pmax       	= ones  (num_Infeeder,1) * 0.85;
Infeeder.Qctrl_Pmin       	= ones  (num_Infeeder,1) * -0.85;
Infeeder.Qctrl_Pstd       	= zeros (num_Infeeder,1);
Infeeder.Qctrl_PF_Pmax    	= ones  (num_Infeeder,1) * 0.95;
Infeeder.Qctrl_PF_Pmin    	= ones  (num_Infeeder,1) * -0.95;
Infeeder.Qctrl_PF_P_ID    	= zeros (num_Infeeder,1);
Infeeder.Qctrl_Qmax       	= ones  (num_Infeeder,1) * 0.25;
Infeeder.Qctrl_Qmin       	= ones  (num_Infeeder,1) * 0.25;
Infeeder.Qctrl_U_Q_ID     	= NaN   (num_Infeeder,1);

%% Terminal table with new required entries

Terminal = table;
Terminal.Terminal_ID  		= InfeederInput.Terminal_ID;
Terminal.Element_ID   		= InfeederInput.Element_ID;
Terminal.Node_ID      		= InfeederInput.Node_ID;
Terminal.Variant_ID   		= ones  (num_Infeeder,1);
Terminal.TerminalNo   		= ones  (num_Infeeder,1);
Terminal.Flag_State   		= ones  (num_Infeeder,1);
Terminal.Ir           		= zeros (num_Infeeder,1);
Terminal.Ik2          		= zeros (num_Infeeder,1);
Terminal.Flag_Terminal		= ones  (num_Infeeder,1) * 7;
Terminal.Report_No   		= ones  (num_Infeeder,1);
Terminal.Flag_Cur    		= zeros (num_Infeeder,1);
Terminal.Flag_Switch 		= zeros (num_Infeeder,1);
Terminal.Flag_Variant		= ones  (num_Infeeder,1);
Terminal.Flag_Obs			= zeros (num_Infeeder,1);

%% Element table with new required entries

Element = table;
Element.Element_ID   	= InfeederInput.Element_ID;
Element.VoltLevel_ID 	= InfeederInput.VoltLevel_ID;
Element.Variant_ID   	= ones  (num_Infeeder,1);
Element.Group_ID     	= ones  (num_Infeeder,1);
Element.Report_No    	= ones  (num_Infeeder,1);
Element.Name         	= cellstr(InfeederInput.Name);
Element.ShortName    	= cellstr(InfeederInput.Name);
Element.Type         	= repmat(cellstr('Infeeder'),num_Infeeder,1);
Element.Flag_Input   	= ones  (num_Infeeder,1) * 3;
Element.Flag_Variant 	= ones  (num_Infeeder,1);
Element.Flag_State   	= ones  (num_Infeeder,1);
Element.EcoStation_ID	= NaN   (num_Infeeder,1);
Element.EcoField_ID     = NaN   (num_Infeeder,1);
Element.ci              = zeros (num_Infeeder,1);
Element.Cs              = zeros (num_Infeeder,1);
Element.cm              = zeros (num_Infeeder,1);
Element.coo             = zeros (num_Infeeder,1);
Element.Ti              = NaN   (num_Infeeder,1);
Element.Tl              = zeros (num_Infeeder,1);
Element.Ts              = NaN   (num_Infeeder,1);
Element.Theta_i         = zeros (num_Infeeder,1);
Element.Theta_u         = zeros (num_Infeeder,1);
Element.Flag_Calc       = zeros (num_Infeeder,1);
Element.Metered         = zeros (num_Infeeder,1);
Element.Zone_ID         = NaN   (num_Infeeder,1);
Element.Flag_Private	= zeros (num_Infeeder,1);
Element.Description 	= repmat(cellstr(''),num_Infeeder,1);
Element.TextVal     	= NaN   (num_Infeeder,1);

%% GraphicElement table with new required entries

GraphicElement = table;
GraphicElement.GraphicElement_ID	= InfeederInput.GraphicElement_ID;
GraphicElement.GraphicLayer_ID  	= ones  (num_Infeeder,1);
GraphicElement.GraphicType_ID   	= ones  (num_Infeeder,1);
GraphicElement.GraphicText_ID1  	= ones  (num_Infeeder,1);
GraphicElement.GraphicText_ID2  	= NaN   (num_Infeeder,1);
GraphicElement.Element_ID       	= InfeederInput.Element_ID;
GraphicElement.SymbolDef        	= ones  (num_Infeeder,1);
GraphicElement.FrgndColor       	= zeros (num_Infeeder,1);
GraphicElement.BkgndColor       	= ones  (num_Infeeder,1) * -1;
GraphicElement.PenStyle         	= zeros (num_Infeeder,1);
GraphicElement.PenWidth         	= ones  (num_Infeeder,1);
GraphicElement.SymbolSize       	= ones  (num_Infeeder,1) * 100;
GraphicElement.SymCenterX       	= InfeederInput.SymCenterX;
GraphicElement.SymCenterY       	= InfeederInput.SymCenterY;
GraphicElement.SymbolType       	= ones  (num_Infeeder,1) * 11;
GraphicElement.SymbolNo         	= zeros (num_Infeeder,1);
GraphicElement.Flag             	= zeros (num_Infeeder,1);
GraphicElement.Variant_ID       	= ones  (num_Infeeder,1);
GraphicElement.Flag_Variant     	= ones  (num_Infeeder,1);
GraphicElement.GraphicArea_ID   	= ones  (num_Infeeder,1);
% GraphicElement.ReducedGraphicType   = zeros (num_Infeeder,1);

%% GraphicTerminal table with new required entries

GraphicTerminal = table;
GraphicTerminal.GraphicTerminal_ID	= InfeederInput.GraphicTerminal_ID;
GraphicTerminal.GraphicElement_ID 	= InfeederInput.GraphicElement_ID;
GraphicTerminal.GraphicText_ID    	= ones  (num_Infeeder,1) * 2;
GraphicTerminal.Terminal_ID       	= InfeederInput.Terminal_ID;
GraphicTerminal.PosX              	= InfeederInput.SymCenterX;
GraphicTerminal.PosY              	= InfeederInput.SymCenterY;
GraphicTerminal.FrgndColor        	= zeros (num_Infeeder,1);
GraphicTerminal.PenStyle          	= zeros (num_Infeeder,1);
GraphicTerminal.PenWidth          	= ones  (num_Infeeder,1);
GraphicTerminal.SwtType           	= zeros (num_Infeeder,1);
GraphicTerminal.SwtAlign          	= ones  (num_Infeeder,1) * 4;
GraphicTerminal.SwtNodePos        	= ones  (num_Infeeder,1) * 20;
GraphicTerminal.SwtFactor         	= ones  (num_Infeeder,1) * 80;
GraphicTerminal.SwtFrgndColor     	= ones  (num_Infeeder,1) * -1;
GraphicTerminal.SwtPenStyle       	= zeros (num_Infeeder,1);
GraphicTerminal.SwtPenWidth       	= zeros (num_Infeeder,1);
GraphicTerminal.SymbolType        	= zeros (num_Infeeder,1);
GraphicTerminal.SymbolAlign       	= ones  (num_Infeeder,1) * 4;
GraphicTerminal.SymbolNodePos     	= ones  (num_Infeeder,1) * 0.4;
GraphicTerminal.SymbolFactor      	= zeros (num_Infeeder,1);
GraphicTerminal.SymbolFrgndColor  	= ones  (num_Infeeder,1) * -1;
GraphicTerminal.SymbolPenStyle    	= zeros (num_Infeeder,1);
GraphicTerminal.SymbolPenWidth    	= zeros (num_Infeeder,1);
GraphicTerminal.TextAlign         	= ones  (num_Infeeder,1) * 292;
GraphicTerminal.Flag              	= zeros (num_Infeeder,1);
GraphicTerminal.Variant_ID        	= ones  (num_Infeeder,1);
GraphicTerminal.Flag_Variant      	= ones  (num_Infeeder,1);
GraphicTerminal.GraphicArea_ID    	= ones  (num_Infeeder,1);
GraphicTerminal.GraphicNode_ID    	= NaN   (num_Infeeder,1);

%% Consideration of additional input variables

AddInpVar = setdiff(...                                                     % Additional input variables (AIV)
    InfeederInput.Properties.VariableNames,...                              % All        input variables
    {'Name','Node','LengthY','Terminal_ID'  ,'Element_ID',...               % Default    input variables 
    'GraphicElement_ID','GraphicTerminal_ID','Node_ID'   ,...
    'VoltLevel_ID'     ,'SymCenterX'        ,'SymCenterY'});

AddVarMain = intersect(AddInpVar, Infeeder.       Properties.VariableNames);  % In Infeeder
AddVarTerm = intersect(AddInpVar, Terminal.       Properties.VariableNames);  % In Terminal
AddVarElem = intersect(AddInpVar, Element.        Properties.VariableNames);  % In Element
AddVarGrEl = intersect(AddInpVar, GraphicElement. Properties.VariableNames);  % In GraphicElement
AddVarGrTe = intersect(AddInpVar, GraphicTerminal.Properties.VariableNames);  % In GraphicTerminal

for k_AIV = 1 : numel(AddVarMain)                                           % Consideration of changes in AIV
    Infeeder.       (AddVarMain{k_AIV}) = InfeederInput.(AddVarMain{k_AIV});
end
for k_AIV = 1 : numel(AddVarTerm)                                          	% Consideration of changes in AIV
    Terminal.       (AddVarTerm{k_AIV}) = InfeederInput.(AddVarTerm{k_AIV});
end
for k_AIV = 1 : numel(AddVarElem)                                           % Consideration of changes in AIV
    Element.        (AddVarElem{k_AIV}) = InfeederInput.(AddVarElem{k_AIV});
end
for k_AIV = 1 : numel(AddVarGrEl)                                       	% Consideration of changes in AIV
    GraphicElement.	(AddVarGrEl{k_AIV}) = InfeederInput.(AddVarGrEl{k_AIV});
end
for k_AIV = 1 : numel(AddVarGrTe)                                        	% Consideration of changes in AIV
    GraphicTerminal.(AddVarGrTe{k_AIV}) = InfeederInput.(AddVarGrTe{k_AIV});
end