function imageToDisplay=getMulticolorImageforUI(imframes,numColors)
%gets a multi-color image stack and returns something that Matlab will
%display properly depending on the number of colors

if numColors==1
    %for one color just display the frame
    imageToDisplay=imfuse(imframes(:,:),imframes(:,:));
elseif numColors==2
    %for two colors the imfuse function works
    imageToDisplay=imfuse(imframes(:,:,2),imframes(:,:,1));
elseif numColors > 2
    %for three colors, a single pixelXpixelX3 matrix will work, but needs
    %to be scaled so values are between 0 and 1
    for i=1:3
        tempImage=imframes(:,:,i);
        tempImage=tempImage-min(min(tempImage));
        imageToDisplay(:,:,i)=tempImage/max(max(tempImage));
    end
    %imageToDisplay=imageToDisplay/max(max(max(imageToDisplay)));
end