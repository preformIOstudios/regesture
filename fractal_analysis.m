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
s = 1;    c = 337; %337 elems
% s = 15;   c = 21; %7 elems
% s = 15;   c = 20; %6 elems
% s = 15;   c = 17; %3 elems
% s = 15;   c = 15; %1 elem
ColorSet = varycolor(e);
%TODO: normalize & filter data rows (channels) 
%   use only rotation and velocity data
%   mask out rows with no data
%HACK: filter out some channels (TODO: should be specified in external data file and based on zero data columns instead of this generic method)
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
R = 4; C = 3;
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
    subplot(R,C,C*0+1);
        imshow(d, 'colormap', gray);
        title('DATA Distance Image [ log, scaled ]');
        
    %plot data
    subplot(R,C,C*0+2);
        set(gca, 'ColorOrder', ColorSet, 'NextPlot', 'replacechildren');
        plot(DATA);
        title('plot(DATA)');

    %display image of data
    subplot(R,C,C*0+3);
        imagesc(DATA);
        title('imagesc(DATA)');
        
    %display image of scaled log of filtered data distance matrix
    subplot(R,C,C*1+1);
        imshow(fd, 'colormap', gray);
        title('fDATA Distance Image [ log, scaled ]');

    %plot filtered data
    subplot(R,C,C*1+2);
        set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
        plot(fDATA);
        title('plot(fDATA)');

    %display image of filtered data
    subplot(R,C,C*1+3);
        imagesc(fDATA);
        title('imagesc(fDATA)');
        
    %display image of excluded data distance matrix
    subplot(R,C,C*2+1);
        imshow(ed, 'colormap', gray);
        title('eDATA Distance Image [ log, scaled ]');

    %plot excluded data
    subplot(R,C,C*2+2);
        set(gca, 'ColorOrder', eColorSet, 'NextPlot', 'replacechildren');
        plot(eDATA);
        title('eDATA');

    %display image of excluded data
    subplot(R,C,C*2+3);
        imagesc(eDATA);
        title('imagesc(eDATA)');
  
    %display image of error data distance matrix
    subplot(R,C,C*3+1);
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
R = 2; C = 5;
%analyze individual channels / groups of channels
N = size(fDATA,1);
[PRDG, w] = periodogram(fDATA,rectwin(N),N,sampleSize);

%debug
% N
% size(w)
% size(PRDG)

