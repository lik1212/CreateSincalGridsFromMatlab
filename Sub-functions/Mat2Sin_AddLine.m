function Mat2Sin_AddLine(LineInput, SinName, SinPath)
%Mat2Sin_AddLine Add Line to a Sincal Model
%
%   Mat2Sin_AddLine(LineInput, SinName, SinPath)
%   
%       LineInput (Required) - Table with 3 variables:
%                              .Name  - Name of the new Lines
%                              .Node1 - Name of the 1. Node Line is connected to
%                              .Node2 - Name of the 2. Node Line is connected to
%                              ....   - options can be added with the 
%                                       Attribute name of Sincal DB Tables 
%                                       Line, Terminal, Element,
%                                       GraphicElement or GraphicTerminal
%                                       (see PSS Sincal Database Description)
%       SinName  (Required)  - String with name of the Sincal file
%       SinPath  (Required)  - String with path of the Sincal file
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Open Matlab connection with the Access DB of the Sincal model

a = Mat2Sin_OpenDBConn(SinName, SinPath);

%% Consideration of IDs (primary keys) before new Lines are added
%  Check existing IDs (in the DB) and define IDs for new Lines

num_Line = size(LineInput,1);   % Number of new Line

Terminal_ID_val        = AccessGetColVal(a, 'Terminal'       , 'Terminal_ID'       );  % Get values for 'Terminal_ID'        in table 'Terminal'
Element_ID_val         = AccessGetColVal(a, 'Element'        , 'Element_ID'        );  % Get values for 'Element_ID'         in table 'Element'
GraphicElement_ID_val  = AccessGetColVal(a, 'GraphicElement' , 'GraphicElement_ID' );  % Get values for 'GraphicElement_ID'  in table 'GraphicElement'
GraphicTerminal_ID_val = AccessGetColVal(a, 'GraphicTerminal', 'GraphicTerminal_ID');  % Get values for 'GraphicTerminal_ID' in table 'GraphicTerminal'

Terminal_ID_offset        = max(double([0, Terminal_ID_val{:}       ]));
Element_ID_offset         = max(double([0, Element_ID_val{:}        ]));
GraphicElement_ID_offset  = max(double([0, GraphicElement_ID_val{:} ]));
GraphicTerminal_ID_offset = max(double([0, GraphicTerminal_ID_val{:}]));

LineInput.Terminal_ID1        = ...                                             % Define Terminal_ID1        of new Lines
    Terminal_ID_offset        + reshape(1:2:num_Line * 2,[],1);
LineInput.Terminal_ID2        = ...                                             % Define Terminal_ID2        of new Lines
    Terminal_ID_offset        + reshape(2:2:num_Line * 2,[],1);
LineInput.Element_ID          = ...                                             % Define Element_ID          of new Lines
    Element_ID_offset         + reshape(1:num_Line,[],1);
LineInput.GraphicElement_ID   = ...                                             % Define GraphicElement_ID   of new Lines
    GraphicElement_ID_offset  + reshape(1:num_Line,[],1);
LineInput.GraphicTerminal_ID1 = ...                                             % Define GraphicTerminal_ID1 of new Lines
    GraphicTerminal_ID_offset + reshape(1:2:num_Line * 2,[],1);
LineInput.GraphicTerminal_ID2 = ...                                             % Define GraphicTerminal_ID2 of new Lines
    GraphicTerminal_ID_offset + reshape(2:2:num_Line * 2,[],1);

%% Add Node_ID, VoltLevel_ID and Graphic offset to the LineInput file
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

% Initial Line to to Node_ID connection, VoltLevel_ID and Node position
Line2Node1_ID = zeros(num_Line,1);
Line2Node2_ID = zeros(num_Line,1);
VoltLevel_ID  = zeros(num_Line,1);
SymCenterX    = zeros(num_Line,1);
SymCenterY    = zeros(num_Line,1);
% Over all Lines, check there Node_ID, VoltLevel_ID and there Node position
for k_Line = 1 : num_Line
    Line2Node1_ID(k_Line) = ...
        SinNodeOut.Node_ID       (ismember(SinNodeOut.Name,      LineInput.Node1(k_Line,:)));
    Line2Node2_ID(k_Line) = ...
        SinNodeOut.Node_ID       (ismember(SinNodeOut.Name,      LineInput.Node2(k_Line,:)));
    VoltLevel_ID(k_Line) = ...
        SinNodeOut.VoltLevel_ID  (ismember(SinNodeOut.Name,      LineInput.Node1(k_Line,:)));       
    SymCenterX(k_Line) = mean([...
        mean([...
        GraphicNodeOut.NodeStartX(ismember(GraphicNodeOut.Node_ID, Line2Node1_ID(k_Line,:))),   ...
        GraphicNodeOut.  NodeEndX(ismember(GraphicNodeOut.Node_ID, Line2Node1_ID(k_Line,:)))]), ...
        mean([...
        GraphicNodeOut.NodeStartX(ismember(GraphicNodeOut.Node_ID, Line2Node2_ID(k_Line,:))),   ...
        GraphicNodeOut.  NodeEndX(ismember(GraphicNodeOut.Node_ID, Line2Node2_ID(k_Line,:)))])]);
    SymCenterY(k_Line) = mean([...
        mean([...
        GraphicNodeOut.NodeStartY(ismember(GraphicNodeOut.Node_ID, Line2Node1_ID(k_Line,:))),   ...
        GraphicNodeOut.NodeStartY(ismember(GraphicNodeOut.Node_ID, Line2Node1_ID(k_Line,:)))]), ...
        mean([...        
        GraphicNodeOut.NodeStartY(ismember(GraphicNodeOut.Node_ID, Line2Node2_ID(k_Line,:))),   ...
        GraphicNodeOut.NodeStartY(ismember(GraphicNodeOut.Node_ID, Line2Node2_ID(k_Line,:)))])]);
end

% Add Node_ID, VoltLevel_ID and Position to the LineInput
LineInput.Node1_ID     = Line2Node1_ID;
LineInput.Node2_ID     = Line2Node2_ID;
LineInput.VoltLevel_ID = VoltLevel_ID;
LineInput.SymCenterX   = SymCenterX;
LineInput.SymCenterY   = SymCenterY;

%% Prepare Input (table entries) for Sincal Database to add new Lines

[Line, Terminal, Element, GraphicElement, GraphicTerminal] = PrepLineFiles(LineInput);

%% Set Input (table entries) to Sincal Database to add new Lines

AccessAddRows(a, 'Line'           , Line           );
AccessAddRows(a, 'Terminal'       , Terminal       );
AccessAddRows(a, 'Element'        , Element        );
AccessAddRows(a, 'GraphicElement' , GraphicElement );
AccessAddRows(a, 'GraphicTerminal', GraphicTerminal);

%% Close Matlab connection with the Access DB of the Sincal model

invoke(a.conn,'Close');	% Close the DB connection

end
