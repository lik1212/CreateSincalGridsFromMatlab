function Tab_Name = GetTabNameADB(DB_Name,DB_Path,DB_Type)
% GetTabNameADB - Get the names of Tables in a Access Database
%
%   Tab_Name = GetTabNameADB(DB_Name,DB_Type,DB_Path)
%   
%       DB_Name    (Required)   - String, Name of the database
%       DB_Path    (Optional)   - String, Path of the database
%                               - (default): 'cd' - current folder 
%       DB_Type    (Optional)   - String, Type of the database
%                               - Allowed types: .accdb and .mdb 
%                               - (default): '.accdb'
%       Tab_Name   (Result)     - Cell, Name of the Tables in the database
%
% RB

%% Programme Core

% Set the default path
if nargin<2
    DB_Path = [cd,'\'];
end
% Set the default database typ
if nargin<3
    DB_Type = '.accdb';
end
% Correct the path if necessary
if DB_Path(end) ~= '\'
    DB_Path = [DB_Path,'\'];
end
% Create a local OLE Automation server "svr" for starting the Access process
srv = actxserver('ADODB.connection');
% Define the Provider
provider = 'Microsoft.ACE.OLEDB.12.0';
% Open the connection with the Access Database
srv.Open(['Provider=' provider ';Data Source=' DB_Path DB_Name DB_Type]);
% Requesting information about the Database tables
rs = srv.OpenSchema('adSchemaTables').GetRows;
% Determine only the name of the tables
Tab_Name = rs(3, ismember(rs(4,:),'TABLE') )';
% Close the connection with the Access Database
srv.Close;
end