function ColorSet=varycolor(NumberOfPlots)
% VARYCOLOR Produces colors with maximum variation on plots with multiple
% lines.
%
%     VARYCOLOR(X) returns a matrix of dimension X by 3.  The matrix may be
%     used in conjunction with the plot command option 'color' to vary the
%     color of lines.  
%
%     Yellow and White colors were not used because of their poor
%     translation to presentations.
% 
%     Example Usage:
%         NumberOfPlots=50;
%
%         ColorSet=varycolor(NumberOfPlots);
% 
%         figure
%         hold on;
% 
%         for m=1:NumberOfPlots
%             plot(ones(20,1)*m,'Color',ColorSet(m,:))
%         end

%Created by Daniel Helmick 8/12/2008
%Redesigned by david allen 12/02/2017

narginchk(1,1)%correct number of input arguements??
nargoutchk(0, 1)%correct number of output arguements??

%Take care of the anomolies
if NumberOfPlots<1
    ColorSet=[];
    
else %default and where this function has an actual advantage
    %store colors to interploate in a set
    %TODO: make color set an input argument
    colors = [1.0 0.0 0.0; 1.0 1.0 0.0; 0.0 1.0 0.0; 0.0 1.0 1.0; 0.0 0.0 1.0; 1.0 0.0 1.0];
    n = size(colors, 1);
    colorwheel = vertcat(colors, colors(1,:));
    %create vector of how far apart colors should be on color wheel
    spread = n / NumberOfPlots;
    spreadS = 1:spread:n+1-spread;
    ColorSet = interp1(colorwheel,spreadS);
end