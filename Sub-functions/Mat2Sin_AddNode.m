function Mat2Sin_AddNode(NodeInput, SinName, SinPath)
%Mat2Sin_AddNode Add Nodes to a Sincal Model
%
%   Mat2Sin_AddNode(NodeInput, SinName, SinPath)
%
%       NodeInput (Required) - Table with 3 variables:
%                              .Name       - Name of the new Nodes
%                              .NodeStartX - X-Position of the new Nodes
%                              .NodeStartY - Y-Position of the new Nodes
%                              .Un   - Nominal voltage of new Nodes
%                              ....  - options can be added with the 
%                                      Attribute name of Sincal DB Tables 
%                                      Node or GraphicNode
%                                      (see PSS Sincal Database Description)
%       SinName   (Required) - String with name of the Sincal file
%       SinPath   (Required) - String with path of the Sincal file
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Open Matlab connection with the Access DB of the Sincal model

a = Mat2Sin_OpenDBConn(SinName, SinPath);

%% Consideration of IDs (primary keys) before new Nodes are added
%  Check IDs of existing Nodes (in the DB) and define IDs for new Nodes

num_Node = size(NodeInput,1);   % Number of new nodes

GraphicNode_ID_val = AccessGetColVal(a, 'GraphicNode', 'GraphicNode_ID');    % Get values for 'GraphicNode_ID' in table 'GraphicNode'
Node_ID_val        = AccessGetColVal(a, 'Node'       , 'Node_ID'       );    % Get values for 'Node_ID'        in table 'Node'

GraphicNode_ID_offset = max(double([0, GraphicNode_ID_val{:}]));
Node_ID_offset        = max(double([0, Node_ID_val{:}       ]));

NodeInput.GraphicNode_ID = GraphicNode_ID_offset + reshape(1:num_Node,[],1); % Define GraphicNode_ID of new Nodes
NodeInput.Node_ID        = Node_ID_offset        + reshape(1:num_Node,[],1); % Define Node_ID        of new Nodes

%% Check if Network voltage level of new Nodes exist, if not create them

VoltageLevel_val = AccessGetColVal(a, 'VoltageLevel', 'Un');                    % Get values for 'Un' in table 'VoltageLevel'
newVoltageLevel  = setdiff(NodeInput.Un,[VoltageLevel_val{:}]);                 % Check if new voltage levels exist
if ~isempty(newVoltageLevel)
    VoltageLevelInput    = table;
    VoltLevel_ID_val     = AccessGetColVal(a, 'VoltageLevel', 'VoltLevel_ID');  % Check  IDs of existing VoltageLevels 
    VoltLevel_ID_offset  = max(double([0, VoltLevel_ID_val{:}]));               % Define IDs for new     VoltageLevels
    VoltageLevelInput.Un           = newVoltageLevel;
    VoltageLevelInput.VoltLevel_ID = VoltLevel_ID_offset + ...
        reshape(1:numel(newVoltageLevel),[],1);
    VoltageLevel = PrepVoltageLevelFiles(VoltageLevelInput);                    % Prepare Input (table entries) for Sincal Database to add new VoltageLevels
    AccessAddRows(a, 'VoltageLevel', VoltageLevel);                             % Set     Input (table entries) to  Sincal Database to add new VoltageLevels
end

%% Connect Node with Network voltage level
%  If all Nodes have new IDs, only the VoltageLevelInput could be used, but
%  for generality, it is compared with the values in the DB

% Get VoltageLevel of existing Nodes 
ColNameVoltageLevel        = {'VoltLevel_ID', 'Un'};
SinVoltageLevelOut         = AccessGetColVal(a, 'VoltageLevel'            , ColNameVoltageLevel); 
SinVoltageLevelOut         = cell2table(SinVoltageLevelOut,'VariableNames', ColNameVoltageLevel);

% Initial Node to VoltLevel_ID connection
Node2VoltLevel_ID = zeros(num_Node,1);
% Over all Nodes check VoltLevel_ID connection
for k_Node = 1 : num_Node
    Node2VoltLevel_ID(k_Node) = ...
        SinVoltageLevelOut.VoltLevel_ID(ismember(SinVoltageLevelOut.Un,NodeInput.Un(k_Node,:)));
end
NodeInput.VoltLevel_ID = Node2VoltLevel_ID;

%% Prepare Input (table entries) for Sincal Database to add new Nodes

[GraphicNode, Node] = PrepNodeFiles(NodeInput);

%% Set Input (table entries) to Sincal Database to add new Nodes

AccessAddRows(a, 'GraphicNode', GraphicNode);
AccessAddRows(a, 'Node'       , Node       );

%% Close Matlab connection with the Access DB of the Sincal model

invoke(a.conn,'Close');	% Close the DB connection

end
