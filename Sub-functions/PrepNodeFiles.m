function [GraphicNode, Node] = PrepNodeFiles(NodeInput)
%PrepNodeFiles Prepare Input for Sincal Database (DB) to add new Nodes
%   
%   The Input for the Sincal Database to add new Node are table entries for
%   the tables GraphicNode and Node. These are prepared with the function.
%
%   [GraphicNode, Node] = PrepNodeFiles(NodeInput)
%   
%       NodeInput   (Required)   - Table with variables:
%                                  .Name         - Name             of new Nodes
%                                  .NodeStartX   - X-Position       of new Nodes
%                                  .NodeStartY   - Y-Position       of new Nodes
%                                  .Un           - Voltage Level    of new Nodes
%                                  .VoltLevel_ID - Voltage Level ID of new Nodes
%                                  .GraphicNode_ID (primary key)
%                                  .Node_ID        (primary key)
%                                  ....  - more variables can be added
%       GraphicNode (Result)     - Table with required entries for the
%                                  Sincal DB table GraphicNode to add Nodes 
%       Node        (Result)     - Table with required entries for the 
%                                  Sincal DB table Node to add Nodes
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Standard Setup

num_Nodes = size(NodeInput,1);

%% GraphicNode table with new required entries

GraphicNode = table;
GraphicNode.GraphicNode_ID(:)	= NodeInput.GraphicNode_ID;
GraphicNode.GraphicLayer_ID		= ones  (num_Nodes,1);
GraphicNode.GraphicType_ID 		= ones  (num_Nodes,1);
GraphicNode.GraphicText_ID1		= ones  (num_Nodes,1);
GraphicNode.GraphicText_ID2		= NaN   (num_Nodes,1);
GraphicNode.Node_ID        		= NodeInput.Node_ID;
GraphicNode.FrgndColor     		= zeros (num_Nodes,1);
GraphicNode.BkgndColor     		= ones  (num_Nodes,1) * -1;
GraphicNode.PenStyle       		= zeros (num_Nodes,1);
GraphicNode.PenWidth       		= ones  (num_Nodes,1) * 2;
GraphicNode.NodeSize       		= ones  (num_Nodes,1) * 4;
GraphicNode.NodeStartX     		= NodeInput.NodeStartX;
GraphicNode.NodeStartY     		= NodeInput.NodeStartY;
GraphicNode.NodeEndX       		= NodeInput.NodeStartX;
GraphicNode.NodeEndY       		= NodeInput.NodeStartY;
GraphicNode.SymType        		= zeros (num_Nodes,1);
GraphicNode.Flag           		= zeros (num_Nodes,1);
GraphicNode.Variant_ID     		= ones  (num_Nodes,1);
GraphicNode.Flag_Variant   		= ones  (num_Nodes,1);
GraphicNode.GraphicArea_ID 		= ones  (num_Nodes,1);

%% Node table with new required entries

Node = table;
Node.Node_ID            = NodeInput.Node_ID;
Node.Group_ID           = ones  (num_Nodes,1);
Node.Variant_ID         = ones  (num_Nodes,1);
Node.VoltLevel_ID		= NodeInput.VoltLevel_ID;
Node.Name               = NodeInput.Name;
Node.ShortName          = NodeInput.Name;
Node.Un                 = NodeInput.Un;
Node.Flag_Type          = ones  (num_Nodes,1);
Node.Ik2                = zeros (num_Nodes,1);
Node.Ip                 = zeros (num_Nodes,1);
Node.Uul                = zeros (num_Nodes,1);
Node.Ull                = zeros (num_Nodes,1);
Node.Uref               = zeros (num_Nodes,1);
Node.hr                 = zeros (num_Nodes,1);
Node.hh                 = zeros (num_Nodes,1);
Node.sh                 = zeros (num_Nodes,1);
Node.m        		 	= zeros (num_Nodes,1);
Node.Flag_Diagram		= zeros (num_Nodes,1);
Node.Report_No   		= ones  (num_Nodes,1);
Node.InclName    		= repmat(cellstr(''),num_Nodes,1);
Node.Flag_Variant		= ones  (num_Nodes,1);
Node.Flag_Reliability	= zeros (num_Nodes,1);
Node.BusbarType_ID   	= NaN   (num_Nodes,1);
Node.SwitchBay1_ID   	= NaN   (num_Nodes,1);
Node.SwitchBay2_ID   	= NaN   (num_Nodes,1);
Node.Flag_HK         	= zeros (num_Nodes,1);
Node.Flag_ABW        	= zeros (num_Nodes,1);
Node.Flag_UM         	= zeros (num_Nodes,1);
Node.UM_Node_ID      	= NaN   (num_Nodes,1);
Node.T_UM            	= zeros (num_Nodes,1);
Node.Flag_VER        	= zeros (num_Nodes,1);
Node.VER_Node_ID     	= NaN   (num_Nodes,1);
Node.Flag_VERP       	= ones  (num_Nodes,1);
Node.T_VER           	= zeros (num_Nodes,1);
Node.p_VER           	= zeros (num_Nodes,1);
Node.Flag_Volt       	= zeros (num_Nodes,1);
Node.RefNode_ID      	= NaN   (num_Nodes,1);
Node.EcoStation_ID   	= NaN   (num_Nodes,1);
Node.EcoField_ID     	= NaN   (num_Nodes,1);
Node.ci              	= zeros (num_Nodes,1);
Node.Cs              	= zeros (num_Nodes,1);
Node.cm              	= zeros (num_Nodes,1);
Node.coo             	= zeros (num_Nodes,1);
Node.Ti              	= NaN   (num_Nodes,1);
Node.Tl              	= zeros (num_Nodes,1);
Node.Ts              	= NaN   (num_Nodes,1);
Node.Phi             	= zeros (num_Nodes,1);
Node.Busbar_ID       	= NaN   (num_Nodes,1);
Node.Equipment_ID    	= NaN   (num_Nodes,1);
Node.Zone_ID         	= NaN   (num_Nodes,1);
Node.Flag_Private    	= zeros (num_Nodes,1);
Node.Uul1            	= zeros (num_Nodes,1);
Node.Ull1            	= zeros (num_Nodes,1);
Node.Stp_ID          	= zeros (num_Nodes,1);
Node.Flag_Phase      	= ones  (num_Nodes,1) * 7;
Node.AddFaultData_ID 	= zeros (num_Nodes,1);
Node.Flag_Pos        	= ones  (num_Nodes,1) * 2;
Node.lat             	= zeros (num_Nodes,1);
Node.lon             	= zeros (num_Nodes,1);
Node.TextVal         	= NaN   (num_Nodes,1);

%% Consideration of additional input variables

AddInpVar = setdiff(...                                                     % Additional input variables (AIV)
    NodeInput.Properties.VariableNames,{...                                	% All        input variables
    'Name'      ,'GraphicNode_ID','Node_ID','VoltLevel_ID',...
    'NodeStartX','NodeStartY'    ,'Un'});                                   % Default    input variables 

AddVarMain = intersect(AddInpVar, Node       .Properties.VariableNames);  	% In Node
AddVarGrap = intersect(AddInpVar, GraphicNode.Properties.VariableNames);   	% In GraphicNode

for k_AIV = 1 : numel(AddVarMain)                                           % Consideration of changes in AIV
    Node.       (AddVarMain{k_AIV}) = NodeInput.(AddVarMain{k_AIV});
end

for k_AIV = 1 : numel(AddVarGrap)                                           % Consideration of changes in AIV
    GraphicNode.(AddVarGrap{k_AIV}) = NodeInput.(AddVarGrap{k_AIV});
end