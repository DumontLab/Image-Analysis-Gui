function [ pix_size, filename ] = WritePairDataToFile_ImAlGui(varargin )
%Writes data from "Mark pairs" button on the gui to an XLS File

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
end
%pulls out a default pixel size, if stated.

int_matrix = [];
data_matrix=[];

%Empty vector that will contain the pair data from the struct data 
%in a format the will write well to an excel sheet  

num_p = numel(data);

%gets position number
timepoints = [];
for i=1:numel(data)
    if data(i).num_kin>0
        tempmatrix=[data(i).K1coord data(i).K2coord...
        i*ones(size(data(i).K1coord,1),1)];
        %Builds a matrix with all kinetochore coordinate data  for a given
        %stage position as well as the position itself
        data_matrix=[data_matrix; tempmatrix];
                if intcheck == 1
            tempint = [data(i).K1Intensities data(i).K2Intensities];
            tempint = [tempint i*ones(size(tempint,1),1)];
            int_matrix = [int_matrix; tempint];
        end
    end
    timepoints = [timepoints data(i).timepoints];
end

data_key={'1x (pixels)' '1y (pixels)' '1z' '1t' '2x (pixels)'...
    '2y (pixels)' '2z' '2t' 'Stage Position' 'Distance (Microns)'...
    'Number of total positions' 'Timepoints (seconds)'};

%text key that will tell you what each column represents

pix_size=inputdlg('What is the pixel size in microns?','Pixel Size',1,...
    default_pix_size);

%Sets Pixel Size

data_matrix(:,10) = ((data_matrix(:,1) - data_matrix(:,5)).^2 +...
    (data_matrix(:,2)-data_matrix(:,6)).^2) .^ 0.5;

data_matrix(:,10) = data_matrix(:,10) * str2num( pix_size{1} );

%calculates the pythagorean distance between the two objects (2d)

[filename,pathname] = uiputfile('.xls');

celldata=num2cell(data_matrix);

celldata{1,11}=num_p;

celldata(1:size(timepoints,1),12:12 + size(timepoints,2) - 1) = num2cell(timepoints); 

%adds in the total number of positions. Important for reconstructing the
%data struct.

sheetdata=[data_key; celldata];

cd(pathname)

pix_size=str2num(pix_size{1});

xlwrite(filename,sheetdata, 'Sheet1');
if intcheck == 1
    
    xlwrite(filename, int_matrix, 'Sheet2');

end





