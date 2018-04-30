function [Line, Terminal, Element, GraphicElement, GraphicTerminal] = PrepLineFiles(LineInput)
%PrepLineFiles Prepare Input for Sincal Database (DB) to add new Lines
%
%   The Input for the Sincal Database to add new Line are table entries for
%   the tables Line, Terminal, Element, GraphicElement and GraphicTerminal.
%   These are prepared with the function.
%
%   [Line, Terminal, Element, GraphicElement, GraphicTerminal] = PrepLineFiles(LineInput)
%
%       LineInput      (Required) - Table with variables:
%                                   .Name         - Name of the new Lines
%                                   .Node1_ID     - ID of the 1. Node Line is connected to
%                                   .Node2_ID     - ID of the 2. Node Line is connected to
%                                   .SymCenterX   - X-Position of the new Lines
%                                   .SymCenterY   - Y-Position of the new Lines
%                                   .VoltLevel_ID - Voltage Level ID
%                                   .Terminal_ID1        (primary key) - related to Node1
%                                   .Terminal_ID2        (primary key) - related to Node2
%                                   .Element_ID          (primary key)
%                                   .GraphicElement_ID   (primary key)
%                                   .GraphicTerminal_ID1 (primary key) - related to Node1
%                                   .GraphicTerminal_ID2 (primary key) - related to Node2
%                                   ....  - more variables can be added
%       Line            (Result)  - Table with required entries for the
%                                   Sincal DB table Line to add Lines
%       Terminal        (Result)  - Table with required entries for the
%                                   Sincal DB table Terminal to add Lines
%       Element         (Result)  - Table with required entries for the
%                                   Sincal DB table Element to add Lines
%       GraphicElement  (Result)  - Table with required entries for the
%                                   Sincal DB table GraphicElement to add Lines
%       GraphicTerminal (Result)  - Table with required entries for the
%                                   Sincal DB table GraphicTerminal to add Lines
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Standard Setup

num_Line = size(LineInput,1);

%% Line table with new required entries

Line = table;
Line.Element_ID      	= LineInput.Element_ID;
Line.Flag_LineTyp    	= ones  (num_Line,1);
Line.LineTyp         	= repmat(cellstr(''),num_Line,1);
Line.Typ_ID          	= zeros (num_Line,1);
Line.Flag_Typ_ID     	= zeros (num_Line,1);
Line.q               	= zeros (num_Line,1);
Line.l               	= ones  (num_Line,1);
Line.ParSys          	= ones  (num_Line,1);
Line.Flag_Vart       	= ones  (num_Line,1);
Line.Flag_Ll         	= zeros (num_Line,1);
Line.fr              	= ones  (num_Line,1);
Line.Flag_Tend       	= zeros (num_Line,1);
Line.Tend            	= zeros (num_Line,1);
Line.r               	= ones  (num_Line,1) * 0.1;
Line.x               	= ones  (num_Line,1) * 0.4;
Line.c               	= zeros (num_Line,1);
Line.Un              	= ones  (num_Line,1);
Line.Flag_Mat        	= ones  (num_Line,1) * 2;
Line.Flag_Cond       	= ones  (num_Line,1);
Line.va              	= zeros (num_Line,1);
Line.Ith             	= zeros (num_Line,1);
Line.fn              	= ones  (num_Line,1) * 50;
Line.I1s             	= zeros (num_Line,1);
Line.Flag_Z0_Input   	= ones  (num_Line,1);
Line.X0_X1           	= zeros (num_Line,1);
Line.R0_R1           	= zeros (num_Line,1);
Line.r0              	= zeros (num_Line,1);
Line.x0              	= zeros (num_Line,1);
Line.c0              	= zeros (num_Line,1);
Line.q0              	= zeros (num_Line,1);
Line.Flag_Ground     	= zeros (num_Line,1);
Line.fIk             	= ones  (num_Line,1);
Line.Umax            	= zeros (num_Line,1);
Line.d               	= ones  (num_Line,1) * 50;
Line.da              	= ones  (num_Line,1) * 50;
Line.Flag_Har        	= ones  (num_Line,1);
Line.qr              	= ones  (num_Line,1);
Line.ql              	= zeros (num_Line,1);
Line.HarImp_ID       	= NaN   (num_Line,1);
Line.Flag_Reliability	= zeros (num_Line,1);
Line.Flag_SF1        	= zeros (num_Line,1);
Line.Flag_SF2        	= zeros (num_Line,1);
Line.LineType_ID     	= NaN   (num_Line,1);
Line.Overload_ID     	= NaN   (num_Line,1);
Line.V_S             	= zeros (num_Line,1);
Line.Flag_ZU         	= zeros (num_Line,1);
Line.Flag_ZUP        	= ones  (num_Line,1) * 3;
Line.T_ZU            	= zeros (num_Line,1);
Line.Flag_ESB        	= ones  (num_Line,1);
Line.Ith1            	= zeros (num_Line,1);
Line.Ith2            	= zeros (num_Line,1);
Line.Ith3            	= zeros (num_Line,1);
Line.Flag_Macro      	= zeros (num_Line,1);
Line.Macro_ID        	= NaN   (num_Line,1);
Line.Flag_Variant    	= ones  (num_Line,1);
Line.Variant_ID      	= ones  (num_Line,1);
Line.LineInfo        	= repmat(cellstr(''),num_Line,1);
Line.alpha           	= ones  (num_Line,1) * 0.004;
Line.CoupData_ID     	= NaN   (num_Line,1);
Line.rR              	= zeros (num_Line,1);
Line.xR              	= zeros (num_Line,1);
Line.cR              	= zeros (num_Line,1);
Line.LineTemp_ID     	= zeros (num_Line,1);

