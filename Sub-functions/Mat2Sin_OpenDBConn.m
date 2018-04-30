function a = Mat2Sin_OpenDBConn(SinName, SinPath)
%OpenMat2SinDBConn Open a COM server connection from Matlab to Sincal's DB
%
%   a = OpenMat2SinDBConn(SinName, SinPath)
%
%       SinName (Required) - String with name of the Sincal file
%       SinPath (Required) - String with path of the Sincal file
%       a       (Result)   - Struct with COM server connection
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Input check

if SinPath(end) ~= '\'          % Correct the path if necessary
    SinPath = [SinPath,'\'];
end

%% Main

a = struct;                                                             % Define an struct for the connection with the DB
a.DB_Path = [SinPath,SinName,'_files\database.mdb'];                    % Set the DB path
try                                                                     % Setting of the Access COM server with try-catch check
    a.conn     = actxserver('ADODB.connection');                        % Server for the Matlab connection to Access
    a.provider = 'Microsoft.ACE.OLEDB.12.0';                            % Define the Provider
    a.conn.Open(['Provider=' a.provider ';Data Source=' a.DB_Path]);    % Open the connection with the Access Database
catch
    disp('Error during the connection of Matlab with Access.');         % If an error occur during the Matlab connection with the DB
    return;
end
