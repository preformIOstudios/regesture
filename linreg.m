function [yCalc, b] = linreg(x,y,method,w)
%LINREG Summary of this function goes here
%   Detailed explanation goes here
%TODO: use an enum for regression method
%   Credits: david allen, Il-Young Son
    
    %handle cases where there is no data
    sz = size(x);
    if length(sz)<2 | min(sz) ==0
        yCalc = []
        b = []
        return
    end

    %calculate linear regression + yintercept
    format long
    n = size(x,1);
    X = [ones(n,1) x];
    
    if (method == 1)
        %"least squares" linear regression
        if nargin < 4           
            %unweighted least squares lin reg
            b = X\y;
        else
            %weighted least squares lin reg
            wX = w.*X;
            wy = w.*y;
            b = wX\wy;
        end
        yCalc = X*b;
        
    elseif (method == 2)
        %give warning that weights are going to be ignored
        if nargin == 4
            warning('ignored weights (w) argument. Theil-Sen linear regression does not support weights.');
        end
        
        %"Theil-Sen" linear regression
        concat = [x y];
        unzip = reshape(concat, numel(x), []);
        rezip = reshape(unzip', 2, n, []);
        data = permute(rezip, [2,1,3]);
        [mTS, bTS] = TheilSen(data);
        b = [bTS'; mTS'; repmat(zeros(1,size(data,3)),size(X,2)-2,1)];
        yCalc = X*b;
           
    else
        %TODO: thow an error for unknown linear regression
        %type
        error('Unhandled linear regression request. "fractalDim" = %2.3g', num2str(method)); 
    end
end

