%% Generate FTstates datasets - Toolik Lake
clear
clc
loc = {'Toolik'}; L = 1;
target = {'T0', 'T8', 'T16'};

for K = 1:length(target)
    % Load training data
    trainPath = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw', ...
                         ['FTstates_' loc{L} '_' target{K} '_Trainset_0Days.csv']);
    opts = detectImportOptions(trainPath);
    train = readtable(trainPath, opts);

    % Load test data
    testPath = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw', ...
                        ['FTstates_' loc{L} '_' target{K} '_Testset_0Days.csv']);
    opts = detectImportOptions(testPath);
    test = readtable(testPath, opts);

    % Combine training and test datasets
    combinedData = [train; test];

    % Combine Y, M, D into datetime
    combinedData.Date = datetime(combinedData.Y, combinedData.M, combinedData.D);

    % Add future targets
    combinedData = addFutureTargets(combinedData, target{K});

    % Get and save horizon-specific datasets
    saveHorizonData(combinedData, loc{L}, target{K});
end

%% Generate FTstates datasets - Deadhorse
clear
clc
loc = {'Deadhorse'}; L = 1;
target = {'T0', 'T_07', 'T_12'};

for K = 1:length(target)
    % Load training data
    trainPath = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw', ...
                         ['FTstates_' loc{L} '_' target{K} '_Trainset_0Days.csv']);
    opts = detectImportOptions(trainPath);
    train = readtable(trainPath, opts);

    % Load test data
    testPath = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw', ...
                        ['FTstates_' loc{L} '_' target{K} '_Testset_0Days.csv']);
    opts = detectImportOptions(testPath);
    test = readtable(testPath, opts);

    % Combine training and test datasets
    combinedData = [train; test];

    % Combine Y, M, D into datetime
    combinedData.Date = datetime(combinedData.Y, combinedData.M, combinedData.D);

    % Add future targets
    combinedData = addFutureTargets(combinedData, target{K});

    % Get and save horizon-specific datasets
    saveHorizonData(combinedData, loc{L}, target{K});
end

%% Functions

% Function to add future targets
function data = addFutureTargets(data, targetName)
    horizons = [7, 30, 90];  % Future horizons
    for h = horizons
        colName = [targetName '_plus', num2str(h)];  % Create column name
        data.(colName) = NaN(height(data), 1);  % Initialize
        for i = 1:height(data)
            futureIdx = find(data.Date == data.Date(i) + days(h), 1);
            if ~isempty(futureIdx)
                data.(colName)(i) = data.(targetName)(futureIdx);  % Use targetName dynamically
            end
        end
    end
end

% Function to save horizon-specific datasets
function saveHorizonData(data, loc, targetName)
    horizons = [0, 7, 30, 90];  % Include 0 for same-day prediction
    
    % List of input features that must be included in each dataset
    inputFeatures = {'Y', 'M', 'D', 'W', 'H', 'S', 'SNODP', 'SWGDN', 'LWGAB', 'T2M', 'SWLAND', 'GHTSKIN', ...
                     'HFLUX', 'SPEED', 'TLML', 'TSH', 'EVPSOIL', 'LWLAND', 'TS', 'QV2M', 'SLP'};
    
    for h = horizons
        if h == 0
            targetCol = targetName;  % Horizon 0 uses the original target
            horizonSuffix = '0Days';
        else
            targetCol = [targetName '_plus', num2str(h)];
            horizonSuffix = [num2str(h), 'Days'];
        end
        
        % Remove rows where the target column is NaN
        subset = data(~isnan(data.(targetCol)), :);
        
        % Ensure only the specified input features and the current target column are included
        validFeatures = [inputFeatures, targetCol];  % Combine input features with the specific target column
        subset = subset(:, validFeatures);  % Select only the columns listed in validFeatures
        
        % Rename the target column back to its original name
        subset.Properties.VariableNames{end} = targetName;
        
        % Save the dataset with the appropriate filename
        filename = sprintf('FTstatesDataset_%s_%s_%s.csv', loc, targetName, horizonSuffix);
        writetable(subset, filename);
    end
end