%% Terminal table with new required entries

Terminal = PrepTerminal(LineInput, 2);

%% Element table with new required entries

Element = table;
Element.Element_ID   	= LineInput.Element_ID;
Element.VoltLevel_ID 	= LineInput.VoltLevel_ID;
Element.Variant_ID   	= ones  (num_Line,1);
Element.Group_ID     	= ones  (num_Line,1);
Element.Report_No    	= ones  (num_Line,1);
Element.Name         	= cellstr(LineInput.Name);
Element.ShortName    	= cellstr(LineInput.Name);
Element.Type         	= repmat(cellstr('Line'),num_Line,1);
Element.Flag_Input   	= ones  (num_Line,1) * 3;
Element.Flag_Variant 	= ones  (num_Line,1);
Element.Flag_State   	= ones  (num_Line,1);
Element.EcoStation_ID 	= NaN   (num_Line,1);
Element.EcoField_ID  	= NaN   (num_Line,1);
Element.ci           	= zeros (num_Line,1);
Element.Cs           	= zeros (num_Line,1);
Element.cm           	= zeros (num_Line,1);
Element.coo          	= zeros (num_Line,1);
Element.Ti           	= NaN   (num_Line,1);
Element.Tl           	= zeros (num_Line,1);
Element.Ts           	= NaN   (num_Line,1);
Element.Theta_i      	= zeros (num_Line,1);
Element.Theta_u      	= zeros (num_Line,1);
Element.Flag_Calc    	= zeros (num_Line,1);
Element.Metered      	= zeros (num_Line,1);
Element.Zone_ID      	= NaN   (num_Line,1);
Element.Flag_Private 	= zeros (num_Line,1);
Element.Description  	= repmat(cellstr(''),num_Line,1);
Element.TextVal      	= NaN   (num_Line,1);

%% GraphicElement table with new required entries

GraphicElement = table;
GraphicElement.GraphicElement_ID 	= LineInput.GraphicElement_ID;
GraphicElement.GraphicLayer_ID   	= ones  (num_Line,1);
GraphicElement.GraphicType_ID    	= ones  (num_Line,1);
GraphicElement.GraphicText_ID1   	= ones  (num_Line,1);
GraphicElement.GraphicText_ID2   	= NaN   (num_Line,1);
GraphicElement.Element_ID        	= LineInput.Element_ID;
GraphicElement.SymbolDef         	= ones  (num_Line,1);
GraphicElement.FrgndColor        	= zeros (num_Line,1);
GraphicElement.BkgndColor        	= ones  (num_Line,1) * -1;
GraphicElement.PenStyle          	= zeros (num_Line,1);
GraphicElement.PenWidth          	= ones  (num_Line,1);
GraphicElement.SymbolSize        	= ones  (num_Line,1) * 100;
GraphicElement.SymCenterX        	= LineInput.SymCenterX;
GraphicElement.SymCenterY        	= LineInput.SymCenterY;
GraphicElement.SymbolType        	= ones  (num_Line,1) * 19;
GraphicElement.SymbolNo          	= zeros (num_Line,1);
GraphicElement.Flag              	= zeros (num_Line,1);
GraphicElement.Variant_ID        	= ones  (num_Line,1);
GraphicElement.Flag_Variant      	= ones  (num_Line,1);
GraphicElement.GraphicArea_ID    	= ones  (num_Line,1);
% GraphicElement.ReducedGraphicType	= zeros (num_Line,1);

%% GraphicTerminal table with new required entries

