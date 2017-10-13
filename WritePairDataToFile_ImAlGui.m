function [ pix_size, filename ] = WritePairDataToFile_ImAlGui( varargin )
%Writes data from "Mark pairs" button on the gui to an XLS File

data=varargin{1};
%pulls out struct tracking data

if length(varargin)>1
    default_pix_size=varargin{2};
else
    default_pix_size={'0.105'};
end
%pulls out a default pixel size, if stated.

if length(varargin)>2
    default_filename=varargin{3};
else
    defaultfilename='Tracking File.xls';
end
%pulls out a default pixel size, if stated.


data_matrix=[];

%Empty vector that will contain the pair data from the struct data 
%in a format the will write well to an excel sheet  

num_p = numel(data);

%gets position number

for i=1:numel(data)
    if data(i).num_kin>0
        tempmatrix=[data(i).K1coord data(i).K2coord...
        i*ones(size(data(i).K1coord,1),1)];
        %Builds a matrix with all kinetochore coordinate data  for a given
        %stage position as well as the position itself
        data_matrix=[data_matrix; tempmatrix];
    end
end

data_key={'1x (pixels)' '1y (pixels)' '1z' '2x (pixels)'...
    '2y (pixels)' '2z' 'Stage Position' 'Distance (Microns)'...
    'Number of total positions'};

%text key that will tell you what each column represents

pix_size=inputdlg('What is the pixel size in microns?','Pixel Size',1,...
    default_pix_size);

%Sets Pixel Size

data_matrix(:,8) = ((data_matrix(:,1) - data_matrix(:,4)).^2 +...
    (data_matrix(:,2)-data_matrix(:,5)).^2) .^ 0.5;

data_matrix(:,8) = data_matrix(:,8) * str2num( pix_size{1} );

%calculates the pythagorean distance between the two objects (2d)

[filename,pathname] = uiputfile('.xls');

celldata=num2cell(data_matrix);
celldata{1,9}=num_p;
%adds in the total number of positions. Important for reconstructing the
%data struct.

sheetdata=[data_key; celldata];

cd(pathname)

xlswrite(filename,sheetdata);





