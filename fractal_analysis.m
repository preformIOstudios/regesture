function [] = fractal_analysis( file, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim, HzLPass, outDir )

%TODO: update function summary and explanation below
%CREATE_RASTER Summary of this function goes here
%   Detailed explanation goes here

    %set default argument values
    if nargin < 6
        %calculate fractal dimension with least squares linear regression
        fractalDim = 1;
        if nargin < 5
            %do not calculate self similarity graphs
            calcSelfSim = false;
            if nargin < 4
                %ignore columns filled with zeros by default
                ignoreZ = true;
                if nargin < 3
                    %default dataFilter
                    dFilter = '';
                    if nargin < 2
                        %default samplesize
                        sampleRate = 120;
                        if nargin < 1
                            %default dataset
                            file = 'calc_files/test/MasterLiuPerformanceALL_Char00_stripped.calc';
                        end
                    end
                end
            end 
        end
    end
    if nargin < 7 || isnan(HzLPass)
        HzLPass = sampleRate / 2;
    end
    if HzLPass == 0
        error(['HzLPass should be set to values > 0Hz. HzLPass = ' num2str(HzLPass)]);
    end
    %handle multiple files and fractal dim analyses
    if iscell(file)
        for i = drange(1:size(file, 2))
            fractal_analysis(file{1,i}, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim, HzLPass);
        end
        return
    elseif iscell(fractalDim)
        for i = drange(1:size(fractalDim, 2))
            fractal_analysis(file, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim{1,i}, HzLPass);
        end
        return
    end
    
    %set private variable values
    file = fullfile(file);
    [fPath,fName,fExt] = fileparts(file);
    if nargin < 8
        outDir = fPath;
    end
    figfmt = 'png'; %TODO: parameterize this?
    figW = 1276; figH = 705; %TODO: parameterize these
    dName = replace(fName,'_', '\_'); %avoid accidental subscript formatting in titles later

    %import data from file name
    DATA = load(file);
    %TODO: parameterize e,s,c
    %set end, start, and cut points in the data
    e = size(DATA, 2);
    s = 1;    c = e; %all elems
    % s = 1;    c = 337; %337 elems
    % s = 15;   c = 44; %30 elems
    % s = 15;   c = 34; %20 elems
    % s = 15;   c = 30; %16 elems
    % s = 15;   c = 27; %13 elems
    % s = 15;   c = 26; %12 elems
    % s = 15;   c = 25; %11 elems
    % s = 15;   c = 24; %10 elems
    % s = 15;   c = 21; %7 elems
    % s = 15;   c = 20; %6 elems
    % s = 15;   c = 19; %5 elems
    % s = 15;   c = 18; %4 elems
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
    if (calcSelfSim == true)
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
        errorImg = error1 / max(error1(:));

        %set figure properties
        fig = figure('NumberTitle', 'off', 'Name', [fName ' Self-Similarity Graph']);
        fig.Position = [0 0 figW figH];
        
        %set rows and columns for subplots
        R = 4; C = 3;
        
        %create subplots
        % %TODO: set positions of subplots to fit maximum space better
        % ax = gca;
        % outerpos = ax.OuterPosition;
        % ti = ax.TightInset; 
        % left = outerpos(1) + ti(1);
        % bottom = outerpos(2) + ti(2);
        % ax_width = outerpos(3) - ti(1) - ti(3);
        % ax_height = outerpos(4) - ti(2) - ti(4);
        % ax.Position = [left bottom ax_width ax_height];
        
            %image of scaled log of distance matrix
            subplot(R,C,C*0+1);
                imshow(d, 'colormap', gray);
                title('DATA Distance Image [ log, scaled ]');

            %plot data
            subplot(R,C,C*0+2);
                set(gca, 'ColorOrder', ColorSet, 'NextPlot', 'replacechildren');
                plot(DATA);
                title('plot(DATA)');

            %image of data
            subplot(R,C,C*0+3);
                imagesc(DATA);
                title('imagesc(DATA)');

            %image of scaled log of filtered data distance matrix
            subplot(R,C,C*1+1);
                imshow(fd, 'colormap', gray);
                title('fDATA Distance Image [ log, scaled ]');

            %plot filtered data
            subplot(R,C,C*1+2);
                set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
                plot(fDATA);
                title('plot(fDATA)');

            %image of filtered data
            subplot(R,C,C*1+3);
                imagesc(fDATA);
                title('imagesc(fDATA)');

            %image of excluded data distance matrix
            subplot(R,C,C*2+1);
                imshow(ed, 'colormap', gray);
                title('eDATA Distance Image [ log, scaled ]');

            %plot excluded data
            subplot(R,C,C*2+2);
                set(gca, 'ColorOrder', eColorSet, 'NextPlot', 'replacechildren');
                plot(eDATA);
                title('eDATA');

            %image of excluded data
            subplot(R,C,C*2+3);
                imagesc(eDATA);
                title('imagesc(eDATA)');

            %image of error data distance matrix
            subplot(R,C,C*3+1);
                imshow(errorImg, 'colormap', gray);
                title('Error Image [ scaled ]');


        %TODO: move this out to batch file
        % %save out scaled log of data distances to an image
        imwrite(d, fullfile(outDir,[fName '_data.png']));
        % %save out scaled log of filtered data distances to an image
        imwrite(d, fullfile(outDir,[fName '_fdata.png']));
        % %save out scaled log of excluded data distances to an image
        imwrite(d, fullfile(outDir,[fName '_edata.png']));
        % %save out scaled image of error data to an image
        imwrite(d, fullfile(outDir,[fName '_error.png']));
        %---------------
        %save out figure
        saveas(fig,fullfile(outDir,[fName '_selfSim']),figfmt);
        %TODO: move analysis above to its own function and call it here instead?
    end

    %---------------
    %power / frequency analysis
    %reference -- https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html?requestedDomain=www.mathworks.com
    %---------------
    %TODO: move power / frequency analysis to its own function and call it here
    %instead
    %---------------
    if (fractalDim ~= 0)
        if fractalDim == 1
            method = 'Least Squares';
            fNameM = 'ls';
        else
            method = 'Theil-Sen';
            fNameM = 'ts';
        end
        
        %analyze individual channels / groups of channels
        N = size(fDATA,1);
        [PRDG, Hz] = periodogram(fDATA,rectwin(N),N,sampleRate);

        %debug
        % N
        % size(w)
        % size(PRDG)

        %set figure properties
        fig = figure('NumberTitle', 'off', 'Name', [fName ' FFT analysis']);
        fig.Position = [0 0 figW figH];

        %set rows and columns for subplots
        R = 2; C = 4;
        
        %create subplots
        % %TODO: set positions of subplots to fit maximum space better
        % ax = gca;
        % outerpos = ax.OuterPosition;
        % ti = ax.TightInset; 
        % left = outerpos(1) + ti(1);
        % bottom = outerpos(2) + ti(2);
        % ax_width = outerpos(3) - ti(1) - ti(3);
        % ax_height = outerpos(4) - ti(2) - ti(4);
        % ax.Position = [left bottom ax_width ax_height];

            %fDATA
            subplot(R,C,C*0+1);
                title(['fDATA = "' dName '"']);
                set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
                plot(fDATA);
                if size(fDATA, 2) > 11
                    %TODO: display gradient
                    colormap(fColorSet);
                    n = size(fColorSet,1);
                    spread = size(fColorSet,1)/4.0;
                    colorbar('Ticks', 0:0.25:1,...
                        'TickLabels', ceil(0:spread:n));
                else
                    %TODO: display legend
                    legend show Location NorthEast;
                end
                xlabel('sample');
                ylabel('amplitude');

            %periodogram
            subplot(R,C,C*1+1);
                title('fDATA periodogram (PRDG)');
                set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
                grid on;
                hold on; % add any enclosed plots to the same graph
                    linPRDG = plot(Hz, 10*log10(PRDG), '-');
                    xlabel('Hz');
                    ylabel('dB [i.e.:dB/rad/samp = 10*log10(P/F)]');
                hold off;

            %log/log plot
            subplot(R,C,C*1+2);
                title('PRDG log/log plot');
                set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
                grid on;
                hold on; % add any enclosed plots to the same graph
                    llPRDG = plot(log10(Hz), log10(PRDG), '-');
                    xlabel('log10(Hz)');
                    ylabel('log10(P/F) [i.e.: dB/10]');

                    %capture X and Y data for linear regression analysis
                    if size(fDATA, 2) > 1
                        x = cell2mat(get(llPRDG, 'XData'))';
                        y = cell2mat(get(llPRDG, 'YData'))';
                    else
                        x = get(llPRDG, 'XData')';
                        y = get(llPRDG, 'YData')';
                    end
                    %ignore Inf values
                    x2 = x(2:end,:);
                    y2 = y(2:end,:);
                hold off;
            
            %<HzLPass log/log plot
            subplot(R,C,C*0+2);
                title(['< ' num2str(HzLPass) 'Hz PRDG log/log plot']);
                set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');

                %remove values greater than zero
                mask = x2<log10(HzLPass);
                xLPass = reshape(x2(mask),[],size(x2,2));
                yLPass = reshape(y2(mask),[],size(y2,2));

                grid on;
                hold on; % add any enclosed plots to the same graph
                    %plot reduced data set 
                    plot(xLPass,yLPass, '-');
                    xlabel('log10(Hz)');
                    ylabel('log10(P/F)');
                hold off;

            %<HzLPass data lin reg
            subplot(R,C,C*0+3);
                title(['<' num2str(HzLPass) 'Hz "' method '" lin reg']);
                set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
                grid on;
                hold on; % add any enclosed plots to the same graph

                    %re-plot underlying data
                    plot(xLPass, yLPass, ':');
                    xlabel('log10(Hz)');
                    ylabel('log10(P/F)');

                    %calculate linear regression + yintercept
                    [yLPassCalc, bLPass] = linreg(xLPass,yLPass, fractalDim);

                    %plot linear regression + y intercept as solid lines
                    plot(xLPass,yLPassCalc);
                hold off;
                
            %all data lin reg     
            subplot(R,C,C*1+3);
                title(['all Hz "' method '" lin reg']);
                set(gca, 'ColorOrder', fColorSet, 'NextPlot', 'replacechildren');
                grid on;
                hold on; % add any enclosed plots to the same graph

                    %re-plot underlying data
                    plot(x2, y2, ':');
                    xlabel('log10(Hz)');
                    ylabel('log10(P/F)');
                    
                    %calculate linear regression + yintercept
                    [yCalc, b] = linreg(x2,y2, fractalDim);

                    %plot linear regression + y intercept as solid lines
                    plot(x2,yCalc);
                hold off;


            %<HzLPass fDim (based on slope dist)
            subplot(R,C,C*0+4);
                title({['< ' num2str(HzLPass) 'Hz fDim'];['histfit("' method '" slopes)']});
                
                if min(size(bLPass)) ~= 0 
                    slopesLPass = bLPass(2, :)';
                else
                    slopesLPass = [];
                end
                    
                if numel(slopesLPass) > 1
                    hold on;
                        hfLPass = histfit(slopesLPass);
                        %add a line and label for mu
                        pdLPass = fitdist(slopesLPass,'Normal');
                        ylimsLPass = ylim;
                        textYLPass = interp1(ylimsLPass, 1.9);
                        plot ([pdLPass.mu pdLPass.mu], ylimsLPass);
                        text(pdLPass.mu,textYLPass,{['\leftarrow mu = ' num2str(pdLPass.mu)]; [' f dim = ' num2str((2-pdLPass.mu)/2)]});
                        xlabel('slope');
                        ylabel('density');
                        
                    hold off;
                else
                    warning('Not enough data in "slopes" to fit this distribution. "slopes" = %2.3g', numel(slopesLPass)); 
                end
            
            %all Hz fDim (based on slope dist)
            subplot(R,C,C*1+4);
                title({'all Hz fDim';['histfit("' method '" slopes)']});

                slopes = b(2, :)';
                
                if numel(slopes) > 1
                    hold on;
                        hf = histfit(slopes);
                        %add a line and label for mu
                        pd = fitdist(slopes,'Normal');
                        ylims = ylim;
                        textY = interp1(ylim, 1.9);
                        plot ([pd.mu pd.mu], ylims);
                        text(pd.mu,textY,{['\leftarrow mu = ' num2str(pd.mu)]; [' f dim = ' num2str((2-pd.mu)/2)]});
                        xlabel('slope');
                        ylabel('density');
                        
                    hold off;
                else
                    warning('Not enough data in "slopes" to fit this distribution. "slopes" = %2.3g', numel(slopes)); 
                end

        %composit those into a single p/f graph for entire dataset
        %    - need to consider different methodologies
        %create a 2D image to represent entire dataset (channels on x, p/f values on y?)
        %save out relevant image(s) for paper

        %save out figure
        saveas(fig,fullfile(outDir,[fName '_fDim_' fNameM '_' num2str(HzLPass) 'HzLPass']),figfmt);
    end
end
