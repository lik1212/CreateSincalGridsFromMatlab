function Mat2Sin_AddInfeeder(InfeederInput, SinName, SinPath)
%Mat2Sin_AddInfeeder Add Infeeder(s) to a Sincal Model
%
%   Mat2Sin_AddInfeeder(InfeederInput, SinName, SinPath)
%
%       InfeederInput (Required) - Table with 3 variables:
%                                  .Name - Name of the new Infeeder(s)
%                                  .Node - Name of the Node Infeeder(s) is
%                                          connected to
%                                  .LengthY - Graphic length in Y direction
%                                  ....  - options can be added with the
%                                          Attribute name of Sincal DB Tables
%                                          Infeeder, Terminal, Element,
%                                          GraphicElement or GraphicTerminal
%                                          (see PSS Sincal Database Description)
%       SinName       (Required) - String with name of the Sincal file
%       SinPath       (Required) - String with path of the Sincal file
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Open Matlab connection with the Access DB of the Sincal model

a = Mat2Sin_OpenDBConn(SinName, SinPath);

%% Consideration of IDs (primary keys) before new Infeeder(s) are added
%  Check existing IDs (in the DB) and define IDs for new Infeeder(s)

num_Infeeder = size(InfeederInput,1);   % Number of new Infeeder(s)

Terminal_ID_val        = AccessGetColVal(a, 'Terminal'       , 'Terminal_ID'       );  % Get values for 'Terminal_ID'        in table 'Terminal'
Element_ID_val         = AccessGetColVal(a, 'Element'        , 'Element_ID'        );  % Get values for 'Element_ID'         in table 'Element'
GraphicElement_ID_val  = AccessGetColVal(a, 'GraphicElement' , 'GraphicElement_ID' );  % Get values for 'GraphicElement_ID'  in table 'GraphicElement'
GraphicTerminal_ID_val = AccessGetColVal(a, 'GraphicTerminal', 'GraphicTerminal_ID');  % Get values for 'GraphicTerminal_ID' in table 'GraphicTerminal'

Terminal_ID_offset        = max(double([0, Terminal_ID_val{:}       ]));
Element_ID_offset         = max(double([0, Element_ID_val{:}        ]));
GraphicElement_ID_offset  = max(double([0, GraphicElement_ID_val{:} ]));
GraphicTerminal_ID_offset = max(double([0, GraphicTerminal_ID_val{:}]));

InfeederInput.Terminal_ID        = ...                                              % Define Terminal_ID        of new Infeeder(s)
    Terminal_ID_offset        + reshape(1:num_Infeeder,[],1);
InfeederInput.Element_ID         = ...                                              % Define Element_ID         of new Infeeder(s)
    Element_ID_offset         + reshape(1:num_Infeeder,[],1);
InfeederInput.GraphicElement_ID  = ...                                              % Define GraphicElement_ID  of new Infeeder(s)
    GraphicElement_ID_offset  + reshape(1:num_Infeeder,[],1);
InfeederInput.GraphicTerminal_ID = ...                                              % Define GraphicTerminal_ID of new Infeeder(s)
    GraphicTerminal_ID_offset + reshape(1:num_Infeeder,[],1);

%% Add Node_ID, VoltLevel_ID and Graphic offset to the InfeederInput file
%  This is done with Node information

% Get Node_ID and VoltLevel_ID of existing Nodes
ColNameNode        = {'Node_ID', 'Name', 'VoltLevel_ID'};
SinNodeOut         = AccessGetColVal(a, 'Node'            , ColNameNode);
SinNodeOut         = cell2table(SinNodeOut,'VariableNames', ColNameNode);
SinNodeOut.Name    = strrep(SinNodeOut.Name, ' ', '');                      % Remove empty spaces in NodeName

% Get Graphic Position of existing Nodes
ColNameGraphicNode = {'NodeStartX', 'NodeStartY', 'NodeEndX', 'NodeEndY','Node_ID'};
GraphicNodeOut     = AccessGetColVal(a, 'GraphicNode'         , ColNameGraphicNode);
GraphicNodeOut     = cell2table(GraphicNodeOut,'VariableNames', ColNameGraphicNode);

% Initial Infeeder(s) to Node_ID connection, VoltLevel_ID and Node position
Infeed2Node_ID = zeros(num_Infeeder,1);
VoltLevel_ID   = zeros(num_Infeeder,1);
SymCenterX     = zeros(num_Infeeder,1);
SymCenterY     = zeros(num_Infeeder,1);
% Over all Infeeder(s), check there Node_ID, VoltLevel_ID and there Node position
for k_Infeeder = 1 : num_Infeeder
    Infeed2Node_ID(k_Infeeder) = ...
        SinNodeOut.Node_ID       (ismember(SinNodeOut.Name,    InfeederInput.Node(k_Infeeder,:)));
    VoltLevel_ID(k_Infeeder) = ...
        SinNodeOut.VoltLevel_ID  (ismember(SinNodeOut.Name,    InfeederInput.Node(k_Infeeder,:)));
    SymCenterX(k_Infeeder) = mean([...
        GraphicNodeOut.NodeStartX(ismember(GraphicNodeOut.Node_ID, Infeed2Node_ID(k_Infeeder,:)))...
        GraphicNodeOut.  NodeEndX(ismember(GraphicNodeOut.Node_ID, Infeed2Node_ID(k_Infeeder,:)))]);
    SymCenterY(k_Infeeder) = mean([...
        GraphicNodeOut.NodeStartY(ismember(GraphicNodeOut.Node_ID, Infeed2Node_ID(k_Infeeder,:)))...
        GraphicNodeOut.  NodeEndY(ismember(GraphicNodeOut.Node_ID, Infeed2Node_ID(k_Infeeder,:)))]);
end

% Add Node_ID, VoltLevel_ID and Position to the DCIInput
InfeederInput.Node_ID      = Infeed2Node_ID;
InfeederInput.VoltLevel_ID = VoltLevel_ID;
InfeederInput.SymCenterX   = SymCenterX;
InfeederInput.SymCenterY   = SymCenterY + InfeederInput.LengthY;

%% Prepare Input (table entries) for Sincal Database to add new Infeeder(s)

[Infeeder, Terminal, Element, GraphicElement, GraphicTerminal] = PrepInfeederFiles(InfeederInput);

%% Set Input (table entries) to Sincal Database to add new Infeeder(s)

AccessAddRows(a, 'Infeeder'       , Infeeder       );
AccessAddRows(a, 'Terminal'       , Terminal       );
AccessAddRows(a, 'Element'        , Element        );
AccessAddRows(a, 'GraphicElement' , GraphicElement );
AccessAddRows(a, 'GraphicTerminal', GraphicTerminal);

%% Close Matlab connection with the Access DB of the Sincal model

invoke(a.conn,'Close');	% Close the DB connection

end
