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
                
                [ struct(ind).movie, temp_matrix, labels ] = ReadPairDataFromFile_ImAlGui_Analysis(info(i).name);
                
                
                
            else
                [ struct(ind).movie, temp_matrix, labels ] =...
                    ReadPairDataFromFile_ImAlGui_Analysis(info(i).name,'Intensities');
            end
            
            
            
            
            temp_matrix(:, size(temp_matrix,2) + 1) = ind*ones(size(temp_matrix,1),1);
            
            matrix = [ matrix; temp_matrix ];
            
            for j = 1:numel(struct(ind).movie)
                
                struct(ind).movie(j).movie_name = info(i).name;
                struct(ind).movie(j).stack_loaded = 0;
            end
            
            
            
        end
        
    end
    
end

data_matrix = matrix;

movie_struct = struct;

clearvars -except obj_struct data_matrix movie_struct folder_name
