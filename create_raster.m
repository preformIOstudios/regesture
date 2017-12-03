function [] = create_raster( fName )

%TODO: come up with a better name for this function
%TODO: update function summary and explanation below
%CREATE_RASTER Summary of this function goes here
%   Detailed explanation goes here

% use default dataset if none is provided
switch nargin
    otherwise
        fName = 'MasterLiuPerformanceChar00.calc';
end 

%import data from file name
DATA = load(fName);

%---------------
%create self-similarity matrix
%---------------
figure('NumberTitle', 'off', 'Name', [fName ' Self-Similarity Graph']);
ColorSet = varycolor(size(DATA, 2));
%TODO: normalize & filter data rows (channels) 
%   use only rotation and velocity data
%   mask out rows with no data

%collapse data matrix into 1D array with a single value per frame
V = sum(DATA, 2);
%replicate those values into matrix for transposition math
%TODO: is there an easier (component-wise?) way to do this and the next line in one command?
VV = repmat(V, 1, numel(V));
%calculate distance between those vectors into a distance array
D = abs(VV - VV');
%calculate scaled log of distances
d1 = log(D);
d = d1 / max(d1(:));
%display distance matrix (scaled and unscaled)
    subplot(2,2,1);
        set(gca, 'ColorOrder', ColorSet, 'NextPlot', 'replacechildren');
        plot(DATA);
        title('DATA');

    subplot(2,2,2);
        imshow(d, 'colormap', gray);
        title('Distance Image [ log, scaled ]');
        
    subplot(2,2,3);
%         colormap default %TODO: set image coloration back to default -- why are these images showing up B&W?!?
        image(D);
        title('Distance Matrix');
        
    subplot(2,2,4);
%         colormap default %TODO: set image coloration back to default -- why are these images showing up B&W?!?
        imagesc(D);
        title('Distance Matrix [scaled]');

%save out scaled log of distances to an image
imwrite(d, [fName, '.png']);
%---------------
%TODO: save out figure
%TODO: move above to its own function and call it here


%---------------
%power / frequency analysis
%reference -- https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html?requestedDomain=www.mathworks.com
%---------------
figure('NumberTitle', 'off', 'Name', [fName ' FFT analysis']);
%HACK: filter out some channels (TODO: should be specified in external data file)
FFTDATA = DATA(:, 1:337); %most elements
% FFTDATA = DATA(:, 15:21); %7 elements
% FFTDATA = DATA(:, 15:20); %6 elements
% FFTDATA = DATA(:, 15:17); %3 elems
% FFTDATA = DATA(:, 15); %1 elem
ColorSet = varycolor(size(FFTDATA, 2));
%analyze individual channels / groups of channels
N = size(FFTDATA,1);
[PRDG, w] = periodogram(FFTDATA,rectwin(N),N,60);

%debug
% N
% size(w)
% size(PRDG)

%plot analysis
    subplot(2,2,1);
        set(gca, 'ColorOrder', ColorSet, 'NextPlot', 'replacechildren');
        plot(FFTDATA);
        title('FFTDATA');
        
    subplot(2,2,2);
        set(gca, 'ColorOrder', ColorSet, 'NextPlot', 'replacechildren');
        grid on;
        hold on; % add any enclosed plots to the same graph
            title('priodogram = plot(w, 10*log10(PRDG))');
            linPRDG = plot(w, 10*log10(PRDG));
        hold off;

    subplot(2,2,4);
        set(gca, 'ColorOrder', ColorSet, 'NextPlot', 'replacechildren');
        grid on;
        hold on; % add any enclosed plots to the same graph
            title('log / log plot; lin regression + y intercept');
            llPRDG = plot(log(w), log(PRDG));
            % TODO: why is this different?
            %loglog(w, PRDG);
            %set PRDG plot style
            set(llPRDG, 'LineStyle', ':');
            %capture X and Y data for linear regression analysis
            llPXData = cell2mat(get(llPRDG, 'XData'))';
            llPYData = cell2mat(get(llPRDG, 'YData'))';
            %set -Inf values to zero
            llPXData(llPXData <= 0) = 0;
            
            %calculate linear regression + yintercept
            x = llPXData;
            y = llPYData;
            format long
            os = ones(size(x,1), 1);
            size(x)
            size(os)
            X = [os x];
            b = X\y;
            
            %plot linear regression + y intercept as solid lines
            yCalc2 = X*b;
            plot(x,yCalc2);
        hold off;
        
    subplot(2,2,3);
        %distribution of slopes
        slopes = b(2, :);
        histfit(slopes)
        title('histfit(slopes)');

%composit those into a single p/f graph for entire dataset
%    - need to consider different methodologies
%create a 2D image to represent entire dataset (channels on x, p/f values on y?)
%save out relevant image(s) for paper
%save out figure for reference
%---------------
%TODO: move power / frequency analysis to its own function and call it here
%instead

end
