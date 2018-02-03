function [nData,fName] = generateNoiseCalc(nType, nSamp, nChan, outDir)
%GENERATENOISECALC Summary of this function goes here
%   Detailed explanation goes here

%default inputs: noise type, number of samples, number of channels
if nargin < 4
    outDir = 'calc_files/test/';
    if nargin < 3
        nChan = 1;
        if nargin < 2
            nSamp = 100;
            if nargin < 1
                nType = 'white'; %TODO: use an enum here?
            end
        end
    end
end

%set inverse frequency power based on noise type
switch nType
    case {'brown', 'brownian', 'red', 2}
        nPow = 2;
        if nType == 2
            nType = 'brown';
        end
    case {'pink', 1}
        nPow = 1;
        nType = 'pink';
    case {'white', 0}
        nPow = 0;
        nType = 'white';
    case {'blue', 'azure', -1}
        nPow = -1;
        if nType == -1
            nType = 'blue';
        end
    case {'purple', 'violet', 'periodic' -2}
        nPow = -2;
        if nType == -2
            nType = 'purple';
        end
    otherwise
        %TODO: 
        %test for custom numeric -2 > value < 2 and set type to 'custom<pow>'
        %otherwise: throw an error
end

%create noise object
cn = dsp.ColoredNoise(nPow,nSamp,nChan);

%generate noise, setting random noise generator to defaults for reproducible results
rng default;
nData = cn();

%initialize filename
fName = fullfile(outDir, [nType 'Noise_' num2str(nSamp) 'x' num2str(nChan) '.calc']);
%TODO: include — timestamp? randmethod? randseed?
%TODO: save out calc file
save(fName, 'nData', '-ascii', '-tabs');

end

