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
%see more information at ?�https://www.mathworks.com/help/rptgen/ug/_mw_bf8ea6ab-5b87-44fd-a82e-c716ff17edd3.html
import mlreportgen.report.*
import mlreportgen.dom.*

%%
%generate simple noise files
generateNoiseCalc('purple', 120, 3);
generateNoiseCalc('blue', 120, 3);
generateNoiseCalc('white', 120, 3);
generateNoiseCalc('pink', 120, 3);
generateNoiseCalc('brown', 120, 3);

%%
%generate complex noise files (ground truth)
generateNoiseCalc('purple', 120 * 60 * 5, 3);
generateNoiseCalc('blue', 120 * 60 * 5, 3);
generateNoiseCalc('white', 120 * 60 * 5, 3);
generateNoiseCalc('pink', 120 * 60 * 5, 3);
generateNoiseCalc('brown', 120 * 60 * 5, 3);

%%
%run fractal analysis on simple noise files
%fractal_analysis( file, sampleSize, dFilter, ignoreZ, calcSelfSim, fractalDim )
close all;
fractal_analysis('calc_files/test/noise_white_120x3.calc', 120, false, false, false, 1);
fractal_analysis('calc_files/test/noise_white_120x3.calc', 120, false, false, false, 2);
close all;
fractal_analysis('calc_files/test/noise_blue_120x3.calc', 120, false, false, false, 1);
fractal_analysis('calc_files/test/noise_blue_120x3.calc', 120, false, false, false, 2);
close all;
fractal_analysis('calc_files/test/noise_purple_120x3.calc', 120, false, false, false, 1);
fractal_analysis('calc_files/test/noise_purple_120x3.calc', 120, false, false, false, 2);
close all;
fractal_analysis('calc_files/test/noise_pink_120x3.calc', 120, false, false, false, 1);
fractal_analysis('calc_files/test/noise_pink_120x3.calc', 120, false, false, false, 2);
close all;
fractal_analysis('calc_files/test/noise_brown_120x3.calc', 120, false, false, false, 1);
fractal_analysis('calc_files/test/noise_brown_120x3.calc', 120, false, false, false, 2);
close all;

%%
%run fractal analysis on complex noise files
close all;
fractal_analysis('calc_files/test/noise_white_36000x3.calc', 120, false, false, false, 2, 1);
fractal_analysis('calc_files/test/noise_white_36000x3.calc', 120, false, false, false, 1, 1);
close all;
fractal_analysis('calc_files/test/noise_blue_36000x3.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_blue_36000x3.calc', 120, false, false, false, 2, 1);
close all;
fractal_analysis('calc_files/test/noise_purple_36000x3.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_purple_36000x3.calc', 120, false, false, false, 2, 1);
close all;
fractal_analysis('calc_files/test/noise_pink_36000x3.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_pink_36000x3.calc', 120, false, false, false, 2, 1);
close all;
fractal_analysis('calc_files/test/noise_brown_36000x3.calc', 120, false, false, false, 1, 1);
fractal_analysis('calc_files/test/noise_brown_36000x3.calc', 120, false, false, false, 2, 1);
close all;

%%
%run fractal analysis on dance files from MITHA2017

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
