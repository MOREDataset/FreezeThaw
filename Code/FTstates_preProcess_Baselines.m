%% preprocess and export data to csv for python model learning & baselines 
% Deadhorse
clc
clear 
filename = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures\Air2UG_alltimeseries_Deadhorse_MERRA2data.csv';
data = readtable(filename);

[data.Y,data.M,data.D] = get_YMD(data.Date);
data.W = isweekend(data.Date); %weekdays
minTS = min(data.Date,[],'all');
maxTS = max(data.Date,[],'all');
hldy_list = holidays(minTS,maxTS);
[data.H,~] = ismember(data.Date,hldy_list);    %holidays    
data.S = get_astronomical_season(data.Date); %Season    
% eval(sprintf('writetable(data,''%s'');','C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\FTstatesDataset_Deadhorse_0Days.csv'))

% % Toolik lake
% 
% clc
% clear 
% filename = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures\Air2UG_alltimeseries_Toolik_MERRA2data.csv';
% data = readtable(filename);
% 
% [data.Y,data.M,data.D] = get_YMD(data.Date);
% data.W = isweekend(data.Date); %weekdays
% minTS = min(data.Date,[],'all');
% maxTS = max(data.Date,[],'all');
% hldy_list = holidays(minTS,maxTS);
% [data.H,~] = ismember(data.Date,hldy_list);    %holidays    
% data.S = get_astronomical_season(data.Date); %Season    
% eval(sprintf('writetable(data,''%s'');',strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\FTstatesDataset_Toolik_0Days.csv')))


%% Naive Season-based Baseline - Toolik
clear
clc

target = {'T0', 'T8', 'T16'};
loc = {'Toolik'}; L = 1;
fprintf('Season-based naive baseline\n%s; Trgt; Hrz; wAccuracy; f1w; FAR\n', loc{L});

for K = 1:length(target)
    fprintf('%s; %s;', loc{L}, target{K}) 
    for i = [0, 7, 30, 90]
        % Load training and test datasets
        trainPath = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw', ...
                             ['FTstates_' loc{L} '_' target{K} '_Trainset_' num2str(i) 'Days.csv']);
        testPath = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw', ...
                            ['FTstates_' loc{L} '_' target{K} '_Testset_' num2str(i) 'Days.csv']);
        opts = detectImportOptions(trainPath);
        trainset = readtable(trainPath, opts);
        opts = detectImportOptions(testPath);
        testset = readtable(testPath, opts);

        % Modify target column name if future horizon
        targetCol = target{K};
        if i ~= 0
            targetCol = [targetCol '_plus' num2str(i)];
        end
        
        % Find most frequent value for each season
        FT_NaiveSeason = zeros(1, 4); % Array to hold season predictions
        for j = 0:3 % Seasons
            seasonIdx = trainset.S == j; % Logical index for season j
            FT_NaiveSeason(j + 1) = mode(trainset.(targetCol)(seasonIdx));
        end

        % Define targets and predictions
        y_train = trainset.(targetCol);
        y_test = testset.(targetCol);

        y_preds = zeros(size(y_test));
        seasons = get_astronomical_season(datetime(testset.Y, testset.M, testset.D) + days(i));
        for j = 0:3
            seasonRows = seasons == j; % Logical index for season j
            y_preds(seasonRows) = FT_NaiveSeason(j + 1); % Set prediction to the mode of the season
        end

        % Compute performance
        [C, ~] = confusionmat(y_test, y_preds);
        TP = C(1,1);
        TN = C(2,2);
        FP = C(2,1);
        FN = C(1,2);

        % Calculate metrics
        accuracy = (TP / (TP + FN) + TN / (TN + FP)) / 2;
        FAR = FP / (FP + TN);

        % Compute weighted F1 score
        % Positive class metrics
        precisionPos = TP / (TP + FP);
        recallPos = TP / (TP + FN);
        f1Pos = 2 * (precisionPos * recallPos) / (precisionPos + recallPos);

        % Negative class metrics
        precisionNeg = TN / (TN + FN);
        recallNeg = TN / (TN + FP);
        f1Neg = 2 * (precisionNeg * recallNeg) / (precisionNeg + recallNeg);

        % Support for weighted F1
        supportPos = sum(y_test == 1);
        supportNeg = sum(y_test == 0);
        totalSupport = supportPos + supportNeg;

        % Weighted F1
        f1 = (f1Pos * supportPos + f1Neg * supportNeg) / totalSupport;

        % Display results
        fprintf('%.3f%%; %.3f%%;', accuracy * 100,FAR * 100);
    end
    fprintf('\n')
end


%% Naive Season-based Baseline - Deadhorse
clear
clc

