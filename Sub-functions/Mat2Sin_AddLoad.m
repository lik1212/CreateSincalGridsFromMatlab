function Mat2Sin_AddLoad(LoadInput, SinName, SinPath)
%Mat2Sin_AddLoad Add Loads to a Sincal Model
%
%   Mat2Sin_AddLoad(LoadInput, SinName, SinPath)
%   
%       LoadInput (Required) - Table with 3 variables:
%                              .Name - Name of the new Loads
%                              .Node - Name of the Node Load is connected to
%                              .LengthY - Graphic length in Y direction
%                              ....  - options can be added with the 
%                                      Attribute name of Sincal DB Tables 
%                                      Load, Terminal, Element,
%                                      GraphicElement or GraphicTerminal
%                                     (see PSS Sincal Database Description)
%       SinName   (Required) - String with name of the Sincal file
%       SinPath   (Required) - String with path of the Sincal file
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Open Matlab connection with the Access DB of the Sincal model

a = Mat2Sin_OpenDBConn(SinName, SinPath);

%% Consideration of IDs (primary keys) before new Loads are added
%  Check existing IDs (in the DB) and define IDs for new Loads

num_Load = size(LoadInput,1);   % Number of new loads

Terminal_ID_val        = AccessGetColVal(a, 'Terminal'       , 'Terminal_ID'       );  % Get values for 'Terminal_ID'        in table 'Terminal'
Element_ID_val         = AccessGetColVal(a, 'Element'        , 'Element_ID'        );  % Get values for 'Element_ID'         in table 'Element'
GraphicElement_ID_val  = AccessGetColVal(a, 'GraphicElement' , 'GraphicElement_ID' );  % Get values for 'GraphicElement_ID'  in table 'GraphicElement'
GraphicTerminal_ID_val = AccessGetColVal(a, 'GraphicTerminal', 'GraphicTerminal_ID');  % Get values for 'GraphicTerminal_ID' in table 'GraphicTerminal'

Terminal_ID_offset        = max(double([0, Terminal_ID_val{:}       ]));
Element_ID_offset         = max(double([0, Element_ID_val{:}        ]));
GraphicElement_ID_offset  = max(double([0, GraphicElement_ID_val{:} ]));
GraphicTerminal_ID_offset = max(double([0, GraphicTerminal_ID_val{:}]));

LoadInput.Terminal_ID        = ...                                              % Define Terminal_ID        of new Loads
    Terminal_ID_offset        + reshape(1:num_Load,[],1);
LoadInput.Element_ID         = ...                                              % Define Element_ID         of new Loads
    Element_ID_offset         + reshape(1:num_Load,[],1);
LoadInput.GraphicElement_ID  = ...                                              % Define GraphicElement_ID  of new Loads
    GraphicElement_ID_offset  + reshape(1:num_Load,[],1);
LoadInput.GraphicTerminal_ID = ...                                              % Define GraphicTerminal_ID of new Loads
    GraphicTerminal_ID_offset + reshape(1:num_Load,[],1);

%% Add Node_ID, VoltLevel_ID and Graphic offset to the LoadInput file
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

% Initial Load to Node_ID connection, VoltLevel_ID and Node position
Load2Node_ID = zeros(num_Load,1);
VoltLevel_ID = zeros(num_Load,1);
SymCenterX   = zeros(num_Load,1);
SymCenterY   = zeros(num_Load,1);
% Over all Loads, check there Node_ID, VoltLevel_ID and there Node position
for k_Load = 1 : num_Load         
    Load2Node_ID(k_Load) = ...
        SinNodeOut.Node_ID       (ismember(SinNodeOut.Name,      LoadInput.Node(k_Load,:)));
    VoltLevel_ID(k_Load) = ...
        SinNodeOut.VoltLevel_ID  (ismember(SinNodeOut.Name,      LoadInput.Node(k_Load,:)));
    SymCenterX(k_Load) = mean([...
        GraphicNodeOut.NodeStartX(ismember(GraphicNodeOut.Node_ID, Load2Node_ID(k_Load,:)))...
        GraphicNodeOut.  NodeEndX(ismember(GraphicNodeOut.Node_ID, Load2Node_ID(k_Load,:)))]);
    SymCenterY(k_Load) = mean([...
        GraphicNodeOut.NodeStartY(ismember(GraphicNodeOut.Node_ID, Load2Node_ID(k_Load,:)))...
        GraphicNodeOut.  NodeEndY(ismember(GraphicNodeOut.Node_ID, Load2Node_ID(k_Load,:)))]); 
end

% Add Node_ID, VoltLevel_ID and Position to the LoadInput
LoadInput.Node_ID      = Load2Node_ID;
LoadInput.VoltLevel_ID = VoltLevel_ID;
LoadInput.SymCenterX   = SymCenterX;
LoadInput.SymCenterY   = SymCenterY + LoadInput.LengthY;

%% Prepare Input (table entries) for Sincal Database to add new Loads

[Load, Terminal, Element, GraphicElement, GraphicTerminal] = PrepLoadFiles(LoadInput);

%% Set Input (table entries) to Sincal Database to add new Loads

AccessAddRows(a, 'Load'           , Load           );
AccessAddRows(a, 'Terminal'       , Terminal       );
AccessAddRows(a, 'Element'        , Element        );
AccessAddRows(a, 'GraphicElement' , GraphicElement );
AccessAddRows(a, 'GraphicTerminal', GraphicTerminal);

%% Close Matlab connection with the Access DB of the Sincal model

invoke(a.conn,'Close');	% Close the DB connection

end
