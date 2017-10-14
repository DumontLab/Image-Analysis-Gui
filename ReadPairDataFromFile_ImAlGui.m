function [ data_struct, data_matrix, column_labels ] = ReadPairDataFromFile_ImAlGui
%Reads data made from the write pair data ImAlGui code back into the image
%analysis GUI. Outputs the neccessary struct, but also a matrix containing
%all the data, as well as a series of labels indicating the values in
%columns

[FileName,PathName] = uigetfile('.xls');
cd(PathName)
data = xlsread(FileName);
%get excel file

data_matrix = data(:, 1:8);
num_p = (data(isnan(data(:, 9)) == 0,9));

%seperates out the data that goes back in the struct vs the number of
%stage position the goes back in the struct. Gets the number of positions


column_labels = {'1x (pixels)' '1y (pixels)' '1z' '2x (pixels)'...
    '2y (pixels)' '2z' 'Stage Position' 'Distance (Microns)'};
%defines the columns

stage_positions = unique(data_matrix(:, 7));

%Gets a list of stage positions

for i=1:num_p
    if ismember(i, stage_positions) == 1
       %fill struct with data if this stageposition has tracks
       temp = data_matrix(data_matrix(:, 7) == i,:);
       %get all data with at the current stage positions
       data_struct(i).K1coord = temp(:, 1:3);
       data_struct(i).K2coord = temp(:, 4:6);
       data_struct(i).num_kin = size(temp, 1);
       %Fills up struct with data for tracking
    else
       data_struct(i).K1coord = [];
       data_struct(i).K2coord = [];
       data_struct(i).num_kin = 0;
       %fills empty stage positions
    end
    
end

