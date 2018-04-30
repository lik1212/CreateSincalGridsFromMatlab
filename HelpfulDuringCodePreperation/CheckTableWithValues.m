% This function will display all Tables that are not empty in a DB

%% Setup

clear; path(pathdef);
SinName      = 'TempEmpty';
path_split   = strsplit(pwd,'\');
addpath(       [strjoin(path_split(1:end-1),'\'),'\Sub-functions\']);
SinPath      = [strjoin(path_split(1:end-1),'\'),'\SincalGrid\'   ];

%% Main. Check which tables are not empty

TabName = GetTabNameADB('database',[SinPath,SinName,'_files\'],'.mdb');
for k_Tab = 1 : numel(TabName)
    a            = Mat2Sin_OpenDBConn(SinName, SinPath);
    ColName      = GetColNameADB('database', TabName{k_Tab},[SinPath,SinName,'_files\'],'.mdb');
    ColVal       = AccessGetColVal(a, TabName{k_Tab}, ColName);
    if size(ColVal,1) ~= 0
        disp(TabName{k_Tab});
    end
end
invoke(a.conn,'Close');	