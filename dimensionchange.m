function dimensions = dimensionchange(data)
metadata=data{1,4};
xdim = metadata.getPixelsSizeX(0).getValue(); % image width, pixels
ydim = metadata.getPixelsSizeY(0).getValue(); % image height, pixels
num_z = metadata.getPixelsSizeZ(0).getValue(); % number of Z slices
num_c = metadata.getPixelsSizeC(0).getValue(); % number of wavelengths
num_t = metadata.getPixelsSizeT(0).getValue(); % number of timepoints
num_p = metadata.getImageCount(); %number of stage positions

total = num_z * num_t * num_p * num_c;

check = 0;

prompt = {'t:','z:','p:','c:'};

defaults = {num2str(num_t), num2str(num_z), num2str(num_p), num2str(num_c)};

while check ~= total

data = inputdlg(prompt,'Do you want to change the dimensions?',1,defaults);

tempt = str2num(data{1});

tempz = str2num(data{2});

tempp = str2num(data{3});

tempc = str2num(data{4});

check  = tempt * tempz *tempp * tempc;

if check ~=total
    msgbox('The new t*z*p*c must equal the old t*z*p*c!')
end
end


num_t = tempt;

num_z = tempz;

num_c = tempc;

num_p = tempp;

dimensions = [num_t num_z num_p num_c];

end