%TODO:
%   select directory to analyze
%   turn contained calc filenames into an array
%   create a time-stamped directory to save out analysis files
%       directory structure should match data directory
%   capture figures and data for output to analysis report
%       time to calculate
%       dimensions of data (filtered and unfiltered)
%       figures
%       self-similarity image
%       slopes analysis (mean, average, spread, etc.)

%import report generation libraries
%see more information at -- https://www.mathworks.com/help/rptgen/ug/_mw_bf8ea6ab-5b87-44fd-a82e-c716ff17edd3.html
% import mlreportgen.report.*
% import mlreportgen.dom.*

%%
% %generate short noise files (ground truth)
% rate = 120;     mins = 0;	secs = 1;	chans = 3;  samps = rate * 60 * mins + rate * secs;
% types = {'purple', 'blue', 'white', 'pink', 'brown'};
% generateNoiseCalc(types, samps, chans);

%%
% %generate wide short  noise files (ground truth)
% rate = 120;     mins = 0;	secs = 1;	chans = 900;  samps = rate * 60 * mins + rate * secs;
% types = {'purple', 'blue', 'white', 'pink', 'brown'};
% generateNoiseCalc(types, samps, chans);

%%
% %generate longer noise files (ground truth)
% rate = 120;     mins = 5;	secs = 0;	chans = 3;  samps = rate * 60 * mins + rate * secs;
% types = {'purple', 'blue', 'white', 'pink', 'brown'};
% generateNoiseCalc(types, samps, chans);

%%
% %generate longest noise files (ground truth)
% rate = 120;     mins = 15;	secs = 0;	chans = 3;  samps = rate * 60 * mins + rate * secs;
% types = {'purple', 'blue', 'white', 'pink', 'brown'};
% generateNoiseCalc(types, samps, chans);

%%
% %generate wide longest noise files (ground truth)
% rate = 120;     mins = 15;	secs = 0;	chans = 900;  samps = rate * 60 * mins + rate * secs;
% types = {'purple', 'blue', 'white', 'pink', 'brown'};
% generateNoiseCalc(types, samps, chans);

%%
%run fractal analysis on audio files
clear;
dFilter = false; ignoreZ = false; calcSelfSim = false; fractalDim = {1,2}; HzLPass = 1; outDir = 'calc_files/test/Music';
sampleRate = NaN;
%create a list of file names
files = {...
    'calc_files\test\Music\Cage\Cage_Music_of_Changes.mp3'...
    ,...
    'calc_files\test\Music\Mozart\Mozart-Piano_Concerto_No24_in_Cminor_K491_Mitsuko_Uchida.mp3'...
    ,...
    'calc_files\test\Music\Mozart\Wolfgang_Amadeus_Mozart_-_Don_Giovanni_-_Overture.ogg.mp3'...
    ,...
    'calc_files\test\Music\Mozart\Wolfgang_Amadeus_Mozart_-_Don_Giovanni-Adelina_Patti-Batti_batti_o_bel_Masetto-1905.ogg.mp3'...
    ,...
    'calc_files\test\Music\Mozart\Wolfgang_Amadeus_Mozart_-_Symphony_40_g-moll_-_1._Molto_allegro.ogg.mp3'...
    ,...
    'calc_files\test\Music\Mozart\Wolfgang_Amadeus_Mozart_-_Symphony_40_g-moll_-_2._Andante.ogg.mp3'...
    ,...
    'calc_files\test\Music\Mozart\Wolfgang_Amadeus_Mozart_-_Symphony_40_g-moll_-_3._Menuetto_Allegretto-Trio.ogg.mp3'...
    ,...
    'calc_files\test\Music\Mozart\Wolfgang_Amadeus_Mozart_-_Symphony_40_g-moll_-_4._Allegro_assai.ogg.mp3'...
    };

%%
%single
close all;
fractal_analysis(files{1,4}, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim, HzLPass, outDir )
%%
%all
close all;
fractal_analysis(files, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim, HzLPass, outDir )
%only least squares lin regression



%%
%run fractal analysis on dance files from MIT HA 2017
clear;
dFilter = false; ignoreZ = false; calcSelfSim = false; fractalDim = {1,2}; HzLPass = NaN; outDir = 'calc_files/test/';
sampleRate = 120;     mins = 0;	secs = 1;	chans = 900;  samps = sampleRate * 60 * mins + sampleRate * secs;
styles = {'africa', 'contemp', 'hiphop', '2indian', 'salsa'};
nSty = numel(styles);
gestures = {'down', 'left', 'right', 'turn', 'up'};
nGst = numel(gestures);
files = cell(1,nSty*nGst);
%create a list of file names
for i = drange(1:nSty)
    for j = drange(1:nGst)
        files{1,((i-1)*nSty)+j} = ['calc_files/' styles{1,i} '/' styles{1,i} '_' gestures{1,j} '_Char00.calc'];
    end
