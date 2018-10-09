function [ data_struct, data_matrix, column_labels] = ReadTimeDataFromFile_ImAlGui
%Reads data made from the write pair data ImAlGui code back into the image
%analysis GUI. Outputs the neccessary struct, but also a matrix containing
%all the data, as well as a series of labels indicating the values in
%columns

[FileName,PathName] = uigetfile('.xls');
cd(PathName)
[ data, column_labels, raw] = xlsread(FileName, 'Sheet1');
[objdata, objtxt, raw] = xlsread(FileName, 'Sheet2');
%get excel file

data_matrix = data(isnan(data(:,1))==0, 1:6);

num_p = (data(isnan(data(:, 7)) == 0,7));

num_t = (max(data_matrix(:,4)));

timepoints = data(:, 8 : 8 + num_p - 1); 

%seperates out the data that goes back in the struct vs the number of
%stage position the goes back in the struct. Gets the number of positions



%defines the columns

stage_positions = unique(data_matrix(:, 6));

%Gets a list of stage positions

for i=1:num_p
    if ismember(i, stage_positions) == 1
       %fill struct with data if this stageposition has tracks
       temp = data_matrix(data_matrix(:, 6) == i,:);
       %get all data with at the current stage positions
       data_struct(i).coord = temp(:, 1:5);
       data_struct(i).num_kin = max(temp(:, 5));
       data_struct(i).timepoints = timepoints(:, i);
       data_struct(i).feat_name = objtxt(objdata(2, :) == i);
       %Fills up struct with data for tracking
       data_struct(i).datatype = 2;
    else
       data_struct(i).coord = [];
       
       data_struct(i).num_kin = 0;
       data_struct(i).timepoints = timepoints(:,i);
       data_struct(i).datatype = 2;
       %fills empty stage positions
    end
    
end