loc = {'Deadhorse'}; L = 1;
target = {'T0', 'T_07', 'T_12'};
fprintf('Season-based naive baseline\n%s,Hrz;wAccuracy;f1w;FAR\n',loc{L});
for K = 1:length(target)
    fprintf('%s; %s;', loc{L}, target{K}) 
    for i = [0, 7, 30, 90]
        % Load training and test datasets
        trainPath = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw', ...
                             ['FTstates_' loc{L} '_' target{K} '_Trainset_' num2str(i) 'Days.csv']);
        testPath = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw', ...
                            ['FTstates_' loc{L} '_' target{K} '_Testset_' num2str(i) 'Days.csv']);
        opts = detectImportOptions(trainPath);
        trainset = readtable(trainPath, opts);
        opts = detectImportOptions(testPath);
        testset = readtable(testPath, opts);

        % Modify target column name if future horizon
        targetCol = target{K};
        if i ~= 0
            targetCol = [targetCol '_plus' num2str(i)];
        end
        
        % Find most frequent value for each season
        FT_NaiveSeason = zeros(1, 4); % Array to hold season predictions
        for j = 0:3 % Seasons
            seasonIdx = trainset.S == j; % Logical index for season j
            FT_NaiveSeason(j + 1) = mode(trainset.(targetCol)(seasonIdx));
        end

        % Define targets and predictions
        y_train = trainset.(targetCol);
        y_test = testset.(targetCol);

        y_preds = zeros(size(y_test));
        seasons = get_astronomical_season(datetime(testset.Y, testset.M, testset.D) + days(i));
        for j = 0:3
            seasonRows = seasons == j; % Logical index for season j
            y_preds(seasonRows) = FT_NaiveSeason(j + 1); % Set prediction to the mode of the season
        end

        % Compute performance
        [C, ~] = confusionmat(y_test, y_preds);
        TP = C(1,1);
        TN = C(2,2);
        FP = C(2,1);
        FN = C(1,2);

        % Calculate metrics
        accuracy = (TP / (TP + FN) + TN / (TN + FP)) / 2;
        FAR = FP / (FP + TN);

        % Compute weighted F1 score
        % Positive class metrics
        precisionPos = TP / (TP + FP);
        recallPos = TP / (TP + FN);
        f1Pos = 2 * (precisionPos * recallPos) / (precisionPos + recallPos);

        % Negative class metrics
        precisionNeg = TN / (TN + FN);
        recallNeg = TN / (TN + FP);
        f1Neg = 2 * (precisionNeg * recallNeg) / (precisionNeg + recallNeg);

        % Support for weighted F1
        supportPos = sum(y_test == 1);
        supportNeg = sum(y_test == 0);
        totalSupport = supportPos + supportNeg;

        % Weighted F1
        f1 = (f1Pos * supportPos + f1Neg * supportNeg) / totalSupport;

        % Display results
        fprintf('%.3f%%; %.3f%%;', accuracy * 100, FAR * 100);
    end
    fprintf('\n')
end



%% Preprocess and select less problematic depths
% Depths
depthLabels = string(data.Properties.VariableNames(3:12));

% Number of depths
numDepths = size(data(:,3:12), 2);

% Initialize an array to store the number of outliers for each depth
outlierCounts = zeros(1, numDepths);

% Define a threshold for outlier detection using the IQR method
outlierThreshold = 1.5; % 1.5 times the IQR

% Loop through each depth to detect outliers
for i = 1:numDepths
    % Extract the time series for the current depth
    timeSeries = data{:, i+2};
    
    % Compute the quartiles and IQR
    Q1 = prctile(timeSeries, 25);
    Q3 = prctile(timeSeries, 75);
    IQR = Q3 - Q1;
    
    % Define outlier thresholds
    lowerBound = Q1 - outlierThreshold * IQR;
    upperBound = Q3 + outlierThreshold * IQR;
    
    % Identify outliers
    outliers = (timeSeries < lowerBound) | (timeSeries > upperBound);
    
    % Count the number of outliers
    outlierCounts(i) = sum(outliers);
end

% Display the results72
for i = 1:numDepths
    fprintf('Depth: %s cm, Outliers: %d\n', depthLabels(i), outlierCounts(i));
end

% Optional: Select the depths with the fewest outliers
% Define a threshold or select based on minimum outlier count
threshold = median(outlierCounts);
selectedDepths = depthLabels(outlierCounts <= threshold);

% Display selected depths
disp('Selected Depths (with fewer outliers):');
disp(selectedDepths);


%% plot results



%% functions
function [Y,M,D] = get_YMD(x)
    [Y,M,D] = ymd(x);
end

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
