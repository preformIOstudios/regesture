function [] = create_raster( fName )

%TODO: come up with a better name for this function
%CREATE_RASTER Summary of this function goes here
%   Detailed explanation goes here

switch nargin
    otherwise
        fName = 'MasterLiuPerformanceChar00.calc';
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
%TODO: is there an easier (component-wise?) way to do this and the next line in one command?
VV = repmat(V, 1, numel(V));
%calculate distance between those vectors into a distance array
D = abs(VV - VV');
%calculate scaled log of distances
d = log(D);
d = d / max(d(:));
%display distance matrix (scaled and unscaled)
figure('NumberTitle', 'off', 'Name', [fName ' Self-Similarity Graph']);
colormap default %TODO: set image coloration back to default -- why are these images showing up B&W?!?
    subplot(2,2,1);
        imagesc(DATA);
        title('DATA');

    subplot(2,2,2);
        imshow(d);
        title('Distance Image [ log, scaled ]');
        
    subplot(2,2,3);
        image(D);
        title('Distance Matrix');
        
    subplot(2,2,4);
        imagesc(D);
        title('Distance Matrix [scaled]');

%save out scaled log of distances to an image
imwrite(d, [fName, '.png']);
%TODO: save out figure
%TODO: move above to its own function and call it here

%---------------
%power / frequency analysis
%reference -- https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html?requestedDomain=www.mathworks.com
%---------------
%HACK: filter out some channels (TODO: should be specified in external data file)
FFTDATA = DATA(:, 1:337);
%analyze individual channels / groups of channels
N = size(FFTDATA,1);
[PRDG, w] = periodogram(FFTDATA,rectwin(N),N,60);
%plot analysis
figure('NumberTitle', 'off', 'Name', [fName ' FFT analysis']);
    subplot(2,2,1);
        imagesc(FFTDATA);
        title('FFTDATA');

    subplot(2,2,2);
        grid on;
        hold on; % add any enclosed plots to the same graph
            title('priodogram = plot(w, 10*log10(PRDG))');
            plot(w, 10*log10(PRDG));
        hold off;

    subplot(2,2,4);
        grid on;
        hold on; % add any enclosed plots to the same graph
            title('log / log plot = plot(log(w), log(PRDG))');
            plot(log(w), log(PRDG));
            % TODO: why is this different?
            %loglog(w, PRDG);
        hold off;
        
    subplot(2,2,3);
        imagesc(log(PRDG));
        title('log(PRDG)');
%composit those into a single p/f graph for entire dataset
%    - need to consider different methodologies
%create a 2D image to represent entire dataset (channels on x, p/f values on y?)
%save out image(s) / figures(s)
%---------------
 
end
