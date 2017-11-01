folder_name = uigetdir;

cd( folder_name )

info = dir;

ind = 0;

matrix = [];

check=questdlg('Do you have intensity data?','Save data?','Yes','No','No');

timepoints = [];

for i = 1:numel(info)
    
    if info( i ).isdir == 0
        
        [path, name, ext] = fileparts( info(i).name );
        
        if strcmp(ext,'.xls') == 1
            
            ind = ind + 1;
            
            if strcmp(check,'No')
                
                [ struct(ind).movie, temp_matrix, labels ] = ReadTimeDataFromFile_Analysis(info(i).name);
                
            else
                [ struct(ind).movie, temp_matrix, labels ] =...
                    ReadTimeDataFromFile_Analysis(info(i).name,'Intensities');
            end
            
            matrix = [ matrix; temp_matrix ];
            
        end
        
    end
    
end
