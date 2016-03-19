% Contains county data sorted by delegate difference
iowaData = csvread('iowa-data-sorted.csv');
numCounties = rows(iowaData) - 1;
numProperties = columns(iowaData) - 1;

% Exclude column headers and county names
iowaStats = iowaData(2:end, 2:end);

sandersCounties = 37;
tiedCounties = 3;
clintonCounties = numCounties - sandersCounties - tiedCounties;

% Compute the correlation matrix of Iowa county data
iowaCorrelation = corr(iowaStats);

[U, S, V] = svd(iowaCorrelation);

firstTwoPCs = U(:, 1:2);
XYcoords = iowaStats * firstTwoPCs;
X = XYcoords(:, 1);
Y = XYcoords(:, 2);

csvwrite('correlation-pca.csv', firstTwoPCs)

graphics_toolkit("gnuplot")
fig = figure('Position', [100, 100, 400, 300]);
hold on;
% Color Sanders counties blue, Clinton counties red, and tied counties black
plot(X(1:sandersCounties), Y(1:sandersCounties), 'b.')
plot(X(sandersCounties + 1:sandersCounties + tiedCounties), 
     Y(sandersCounties + 1:sandersCounties + tiedCounties), 'k.')
plot(X(numCounties - clintonCounties + 1:numCounties - 1), 
     Y(numCounties - clintonCounties + 1:numCounties - 1), 'r.')
title('Iowa County Data - Correlation Principle Component Analysis')
xlabel('1st Principal Component (weighted sum of almost all stats)')
ylabel('2nd Principal Component (emphasizing Delegate Difference)')
hold off;

saveas(fig,'figures/iowa-corr-pca','pdf')