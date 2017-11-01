function [ int ] = IntCalc_ImAlGui( Image , coord, rectsize )
%Intensity calculation in the image analysis GUI 
%   Calculates intensity in an "Image" at a coordinate "coord" in a square
%   of a given size "size"

coord = [round(coord(1)) round(coord(2))];

if rem( rectsize, 2 ) == 1
    rect = [ (coord( 1 ) - (rectsize / 2 - 0.5)) (coord( 2 ) - (rectsize / 2 - 0.5))...
        rectsize-1 rectsize-1 ];
else
    rect = [ (coord( 1 ) - rectsize / 2 ) (coord( 2 ) - rectsize / 2 )...
        rectsize-1 rectsize-1 ];
end

I = imcrop(Image, rect);

int = sum(I(:));

end

