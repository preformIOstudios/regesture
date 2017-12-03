function [ D ] = similarity( DATA1, DATA2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

switch nargin
    case 1
        DATA2 = DATA1;
end

%collapse data matrix into 1D array with a single value per row
V1 = sum(DATA1, 2);
V2 = sum(DATA2, 2);
%replicate those values into matrix for transposition math
%TODO: is there an easier (component-wise?) way to do this and the next line in one command?
VV1 = repmat(V1, 1, numel(V1));
VV2 = repmat(V2, 1, numel(V2));
%calculate distance between those vectors into a distance array
D = abs(VV1 - VV2');

end