%plot analysis
    subplot(R,C,C*0+1);
    %fDATA
        set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
        plot(fDATA);
        title('fDATA');
        
    subplot(R,C,C*1+1);
    %periodogram
        set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
        grid on;
        hold on; % add any enclosed plots to the same graph
            title('periodogram = plot(w, 10*log10(PRDG))');
            linPRDG = plot(w, 10*log10(PRDG));
        hold off;

    subplot(R,C,C*0+2);
    %"Least Squares" linear regression
        title('log/log plot | "Least Squares" lin reg');
        set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
        grid on;
        hold on; % add any enclosed plots to the same graph
            llPRDG = plot(log(w), log(PRDG));
            % TODO: why is this different?
            %loglog(w, PRDG);
            %set PRDG plot style
            set(llPRDG, 'LineStyle', ':');
            %capture X and Y data for linear regression analysis
            if size(fDATA, 2) > 1
                x = cell2mat(get(llPRDG, 'XData'))';
                y = cell2mat(get(llPRDG, 'YData'))';
            else
                x = get(llPRDG, 'XData')';
                y = get(llPRDG, 'YData')';
            end
            %set Inf values to nearest value
            maxX = max(x(x<Inf));
            minX = min(x(x>-Inf));
            dMax = maxX - max(x(x<maxX));
            dMin = minX - min(x(x>minX));
            x(x == Inf) = maxX + dMax;
            x(x == -Inf) = minX + dMin;
            
            %calculate linear regression + yintercept
            format long
            n = size(x,1);
            X = [ones(n,1) x];
            b = X\y;
            
            %plot linear regression + y intercept as solid lines
            yCalc = X*b;
            plot(x,yCalc);
        hold off;
        
    subplot(R,C,C*1+2);
    %"Least Squares" slope distribution
        slopes = b(2, :);
        if numel(slopes) > 1
            histfit(slopes)
            title('histfit("Least Squares" slopes)');
        else
            error('Not enough data in "slopes" to fit this distribution. "slopes" = %2.3g', numel(slopes)); 
        end
  
    subplot(R,C,C*0+3);
    %"Theil-Sen" linear regression
        title('log/log plot | "Theil-Sen" lin reg');
        set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
        grid on;

        format long
        n = size(x,1);
        X = [ones(n,1) x];
        Bhat = X\y;
        yCalcBhat = X*Bhat;
        concat = [x y];
        unzip = reshape(concat, numel(x), []);
        rezip = reshape(unzip', 2, n, []);
        data = permute(rezip, [2,1,3]);
        data(1) = data(1);
        [m2, b2] = TheilSen(data);
        BTS = [m2'; b2'; repmat(zeros(1,size(data,3)),size(X,2)-2,1)];
        yCalcTS = X*BTS;
        
        hold on;
            plot(x,yCalcBhat,'--')
            plot(x,yCalcTS, '-')
            plot(x,y,':')
        hold off;
        
    subplot(R,C,C*1+3);
    %"Theil-Sen" slope distribution
        slopes = BTS(2, :);
        if numel(slopes) > 1
            histfit(slopes)
            title('histfit("Theil-Sen" slopes)');
        else
            error('Not enough data in "slopes" to fit this distribution. "slopes" = %2.3g', numel(slopes)); 
        end

    subplot(R,C,C*0+4);
    %< 1Hz "Least Squares" linear regression
        title('< 1Hz log / log plot; "Least Squares" lin reg');

        %remove values greater than zero
        mask = x<0;
        x = x(mask);
        y = y(mask);
        fractColorSet = varycolor(size(x, 1));
            
        set(gca, 'ColorOrder', fractColorSet, 'NextPlot', 'replacechildren');
        grid on;
        hold on; % add any enclosed plots to the same graph
            %calculate linear regression + yintercept
            format long
            n = size(x,1);
            X = [ones(n,1) x];
            b = X\y;
            
            %plot linear regression + y intercept as solid lines
            yCalc = X*b;
            plot(x,y,':');
            plot(x,yCalc,'-');
        hold off;
        
    subplot(R,C,C*1+4);
    %< 1Hz "Least Squares" slope distribution
        slopes = b(2, :);
        if numel(slopes) > 1
            histfit(slopes)
            title('< 1Hz | histfit("Least Squares" slopes)');
        else
            warning('Not enough data in "slopes" to fit this distribution. "slopes" = %2.3g', numel(slopes)); 
        end

        
    subplot(R,C,C*0+5);
    %< 1Hz "Theil-Sen" linear regression
        title('< 1Hz | log/log | "Theil-Sen" lin reg');
        set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
        grid on;

        format long
        n = size(x,1);
        X = [ones(n,1) x];
        Bhat = X\y;
        yCalcBhat = X*Bhat;
        concat = [x y];
        unzip = reshape(concat, numel(x), []);
        rezip = reshape(unzip', 2, n, []);
        data = permute(rezip, [2,1,3]);
        data(1) = data(1);
        [m2, b2] = TheilSen(data);
        BTS = [m2'; b2'; repmat(zeros(1,size(data,3)),size(X,2)-2,1)];
        yCalcTS = X*BTS;
        
        hold on;
            plot(x,yCalcBhat,'--')
            plot(x,yCalcTS, '-')
            plot(x,y,':')
        hold off;
        
    subplot(R,C,C*1+5);
    %< 1Hz "Theil-Sen" slope distribution
        slopes = BTS(2, :);
        if numel(slopes) > 1
            histfit(slopes)
            title('< 1Hz | histfit("Theil-Sen" slopes)');
        else
            warning('Not enough data in "slopes" to fit this distribution. "slopes" = %2.3g', numel(slopes)); 
        end

        
%composit those into a single p/f graph for entire dataset
%    - need to consider different methodologies
%create a 2D image to represent entire dataset (channels on x, p/f values on y?)
%save out relevant image(s) for paper
%save out figure for reference
%---------------
%TODO: move power / frequency analysis to its own function and call it here
%instead

end
