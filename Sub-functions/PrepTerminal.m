function Terminal = PrepTerminal(EleTerminalInput, num_Port)
% TODO
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)
%% Main

num_Terminal = size(EleTerminalInput,1);
Terminal     = table;

switch num_Port
    case 1
        Terminal.Terminal_ID = EleTerminalInput.Terminal_ID;
        Terminal.Node_ID 	 = EleTerminalInput.Node_ID;
        Terminal.TerminalNo  = ones(num_Terminal,1);
    case 2
        Terminal.Terminal_ID = [EleTerminalInput.Terminal_ID1; EleTerminalInput.Terminal_ID2];
        Terminal.Node_ID     = [EleTerminalInput.Node1_ID    ; EleTerminalInput.Node2_ID    ];
        Terminal.TerminalNo  = repelem([1; 2] , num_Terminal, 1);
end

Terminal.Element_ID   		= repmat(EleTerminalInput.Element_ID , num_Port, 1);
Terminal.Variant_ID   		= ones  (num_Terminal * num_Port, 1);
Terminal.Flag_State   		= ones  (num_Terminal * num_Port, 1);
Terminal.Ir           		= zeros (num_Terminal * num_Port, 1);
Terminal.Ik2          		= zeros (num_Terminal * num_Port, 1);
Terminal.Flag_Terminal		= ones  (num_Terminal * num_Port, 1) * 7;
Terminal.Report_No   		= ones  (num_Terminal * num_Port, 1);
Terminal.Flag_Cur    		= zeros (num_Terminal * num_Port, 1);
Terminal.Flag_Switch 		= zeros (num_Terminal * num_Port, 1);
Terminal.Flag_Variant		= ones  (num_Terminal * num_Port, 1);
Terminal.Flag_Obs			= zeros (num_Terminal * num_Port, 1);