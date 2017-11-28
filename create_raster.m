function [] = create_raster( fName )

%TODO: come up with a better name for this function
%CREATE_RASTER Summary of this function goes here
%   Detailed explanation goes here

switch nargin
    otherwise
        fName = "MasterLiuPerformanceChar00.calc";
end 

%import file
DATA = load(fName);

%---------------
%create self-similarity matrix
%---------------
%TODO: normalize & filter data rows (channels) 
%   use only rotation and velocity data

%collapse data matrix into 1D array with a single value per frame
V = sum(DATA, 2);
%replicate those values into matrix for transposition math
%TODO: is there an easier way to do this and the next line in one command?
VV = repmat(V, 1, numel(V));
%calculate distance between those vectors into a distance array
D = abs(VV - VV');
%display distance matrix (scaled and unscaled)
figure('NumberTitle', 'off', 'Name', fName + ' Self-Similarity Graph');
subplot(2,2,1);
imagesc(D);
title('Distance Matrix [scaled]');
subplot(2,2,2);
image(D);
title('Distance Matrix');

%save out scaled log of distances to an image
D = log(D);
D = D / max(D(:));
subplot(2,2,3);
imshow(D);
title('Distance Image [ log, scaled ]');
%TODO: figure out why this is suddenly not working
% fName
% imwrite(D, [fName, '.png']); 

%---------------
%TODO: create power / frequency analysis
%reference -- https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html?requestedDomain=www.mathworks.com
%---------------
%HACK: filter out some channels (TODO: should be specified in external data file)
FFTDATA = DATA(:, 1:337);
%analyze individual channels / groups of channels
%plot entire analysis
figure('NumberTitle', 'off', 'Name', fName + ' FFT analysis');
subplot(2,2,1);
imagesc(FFTDATA);
title('FFTDATA');

subplot(2,2,2);
grid on;
hold on; % add any enclosed plots to the same graph
title('fft(FFTDATA)');
FFTanalysis = fft(FFTDATA);
x = 0:1/(length(FFTanalysis)-1):1;
length(x);
length(FFTanalysis);
plot(x, FFTanalysis);
%composit those into a single p/f graph for entire dataset
%    - need to consider different methodologies
hold off;
subplot(2,2,4);
grid on;
N = size(FFTDATA,1);
N;
PRDG = periodogram(FFTDATA,rectwin(N),N,60);
periodogram(FFTDATA,rectwin(N),N,60)
subplot(2,2,3);
imagesc(log(PRDG));
title('PRDG');
%create a 2D image to represent entire dataset (channels on x, p/f values on y?)
%save out image(s) / figures(s)
%---------------
 
end
