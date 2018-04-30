function FileExist = CopySinFile(SinName_orig, SinName_copy, SinPath_orig, SinPath_copy)
%CopySinFile Make a copy of a Sincal File with all related files
%
%   FileExist = CopySinFile(SinName_orig, SinName_copy, SinPath)
%
%       SinName_orig (Required) - String, name of the original Sincal file
%       SinName_copy (Required) - String, name of the Sincal file copy
%       SinPath_orig (Required) - String, path of the original Sincal file
%                                 and if SinPath_copy is not given also of
%                                 the file copy
%       SinPath_copy (Optional) - String, path of the Sincal file copy
%       FileExist    (Result)   - Logical value, informs if the new file
%                                 already exists
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Create new file
if nargin < 4                       % If Path of original and copy is the same
    SinPath_copy = SinPath_orig;
end
if exist([SinPath_copy,SinName_copy,'.sin'],'file')        	% Check if file already exists
    FileExist = true;
    warning('Attention, new copy file already exists and will not  be overwritten.');	% Warning message
else
    FileExist = false;
    copyfile([SinPath_orig,SinName_orig,'.sin'  ],[SinPath_copy,SinName_copy,'.sin'  ]);  % Copy sin file
    copyfile([SinPath_orig,SinName_orig,'_files'],[SinPath_copy,SinName_copy,'_files']);  % Copy sin folder with database
    % Correct the file database.mdb info in database.ini
    fid = fopen([SinPath_copy,SinName_copy,'_files\','database.ini'],'r');                % fid - file identifier, open ini-file
    file_text_orig = fread(fid);                                                          % read-out binary data of the ini-file
    file_text_orig = char(file_text_orig');                                               % binary data to char (original text)
    file_text_copy = strrep(file_text_orig,...                                            % Correct the database.mdb path
        [SinName_orig,'_files\database.mdb'],...                                          % (text in copy file)
        [SinName_copy,'_files\database.mdb']) ;
    fclose(fid);                                                                          % close fid to rewrite ini-file with new text
    fid = fopen([SinPath_copy,SinName_copy,'_files\','database.ini'],'w');                % delete old (original) ini-file content
    fwrite(fid,file_text_copy);                                                           % write  new (copy)     ini-file content
    fclose(fid);                                                                          % close ini-file
end
end
