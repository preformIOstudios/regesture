function [] = fractal_analysis( fName, sampleSize, dFilter, ignoreZ )

%TODO: update function summary and explanation below
%CREATE_RASTER Summary of this function goes here
%   Detailed explanation goes here

%set default argument values
if nargin == 4
        %do nothing
else
    %ignore columns filled with zeros by default
    ignoreZ = true;
    if nargin == 3
        %do nothing else
    else
        %default dataFilter
        dFilter = "";
        if nargin == 2
            %do nothing else
        else
            %default samplesize
            sampleSize = 60;
            if nargin == 1
                %do nothing else            
            else
                %default dataset
                fName = 'MasterLiuPerformanceChar00.calc';
            end
        end
    end
end 

%import data from file name
DATA = load(fName);
%set end, start, and cut points in the data
e = size(DATA, 2);
s = 1;    c = 337;
% s = 15;   c = 21;
% s = 15;   c = 20;
% s = 15;   c = 17;
% s = 15;   c = 15;
% s = 15;   c = 21;
ColorSet = varycolor(e);
%TODO: normalize & filter data rows (channels) 
%   use only rotation and velocity data
%   mask out rows with no data
%HACK: filter out some channels (TODO: should be specified in external data file)
%filtered data
fDATA = DATA(:, s:c); 
fColorSet = varycolor(c-s+1);
%excluded data
eDATA = DATA(:, c+1:e); 
eColorSet = varycolor(e-c);

%---------------
%create self-similarity matrix
%---------------
figure('NumberTitle', 'off', 'Name', [fName ' Self-Similarity Graph']);
C = 4; R = 3;
    %get self-similarity graphs
    D = similarity(DATA);
    fD = similarity(fDATA);
    eD = similarity(eDATA);
    %calculate scaled log of distances
    d1 = log(D);
    d = d1 / max(d1(:));
    fd1 = log(D);
    fd = fd1 / max(fd1(:));
    ed1 = log(eD);
    ed = ed1 / max(ed1(:));
    %calculate distance contribution of excluded data
    format long
    error1 = abs(D-fD);
    error = error1 / max(error1(:));
    
    %display image of scaled log of distance matrix
    subplot(C,R,R*0+1);
        imshow(d, 'colormap', gray);
        title('DATA Distance Image [ log, scaled ]');
        
    %plot data
    subplot(C,R,R*0+2);
        set(gca, 'ColorOrder', ColorSet, 'NextPlot', 'replacechildren');
        plot(DATA);
        title('plot(DATA)');

    %display image of data
    subplot(C,R,R*0+3);
        imagesc(DATA);
        title('imagesc(DATA)');
        
    %display image of scaled log of filtered data distance matrix
    subplot(C,R,R*1+1);
        imshow(fd, 'colormap', gray);
        title('fDATA Distance Image [ log, scaled ]');

    %plot filtered data
    subplot(C,R,R*1+2);
        set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
        plot(fDATA);
        title('plot(fDATA)');

    %display image of filtered data
    subplot(C,R,R*1+3);
        imagesc(fDATA);
        title('imagesc(fDATA)');
        
    %display image of excluded data distance matrix
    subplot(C,R,R*2+1);
        imshow(ed, 'colormap', gray);
        title('eDATA Distance Image [ log, scaled ]');

    %plot excluded data
    subplot(C,R,R*2+2);
        set(gca, 'ColorOrder', eColorSet, 'NextPlot', 'replacechildren');
        plot(eDATA);
        title('eDATA');

    %display image of excluded data
    subplot(C,R,R*2+3);
        imagesc(eDATA);
        title('imagesc(eDATA)');
  
    %display image of error data distance matrix
    subplot(C,R,R*3+1);
        imshow(error, 'colormap', gray);
        title('Error Image [ scaled ]');


%TODO: move this out to batch file
%save out scaled log of data distances to an image
imwrite(d, [fName, '_data.png']);
%save out scaled log of filtered data distances to an image
imwrite(fd, [fName, '_fdata.png']);
%save out scaled log of excluded data distances to an image
imwrite(ed, [fName, '_edata.png']);
%save out scaled image of error data to an image
imwrite(error, [fName, '_error.png']);
%---------------
%TODO: save out figure
%TODO: move above to its own function and call it here


%---------------
%power / frequency analysis
%reference -- https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html?requestedDomain=www.mathworks.com
%---------------
figure('NumberTitle', 'off', 'Name', [fName ' FFT analysis']);
C = 2; R = 2;
%analyze individual channels / groups of channels
N = size(fDATA,1);
[PRDG, w] = periodogram(fDATA,rectwin(N),N,sampleSize);

%debug
% N
% size(w)
% size(PRDG)

%plot analysis
    subplot(C,R,R*0+1);
        set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
        plot(fDATA);
        title('fDATA');
        
    subplot(C,R,R*0+2);
        set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
        grid on;
        hold on; % add any enclosed plots to the same graph
            title('priodogram = plot(w, 10*log10(PRDG))');
            linPRDG = plot(w, 10*log10(PRDG));
        hold off;

    subplot(C,R,R*1+2);
        set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
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
            X = [os x];
            b = X\y;
            
            %plot linear regression + y intercept as solid lines
            yCalc2 = X*b;
            plot(x,yCalc2);
        hold off;
        
    subplot(C,R,R*1+1);
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
