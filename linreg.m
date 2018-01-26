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
        [m2, b2] = TheilSen(data);
        %plims = [min(min(data(:,1,:))) max(max(data(:,1,:)))]';
        b = [m2'; b2'; repmat(zeros(1,size(data,3)),size(X,2)-2,1)];
        yCalc = X*b;
        %TODO: something about this last line above smells funny
        % check against example code (below)
            % n=100;
            % outN=round(0.2*n);
            % noise = randn(n,2)*0.1; noise(randi(n*2,[outN 1]))=randn(outN,1)*5;
            % data = [linspace(0,10,n)' linspace(0,5,n)'] + noise;
            % [m, b] = TheilSen(data);
            % plims = [min(data(:,1)) max(data(:,1))]';
            % figure
            % plot(data(:,1),data(:,2),'k.',...
            %     plims,plims*m+b,'-r')
            % legend('Data','TheilSen','Least Squares','location','NW')
            % title(sprintf('Acual Slope = %2.3g, LS est = %2.3g, TS est = %2.3g',[0.5 Bhat(2) m]))
        % used the following to get a data array that is multidimensional
            % dataArr=zeros(100,2,2);
            % dataArr(:,:,1) = data;
            % dataArr(:,:,2) = [linspace(10,15,n)' linspace(5,0,n)'] + noise;
            % plims = [min(min(dataArr(:,1,:))) max(max(data(:,1,:)))]';
            % plot(squeeze(dataArr(:,1,:)), squeeze(dataArr(:,2,:)), '.');
            % plot(plims,plims*m'+b','-r'); %output looks somewhat
            % accurate, but shape of data may be wrong (if it was correct, it would
            % generate different plot line colors)
           
    else
        %TODO: thow an error for unknown linear regression
        %type
        error('Unhandled linear regression request. "fractalDim" = %2.3g', num2str(method)); 
    end
end

