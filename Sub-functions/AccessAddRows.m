function AccessAddRows(a, TabName, NewRows)
%AccessAddRows
%   
%   If a COM Server connection from Matlab to Access DB is built, this
%   function will add new values (rows) to one table in the DB
%
%   AccessAddRows(a, TabName, NewRows)
%   
%       a       (Required) - Struct with COM server connection
%       TabName (Required) - String with name of the DB's tables
%       NewRows (Required) - New values to be add in table. It should be in
%                            matlab table-format with the name of columns 
%                            (variables) same as the one in the DB table.
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Main

VariableNames = NewRows.Properties.VariableNames;	% Column names
invoke(a.conn,'BeginTrans');                     	% Begin a new transaction in the open connection
% NaN values or empty string values cannot be added as 'NaN' into a DB
% table, they must stay empty. For this reason a flag variable will decide
% which column values of a new row will stay empty (not be added into a DB
% table). This is done with the following code part
for k_r = 1 : size(NewRows,1)                                                   % r - row
    k_Row_cell    = table2cell(NewRows(k_r,:));                                 % Values as cell to easier compare them
    pos_of_NaN    = ...                                                         % NaN values will not be insert in DB
        cellfun(@any, (cellfun(@isnan, k_Row_cell,'UniformOutput',0)));
    pos_of_empty  = strcmp(k_Row_cell,'');                                      % empty string values will not be insert in DB
    k_Row_cell(cellfun(@ischar, k_Row_cell)) = ...                              % String values has to be inside apostrophes -> ''  
        strcat('''',k_Row_cell(cellfun(@ischar, k_Row_cell)),'''');
    k_Row_cell    = cellfun(@num2str, k_Row_cell,'UniformOutput',0);            % All values to String
    Variable_Flag = ~(pos_of_NaN | pos_of_empty);                               % Flag if not NaN or empty values
    Sql_Col       = ['(',strjoin(strcat(VariableNames(Variable_Flag),', '))];   % Create sql (column1, column2, ...)-part
    Sql_Val       = ['(',strjoin(strcat(k_Row_cell   (Variable_Flag),', '))];   % Create sql (value1 , value2 , ...)-part
    Sql_Col(end)  = ')';                                                        % Change last komma to a closing bracket
    Sql_Val(end)  = ')';                                                        % Change last komma to a closing bracket
    sql = ['INSERT INTO ',TabName,' ' Sql_Col ,' VALUES ', Sql_Val];            % Sql command to insert new records (rows) in a table.
    invoke(a.conn,'Execute',sql);                                               % Execute the SQL Command
end
invoke(a.conn,'CommitTrans');% Save all changes