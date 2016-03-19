% Contains county data sorted by delegate difference
iowaData = csvread('iowa-data-sorted.csv');
numCounties = rows(iowaData) - 1;
numProperties = columns(iowaData) - 1;

% Exclude column headers and county names
iowaStats = iowaData(2:end, 2:end);

correlationMatrix = corr(iowaStats);

csvwrite('iowa-correlation-raw.csv', correlationMatrix)