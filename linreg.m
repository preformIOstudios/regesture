function [yCalc, b] = linreg(x,y, method)
%LINREG Summary of this function goes here
%   Detailed explanation goes here
%TODO: use an enum for regression method

%calculate linear regression + yintercept
    format long
    n = size(x,1);
    X = [ones(n,1) x];
    
    if (method == 1)
        %"least squares" linear regression
        b = X\y;
        yCalc = X*b;
        
    elseif (method == 2)
        %"Theil-Sen" linear regression
        concat = [x y];
        unzip = reshape(concat, numel(x), []);
        rezip = reshape(unzip', 2, n, []);
        data = permute(rezip, [2,1,3]);
        data(1) = data(1); %TODO: why is this here?
        [mTS, bTS] = TheilSen(data);
        b = [bTS'; mTS'; repmat(zeros(1,size(data,3)),size(X,2)-2,1)];
        yCalc = X*b;
           
    else
        %TODO: thow an error for unknown linear regression
        %type
        error('Unhandled linear regression request. "fractalDim" = %2.3g', num2str(method)); 
    end
end

