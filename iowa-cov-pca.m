% Contains county data sorted by delegate difference
iowaData = csvread('iowa-data-sorted.csv');
numCounties = rows(iowaData) - 1;
numProperties = columns(iowaData) - 1;

% Exclude column headers and county names
iowaStats = iowaData(2:end, 2:end);

% Cell array of column headers
countyProperties = cellstr([
  "County";
  "Population";
  "Median Age";
  "Median Household Income";
  "High School Graduate";
  "Bachelor's Degree";
  "Percent Rural";
  "Sessions";
  "Sessions (Normalized)";
  "Sanders Delegates";
  "Clinton Delegates";
  "Delegate Difference"
]);

sandersCounties = 37;
tiedCounties = 3;
clintonCounties = numCounties - sandersCounties - tiedCounties;

% Compute the covariance matrix of Iowa county data
iowaCovariance = cov(iowaStats);

[U, S, V] = svd(iowaCovariance);

firstTwoPCs = U(:, 1:2);
XYcoords = iowaStats * firstTwoPCs;
X = XYcoords(:, 1);
Y = XYcoords(:, 2);

csvwrite('covariance-pca.csv', firstTwoPCs)

% Get the column header corresponding to the principal component
[max_first, max_index_first] = max(firstTwoPCs(:,1));
firstPCEmphasis = char(countyProperties(max_index_first));
[max_second, max_index_second] = max(firstTwoPCs(:,2));
secondPCEmphasis = char(countyProperties(max_index_second));

graphics_toolkit("gnuplot")
fig = figure('Position', [100, 100, 400, 300]);
hold on;
% Color Sanders counties blue, Clinton counties red, and tied counties black
plot(X(1:sandersCounties), Y(1:sandersCounties), 'b.')
plot(X(sandersCounties + 1:sandersCounties + tiedCounties), 
     Y(sandersCounties + 1:sandersCounties + tiedCounties), 'k.')
plot(X(numCounties - clintonCounties + 1:numCounties - 1), 
     Y(numCounties - clintonCounties + 1:numCounties - 1), 'r.')
title('Iowa County Data - Covariance Principle Component Analysis')
xlabel(sprintf('1st Principal Component (emphasizing %s)', firstPCEmphasis))
ylabel(sprintf('2nd Principal Component (emphasizing %s)', secondPCEmphasis))
hold off;

saveas(fig,'figures/iowa-cov-pca','pdf')