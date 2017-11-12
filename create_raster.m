function [ ssi ] = create_raster( fName )

%CREATE_RASTER Summary of this function goes here
%   Detailed explanation goes here

%import file
f = load(fName);
%store refolding value
h = size(f,1);

%---------------
%create self-similarity matrix
%---------------
%unfold data
d = reshape(f, [], 1);
%create a matrix for each bone
d = repmat(d, 1, h);
%refold data
d = reshape(d', h, h,[]);
%calculate difference values
ssm = abs(permute(d,[2 1 3]) - d);
%flatten into single image
ssi = sum(ssm, 3);
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