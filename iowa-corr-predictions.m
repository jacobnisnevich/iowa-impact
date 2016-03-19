% Contains county data sorted by delegate difference
iowaData = csvread('iowa-data-sorted.csv');
numCounties = rows(iowaData) - 1;
numProperties = columns(iowaData) - 1;

% Exclude column headers and county names
iowaStats = iowaData(2:end, 2:end);

% Linear model predictions data
predictionsData = csvread('linear-model-predictions.csv');
predictionsStats = predictionsData(2:end, :);

sandersCounties = 37;
tiedCounties = 3;
clintonCounties = numCounties - sandersCounties - tiedCounties;

% X is the normalized sessions column
X = iowaStats(:, 8);
Y = predictionsStats(:, 2) - predictionsStats(:, 1);

linearRegressionY = (X \ Y) * X;

graphics_toolkit("gnuplot")
fig = figure('Position', [100, 100, 400, 300]);
hold on;
plot(X, linearRegressionY, 'k-')
% Color Sanders counties blue, Clinton counties red, and tied counties black
plot(X(1:sandersCounties), Y(1:sandersCounties), 'b.')
plot(X(sandersCounties + 1:sandersCounties + tiedCounties), 
     Y(sandersCounties + 1:sandersCounties + tiedCounties), 'k.')
plot(X(numCounties - clintonCounties + 1:numCounties - 1), 
     Y(numCounties - clintonCounties + 1:numCounties - 1), 'r.')
title('Correlation between Linear Model Predictions and Normalized Sessions')
xlabel('Normalized Sessions')
ylabel('Actual Delegate Difference - Predicted Delegate Difference')
hold off;

correlationCoefficient = corrcoef(X, Y)

saveas(fig,'figures/iowa-corr-predictions','pdf')