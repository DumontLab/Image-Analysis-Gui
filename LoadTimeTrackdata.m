folder_name = uigetdir;

cd( folder_name )

info = dir;

ind = 0;

matrix = [];

timepoints = [];

for i = 1:numel(info)
    
    if info( i ).isdir == 0
        
        [path, name, ext] = fileparts( info(i).name );
        
        if strcmp(ext,'.xls') == 1
            
            ind = ind + 1;
            
            [ struct(ind).movie, temp_matrix, labels ] = ReadTimeDataFromFile_Analysis(info(i).name);
            
            matrix = [ matrix; temp_matrix ];
            
        end
        
    end
    
end
