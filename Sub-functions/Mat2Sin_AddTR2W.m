function Mat2Sin_AddTR2W(TR2WInput, SinName, SinPath)
%Mat2Sin_AddTR2W Add TR2W to a Sincal Model
%
%   Mat2Sin_AddTR2W(TR2WInput, SinName, SinPath)
%   
%       TR2WInput (Required) - Table with 3 variables:
%                              .Name  - Name of the new TR2Ws
%                              .Node1 - Name of the 1. Node TR2W is connected to
%                              .Node2 - Name of the 2. Node TR2W is connected to
%                              .Un1   - Rated Voltage, Side 1 (optional)
%                              .Un2   - Rated Voltage, Side 2 (optional)
%                              ....   - options can be added with the 
%                                       Attribute name of Sincal DB Tables 
%                                       TwoWindingTransformer, Terminal, Element,
%                                       GraphicElement or GraphicTerminal
%                                       (see PSS Sincal Database Description)
%       SinName  (Required)  - String with name of the Sincal file
%       SinPath  (Required)  - String with path of the Sincal file
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Open Matlab connection with the Access DB of the Sincal model

a = Mat2Sin_OpenDBConn(SinName, SinPath);

%% Check if TR Rated Voltage is an input

if all(ismember({'Un1','Un2'},TR2WInput.Properties.VariableNames))
    Un_input_yes = true;
end

%% Consideration of IDs (primary keys) before new TR2Ws are added
%  Check existing IDs (in the DB) and define IDs for new TR2Ws

num_TR2W = size(TR2WInput,1);   % Number of new TR2W

Terminal_ID_val        = AccessGetColVal(a, 'Terminal'       , 'Terminal_ID'       );  % Get values for 'Terminal_ID'        in table 'Terminal'
Element_ID_val         = AccessGetColVal(a, 'Element'        , 'Element_ID'        );  % Get values for 'Element_ID'         in table 'Element'
GraphicElement_ID_val  = AccessGetColVal(a, 'GraphicElement' , 'GraphicElement_ID' );  % Get values for 'GraphicElement_ID'  in table 'GraphicElement'
GraphicTerminal_ID_val = AccessGetColVal(a, 'GraphicTerminal', 'GraphicTerminal_ID');  % Get values for 'GraphicTerminal_ID' in table 'GraphicTerminal'

Terminal_ID_offset        = max(double([0, Terminal_ID_val{:}       ]));
Element_ID_offset         = max(double([0, Element_ID_val{:}        ]));
GraphicElement_ID_offset  = max(double([0, GraphicElement_ID_val{:} ]));
GraphicTerminal_ID_offset = max(double([0, GraphicTerminal_ID_val{:}]));

TR2WInput.Terminal_ID1        = ...                                             % Define Terminal_ID1        of new TR2Ws
    Terminal_ID_offset        + reshape(1:2:num_TR2W * 2,[],1);
TR2WInput.Terminal_ID2        = ...                                             % Define Terminal_ID2        of new TR2Ws
    Terminal_ID_offset        + reshape(2:2:num_TR2W * 2,[],1);
TR2WInput.Element_ID          = ...                                             % Define Element_ID          of new TR2Ws
    Element_ID_offset         + reshape(1:num_TR2W,[],1);
TR2WInput.GraphicElement_ID   = ...                                             % Define GraphicElement_ID   of new TR2Ws
    GraphicElement_ID_offset  + reshape(1:num_TR2W,[],1);
TR2WInput.GraphicTerminal_ID1 = ...                                             % Define GraphicTerminal_ID1 of new TR2Ws
    GraphicTerminal_ID_offset + reshape(1:2:num_TR2W * 2,[],1);
TR2WInput.GraphicTerminal_ID2 = ...                                             % Define GraphicTerminal_ID2 of new TR2Ws
    GraphicTerminal_ID_offset + reshape(2:2:num_TR2W * 2,[],1);

%% Add Node_ID and Graphic offset to the TR2WInput file (and Voltage)
%  This is done with Node information

% Get Node_ID of existing Nodes
ColNameNode        = {'Node_ID', 'Name', 'VoltLevel_ID'};
SinNodeOut         = AccessGetColVal(a, 'Node'            , ColNameNode); 
SinNodeOut         = cell2table(SinNodeOut,'VariableNames', ColNameNode);
SinNodeOut.Name    = strrep(SinNodeOut.Name, ' ', '');                      % Remove empty spaces in NodeName

% Get Voltage of Voltage Level
ColNameNode        = {'VoltLevel_ID', 'Un'};
VoltageLevelOut    = AccessGetColVal(a, 'VoltageLevel'         , ColNameNode); 
VoltageLevelOut    = cell2table(VoltageLevelOut,'VariableNames', ColNameNode);

% Get Graphic Position of existing Nodes
ColNameGraphicNode = {'NodeStartX', 'NodeStartY', 'NodeEndX', 'NodeEndY', 'Node_ID'};
GraphicNodeOut     = AccessGetColVal(a, 'GraphicNode'         , ColNameGraphicNode); 
GraphicNodeOut     = cell2table(GraphicNodeOut,'VariableNames', ColNameGraphicNode);

