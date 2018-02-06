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
import mlreportgen.report.*
import mlreportgen.dom.*

%%
%generate short noise files (ground truth)
rate = 120;     mins = 0;	secs = 1;	chans = 3;  samps = rate * 60 * mins + rate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
generateNoiseCalc(types, samps, chans);

%%
%generate wide short  noise files (ground truth)
rate = 120;     mins = 0;	secs = 1;	chans = 900;  samps = rate * 60 * mins + rate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
generateNoiseCalc(types, samps, chans);

%%
%generate longer noise files (ground truth)
rate = 120;     mins = 5;	secs = 0;	chans = 3;  samps = rate * 60 * mins + rate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
generateNoiseCalc(types, samps, chans);

%%
%generate longest noise files (ground truth)
rate = 120;     mins = 15;	secs = 0;	chans = 3;  samps = rate * 60 * mins + rate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
generateNoiseCalc(types, samps, chans);

%%
%generate wide longest noise files (ground truth)
rate = 120;     mins = 15;	secs = 0;	chans = 900;  samps = rate * 60 * mins + rate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
generateNoiseCalc(types, samps, chans);

%%
%run fractal analysis on short noise files
%fractal_analysis( file, sampleSize, dFilter, ignoreZ, calcSelfSim, fractalDim )
close all;
fractal_analysis('calc_files/test/noise_white_120x3.calc', 120, false, false, false, 1);
%%
fractal_analysis('calc_files/test/noise_white_120x3.calc', 120, false, false, false, 2);
fractal_analysis('calc_files/test/noise_blue_120x3.calc', 120, false, false, false, 1);
fractal_analysis('calc_files/test/noise_blue_120x3.calc', 120, false, false, false, 2);
fractal_analysis('calc_files/test/noise_purple_120x3.calc', 120, false, false, false, 1);
fractal_analysis('calc_files/test/noise_purple_120x3.calc', 120, false, false, false, 2);
fractal_analysis('calc_files/test/noise_pink_120x3.calc', 120, false, false, false, 1);
fractal_analysis('calc_files/test/noise_pink_120x3.calc', 120, false, false, false, 2);
fractal_analysis('calc_files/test/noise_brown_120x3.calc', 120, false, false, false, 1);
fractal_analysis('calc_files/test/noise_brown_120x3.calc', 120, false, false, false, 2);

%%
%run fractal analysis on wide short noise files
rate = 120;     mins = 0;	secs = 1;	chans = 900;  samps = rate * 60 * mins + rate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
files = types;
%create a list of file names
for i = drange(1:size(types, 2))
    files{i} = ['calc_files/test/noise_' types{1,i} '_' num2str(samps) 'x' num2str(chans) '.calc'];
end

%%
%single
close all;
fractal_analysis(files{1,1}, 120, false, false, false, 1);
%%
%all
close all;
fractal_analysis(files, 120, false, false, false, {1,2});


%%
%run fractal analysis on longer noise files
close all;
fractal_analysis('calc_files/test/noise_white_36000x3.calc', 120, false, false, false, 1, 1);
%%
fractal_analysis('calc_files/test/noise_white_36000x3.calc', 120, false, false, false, 2, 1);
fractal_analysis('calc_files/test/noise_blue_36000x3.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_blue_36000x3.calc', 120, false, false, false, 2, 1);
fractal_analysis('calc_files/test/noise_purple_36000x3.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_purple_36000x3.calc', 120, false, false, false, 2, 1);
fractal_analysis('calc_files/test/noise_pink_36000x3.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_pink_36000x3.calc', 120, false, false, false, 2, 1);
fractal_analysis('calc_files/test/noise_brown_36000x3.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_brown_36000x3.calc', 120, false, false, false, 2, 1);

%%
%run fractal analysis on longest noise files
rate = 120;     mins = 15;	secs = 0;	chans = 3;  samps = rate * 60 * mins + rate * secs;
types = {'purple', 'blue', 'white', 'pink', 'brown'};
files = types;
%create a list of file names
for i = drange(1:size(types, 2))
    files{i} = ['calc_files/test/noise_' types{1,i} '_' num2str(samps) 'x' num2str(chans) '.calc'];
end

%%
%single
close all;
fractal_analysis(files{1,1}, 120, false, false, false, 1, 1);
%%
%all
close all;
fractal_analysis(files, 120, false, false, false, {1,2}, 1);


%%
%run fractal analysis on wide longest noise files
close all;
fractal_analysis('calc_files/test/noise_white_108000x900.calc', 120, false, false, false, 1, 1);
%%
fractal_analysis('calc_files/test/noise_white_108000x900.calc', 120, false, false, false, 2, 1);
fractal_analysis('calc_files/test/noise_blue_108000x900.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_blue_108000x900.calc', 120, false, false, false, 2, 1);
fractal_analysis('calc_files/test/noise_purple_108000x900.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_purple_108000x900.calc', 120, false, false, false, 2, 1);
fractal_analysis('calc_files/test/noise_pink_108000x900.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_pink_108000x900.calc', 120, false, false, false, 2, 1);
fractal_analysis('calc_files/test/noise_brown_108000x900.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_brown_108000x900.calc', 120, false, false, false, 2, 1);

%%
%run fractal analysis on dance files from MITHA2017
close all;
fractal_analysis('calc_files/africa/africa_down_Char00.calc');
fractal_analysis('calc_files/africa/africa_left_Char00.calc');
fractal_analysis('calc_files/africa/africa_right_Char00.calc');
fractal_analysis('calc_files/africa/africa_turn_Char00.calc');
fractal_analysis('calc_files/africa/africa_up_Char00.calc');

fractal_analysis('calc_files/contemporary/contemp_down_Char00.calc');
fractal_analysis('calc_files/contemporary/contemp_left_Char00.calc');
fractal_analysis('calc_files/contemporary/contemp_right_Char00.calc');
fractal_analysis('calc_files/contemporary/contemp_turn_Char00.calc');
fractal_analysis('calc_files/contemporary/contemp_up_Char00.calc');

fractal_analysis('calc_files/hiphop/hiphop_down_Char00.calc');
fractal_analysis('calc_files/hiphop/hiphop_left_Char00.calc');
fractal_analysis('calc_files/hiphop/hiphop_right_Char00.calc');
fractal_analysis('calc_files/hiphop/hiphop_turn_Char00.calc');
fractal_analysis('calc_files/hiphop/hiphop_up_Char00.calc');

fractal_analysis('calc_files/indian/2indian_down_Char00.calc');
fractal_analysis('calc_files/indian/2indian_left_Char00.calc');
fractal_analysis('calc_files/indian/2indian_right_Char00.calc');
fractal_analysis('calc_files/indian/2indian_turn_Char00.calc');
fractal_analysis('calc_files/indian/2indian_up_Char00.calc');

fractal_analysis('calc_files/salsa/salsa_down_Char00.calc');
fractal_analysis('calc_files/salsa/salsa_left_Char00.calc');
fractal_analysis('calc_files/salsa/salsa_right_Char00.calc');
fractal_analysis('calc_files/salsa/salsa_turn_Char00.calc');
fractal_analysis('calc_files/salsa/salsa_up_Char00.calc');
