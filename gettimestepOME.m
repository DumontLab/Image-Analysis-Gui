function time = gettimestepOME(metadata, z, p, c , t)
% Function to get time data out of ome metadata. Current version won't work
% if there are unequal numbers of frames between different colors.

totalsize = z * c * t;

for i = 0 : p - 1
    
    plane = 0;
    
    time_array = [];
    
    while plane < totalsize - 1
        
        timepoint = metadata.getPlaneDeltaT(i, plane);
        
        time_array = [time_array; double(timepoint.value)];
        
        plane = plane + 1;
        
        plane = plane + (z) * (c) - 1;
        

        
    end
    
    struct(i + 1).time = time_array;
    
end

time = [];

for i = 1:numel(struct)
    time = [time struct(i).time];
end
