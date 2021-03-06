function [fitresult, gof] = createFit(bins, binCounts)
%CREATEFIT(BINS,BINCOUNTS)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : bins
%      Y Output: binCounts
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 15-Apr-2022 17:03:42


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( bins, binCounts );

% Set up fittype and options.
ft = fittype( 'A1 * exp(-((x - mu1)/(2 * sigma1))^2) + A2 * exp(-((x - mu2)/(2 * sigma2))^2)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.StartPoint = [50 20 901 1800 100 100];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'binCounts vs. bins', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'bins', 'Interpreter', 'none' );
ylabel( 'binCounts', 'Interpreter', 'none' );
grid on


