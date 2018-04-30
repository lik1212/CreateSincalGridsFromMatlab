function Col_Name = GetColNameADB(DB_Name,Tab_Name,DB_Path,DB_Type)
% GetColNameADB - Get the names of columns in a Access Database Table
%
%   Col_Name = GetColNameADB(DB_Name,Tab_Name,DB_Type,DB_Path)
%   
%       DB_Name    (Required)   - String, Name of the database
%       Tab_Name   (Required)   - String, Name of the table
%       DB_Path    (Optional)   - String, Path of the database
%                               - (default): 'cd' - current folder 
%       DB_Type    (Optional)   - String, Type of the database
%                               - Allowed types: .accdb and .mdb 
%                               - (default): '.accdb'
%       Col_Name   (Result)     - Cell, Name of the columns in the Access
%                                 Database Table
%
% RB

%% Programme Core

% Set the default path
if nargin<3
    DB_Path = [cd,'\'];
end
% Set the default database typ
if nargin<4
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
rs = srv.OpenSchema('adSchemaColumns').GetRows;
% Matrix with data about all Tables and Columns in Database
matOfAllData = rs;
% Determine which Columns correspond to the 'Tab_Name' - Table
vecOfAllCol = matOfAllData(3,:);
% Number ot all columns in all Tables
numOfAllCol = numel(vecOfAllCol);
% Initial flaq vetor to determine which Columns correspond to 
% the 'Tab_Name' - Table
ColFlagVec = zeros(numOfAllCol,1);
% Through all Columns
for k=1:numOfAllCol
    % If Column correspond to the 'Tab_Name' - Table
    if isempty(setdiff(vecOfAllCol(k),Tab_Name));
        % Set the flaq to vector to one
        ColFlagVec(k) = 1;
    end
end
% Determine Data-Matrix only for the 'Tab_Name' Table
vecOfTabData = matOfAllData(:,logical(ColFlagVec));
% Determine the order of Columns in the Table
orderOfTabData = vecOfTabData(7,:);
% from cell to double
numeric_orderOfTabData = cell2mat(orderOfTabData);
% index vector with rearrangement flag
[~,indexVector] = sort(numeric_orderOfTabData);
% Rearrang the Columns
sortedVecOfTabData = vecOfTabData(:,indexVector);
% Names of columns in a Access Database Table
Col_Name = sortedVecOfTabData(4,:);
end

