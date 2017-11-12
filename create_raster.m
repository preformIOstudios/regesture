function [ ssi ] = create_raster( fName )

%CREATE_RASTER Summary of this function goes here
%   Detailed explanation goes here

%import file
f = load(fName);

%---------------
%create self-similarity matrix
%---------------
%TODO: normalize & filter rows to clean data
%collapse data
d = sum(f, 2);
%create a matrix for each bone
d = repmat(d, 1, numel(d));
%calculate difference values
ssi = abs(d' - d);
%display image graphs of data (scaled and unscaled)
figure, imagesc(ssi);
figure, image(ssi);

%save out scaled image
ssi = log(ssi);
ssi = ssi / max(ssi(:));
figure, imshow(ssi);
imwrite(ssi, [fName, '.png']);

%---------------
%create power / frequency matrix (TODO)
%---------------
%create FFT analysis matrix
%save out graph(s)
%---------------


end