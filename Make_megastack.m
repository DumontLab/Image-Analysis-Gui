function megastack = Make_megastack(nd_file)

metadata=nd_file{1,4};
xdim = metadata.getPixelsSizeX(0).getValue(); % image width, pixels
ydim = metadata.getPixelsSizeY(0).getValue(); % image height, pixels

num_z = metadata.getPixelsSizeZ(0).getValue(); % number of Z slices
num_c = metadata.getPixelsSizeC(0).getValue(); % number of wavelengths
num_t = metadata.getPixelsSizeT(0).getValue(); % number of timepoints
num_p = metadata.getImageCount(); %number of stage positions

    


check=questdlg('Do you have a color with a different number of z steps?','Unequal Colors?','Yes','No','No');

if strcmp(check,'Yes') == 1
    num_p = num_p - 1;
end





%%%Pulls metadata from OME format. useful because it does not change
%%%between file formats and acquisition programs




dimensions=[num_c num_z num_p num_t];

pixeldim=[ydim xdim];

alldim=[pixeldim dimensions];

megastack=zeros(alldim);





for i=1:num_p
    t_ind=0;
    for x=1:num_t
        planes=0;
        if num_c < 4
            for j=1:num_c
                for q=1:num_z
                    megastack(:,:,j,q,i,x)=nd_file{i,1}{q+(j-1)*num_z + t_ind, 1};
                    planes = planes + 1;
                    %disp(q+(j-1)*num_z)
                end
            end
        else
            colors= [1 2 3 4];
            drop=input('Too many colors! Please chose which channel to drop (1-4) ');
            colors(colors==drop)=[];
            for j=1:num_c
                for q=1:num_z
                    megastack(:,:,j,q,i,x)=nd_file{i,1}{q+(colors(j)-1)*num_z + t_ind, 1};
                    planes = planes + 1;
                end
            end
        end
        t_ind = planes + t_ind;
    end
    
end