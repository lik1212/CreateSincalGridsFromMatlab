function ColVal = AccessGetColVal(a, TabName, ColName)
%AccessGet1ColVal Get values of table's colum of a Access DB
%   
%   If a COM Server connection from Matlab to Access DB is built, this
%   function will get the values of one column of one table in the DB
%
%   ColVal = AccessGet1ColVal(a, TabName, ColName)
%   
%       a       (Required) - Struct with COM server connection
%       TabName (Required) - String with name of the DB's tables
%       ColName (Required) - String or Cell with name of the DB's tables's
%                            columns name of which values will be gotten
%       ColVal  (Result)   - Cell with column values
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Main

if ischar(ColName)                                  % If ColName is a char
    Sql_Col = ColName;                              % Create sql "column1"-part
else
    Sql_Col = strjoin(ColName,', ');                % Create sql "column1, column2, ..."-part
    if strcmp(Sql_Col(end),',')                     % If last part of it a komma
        Sql_Col(end)  = [];                         % Delete the last komma
    end
end
sql    = ['SELECT ', Sql_Col, ' FROM ', TabName];	% SQL command: 'SELECET "column1, column2, ..." FROM "Table Name"'
ADO_rs = invoke(a.conn,'Execute',sql);           	% Get the Recordset(ADO_rs) for table 
if ADO_rs.EOF                                       % EOF - End of File, check if table is empty, EOF == 1 if empty
    if ischar(ColName)    
        ColVal = cell(0, 1);                        % Return empty cell if no values in the column
    else
        ColVal = cell(0, numel(ColName));          	% Return empty cell if no values in the column
    end
else
    ColVal = invoke(ADO_rs,'GetRows')';             % Get the Recordset Values, the file is a cell
end