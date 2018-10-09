clear

if exist('data') ~= 1
    data = bfopen;
    
    dimensions = dimensionchange(data);
    
end

megastack = Make_megastack(data);

clearvars -except megastack
