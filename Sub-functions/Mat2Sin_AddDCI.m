function Mat2Sin_AddDCI(DCIInput, SinName, SinPath)
%Mat2Sin_AddDCI Add DCInfeeders to a Sincal Model
%
%   Mat2Sin_AddDCI(DCIInput, SinName, SinPath)
%   
%       DCIInput (Required) - Table with 3 variables:
%                             .Name - Name of the new DCIs
%                             .Node - Name of the Node DCI is connected to
%                             .LengthY - Graphic length in Y direction
%                             ....  - options can be added with the 
%                                     Attribute name of Sincal DB Tables 
%                                     DCInfeeder, Terminal, Element,
%                                     GraphicElement or GraphicTerminal
%                                     (see PSS Sincal Database Description)
%       SinName  (Required) - String with name of the Sincal file
%       SinPath  (Required) - String with path of the Sincal file
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Open Matlab connection with the Access DB of the Sincal model

a = Mat2Sin_OpenDBConn(SinName, SinPath);

%% Consideration of IDs (primary keys) before new DCIs are added
%  Check existing IDs (in the DB) and define IDs for new DCIs

num_DCI = size(DCIInput,1);   % Number of new DCIs

Terminal_ID_val        = AccessGetColVal(a, 'Terminal'       , 'Terminal_ID'       );  % Get values for 'Terminal_ID'        in table 'Terminal'
Element_ID_val         = AccessGetColVal(a, 'Element'        , 'Element_ID'        );  % Get values for 'Element_ID'         in table 'Element'
GraphicElement_ID_val  = AccessGetColVal(a, 'GraphicElement' , 'GraphicElement_ID' );  % Get values for 'GraphicElement_ID'  in table 'GraphicElement'
GraphicTerminal_ID_val = AccessGetColVal(a, 'GraphicTerminal', 'GraphicTerminal_ID');  % Get values for 'GraphicTerminal_ID' in table 'GraphicTerminal'

Terminal_ID_offset        = max(double([0, Terminal_ID_val{:}       ]));
Element_ID_offset         = max(double([0, Element_ID_val{:}        ]));
GraphicElement_ID_offset  = max(double([0, GraphicElement_ID_val{:} ]));
GraphicTerminal_ID_offset = max(double([0, GraphicTerminal_ID_val{:}]));

DCIInput.Terminal_ID        = ...                                              % Define Terminal_ID        of new DCIs
    Terminal_ID_offset        + reshape(1:num_DCI,[],1);
DCIInput.Element_ID         = ...                                              % Define Element_ID         of new DCIs
    Element_ID_offset         + reshape(1:num_DCI,[],1);
DCIInput.GraphicElement_ID  = ...                                              % Define GraphicElement_ID  of new DCIs
    GraphicElement_ID_offset  + reshape(1:num_DCI,[],1);
DCIInput.GraphicTerminal_ID = ...                                              % Define GraphicTerminal_ID of new DCIs
    GraphicTerminal_ID_offset + reshape(1:num_DCI,[],1);

%% Add Node_ID, VoltLevel_ID and Graphic offset to the DCIInput file
%  This is done with Node information

% Get Node_ID and VoltLevel_ID of existing Nodes
ColNameNode        = {'Node_ID', 'Name', 'VoltLevel_ID'};
SinNodeOut         = AccessGetColVal(a, 'Node'            , ColNameNode); 
SinNodeOut         = cell2table(SinNodeOut,'VariableNames', ColNameNode);
SinNodeOut.Name    = strrep(SinNodeOut.Name, ' ', '');                      % Remove empty spaces in NodeName

% Get Graphic Position of existing Nodes
ColNameGraphicNode = {'NodeStartX', 'NodeStartY', 'NodeEndX', 'NodeEndY', 'Node_ID'};
GraphicNodeOut     = AccessGetColVal(a, 'GraphicNode'         , ColNameGraphicNode); 
GraphicNodeOut     = cell2table(GraphicNodeOut,'VariableNames', ColNameGraphicNode);

% Initial DCI to Node_ID connection, VoltLevel_ID and Node position
DCI2Node_ID  = zeros(num_DCI,1);
VoltLevel_ID = zeros(num_DCI,1);
SymCenterX   = zeros(num_DCI,1);
SymCenterY   = zeros(num_DCI,1);
% Over all DCIs, check there Node_ID, VoltLevel_ID and there Node position
for k_DCI = 1 : num_DCI         
    DCI2Node_ID(k_DCI) = ...
        SinNodeOut.Node_ID       (ismember(SinNodeOut.Name,        DCIInput.Node(k_DCI,:)));
    VoltLevel_ID(k_DCI) = ...
        SinNodeOut.VoltLevel_ID  (ismember(SinNodeOut.Name,        DCIInput.Node(k_DCI,:)));
    SymCenterX(k_DCI) = mean([...
        GraphicNodeOut.NodeStartX(ismember(GraphicNodeOut.Node_ID, DCI2Node_ID(k_DCI,:)))...
        GraphicNodeOut.  NodeEndX(ismember(GraphicNodeOut.Node_ID, DCI2Node_ID(k_DCI,:)))]);
    SymCenterY(k_DCI) = mean([...
        GraphicNodeOut.NodeStartY(ismember(GraphicNodeOut.Node_ID, DCI2Node_ID(k_DCI,:)))...
        GraphicNodeOut.  NodeEndY(ismember(GraphicNodeOut.Node_ID, DCI2Node_ID(k_DCI,:)))]);
end

% Add Node_ID, VoltLevel_ID and Position to the DCIInput
DCIInput.Node_ID      = DCI2Node_ID;
DCIInput.VoltLevel_ID = VoltLevel_ID;
DCIInput.SymCenterX   = SymCenterX;
DCIInput.SymCenterY   = SymCenterY + DCIInput.LengthY;

%% Prepare Input (table entries) for Sincal Database to add new DCIs

[DCInfeeder, Terminal, Element, GraphicElement, GraphicTerminal] = PrepDCIFiles(DCIInput);

%% Set Input (table entries) to Sincal Database to add new DCIs

AccessAddRows(a, 'DCInfeeder'     , DCInfeeder     );
AccessAddRows(a, 'Terminal'       , Terminal       );
AccessAddRows(a, 'Element'        , Element        );
AccessAddRows(a, 'GraphicElement' , GraphicElement );
AccessAddRows(a, 'GraphicTerminal', GraphicTerminal);

%% Close Matlab connection with the Access DB of the Sincal model

invoke(a.conn,'Close');	% Close the DB connection

end
