function [ data_struct, data_matrix, column_labels] = ReadPairDataFromFile_ImAlGui_Analysis
%Reads data made from the write pair data ImAlGui code back into the image
%analysis GUI. Outputs the neccessary struct, but also a matrix containing
%all the data, as well as a series of labels indicating the values in
%columns

check = questdlg('Do you have intensity data?','Intensity?','Yes','No','No');

intcheck = strcmp(check, 'Yes');

[FileName,PathName] = uigetfile('.xls');
cd(PathName)
[ data, column_labels, raw] = xlsread(FileName, 'Sheet1');

if intcheck == 1
    [intdata, dummy, meh] = xlsread(FileName, 'Sheet2');
end

%get excel file

data_matrix = data(isnan(data(:,1))==0, 1:10);

num_p = (data(isnan(data(:, 11)) == 0,11));

num_t = (max(data_matrix(:,4)));

timepoints = data(:, 12 : 12 + num_p - 1); 

%seperates out the data that goes back in the struct vs the number of
%stage position the goes back in the struct. Gets the number of positions


column_labels = {'1x (pixels)' '1y (pixels)' '1z' '1t' '2x (pixels)'...
    '2y (pixels)' '2z' '2t' 'Stage Position' 'Distance (Microns)'};
%defines the columns

stage_positions = unique(data_matrix(:, 9));

%Gets a list of stage positions

for i=1:num_p
    if ismember(i, stage_positions) == 1
       %fill struct with data if this stageposition has tracks
       temp = data_matrix(data_matrix(:, 9) == i,:);
       %get all data with at the current stage positions
       data_struct(i).K1coord = temp(:, 1:4);
       data_struct(i).K2coord = temp(:, 5:8);
       data_struct(i).num_kin = size(temp, 1);
       data_struct(i).timepoints = timepoints(:,i);
       %Fills up struct with data for tracking
       data_struct(i).datatype = 1;
       if intcheck ==1
           data_struct(i).intensities = intdata(intdata(:,size(intdata,2))...
               == i, 1:size(intdata,2)-1);
       end
    else
        data_struct(i).K1coord = [];
       data_struct(i).K2coord = [];
       data_struct(i).num_kin = 0;
       data_struct(i).timepoints = timepoints(:,i);
       %fills empty stage positions
       data_struct(i).datatype = 1;
    end
    
end