end

%%
%single
close all;
fractal_analysis(files{1,1}, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim{1,1}, HzLPass, outDir )
%%
%all
close all;
fractal_analysis(files, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim{1,1}, HzLPass, outDir )
%only least squares lin regression


%%
%run fractal analysis on short noise files
clear;
dFilter = false; ignoreZ = false; calcSelfSim = false; fractalDim = {1,2}; HzLPass = NaN; outDir = 'calc_files/test/';
sampleRate = 120;     mins = 0;	secs = 1;	chans = 3;  samps = sampleRate * 60 * mins + sampleRate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
files = types;
%create a list of file names
for i = drange(1:size(types, 2))
    files{i} = ['calc_files/test/noise_' types{1,i} '_' num2str(samps) 'x' num2str(chans) '.calc'];
end

%%
%single
close all;
fractal_analysis(files{1,1}, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim{1,1}, HzLPass, outDir )
%%
%all
close all;
fractal_analysis(files, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim, HzLPass, outDir )


%%
%run fractal analysis on wide short noise files
clear;
dFilter = false; ignoreZ = false; calcSelfSim = false; fractalDim = {1,2}; HzLPass = NaN; outDir = 'calc_files/test/';
sampleRate = 120;     mins = 0;	secs = 1;	chans = 900;  samps = sampleRate * 60 * mins + sampleRate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
files = types;
%create a list of file names
for i = drange(1:size(types, 2))
    files{i} = ['calc_files/test/noise_' types{1,i} '_' num2str(samps) 'x' num2str(chans) '.calc'];
end

%%
%single
close all;
fractal_analysis(files{1,1}, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim{1,1}, HzLPass, outDir )
%%
%all
close all;
fractal_analysis(files, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim, HzLPass, outDir )


%%
%run fractal analysis on longer noise files
clear;
dFilter = false; ignoreZ = false; calcSelfSim = false; fractalDim = {1,2}; HzLPass = 1; outDir = 'calc_files/test/';
sampleRate = 120;     mins = 5;	secs = 0;	chans = 3;  samps = sampleRate * 60 * mins + sampleRate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
files = types;
%create a list of file names
for i = drange(1:size(types, 2))
    files{i} = ['calc_files/test/noise_' types{1,i} '_' num2str(samps) 'x' num2str(chans) '.calc'];
end

%%
%single
close all;
fractal_analysis(files{1,1}, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim{1,1}, HzLPass, outDir )
%%
%all
close all;
fractal_analysis(files, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim, HzLPass, outDir )


%%
%run fractal analysis on longest noise files
clear;
dFilter = false; ignoreZ = false; calcSelfSim = false; fractalDim = {1,2}; HzLPass = 1; outDir = 'calc_files/test/';
sampleRate = 120;     mins = 15;	secs = 0;	chans = 3;  samps = sampleRate * 60 * mins + sampleRate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
files = types;
%create a list of file names
for i = drange(1:size(types, 2))
    files{i} = ['calc_files/test/noise_' types{1,i} '_' num2str(samps) 'x' num2str(chans) '.calc'];
end

%%
%single
close all;
fractal_analysis(files{1,1}, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim{1,1}, HzLPass, outDir )
%%
%all
close all;
fractal_analysis(files, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim{1,1}, HzLPass, outDir )
%unable to run Theil-Sen analysis because of memory constraints: error below
% Error using nan
% Requested 54000x54000 (21.7GB) array exceeds maximum array size preference. Creation of arrays greater than this limit may
% take a long time and cause MATLAB to become unresponsive. See array size limit or preference panel for more information.
% 
% Error in TheilSen (line 68)
%     C = nan(sz(1));

%%
%run fractal analysis on wide longest noise files
clear;
dFilter = false; ignoreZ = false; calcSelfSim = false; fractalDim = {1,2}; HzLPass = 1; outDir = 'calc_files/test/';
sampleRate = 120;     mins = 15;	secs = 0;	chans = 900;  samps = sampleRate * 60 * mins + sampleRate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
files = types;
%create a list of file names
for i = drange(1:size(types, 2))
    files{i} = ['calc_files/test/noise_' types{1,i} '_' num2str(samps) 'x' num2str(chans) '.calc'];
end

%%
%single
close all;
fractal_analysis(files{1,1}, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim{1,1}, HzLPass, outDir )
%%
%all
close all;
fractal_analysis(files, sampleRate, dFilter, ignoreZ, calcSelfSim, fractalDim{1,1}, HzLPass, outDir )
%unable to run Theil-Sen analysis because of memory constraints: error below
% Error using nan
% Requested 54000x54000 (21.7GB) array exceeds maximum array size preference. Creation of arrays greater than this limit may
% take a long time and cause MATLAB to become unresponsive. See array size limit or preference panel for more information.
% 
% Error in TheilSen (line 68)
%     C = nan(sz(1));


