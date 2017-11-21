
function [ pix_size, filename ] = WriteTimeDataToFile_ImAlGui(varargin )
%Writes data from "Time Track" button on the gui to an XLS File

data=varargin{1};
%pulls out struct tracking data

if length(varargin)>1
    default_pix_size={num2str(varargin{2})};
else
    default_pix_size={'0.105'};
end
%pulls out a default pixel size, if stated.

if length(varargin)>2
    intcheck = strcmp(varargin{3}, 'Intensities');
else
intcheck = 0;
end
%pulls out a default pixel size, if stated.


data_matrix=[];
int_matrix = [];

%Empty vector that will contain the pair data from the struct data 
%in a format the will write well to an excel sheet  

num_p = numel(data);

%gets position number
timepoints = [];
ind = 1;
length_feat = 0;
for i=1:numel(data)
    if data(i).num_kin>0
        object(1, length_feat + ind:length_feat + ind + data(i).num_kin-1) = data(i).feat_name;
        object(2, length_feat + ind:length_feat + ind + data(i).num_kin-1) = num2cell((ind:ind + data(i).num_kin-1));
        object(3, length_feat + ind:length_feat + ind + data(i).num_kin-1) = ...
            num2cell(i * ones(1,data(i).num_kin));
        length_feat = size( object, 2 );
        tempmatrix=[data(i).coord i*ones(size(data(i).coord,1),1)];
        %Builds a matrix with all kinetochore coordinate data  for a given
        %stage position as well as the position itself
        data_matrix=[data_matrix; tempmatrix];
        if intcheck == 1
            tempint = data(i).Intensities;
            tempint = [tempint i*ones(size(tempint,1),1)];
            int_matrix = [int_matrix; tempint];
        end
    end
    timepoints = [timepoints data(i).timepoints];
end

data_key={'x (pixels)' 'y (pixels)' 'z' 't' 'object number' 'Stage Position'...
    'Number of total positions' 'Timepoints (seconds)'};

%text key that will tell you what each column represents

pix_size=inputdlg('What is the pixel size in microns?','Pixel Size',1,...
    default_pix_size);

%Sets Pixel Size


[filename,pathname] = uiputfile('.xls');

celldata=num2cell(data_matrix);

celldata{1,7}=num_p;


celldata(1:size(timepoints,1),8 : 8 + size(timepoints,2) - 1) = num2cell(timepoints); 

%adds in the total number of positions. Important for reconstructing the
%data struct.

sheetdata=data_key;

sheetdata(2:size(celldata,1) + 1 ,1:size( celldata, 2))= celldata;

cd(pathname)

pix_size=str2num(pix_size{1});

xlwrite(filename, sheetdata, 'Sheet1');

xlwrite(filename, object, 'Sheet2');

if intcheck == 1
    
    xlwrite(filename, int_matrix, 'Sheet3');

end






end

