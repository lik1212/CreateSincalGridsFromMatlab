% To get the variable names (column names) and there default values from a
% Sincal DB table, this function can be helpful. The resulting variable is
% already in a form prepared for Multi-line Editing in e.g. the TexStudio
% editor. In this way the matlab code for creating an input table for the
% DB table is easier to create.

%% Setup

clear; path(pathdef);
SinName      = 'TempEmpty';
TabName      = 'Node';                  % 'Line', 'Terminal', 'Load' etc...
path_split   = strsplit(pwd,'\');
addpath(       [strjoin(path_split(1:end-1),'\'),'\Sub-functions']);
SinPath      = [strjoin(path_split(1:end-1),'\'),'\SincalGrid\'  ];

%%  Main
ResFile      = cell(0);                                                     % Initial
a            = Mat2Sin_OpenDBConn(SinName, SinPath);
ColName      = GetColNameADB('database',TabName,[SinPath,'TempEmpty_files\'],'.mdb');
ResFile(:,1) = ColName';
ColVal       = AccessGetColVal(a, TabName, ColName);
num_ColVal   = size(ColVal,1);
ResFile(:, ...
    2 : 2 + num_ColVal - 1) = ColVal';
invoke(a.conn,'Close');	