% Initial TR2W to Node_ID connection, and Node position
TR2W2Node1_ID = zeros(num_TR2W,1);
TR2W2Node2_ID = zeros(num_TR2W,1);
SymCenterX    = zeros(num_TR2W,1);
SymCenterY    = zeros(num_TR2W,1);
VoltLevel_ID  = zeros(num_TR2W,1);
if ~ Un_input_yes  % If Rated Voltage is not an input
    Un1           = zeros(num_TR2W,1);
    Un2           = zeros(num_TR2W,1);
end
% Over all TR2Ws, check where Nodes are and there position
for k_TR2W = 1 : num_TR2W
    TR2W2Node1_ID(k_TR2W) = ...
        SinNodeOut.Node_ID       (ismember(SinNodeOut.Name,      TR2WInput.Node1(k_TR2W,:)));
    TR2W2Node2_ID(k_TR2W) = ...
        SinNodeOut.Node_ID       (ismember(SinNodeOut.Name,      TR2WInput.Node2(k_TR2W,:)));
    SymCenterX(k_TR2W) = mean([...
        mean([...
        GraphicNodeOut.NodeStartX(ismember(GraphicNodeOut.Node_ID, TR2W2Node1_ID(k_TR2W,:))),   ...
        GraphicNodeOut.  NodeEndX(ismember(GraphicNodeOut.Node_ID, TR2W2Node1_ID(k_TR2W,:)))]), ...
        mean([...
        GraphicNodeOut.NodeStartX(ismember(GraphicNodeOut.Node_ID, TR2W2Node2_ID(k_TR2W,:))),   ...
        GraphicNodeOut.  NodeEndX(ismember(GraphicNodeOut.Node_ID, TR2W2Node2_ID(k_TR2W,:)))])]);
    SymCenterY(k_TR2W) = mean([...
        mean([...
        GraphicNodeOut.NodeStartY(ismember(GraphicNodeOut.Node_ID, TR2W2Node1_ID(k_TR2W,:))),   ...
        GraphicNodeOut.NodeStartY(ismember(GraphicNodeOut.Node_ID, TR2W2Node1_ID(k_TR2W,:)))]), ...
        mean([...        
        GraphicNodeOut.NodeStartY(ismember(GraphicNodeOut.Node_ID, TR2W2Node2_ID(k_TR2W,:))),   ...
        GraphicNodeOut.NodeStartY(ismember(GraphicNodeOut.Node_ID, TR2W2Node2_ID(k_TR2W,:)))])]);
    VoltLevel_ID(k_TR2W) = ...
        SinNodeOut.VoltLevel_ID(ismember(...
        SinNodeOut.Node_ID          , TR2W2Node1_ID(k_TR2W,:)));	% Always assigned to voltage of 1. Node
    if ~ Un_input_yes   % If Rated Voltage is not an input
        Un1(k_TR2W) = ....
            VoltageLevelOut.Un                                   (ismember(...
            VoltageLevelOut.VoltLevel_ID, SinNodeOut.VoltLevel_ID(ismember(...
            SinNodeOut.Node_ID          , TR2W2Node1_ID(k_TR2W,:)))));
        Un2(k_TR2W) = ...
            VoltageLevelOut.Un                                   (ismember(...
            VoltageLevelOut.VoltLevel_ID, SinNodeOut.VoltLevel_ID(ismember(...
            SinNodeOut.Node_ID          , TR2W2Node2_ID(k_TR2W,:)))));
    end
end

% Add Node_ID and Position to the TR2WInput
TR2WInput.Node1_ID     = TR2W2Node1_ID;
TR2WInput.Node2_ID     = TR2W2Node2_ID;
TR2WInput.SymCenterX   = SymCenterX;
TR2WInput.SymCenterY   = SymCenterY;
TR2WInput.VoltLevel_ID = VoltLevel_ID;
if ~ Un_input_yes   % If Rated Voltage is not an input
    TR2WInput.Un1          = Un1;
    TR2WInput.Un2          = Un2;
end

%% Prepare Input (table entries) for Sincal Database to add new TR2Ws

[TwoWindingTransformer, Terminal, Element, GraphicElement, GraphicTerminal] = PrepTR2WFiles(TR2WInput);

%% Set Input (table entries) to Sincal Database to add new TR2Ws

AccessAddRows(a, 'TwoWindingTransformer', TwoWindingTransformer);
AccessAddRows(a, 'Terminal'             , Terminal             );
AccessAddRows(a, 'Element'              , Element              );
AccessAddRows(a, 'GraphicElement'       , GraphicElement       );
AccessAddRows(a, 'GraphicTerminal'      , GraphicTerminal      );

%% Close Matlab connection with the Access DB of the Sincal model

invoke(a.conn,'Close');	% Close the DB connection

end
