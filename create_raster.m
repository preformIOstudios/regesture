function [ D ] = create_raster( fName )

%CREATE_RASTER Summary of this function goes here
%   Detailed explanation goes here

%import file
DATA = load(fName);

%---------------
%create self-similarity matrix
%---------------
%TODO: normalize & filter data rows (channels) 
%   use only rotation and velocity data

%collapse data matrix into a 1D array with a single value per frame
V = sum(DATA, 2);
%replicate those values into matrix for transposition math (TODO: is there
%an easier way to do this and the next line in one command?)
VV = repmat(V, 1, numel(V));
%calculate distance between those vectors into a distance array
D = abs(VV' - VV);
%display distanc matrix (scaled and unscaled)
figure, imagesc(D);
figure, image(D);

%save out scaled log of distances to an image
D = log(D);
D = D / max(D(:));
figure, imshow(D);
imwrite(D, [fName, '.png']);

%---------------
%create power / frequency matrix (TODO)
%reference -- https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html?requestedDomain=www.mathworks.com
%---------------
%analyze individual channels / groups of channels
%create a 2D image to represent entire dataset
%composit those into a single row for entire dataset
%    - need to consider different methodologies
%save out graph(s)
%---------------

end
