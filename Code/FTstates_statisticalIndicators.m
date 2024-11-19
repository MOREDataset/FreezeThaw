%% Deadhorse indicator1
clear 
clc
filename = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures\Air2UG_alltimeseries_Deadhorse_MERRA2data.csv';
data = readtable(filename);

% unFrozen days indicator

clear Indicator_state
clc

% Define depths and freezing point
depths = {'T0','T_07', 'T_12'};
freezingPoint = 0;

% Extract unique years from the data
yrz = unique(data.Date.Year);

% Initialize the Indicator table with years
Indicator_state = table(yrz, 'VariableNames', {'Years'});

% Loop through each depth and year
for i = 1:length(depths)
    % Preallocate columns for frozen and unfrozen days
    numFrozenCol = strcat('numFrozenDays_', depths{i});
    numUnfrozenCol = strcat('numUnfrozenDays_', depths{i});
    
    Indicator_state.(numFrozenCol) = zeros(length(yrz), 1); % Preallocate frozen days column
    Indicator_state.(numUnfrozenCol) = zeros(length(yrz), 1); % Preallocate unfrozen days column
    
    for j = 1:length(yrz)
        % Extract data for the current year
        data_year = data(data.Date.Year == yrz(j), :);
        
        % Determine frozen or unfrozen days (1 for frozen, 0 for unfrozen)
        frozenDays = data_year.(depths{i}) <= freezingPoint;
        
        % Count the number of frozen days
        Indicator_state.(numFrozenCol)(j) = sum(frozenDays);
        
        % Count the number of unfrozen days
        Indicator_state.(numUnfrozenCol)(j) = length(frozenDays) - Indicator_state.(numFrozenCol)(j);
    end
end
Indicator_state = Indicator_state(2:end-1,:);%remove 1986 and 2000 because they are not full years

%compute the weighted number of days instead
for iii = 1:length(depths)
    iii
    eval(sprintf('Indicator_state.numFrozenDays_%s = 100*Indicator_state.numFrozenDays_%s./(Indicator_state.numFrozenDays_%s+Indicator_state.numUnfrozenDays_%s);',depths{iii},depths{iii},depths{iii},depths{iii}))
    eval(sprintf('Indicator_state.numUnfrozenDays_%s = 100*Indicator_state.numUnfrozenDays_%s./(Indicator_state.numFrozenDays_%s+Indicator_state.numUnfrozenDays_%s);',depths{iii},depths{iii},depths{iii},depths{iii}))
end

% Graph

figure('units','normalized','OuterPosition',[0 0 1 1]);
t = tiledlayout(1, 1,"TileSpacing","tight",'Padding','tight'); % 1 row, 3 columns
nexttile;
size1 = 40;

% Define markers for each depth
markers = {'o','square','diamond'};
colors = lines(length(depths));

for i = 1:length(depths)
    hold on;

    temp = Indicator_state{:,2*i+1};
    % Plot the growing season duration as a line
    plot(Indicator_state.Years, temp, ...
         'LineWidth', 2, 'Color', colors(i, :), 'Marker', markers{i}, ...
         'MarkerFaceColor', colors(i, :),'MarkerSize',10, 'DisplayName',[strrep(strrep(strrep(depths{i},'_0',''),'_',''),'T','') ' cm']);
    
    % Calculate the number of days and add as text label
    LT = trenddecomp(temp);
    plot(Indicator_state.Years, LT, ...
             'LineWidth', 1, 'Color', colors(i, :), 'Marker', 'none', ...
             'MarkerFaceColor', colors(i, :), 'LineStyle','--', 'HandleVisibility','off');

    set(gca,'Box','on','FontSize',size1-5,'TickLabelInterpreter','latex',...
        'LineWidth',0.5,'YMinorGrid','off','YMinorTick','off','TickDir',...
        'in','YGrid','on','XTickLabelRotation',90);
    hold off;
    ax = gca;
    % ax.YTickLabel = ax.YTickLabel;
    xticks(yrz); % Ensure y-axis shows all the used years
    ylabel('Ratio of unfrozen days (\%)','FontSize',size1,'Interpreter','latex');
end