GraphicTerminal = table;
GraphicTerminal.GraphicTerminal_ID	= [LineInput.GraphicTerminal_ID1; LineInput.GraphicTerminal_ID2];
GraphicTerminal.GraphicElement_ID 	= repmat(LineInput.GraphicElement_ID, 2, 1);
GraphicTerminal.GraphicText_ID    	= ones  (num_Line * 2, 1) * 2;
GraphicTerminal.Terminal_ID       	= [LineInput.Terminal_ID1; LineInput.Terminal_ID2];
GraphicTerminal.PosX              	= repmat(LineInput.SymCenterX, 2, 1);
GraphicTerminal.PosY              	= repmat(LineInput.SymCenterY, 2, 1);
GraphicTerminal.FrgndColor        	= zeros (num_Line * 2, 1);
GraphicTerminal.PenStyle          	= zeros (num_Line * 2, 1);
GraphicTerminal.PenWidth          	= ones  (num_Line * 2, 1);
GraphicTerminal.SwtType           	= zeros (num_Line * 2, 1);
GraphicTerminal.SwtAlign          	= ones  (num_Line * 2, 1) * 4;
GraphicTerminal.SwtNodePos        	= ones  (num_Line * 2, 1) * 20;
GraphicTerminal.SwtFactor         	= ones  (num_Line * 2, 1) * 80;
GraphicTerminal.SwtFrgndColor     	= ones  (num_Line * 2, 1) * -1;
GraphicTerminal.SwtPenStyle       	= zeros (num_Line * 2, 1);
GraphicTerminal.SwtPenWidth       	= zeros (num_Line * 2, 1);
GraphicTerminal.SymbolType        	= zeros (num_Line * 2, 1);
GraphicTerminal.SymbolAlign       	= ones  (num_Line * 2, 1) * 4;
GraphicTerminal.SymbolNodePos     	= ones  (num_Line * 2, 1) * 0.4;
GraphicTerminal.SymbolFactor      	= zeros (num_Line * 2, 1);
GraphicTerminal.SymbolFrgndColor  	= ones  (num_Line * 2, 1) * -1;
GraphicTerminal.SymbolPenStyle    	= zeros (num_Line * 2, 1);
GraphicTerminal.SymbolPenWidth    	= zeros (num_Line * 2, 1);
GraphicTerminal.TextAlign         	= ones  (num_Line * 2, 1) * 292;
GraphicTerminal.Flag              	= zeros (num_Line * 2, 1);
GraphicTerminal.Variant_ID        	= ones  (num_Line * 2, 1);
GraphicTerminal.Flag_Variant      	= ones  (num_Line * 2, 1);
GraphicTerminal.GraphicArea_ID    	= ones  (num_Line * 2, 1);
GraphicTerminal.GraphicNode_ID    	= NaN   (num_Line * 2, 1);

%% Consideration of additional input variables

AddInpVar = setdiff(...                                                     % Additional input variables (AIV)
    LineInput.Properties.VariableNames,...                                  % All        input variables
    {'Name', 'Node1'      ,'LengthY' , 'Node2'   ,'Terminal_ID1',...        % Default    input variables 
    'Terminal_ID2'        ,'Element_ID'          ,'GraphicElement_ID',...
    'GraphicTerminal_ID1' ,'GraphicTerminal_ID2' ,...
    'Node1_ID','Node2_ID' ,'VoltLevel_ID',...
    'SymCenterX'          ,'SymCenterY'});

AddVarMain = intersect(AddInpVar, Line.           Properties.VariableNames); % In Line
AddVarTerm = intersect(AddInpVar, Terminal.       Properties.VariableNames); % In Terminal
AddVarElem = intersect(AddInpVar, Element.        Properties.VariableNames); % In Element
AddVarGrEl = intersect(AddInpVar, GraphicElement. Properties.VariableNames); % In GraphicElement
AddVarGrTe = intersect(AddInpVar, GraphicTerminal.Properties.VariableNames); % In GraphicTerminal

for k_AIV = 1 : numel(AddVarMain)                                           % Consideration of changes in AIV
    Line.           (AddVarMain{k_AIV}) = LineInput.(AddVarMain{k_AIV});
end
for k_AIV = 1 : numel(AddVarTerm)                                           % Consideration of changes in AIV
    Terminal.       (AddVarTerm{k_AIV}) = repmat(LineInput.(AddVarTerm{k_AIV}),2,1);
end
for k_AIV = 1 : numel(AddVarElem)                                           % Consideration of changes in AIV
    Element.        (AddVarElem{k_AIV}) = LineInput.(AddVarElem{k_AIV});
end
for k_AIV = 1 : numel(AddVarGrEl)                                       	% Consideration of changes in AIV
    GraphicElement.	(AddVarGrEl{k_AIV}) = LineInput.(AddVarGrEl{k_AIV});
end
for k_AIV = 1 : numel(AddVarGrTe)                                         	% Consideration of changes in AIV
    GraphicTerminal.(AddVarGrTe{k_AIV}) = repmat(LineInput.(AddVarGrTe{k_AIV}),2,1);
end
