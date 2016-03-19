% Contains county data sorted by delegate difference
iowaData = csvread('iowa-data-sorted.csv');
numCounties = rows(iowaData) - 1;
numProperties = columns(iowaData) - 1;

% Exclude column headers and county names
iowaStats = iowaData(2:end, 2:end);

sandersCounties = 37;
tiedCounties = 3;
clintonCounties = numCounties - sandersCounties - tiedCounties;

X = iowaStats(:, 2);
Y = iowaStats(:, 11);

graphics_toolkit("gnuplot")
fig = figure;
hold on;
% Color Sanders counties blue, Clinton counties red, and tied counties black
plot(X(1:sandersCounties), Y(1:sandersCounties), 'b.')
plot(X(sandersCounties + 1:sandersCounties + tiedCounties), 
     Y(sandersCounties + 1:sandersCounties + tiedCounties), 'k.')
plot(X(numCounties - clintonCounties + 1:numCounties - 1), 
     Y(numCounties - clintonCounties + 1:numCounties - 1), 'r.')
title('Median Age and Delegate Difference')
xlabel('Median Age')
ylabel('Delegate Difference (Sanders Del. - Clinton Del.)')
hold off;

saveas(fig,'figures/iowa-corr-age','pdf')