legend1 = legend('show');
set(legend1, 'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
% legend1 = legend({'0 cm','7 cm','12 cm'}, 'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);

title(legend1,'Soil depth','FontSize',size1,'Interpreter','latex');

% exportgraphics(gcf,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\Graph_indicator1_Deadhorse.pdf'),"ContentType","image","Resolution",300)

%% Toolik indicator2
clear 
clc
filename = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures\Air2UG_alltimeseries_Toolik_MERRA2data.csv';
data = readtable(filename);

% unFrozen days indicator

clear Indicator_state
clc

% Define depths and freezing point
depths = {'T0','T8', 'T16'};
freezingPoint = 0;

% Extract unique years from the data
yrz = unique(data.Date.Year);

% Initialize the Indicator table with years
Indicator_state = table(yrz, 'VariableNames', {'Years'});

% Loop through each depth and year
for i = 1:length(depths)
    % Preallocate columns for frozen and unfrozen days
    numFrozenCol = strcat('numFrozenDays_', depths{i});
    numUnfrozenCol = strcat('numUnfrozenDays_', depths{i});
    
    Indicator_state.(numFrozenCol) = zeros(length(yrz), 1); % Preallocate frozen days column
    Indicator_state.(numUnfrozenCol) = zeros(length(yrz), 1); % Preallocate unfrozen days column
    
    for j = 1:length(yrz)
        % Extract data for the current year
        data_year = data(data.Date.Year == yrz(j), :);
        
        % Determine frozen or unfrozen days (1 for frozen, 0 for unfrozen)
        frozenDays = data_year.(depths{i}) <= freezingPoint;
        
        % Count the number of frozen days
        Indicator_state.(numFrozenCol)(j) = sum(frozenDays);
        
        % Count the number of unfrozen days
        Indicator_state.(numUnfrozenCol)(j) = length(frozenDays) - Indicator_state.(numFrozenCol)(j);
    end
end

% Graph

figure('units','normalized','OuterPosition',[0 0 1 1]);
t = tiledlayout(1, 1,"TileSpacing","tight",'Padding','tight'); % 1 row, 3 columns
nexttile;
size1 = 40;

% Define markers for each depth
markers = {'o','square','diamond'};
colors = lines(length(depths));

for i = 1:length(depths)
    hold on;

    temp = Indicator_state{:,2*i+1};
    % Plot the growing season duration as a line
    plot(Indicator_state.Years, temp, ...
         'LineWidth', 2, 'Color', colors(i, :), 'Marker', markers{i}, ...
         'MarkerFaceColor', colors(i, :),'MarkerSize',10);
    
    % Calculate the number of days and add as text label
    LT = trenddecomp(temp);
    plot(Indicator_state.Years, LT, ...
             'LineWidth', 1, 'Color', colors(i, :), 'Marker', 'none', ...
             'MarkerFaceColor', colors(i, :), 'LineStyle','--', 'HandleVisibility','off');

    set(gca,'Box','on','FontSize',size1-5,'TickLabelInterpreter','latex',...
        'LineWidth',0.5,'YMinorGrid','off','YMinorTick','off','TickDir',...
        'in','YGrid','on','XTickLabelRotation',90);
    hold off;
end
ax = gca;
ax.YTickLabel = ax.YTickLabel;
xticks(yrz); % Ensure y-axis shows all the used years
ylabel('Number of unfrozen days','FontSize',size1,'Interpreter','latex');

legend1 = legend({'0cm','8cm','16cm'}, 'Orientation','horizontal','Location','northoutside','Interpreter','latex','FontSize',size1);
title(legend1,'Soil depth','FontSize',size1,'Interpreter','latex');

% exportgraphics(gcf,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\Graph_indicator1_Toolik.pdf'),"ContentType","image","Resolution",300)

%% statistics
clear 
clc

filename = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures\Air2UG_alltimeseries_Deadhorse_MERRA2data.csv';
data = readtable(filename);

% Convert Date column to datetime format
data.Date = datetime(data.Date, 'InputFormat', 'yyyy-MM-dd');

% Define depths and freezing point
depths = {'T0','T_07', 'T_12'};

fprintf('Depth, Avg Mean, Avg Median, Avg StD, Avg Min, Avg Max, Avg Range, Avg IQR, Avg # Freeze days\n')

% Loop through each depth
for i = 1:length(depths)
    groundTemp = data.(depths{i});
    
    % Loop through each year
    years = year(data.Date);
    months = month(data.Date);  % Extract months to check for completeness
    uniqueYears = unique(years);
    
    % Initialize arrays to store yearly statistics
    yearlyMean = [];
    yearlyMedian = [];
    yearlyStd = [];
    yearlyMin = [];
    yearlyMax = [];
    yearlyRange = [];
    yearlyIQR = [];
    yearlyFreezeDays = [];
    
    % Calculate yearly statistics, but only for full years
    for j = 1:length(uniqueYears)
        % Check if the year has all 12 months
        yearData = groundTemp(years == uniqueYears(j)); % Data for the specific year
        yearMonths = unique(months(years == uniqueYears(j))); % Unique months for that year
        
        if length(yearMonths) == 12  % Only proceed if the year has all 12 months
            % Compute statistics for the year
            yearlyMean = [yearlyMean; mean(yearData)];
            yearlyMedian = [yearlyMedian; median(yearData)];
            yearlyStd = [yearlyStd; std(yearData)];
            yearlyMin = [yearlyMin; min(yearData)];
            yearlyMax = [yearlyMax; max(yearData)];
            yearlyRange = [yearlyRange; max(yearData) - min(yearData)];
            yearlyIQR = [yearlyIQR; iqr(yearData)];
            yearlyFreezeDays = [yearlyFreezeDays; sum(yearData < 0) / numel(yearData)];
        end
    end
    
    % Calculate the averages of the yearly statistics
    avgMean = mean(yearlyMean);
    avgMedian = mean(yearlyMedian);
    avgStd = mean(yearlyStd);
    avgMin = mean(yearlyMin);
    avgMax = mean(yearlyMax);
    avgRange = mean(yearlyRange);
    avgIQR = mean(yearlyIQR);
    avgFreezeDays = mean(yearlyFreezeDays);
    
    % Output the averaged statistics for each depth
    fprintf('%s, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.4f\n', ...
        depths{i}, avgMean, avgMedian, avgStd, avgMin, avgMax, avgRange, avgIQR, avgFreezeDays);
end

clear
filename = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures\Air2UG_alltimeseries_Toolik_MERRA2data.csv';
data = readtable(filename);

% Convert Date column to datetime format
data.Date = datetime(data.Date, 'InputFormat', 'yyyy-MM-dd');

% Define depths and freezing point
depths = {'T0','T8', 'T16'};

% Loop through each depth
for i = 1:length(depths)
    groundTemp = data.(depths{i});
    
    % Loop through each year
    years = year(data.Date);
    months = month(data.Date);  % Extract months to check for completeness
    uniqueYears = unique(years);
    
    % Initialize arrays to store yearly statistics
    yearlyMean = [];
    yearlyMedian = [];
    yearlyStd = [];
    yearlyMin = [];
    yearlyMax = [];
    yearlyRange = [];
    yearlyIQR = [];
    yearlyFreezeDays = [];
    
    % Calculate yearly statistics, but only for full years
    for j = 1:length(uniqueYears)
        % Check if the year has all 12 months
        yearData = groundTemp(years == uniqueYears(j)); % Data for the specific year
        yearMonths = unique(months(years == uniqueYears(j))); % Unique months for that year
        
        if length(yearMonths) == 12  % Only proceed if the year has all 12 months
            % Compute statistics for the year
            yearlyMean = [yearlyMean; mean(yearData)];
            yearlyMedian = [yearlyMedian; median(yearData)];
            yearlyStd = [yearlyStd; std(yearData)];
            yearlyMin = [yearlyMin; min(yearData)];
            yearlyMax = [yearlyMax; max(yearData)];
            yearlyRange = [yearlyRange; max(yearData) - min(yearData)];
            yearlyIQR = [yearlyIQR; iqr(yearData)];
            yearlyFreezeDays = [yearlyFreezeDays; sum(yearData < 0) / numel(yearData)];
        end
    end
    
    % Calculate the averages of the yearly statistics
    avgMean = mean(yearlyMean);
    avgMedian = mean(yearlyMedian);
    avgStd = mean(yearlyStd);
    avgMin = mean(yearlyMin);
    avgMax = mean(yearlyMax);
    avgRange = mean(yearlyRange);
    avgIQR = mean(yearlyIQR);
    avgFreezeDays = mean(yearlyFreezeDays);
    
    % Output the averaged statistics for each depth
    fprintf('%s, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.4f\n', ...
        depths{i}, avgMean, avgMedian, avgStd, avgMin, avgMax, avgRange, avgIQR, avgFreezeDays);
end

%% Functions

function seasons = get_astronomical_season(dates)
    % Extract the year from the dates
    yrs = year(dates);
    
    % Create datetime arrays for the equinoxes and solstices
    spring_equinox = datetime(yrs, 3, 20);
    summer_solstice = datetime(yrs, 6, 21);
    fall_equinox = datetime(yrs, 9, 22);
    winter_solstice = datetime(yrs, 12, 21);

    % Preallocate the seasons array
    seasons = zeros(size(dates));

    % Determine the season for each date
    seasons(dates >= spring_equinox & dates < summer_solstice) = 0; % Spring
    seasons(dates >= summer_solstice & dates < fall_equinox) = 1; % Summer
    seasons(dates >= fall_equinox & dates < winter_solstice) = 2; % Fall
    seasons(dates >= winter_solstice | dates < spring_equinox) = 3; % Winter
end

%% Growing season indicator (maybe??)

clear Indicator_seasongrowth
clc

% Define depths and frost point
depths = {'T0','T_07', 'T_12'};
frostPoint = 0;

% Extract unique years from the data
yrz = unique(data.Date.Year);

% Initialize the Indicator_seasongrowth table with years
Indicator_seasongrowth = table(yrz, 'VariableNames', {'Years'});

% Loop through each depth and year
% Preallocate columns for growing season start, end, and length
startCol = 'Start_Tair';
endCol = 'End_Tair';
lengthCol = 'Length_Tair';

Indicator_seasongrowth.(startCol) = NaT(length(yrz), 1); % Preallocate start date column
Indicator_seasongrowth.(endCol) = NaT(length(yrz), 1);   % Preallocate end date column
Indicator_seasongrowth.(lengthCol) = NaN(length(yrz), 1); % Preallocate growing season length column

for j = 1:length(yrz)
    % Extract data for the current year
    data_year = data(data.Date.Year == yrz(j), :);
    
    % Determine the seasons for the current year
    seasons = get_astronomical_season(data_year.Date);
    
    % Identify indices for spring and fall based on the seasons function
    springIndices = find(seasons == 0); % Spring is coded as 0
    fallIndices = find(seasons == 2);   % Fall is coded as 2
    
    % Find the actual dates of frost days within spring and fall
    springFrostDates = data_year.Date(springIndices(data_year.Tair(springIndices) <= frostPoint));
    fallFrostDates = data_year.Date(fallIndices(data_year.Tair(fallIndices) <= frostPoint));
    
    % Identify the last frost day in spring and the first frost day in fall
    if ~isempty(springFrostDates)
        lastFrostOfSpring = max(springFrostDates);
    else
        lastFrostOfSpring = NaT; % Handle case where no frost is found in spring
    end
    
    if ~isempty(fallFrostDates)
        firstFrostOfFall = min(fallFrostDates);
    else
        firstFrostOfFall = NaT; % Handle case where no frost is found in fall
    end
    
    % Compute the growing season
    if ~isnat(lastFrostOfSpring) && ~isnat(firstFrostOfFall)
        Indicator_seasongrowth.(startCol)(j) = lastFrostOfSpring + 1;
        Indicator_seasongrowth.(endCol)(j) = firstFrostOfFall - 1;
        Indicator_seasongrowth.(lengthCol)(j) = days(Indicator_seasongrowth.(endCol)(j) - Indicator_seasongrowth.(startCol)(j)) + 1; % Inclusive counting
    end
end
Indicator_seasongrowth = rmmissing(Indicator_seasongrowth);

