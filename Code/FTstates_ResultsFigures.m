%% miniplots for the framework figure
plot(data.T8)
close('all')
clc
clear 
size1 = 40;
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures'))
path_directory = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures';
%%%%*** daily data
file_name = 'NRCS_Toolik.xlsx';
opts = spreadsheetImportOptions("NumVariables", 13);
% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A3:M8143";
% Specify column names and types
opts.VariableNames = ["Date", "Tair", "T0", "T8", "T16", "T23", "T31", "T38", "T46", "T61", "T76", "T97", "PCPT"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Import the data
data = readtable([path_directory '\' file_name], opts, "UseExcel", false);
data = removevars(data, ["PCPT","T38","T23","T31","T46","T61","T76", "T97"]);
data = table2timetable(data);

start_ind = datetime('17-Sep-1998','Format','dd-MMM-uuuu');
end_ind = datetime('17-Sep-1999','Format','dd-MMM-uuuu');
S = timerange(start_ind,end_ind,'closed');
data = data(S,:);

% 
figure('units','normalized','OuterPosition',[0 0 1 1]);
t = tiledlayout('flow', 'TileSpacing', 'tight', 'Padding', 'tight');
nexttile
plot(data.Date, data.T8, '-o', 'Color','#298BC3', 'LineWidth',1.5, 'MarkerFaceColor','w','MarkerSize',3)
% xlabel(t, 'Date (in days)', 'FontSize', 40, 'interpreter','latex');
ylabel(t, 'Soil temperature at Depth = 8 cm', 'FontSize', 40, 'interpreter','latex');
set(gca,'Box','on', 'FontSize',40, 'TickLabelInterpreter', 'latex');
yline(0, ':','0$^{\circ}$C Threshold',Interpreter='latex', LabelHorizontalAlignment='center', LabelVerticalAlignment='middle', FontSize=30, Color='#EDB120', LineWidth=2);
exportgraphics(t,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\FT_framework_threshold.pdf'),'Resolution',300)


%
figure('units','normalized','OuterPosition',[0 0 1 1]);
t = tiledlayout('flow', 'TileSpacing', 'tight', 'Padding', 'tight');
nexttile, hold on

b = bar([0,7,30,90], [.5, .5, -.5, .5],'BarWidth', .9,'EdgeColor','none','FaceColor','flat');
b.CData(1,:) = [247 174 48]./255;
b.CData(3,:) = [41 139 195]./255;
b.CData(2,:) = [247 174 48]./255;
b.CData(4,:) = [247 174 48]./255;

set(gca, 'Box', 'on', 'FontSize', 40, 'TickLabelInterpreter', 'latex', ...
'YMinorGrid', 'off', 'YMinorTick', 'off', 'TickDir', 'none', 'XGrid', 'on','YGrid','on',...
'XTick', [0 7 30 90], 'xticklabels', {'+0 days', '+7 days', '+30 days', '+90 days'},'XTickLabelRotation',90, 'YTick', [-0.5 0.5], 'yticklabels', {'Freezing state', 'Thawing state'});
ylim([-0.6,.6])
hold on
plot([0,7,30,90], [.5, .5, -.5, .5], 'k--o','LineWidth',1, 'MarkerFaceColor','auto')
exportgraphics(t,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\FT_framework_prdhrz.pdf'),'Resolution',300)

%% * Density Distributions
%TOOLIK LAKE
close('all')
clc
clear 
size1 = 40;
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures'))
path_directory = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures';
%%%%*** daily data
file_name = 'NRCS_Toolik.xlsx';
opts = spreadsheetImportOptions("NumVariables", 13);
% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A3:M8143";
% Specify column names and types
opts.VariableNames = ["Date", "Tair", "T0", "T8", "T16", "T23", "T31", "T38", "T46", "T61", "T76", "T97", "PCPT"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Import the data
data = readtable([path_directory '\' file_name], opts, "UseExcel", false);
data = removevars(data, ["PCPT","T38","T23","T31","T46","T61","T76", "T97"]);
data = table2timetable(data);

start_ind = datetime('17-Sep-1998','Format','dd-MMM-uuuu');
end_ind = datetime('25-Aug-2016','Format','dd-MMM-uuuu');
S = timerange(start_ind,end_ind,'closed');
data = data(S,:);

figure('units','normalized','OuterPosition',[0 0 1 1]);
t = tiledlayout(4,2,'TileSpacing','compact','Padding','tight');

depths = {'Tair', 'T0', 'T8', 'T16'};
jj = 1;
for j = 1:length(depths)
    nexttile(jj),
    hold on
    % Calculate Density distribution for each class
    xRange = linspace(min(data.(depths{j})), max(data.(depths{j})), 1000);
    %class 0
    [f0, xi] = ksdensity(data.(depths{j})(data.(depths{j})<=0),xRange); % Estimate the density
    normalized_f0 = f0 / trapz(xi, f0);
    area(xi, normalized_f0, 'DisplayName','Freezing', FaceAlpha = 0.8, EdgeColor = 'none', FaceColor=[0    0.4470    0.7410]); % Plot the density
    %class 1
    [f1, xi] = ksdensity(data.(depths{j})(data.(depths{j})>0),xRange); % Estimate the density
    normalized_f1 = f1 / trapz(xi, f1);
    area(xi, normalized_f1, 'DisplayName','Thawing', FaceAlpha = 0.8, EdgeColor = 'none', FaceColor=[0.9290    0.6940    0.1250]); % Plot the density
    set(gca,'Box','on');    

    % Calculate Skewness for each class
    skewnessClass0 = skewness(data.(depths{j})(data.(depths{j})<=0));
    skewnessClass1 = skewness(data.(depths{j})(data.(depths{j})>0));
    skwDiff(j) = abs(skewnessClass1-skewnessClass0);

    if j == 1
        title(strcat({'Height = 1.5 m ($\Delta \alpha_3$ = '},num2str(round(abs(skwDiff(j)),2)), ')'),'Interpreter','latex');
        % legend1 = legend(gca,'show','Location','northeastoutside');
        % set(legend1,'Orientation','vertical','Interpreter','latex','FontSize',size1-10);
    else
        title(strcat({'Depth = '},strrep(strrep(depths{j},'T',''),'_','\_'),{' cm ($\Delta \alpha_3$ = '},num2str(round(abs(skwDiff(j)),2)), ')'),'Interpreter','latex');
    end        
    jj = jj + 2; 
    if j~=4
        set(gca, 'Box', 'on', 'xticklabels',[], 'FontSize', size1-15, 'TickLabelInterpreter', 'latex', ...
            'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on', 'ylim', [0 0.22], 'xlim', [-40 30]);
    else
        set(gca, 'Box', 'on', 'FontSize', size1-15, 'TickLabelInterpreter', 'latex', ...
            'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on', 'ylim', [0 0.22], 'xlim', [-40 30]);        
    end    
end
ylabel(t, 'Probability Density (1/$^{\circ}$C)', 'FontSize', size1-10, 'interpreter', 'latex');
xlabel(gca, 'Temperatures at Toolik Lake ($^{\circ}C$)', 'FontSize', size1-10, 'interpreter', 'latex');
% exportgraphics(gcf, ['C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\','FT_DensityDistribution_Toolik.pdf'],'Resolution',300)

% Deadhorse
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures'))
path_directory = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures\data\Deadhorse';
% Import the TXT data
original_files = dir([path_directory '\*.txt']);
strtime = {'MM/dd/yy','dd/MM/yyyy','MM/dd/yy'};
for k=1:length(original_files)
    filename=[path_directory '\' original_files(k).name];
    opts = delimitedTextImportOptions("NumVariables", 12);
    % Specify range and delimiter
    opts.DataLines = [1, Inf];
    opts.Delimiter = "\t";
    % Specify column names and types
    opts.VariableNames = ["Date", "Air", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12"];
    opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts = setvaropts(opts, "Date", "InputFormat", strtime{k});
    temp = readtimetable(filename, opts);
    temp.Date.Format = 'yyyy-MM-dd';
    temp.Properties.VariableNames = {'Tair','T0','T_02','T_07','T_12','T_22','T_32','T_42','T_62','T_67','T_72'};
    temp = rmmissing(temp,"MinNumMissing",6);
    eval(sprintf('data%d = temp(2:end,:);',k));
end

% Import data from the XLS file 
original_files = dir([path_directory '/*.xls']);
opts = spreadsheetImportOptions("NumVariables", 12);
% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:L5379";
% Specify column names and types
opts.VariableNames = ["Date", "AirTemp", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Import the data
temp = readtimetable(strcat(path_directory,'\',original_files(1).name), opts, 'UseExcel', false);
temp.Date.Format = 'yyyy-MM-dd';
temp.Properties.VariableNames = {'Tair','T0','T_02','T_07','T_12','T_22','T_32','T_42','T_62','T_67','T_72'};
eval(sprintf('data%d = rmmissing(temp,''MinNumMissing'',6);',k+1))
data = [data1;data2;data3;data4];
data = sortrows(data,"Date","ascend");
data = unique(data);
% data = table(year(data.Date), month(data.Date), day(data.Date), data.Tair, data.T0, data.T_02, data.T_07, data.T_12, data.T_22, data.T_32, data.T_42, data.T_62, data.T_67, data.T_72);
% data.Properties.VariableNames = {'Year','Month','Day','Tair','T0','T_02','T_07','T_12','T_22','T_32','T_42','T_62','T_67','T_72'};
% tf = isregular(data);
data = retime(data,"regular","linear","TimeStep",caldays(1));
data = data(:,[1 2 4 5]);

start_ind = datetime('5-Oct-1986','Format','dd-MMM-uuuu');
end_ind = datetime('30-May-2000','Format','dd-MMM-uuuu');
S = timerange(start_ind,end_ind,'closed');
data = data(S,:);

% figure('units','normalized','OuterPosition',[0 0 1 1]);
% t = tiledlayout(4,2,'TileSpacing','tight','Padding','tight');

depths = {'Tair', 'T0', 'T_07', 'T_12'};
jj = 2;
for j = 1:length(depths)
    nexttile(jj),
    hold on
    % Calculate Density distribution for each class
    xRange = linspace(min(data.(depths{j})), max(data.(depths{j})), 1000);
    %class 0
    [f0, xi] = ksdensity(data.(depths{j})(data.(depths{j})<=0),xRange); % Estimate the density
    normalized_f0 = f0 / trapz(xi, f0);
    area(xi, normalized_f0, 'DisplayName','Freezing', FaceAlpha = 0.8, EdgeColor = 'none', FaceColor=[0    0.4470    0.7410]); % Plot the density
    %class 1
    [f1, xi] = ksdensity(data.(depths{j})(data.(depths{j})>0),xRange); % Estimate the density
    normalized_f1 = f1 / trapz(xi, f1);
    area(xi, normalized_f1, 'DisplayName','Thawing', FaceAlpha = 0.8, EdgeColor = 'none', FaceColor=[0.9290    0.6940    0.1250]); % Plot the density
    set(gca,'Box','on');    

    % Calculate Skewness for each class
    skewnessClass0 = skewness(data.(depths{j})(data.(depths{j})<=0));
    skewnessClass1 = skewness(data.(depths{j})(data.(depths{j})>0));
    skwDiff(j) = abs(skewnessClass1-skewnessClass0);

    if j == 1
        title(strcat({'Height = 1.5 m ($\Delta \alpha_3$ = '},num2str(round(abs(skwDiff(j)),2)), ')'),'Interpreter','latex');
    else
        title(strcat({'Depth = '},strrep(strrep(strrep(depths{j},'T',''),'_0',''),'_',''),{' cm ($\Delta \alpha_3$ = '},num2str(round(abs(skwDiff(j)),2)), ')'),'Interpreter','latex');
    end        
    jj = jj + 2; 
    if j~=4
        set(gca, 'Box', 'on', 'xticklabels',[],'yticklabels',[], 'FontSize', size1-15, 'TickLabelInterpreter', 'latex', ...
            'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on', 'ylim', [0 0.22], 'xlim', [-40 30]);
    else
        set(gca, 'Box', 'on','yticklabels',[], 'FontSize', size1-15, 'TickLabelInterpreter', 'latex', ...
            'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on', 'ylim', [0 0.22], 'xlim', [-40 30]);        
    end
end

ylabel(t, 'Probability Density (1/$^{\circ}$C)', 'FontSize', size1-10, 'interpreter', 'latex');
xlabel(gca, 'Temperatures at Deadhorse ($^{\circ}C$)', 'FontSize', size1-10, 'interpreter', 'latex');
legend1 = legend(gca,'show','Location','northeastoutside');
set(legend1,'Orientation','horizontal','Interpreter','latex','FontSize',size1-10);
legend1.Layout.Tile = 'North'; % <-- place legend east of tiles

exportgraphics(gcf, ['C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\','FT_DensityDistributions.pdf'],'Resolution',300)

%% * Timeseries - Plot (all together)
clc
clear 
size1 = 25;
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures'))
path_directory = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures';
%%%%*** daily data
file_name = 'NRCS_Toolik.xlsx';
opts = spreadsheetImportOptions("NumVariables", 13);
% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A3:M8143";
% Specify column names and types
opts.VariableNames = ["Date", "Tair", "T0", "T8", "T16", "T23", "T31", "T38", "T46", "T61", "T76", "T97", "PCPT"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Import the data
data = readtable([path_directory '\' file_name], opts, "UseExcel", false);
data = removevars(data, ["PCPT","Tair","T38","T23","T31","T46","T61","T76", "T97"]);
data = table2timetable(data);

start_ind = datetime('17-Sep-1998','Format','dd-MMM-uuuu');
end_ind = datetime('25-Aug-2016','Format','dd-MMM-uuuu');
S = timerange(start_ind,end_ind,'closed');
data = data(S,:);
min_tmp = min(data,[],"all");
max_tmp = max(data,[],"all");

cmap = get(0, 'defaultaxescolororder');


figure('units','normalized','OuterPosition',[0 0 1 1]);
% Create a tiled layout with 3 tiles (one for each depth)
t = tiledlayout(3, 2, 'TileSpacing', 'compact', 'Padding', 'tight');

nexttile(1),
ind1 = find(data.T0<0);
ind2 = find(data.T0>=0);
scatter(data.Date(ind1),data.T0(ind1),12,cmap(1,:))
hold on,
scatter(data.Date(ind2),data.T0(ind2),12,cmap(2,:), "filled", "o", "MarkerFaceColor", "#EDB120")

set(gca, 'Box', 'on', 'XTick',[], 'FontSize', size1, 'TickLabelInterpreter', 'latex', ...
'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on', 'ylim', [min_tmp.min max_tmp.max]);
% Set title for each subplot
title('Depth = 0 cm', "Interpreter","latex");%,'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
% ax = gca;
% ax.TitleHorizontalAlignment = 'left';
% ax.Title.VerticalAlignment = 'bottom';

   

nexttile(3),
ind1 = find(data.T8<0);
ind2 = find(data.T8>=0);
scatter(data.Date(ind1),data.T8(ind1),12,cmap(1,:))
hold on,
scatter(data.Date(ind2),data.T8(ind2),12,cmap(2,:), "filled", "o", "MarkerFaceColor", "#EDB120")
set(gca, 'Box', 'on', 'XTick',[], 'FontSize', size1, 'TickLabelInterpreter', 'latex', ...
'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on', 'ylim', [min_tmp.min max_tmp.max]);
% Set title for each subplot
title('Depth = 8 cm', "Interpreter","latex");%,'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
% ax = gca;
% ax.TitleHorizontalAlignment = 'left';
% ax.Title.VerticalAlignment = 'bottom';


nexttile(5),
ind1 = find(data.T16<0);
ind2 = find(data.T16>=0);
scatter(data.Date(ind1),data.T16(ind1),12,cmap(1,:))
hold on,
scatter(data.Date(ind2),data.T16(ind2),12,cmap(2,:), "filled", "o", "MarkerFaceColor", "#EDB120")
set(gca, 'Box', 'on',  'FontSize', size1, 'TickLabelInterpreter', 'latex', ...
'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on', 'ylim', [min_tmp.min max_tmp.max]);
% Set title for each subplot
title('Depth = 16 cm', "Interpreter","latex");%,'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
% ax = gca;
% ax.TitleHorizontalAlignment = 'left';
% ax.Title.VerticalAlignment = 'bottom';

ylabel(t, 'Soil temperature $(^{\circ}C)$','interpreter','latex','FontSize',size1+5);
xlabel(gca, 'Toolik Lake','interpreter','latex','FontSize',size1+5)
% %Export
% exportgraphics(t,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\FT_Temp_Toolik.pdf'),'ContentType','vector')
% fprintf('Finito!\n')
% exportgraphics(t,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\FT_Temp_Toolik.pdf'),'ContentType','vector')
% close(gcf)


%%timeseries - Deadhorse
clearvars -except min_tmp max_tmp t     %deletes all variables except X in workspace
size1 = 25;
addpath(genpath('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures'))
path_directory = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\AirAndActiveLayerTemperatures\data\Deadhorse';
% Import the TXT data
original_files = dir([path_directory '\*.txt']);
strtime = {'MM/dd/yy','dd/MM/yyyy','MM/dd/yy'};
for k=1:length(original_files)
    filename=[path_directory '\' original_files(k).name];
    opts = delimitedTextImportOptions("NumVariables", 12);
    % Specify range and delimiter
    opts.DataLines = [1, Inf];
    opts.Delimiter = "\t";
    % Specify column names and types
    opts.VariableNames = ["Date", "Air", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12"];
    opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts = setvaropts(opts, "Date", "InputFormat", strtime{k});
    temp = readtimetable(filename, opts);
    temp.Date.Format = 'yyyy-MM-dd';
    temp.Properties.VariableNames = {'Tair','T0','T_02','T_07','T_12','T_22','T_32','T_42','T_62','T_67','T_72'};
    temp = rmmissing(temp,"MinNumMissing",6);
    eval(sprintf('data%d = temp(2:end,:);',k));
end

% Import data from the XLS file 
original_files = dir([path_directory '/*.xls']);
opts = spreadsheetImportOptions("NumVariables", 12);
% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:L5379";
% Specify column names and types
opts.VariableNames = ["Date", "AirTemp", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
% Import the data
temp = readtimetable(strcat(path_directory,'\',original_files(1).name), opts, 'UseExcel', false);
temp.Date.Format = 'yyyy-MM-dd';
temp.Properties.VariableNames = {'Tair','T0','T_02','T_07','T_12','T_22','T_32','T_42','T_62','T_67','T_72'};
eval(sprintf('data%d = rmmissing(temp,''MinNumMissing'',6);',k+1))
data = [data1;data2;data3;data4];
data = sortrows(data,"Date","ascend");
data = unique(data);
% data = table(year(data.Date), month(data.Date), day(data.Date), data.Tair, data.T0, data.T_02, data.T_07, data.T_12, data.T_22, data.T_32, data.T_42, data.T_62, data.T_67, data.T_72);
% data.Properties.VariableNames = {'Year','Month','Day','Tair','T0','T_02','T_07','T_12','T_22','T_32','T_42','T_62','T_67','T_72'};
% tf = isregular(data);
data = retime(data,"regular","linear","TimeStep",caldays(1));
data = data(:,[2 4 5]);

start_ind = datetime('5-Oct-1986','Format','dd-MMM-uuuu');
end_ind = datetime('30-May-2000','Format','dd-MMM-uuuu');
S = timerange(start_ind,end_ind,'closed');
data = data(S,:);

min_tmp = min(min_tmp.min,min(data,[],"all"));
max_tmp = max(max_tmp.max,max(data.T0));

cmap = get(0, 'defaultaxescolororder');

% figure('units','normalized','OuterPosition',[0 0 1 1]);
% t = tiledlayout(3,1,'TileSpacing','tight','Padding','tight');

nexttile(2),
ind1 = find(data.T0<0);
ind2 = find(data.T0>=0);
scatter(data.Date(ind1),data.T0(ind1),12,cmap(1,:))
hold on,
scatter(data.Date(ind2),data.T0(ind2),12,cmap(2,:), "filled", "o", "MarkerFaceColor", "#EDB120")
set(gca, 'Box', 'on', 'XTick',[], 'yticklabels', [], 'FontSize', size1, 'TickLabelInterpreter', 'latex', ...
'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on', 'ylim', [min_tmp.min max_tmp]);
% Set title for each subplot
tt1 = title('Depth = 0 cm', "Interpreter","latex");%,'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
% ax = gca;
% ax.TitleHorizontalAlignment = 'left';
% ax.Title.VerticalAlignment = 'bottom';

nexttile(4),
ind1 = find(data.T_07<0);
ind2 = find(data.T_07>=0);
scatter(data.Date(ind1),data.T_07(ind1),12,cmap(1,:))
hold on,
scatter(data.Date(ind2),data.T_07(ind2),12,cmap(2,:), "filled", "o", "MarkerFaceColor", "#EDB120")
set(gca, 'Box', 'on', 'XTick',[], 'yticklabels', [], 'FontSize', size1, 'TickLabelInterpreter', 'latex', ...
'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on', 'ylim', [min_tmp.min max_tmp]);
% Set title for each subplot
title('Depth = 7 cm', "Interpreter","latex");%,'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
% ax = gca;
% ax.TitleHorizontalAlignment = 'left';
% ax.Title.VerticalAlignment = 'bottom';

nexttile(6),
ind1 = find(data.T_12<0);
ind2 = find(data.T_12>=0);
scatter(data.Date(ind1),data.T_12(ind1),12,cmap(1,:), 'DisplayName','Freezing')
hold on,
scatter(data.Date(ind2),data.T_12(ind2),12,cmap(2,:), "filled", "o", "MarkerFaceColor", "#EDB120", 'DisplayName','Thawing')
set(gca, 'Box', 'on', 'yticklabels', [], 'FontSize', size1, 'TickLabelInterpreter', 'latex', ...
'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on', 'ylim', [min_tmp.min max_tmp]);
% Set title for each subplot
title('Depth = 12 cm', "Interpreter","latex");%,'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
% ax = gca;
% ax.TitleHorizontalAlignment = 'left';
% ax.Title.VerticalAlignment = 'bottom';

ylabel(t, 'Soil temperature $(^{\circ}C)$','interpreter','latex','FontSize',size1+5);
xlabel(gca, 'Deadhorse','interpreter','latex','FontSize',size1+5)

legend1 = legend(gca,'show','Location','northeastoutside');
set(legend1,'Orientation','horizontal','Interpreter','latex','FontSize',size1+5);
legend1.Layout.Tile = 'North'; % <-- place legend east of tiles

%Export
exportgraphics(t,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\FT_Temperatures.pdf'),'Resolution',300)


%% Permafrost Area Fraction Plot for introduction

clear
clc

size1 = 30;

% Load the NC file
file_path = 'C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month23\\Fire\\Maps\\ESACCI-PERMAFROST-L4-PFR-ERA5_MODISLST_BIASCORRECTED-AREA4_PP-2000-fv04.0.nc';

% Read variables
lat = ncread(file_path, 'lat');
lon = ncread(file_path, 'lon');
% pfr = ncread(file_path, 'PFR');
load('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\Fire\NewWork\V2\results\PFR_all_years.mat') %just load this!
% Remove fill values (assuming 255 is the fill value for missing data)
PFR_all_years(PFR_all_years == 255) = NaN;
% Calculate the modal value for each grid cell
pfr = mean(PFR_all_years, 3);
filtered_pfr = pfr';

% Define the Alaska region
lat_min = 50; lat_max = 72;
lon_min = -170; lon_max = -130;

% Convert longitudes to the range [-180, 180]
lon = mod(lon + 180, 360) - 180;

% Filter the data within the Alaska region
lat_idx = find(lat >= lat_min & lat <= lat_max);
lon_idx = find(lon >= lon_min & lon <= lon_max);

filtered_lat = lat(lat_idx);
filtered_lon = lon(lon_idx);
% filtered_pfr = pfr(lon_idx, lat_idx)';

% Mask out values outside of Alaska
masked_pfr = filtered_pfr;
masked_pfr(masked_pfr == 0) = NaN; % Assuming 0 is the value to mask

% Create a meshgrid for the filtered data
[lon_grid, lat_grid] = meshgrid(filtered_lon, filtered_lat);

lat_grid = lat_grid(:,1:2900); %cheat to remove data outside of alaska
lon_grid = lon_grid(:,1:2900); %cheat to remove data outside of alaska
masked_pfr = masked_pfr(:,1:2900); %cheat to remove data outside of alaska

figure('units','normalized','OuterPosition',[0         0    0.9513    1.0000]);
% Create a geoaxes
gx = geoaxes;
geobasemap(gx, 'grayland'); % You can choose other basemap options like 'streets', 'topographic', etc.

% Plot the PFR data using geoscatter (point-based) for demonstration
geoscatter(lat_grid(:), lon_grid(:), 5, masked_pfr(:), 'filled');

% Adjust color limits and add colorbar
load('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\Fire\NewWork\V2\results\CustomColormap_ice2.mat');
colormap(CustomColormap_ice2);

c = colorbar;
c.Label.String = "Permafrost Area Fraction";
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
c.FontSize = size1-10;

% Adjust the axis limits to zoom in on the North Slope region
lat_min = 62; lat_max = 71.5; % North Slope latitudes
lon_min = -169; lon_max = -140; % North Slope longitudes
geolimits([lat_min lat_max], [lon_min lon_max]); % Use geolimits to set latitude and longitude bounds

hold on
%%% ************************ Run this separately so the x axis is correct
% Coordinates for Deadhorse and Toolik Lake
deadhorse_lat = 70.2000;  % Latitude of Deadhorse
deadhorse_lon = -148.4597;  % Longitude of Deadhorse

toolik_lat = 68.6275;  % Latitude of Toolik Lake
toolik_lon = -149.5986;  % Longitude of Toolik Lake

% Highlight Deadhorse on the map
geoscatter(deadhorse_lat, deadhorse_lon, 20, 'r', 'd','filled'); % Red marker for Deadhorse
geoscatter(toolik_lat, toolik_lon, 20, 'r', 'd', 'filled'); % Blue marker for Toolik Lake

c.TickLabels = strcat(c.TickLabels,'$\%$');
% 
gx.LongitudeAxis.FontSize = size1-10;
gx.LongitudeAxis.TickLabelInterpreter = 'latex';
gx.LongitudeAxis.TickLabels = strrep(get(gx.LongitudeAxis,'TickLabels'),'°','$^{\circ}$');
gx.LatitudeAxis.FontSize = size1-10;
gx.LatitudeAxis.TickLabelInterpreter = 'latex';
gx.LatitudeAxis.TickLabels = strrep(get(gx.LatitudeAxis,'TickLabels'),'°','$^{\circ}$');

% Latitude and Longitude coordinates of the James Dalton Highway
shapefile = 'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\tl_2019_02_prisecroads\tl_2019_02_prisecroads.shp';
roads = readgeotable(shapefile);
roads = roads(contains(roads.FULLNAME, 'Dalton'), :);
geoplot(roads.Shape,':', 'LineWidth', 2, 'Color','k');

%%% ************************ manually change the labels to latex formatting
% %exportgraphics(gcf,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\PFR_plot_FTv3_1.pdf'),"Resolution",300)

%% Permafrost Area Fraction Plot for introduction - additional

clear
clc

size1 = 30;

% Load the NC file
file_path = 'C:\\Users\\mohamed.ahajjam\\Desktop\\UND\\Defense resiliency platform\\Month23\\Fire\\Maps\\ESACCI-PERMAFROST-L4-PFR-ERA5_MODISLST_BIASCORRECTED-AREA4_PP-2000-fv04.0.nc';

% Read variables
lat = ncread(file_path, 'lat');
lon = ncread(file_path, 'lon');
% pfr = ncread(file_path, 'PFR');
load('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\Fire\NewWork\V2\results\PFR_all_years.mat') %just load this!
% Remove fill values (assuming 255 is the fill value for missing data)
PFR_all_years(PFR_all_years == 255) = NaN;
% Calculate the modal value for each grid cell
pfr = mean(PFR_all_years, 3);
filtered_pfr = pfr';

% Define the Alaska region
lat_min = 50; lat_max = 72;
lon_min = -170; lon_max = -130;

% Convert longitudes to the range [-180, 180]
lon = mod(lon + 180, 360) - 180;

% Filter the data within the Alaska region
lat_idx = find(lat >= lat_min & lat <= lat_max);
lon_idx = find(lon >= lon_min & lon <= lon_max);

filtered_lat = lat(lat_idx);
filtered_lon = lon(lon_idx);
% filtered_pfr = pfr(lon_idx, lat_idx)';

% Mask out values outside of Alaska
masked_pfr = filtered_pfr;
masked_pfr(masked_pfr == 0) = NaN; % Assuming 0 is the value to mask

% Create a meshgrid for the filtered data
[lon_grid, lat_grid] = meshgrid(filtered_lon, filtered_lat);

lat_grid = lat_grid(:,1:2900); %cheat to remove data outside of alaska
lon_grid = lon_grid(:,1:2900); %cheat to remove data outside of alaska
masked_pfr = masked_pfr(:,1:2900); %cheat to remove data outside of alaska

figure('units','normalized','outerposition',[0 0 1 1]);
% Create a geoaxes
gx = geoaxes;
geobasemap(gx, 'satellite'); % You can choose other basemap options like 'streets', 'topographic', etc.

masked_pfr = ones(size(masked_pfr))*NaN;

% Plot the PFR data using geoscatter (point-based) for demonstration
geoscatter(lat_grid(:), lon_grid(:), 5, masked_pfr(:), 'filled');

% Adjust color limits and add colorbar
load('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\Fire\NewWork\V2\results\CustomColormap_ice2.mat');
colormap(CustomColormap_ice2);

c = colorbar;
c.Label.String = "Permafrost Area Fraction";
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
c.TickLabels = strcat(c.TickLabels,'$\%$');
c.FontSize = size1-10;

gx.LongitudeAxis.FontSize = size1-10;
gx.LongitudeAxis.TickLabelInterpreter = 'latex';
gx.LongitudeAxis.TickLabels = strrep(get(gx.LongitudeAxis,'TickLabels'),'°','$^{\circ}$');
gx.LatitudeAxis.FontSize = size1-10;
gx.LatitudeAxis.TickLabelInterpreter = 'latex';
gx.LatitudeAxis.TickLabels = strrep(get(gx.LatitudeAxis,'TickLabels'),'°','$^{\circ}$');

hold on

% Plot boundaries of Alaska
shapefile = 'usastatelo.shp';
states = readgeotable(shapefile);
alaska = states(strcmp(states.Name, 'Alaska'), :);
h = geoplot(alaska, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.5);

exportgraphics(gcf,strcat('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\PFR_plot_base_FT.eps'),"ContentType","vector")

%% *Deadhorse - main results
clc
clear
% Data for performance (example data)
depths = [12, 7, 0];  % Depths in cm (y-axis)
horizons = [0, 7, 30, 90];  % Prediction horizons (x-axis)

% Example data for Balanced Accuracy (bAcc) for baseline and proposed models
bAcc_baseline = [91.39, 92.70, 93.51, 34.08; 78.62, 78.29, 75.78, 35.52; 89.83, 87.07, 93.03, 38.79];
bAcc_proposed = [98.94, 99.40, 98.67, 97.47; 98.83, 98.05, 99.18, 98.50; 96.85, 96.96, 96.96, 97.61];


% Average performance of conventional ML models (from  12 --> 7 __> 0)
bAcc_convML_RF =  [98.41	98.54	98.35	97.66;	98.06	98.15	98.71	98.18;	96.27	97.13	96.82	97.01];
bAcc_convML_SGD = [50.00	50.00	50.00	49.53;	85.20	88.49	90.39	67.25;	95.29	95.97	91.99	91.35];
bAcc_convML_KNN = [96.55	98.00	97.08	95.28;	96.24	97.62	96.50	96.15;	96.09	95.91	94.56	97.05];
bAcc_convML_SVM = [95.21	94.99	92.73	93.43;	95.41	96.00	93.43	94.86;	95.94	96.48	94.46	95.95];
bAcc_convML_MLP = [95.43	95.47	95.22	93.13;	96.11	97.55	94.96	96.21;	96.03	96.30	96.20	96.91]; % 


figure('units','normalized','OuterPosition',[0 0 1 1]);
% Create a tiled layout with 3 tiles (one for each depth)
t = tiledlayout(3, 2, 'TileSpacing', 'Compact', 'Padding', 'Compact');

j = 1;

% Loop over each depth
for i = length(depths):-1:1
    nexttile(j); % Create the next subplot
    
    hold on;
    
    % Calculate min, max, and average for each horizon across conventional ML models
    bAcc_convML_min = min([bAcc_convML_SGD(i,:);bAcc_convML_KNN(i,:);bAcc_convML_SVM(i,:);bAcc_convML_MLP(i,:)], [],1); % Min values across conventional ML models
    bAcc_convML_max = max([bAcc_convML_SGD(i,:);bAcc_convML_KNN(i,:);bAcc_convML_SVM(i,:);bAcc_convML_MLP(i,:)], [], 1); % Max values across conventional ML models
    bAcc_convML_avg = mean([bAcc_convML_SGD(i,:);bAcc_convML_KNN(i,:);bAcc_convML_SVM(i,:);bAcc_convML_MLP(i,:)], 1); % Average values across conventional ML models

    % Bar plot for proposed technique
    b = bar(1:4, [bAcc_proposed(i, :);bAcc_convML_avg; bAcc_baseline(i, :)],...
        'BarWidth', .9,'EdgeColor','none'); % Proposed
    b(1).FaceColor = [0 0.4470 0.7410];
    b(2).FaceColor = [0.9290 0.6940 0.1250];
    b(3).FaceColor = [0.4660 0.6740 0.1880];  % Color for conventional ML models

    ylim([0 100]);
    yl = get(gca,'ylim');

    % add values over bars 1
    xtips1 = b(1).XEndPoints;
    ytips1 = yl(1)/2 + b(1).YEndPoints/2;
    labels1 = string(b(1).YData);
    text(xtips1,ytips1,strcat(labels1,'\%'),'HorizontalAlignment','center','Rotation',90,...
        'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','w');

    % add values over bars 2
    xtips2 = b(2).XEndPoints;
    ytips2 = yl(1)/2 + b(2).YEndPoints/2;
    labels2 = string(round(b(2).YData,2));
    text(xtips2,ytips2,strcat(labels2,'\%'),'HorizontalAlignment','center','Rotation',90,...
        'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','w');
    
    % add values over bars 3
    xtips3 = b(3).XEndPoints;
    ytips3 = yl(1)/2 + b(3).YEndPoints/2;
    labels3 = string(b(3).YData);
    for ii = 1:length(xtips3)
        if str2num(regexp(labels3(ii),'%','split')) < 40
            text(xtips3(ii),3.3*ytips3(ii),strcat(labels3(ii),'\%'),'HorizontalAlignment','center','Rotation',90,...
                'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','k');
        else
            text(xtips3(ii),ytips3(ii),strcat(labels3(ii),'\%'),'HorizontalAlignment','center','Rotation',90,...
                'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','w');
        end
    end
    

    % Overlay error bars on top of the third bar (conventional ML)
    % Place error bars on the third bar by aligning them with its X coordinates
    x = b(2).XEndPoints;
    errorbar(x, bAcc_convML_avg, bAcc_convML_avg - bAcc_convML_min, bAcc_convML_max - bAcc_convML_avg, ...
        'k', 'LineWidth', 1.2, 'CapSize', 10, 'LineStyle', 'none');
    
    % Set title for each subplot
    title(sprintf('Depth = %d cm', depths(i)), "Interpreter","latex",...
        "Position",[0.976456009913259,102.6699029126214,1.4210854715202e-14],...
        'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
    
    set(gca, 'Box', 'on', 'FontSize', 20, 'TickLabelInterpreter', 'latex', ...
'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'none', 'YGrid', 'on',...
'XTick', [1 2 3 4], 'xticklabels', {'+0 days', '+7 days', '+30 days', '+90 days'});

    
    hold off;
    j = j+2;
    
    if i == 2
        ylabel('Balanced Accuracy (\%)', 'FontSize', 30, 'interpreter', 'latex');
    end
end

% % Add a common legend
% lgd = legend('Proposed technique', 'Baseline model', 'Orientation', 'horizontal', 'Location', 'northoutside');
% lgd.Layout.Tile = 'north'; % Place the legend above the plots
% set(lgd,'Interpreter','latex','FontSize',20);
% 
% % Common X and Y labels for the entire plot
% xlabel(t, 'Prediction Horizon (days)', 'FontSize', 30, 'interpreter', 'latex');

% exportgraphics(t,'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\mainResults_Deadhorse_bAcc.pdf') % Use vector for best quality

% Deadhorse - FAR
clc
% Data for performance (example data)
depths = [12, 7, 0];  % Depths in cm (y-axis)
horizons = [0, 7, 30, 90];  % Prediction horizons (x-axis)

% Example data for False Alarm Rate (FAR) for baseline and proposed models
FAR_baseline = [15.08, 12.70, 11.63, 96.43; 41.62, 43.42, 47.62, 90.36; 18.49, 22.41, 12.50, 89.58];
FAR_proposed = [0.54, 0.40, 0.27, 0.69; 1.30, 0.49, 1.64, 1.17; 1.84, 1.28, 3.00, 2.03];

% Average performance of conventional ML models (from  16 --> 8 __> 0)
FAR_convML_RF =  [0.80	0.54	0.14	1.10;	1.79	0.81	1.80	2.34;	1.98	1.28	3.29	2.91];
FAR_convML_SGD = [0.00	0.00	0.00	4.12;	8.93	5.21	5.08	6.86;	3.26	4.97	6.43	1.89];
FAR_convML_KNN = [0.94	0.81	1.08	1.10;	4.38	1.63	3.61	3.51;	2.69	2.70	4.71	2.47];
FAR_convML_SVM = [4.42	5.23	5.41	4.81;	5.52	4.07	4.75	6.35;	2.97	3.27	4.57	2.62];
FAR_convML_MLP = [1.61	2.68	1.62	3.02;	4.38	2.28	4.59	4.18;	2.12	2.27	4.86	3.78]; % 

% figure('units','normalized','OuterPosition',[0 0 1 1]);
% Create a tiled layout with 3 tiles (one for each depth)
% t = tiledlayout(3, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');

j = 2;
% Loop over each depth
for i = length(depths):-1:1
    nexttile(j); % Create the next subplot
    
    hold on;
    
    % Calculate min, max, and average for each horizon across conventional ML models
    FAR_convML_min = min([FAR_convML_SGD(i,:);FAR_convML_KNN(i,:);FAR_convML_SVM(i,:);FAR_convML_MLP(i,:)], [],1); % Min values across conventional ML models
    FAR_convML_max = max([FAR_convML_SGD(i,:);FAR_convML_KNN(i,:);FAR_convML_SVM(i,:);FAR_convML_MLP(i,:)], [], 1); % Max values across conventional ML models
    FAR_convML_avg = mean([FAR_convML_SGD(i,:);FAR_convML_KNN(i,:);FAR_convML_SVM(i,:);FAR_convML_MLP(i,:)], 1); % Average values across conventional ML models

    % Bar plot for proposed technique
    b = bar(1:4, [FAR_proposed(i, :); FAR_convML_avg; FAR_baseline(i, :)],...
        'BarWidth', .9,'EdgeColor','none'); % Proposed
    b(1).FaceColor = [0 0.4470 0.7410];
    b(2).FaceColor = [0.9290 0.6940 0.1250];
    b(3).FaceColor = [0.4660 0.6740 0.1880];  % Color for conventional ML models

    ylim([0 100]);
    yl = get(gca,'ylim');

    % Overlay error bars on top of the third bar (conventional ML)
    % Place error bars on the third bar by aligning them with its X coordinates
    x = b(2).XEndPoints;
    errorbar(x, FAR_convML_avg, FAR_convML_avg - FAR_convML_min, FAR_convML_max - FAR_convML_avg, ...
        'k', 'LineWidth', 1.2, 'CapSize', 10, 'LineStyle', 'none');

    % add values over bars 1
    xtips1 = b(1).XEndPoints;
    ytips1 = 20 + b(1).YEndPoints/2;
    labels1 = string(b(1).YData);
    text(xtips1,ytips1,strcat(labels1,'\%'),'HorizontalAlignment','center','Rotation',90,...
        'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','k');

    % add values over bars 2
    xtips2 = b(2).XEndPoints;
    ytips2 = 25 + b(2).YEndPoints/2;
    labels2 = string(round(b(2).YData,2));
    text(xtips2,ytips2,strcat(labels2,'\%'),'HorizontalAlignment','center','Rotation',90,...
        'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','k');


    % add values over bars 3
    xtips3 = b(3).XEndPoints;
    ytips3 = yl(1)/2 + b(3).YEndPoints/2;
    labels3 = string(b(3).YData);
    for ii = 1:length(xtips3)
        if 18 <= str2num(regexp(labels3(ii),'%','split')) && str2num(regexp(labels3(ii),'%','split')) < 40
            text(xtips3(ii),4.5*ytips3(ii),strcat(labels3(ii),'\%'),'HorizontalAlignment','center','Rotation',90,...
                'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','k');
        else 
            if str2num(regexp(labels3(ii),'%','split')) < 18
                text(xtips3(ii),4*ytips3(ii)+10,strcat(labels3(ii),'\%'),'HorizontalAlignment','center','Rotation',90,...
                    'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','k');            
            else
            text(xtips3(ii),ytips3(ii),strcat(labels3(ii),'\%'),'HorizontalAlignment','center','Rotation',90,...
                'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','w');
            end
        end
    end
    
    % Add 'days' to the x-tick labels
    xticklabels({'+0 days', '+7 days', '+30 days', '+90 days'});

    % Set title for each subplot
    title(sprintf(' '), "Interpreter","latex");
    
    set(gca, 'Box', 'on', 'FontSize', 20, 'TickLabelInterpreter', 'latex', ...
'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'none', 'YGrid', 'on',...
'XTick', [1 2 3 4], 'xticklabels', {'+0 days', '+7 days', '+30 days', '+90 days'});

    hold off;
    j = j+2;

    if i == 2
        ylabel('False Alarm Rate (\%)', 'FontSize', 30, 'interpreter', 'latex');
    end
end

% Add a common legend
lgd = legend('Proposed technique', 'Conventional ML baseline', 'Naive baseline', 'Orientation', 'horizontal', 'Location', 'northoutside');
lgd.Layout.Tile = 'north'; % Place the legend above the plots
set(lgd,'Interpreter','latex','FontSize',20);


% Common X and Y labels for the entire plot
xlabel(t, 'Prediction Horizon (days)', 'FontSize', 30, 'interpreter', 'latex');

exportgraphics(t,'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\mainResults_Deadhorse.pdf', 'Resolution', 300) % Use vector for best quality


%% *Toolik Lake - main results
clc
clear
% Data for performance
depths = [16, 8, 0];  % Depths in cm (y-axis)
horizons = [0, 7, 30, 90];  % Prediction horizons (x-axis)

% Example data for Balanced Accuracy (bAcc) for baseline and proposed models
bAcc_baseline = [84.38, 81.29, 87.05, 46.96; 82.88, 78.78, 86.34, 47.99; 81.82, 83.51, 86.27, 53.14];
bAcc_proposed = [98.20, 95.96, 96.38, 96.99; 98.16, 94.28, 91.80, 95.28; 97.81, 94.92, 94.97, 95.10];


% Average performance of conventional ML models (from  16 --> 8 __> 0)
bAcc_convML_RF = [97.95	95.78	95.94	97.06;	98.16	93.60	90.88	95.71;	97.86	94.26	94.25	95.34];
bAcc_convML_SGD = [96.45	92.27	91.97	86.97;	97.61	91.40	89.64	84.03;	97.58	91.27	92.30	77.56];
bAcc_convML_KNN = [97.63	94.97	92.89	92.17;	96.93	92.87	88.91	89.89;	95.71	93.94	91.44	89.64];
bAcc_convML_SVM = [98.08	94.23	94.64	94.93;	98.34	92.68	90.74	92.97;	97.34	93.52	93.98	92.83];
bAcc_convML_MLP = [98.51	95.66	94.76	96.05;	98.22	92.50	90.01	93.82;	97.14	94.53	93.76	93.94]; % 


figure('units','normalized','OuterPosition',[0 0 1 1]);
% Create a tiled layout with 3 tiles (one for each depth)
t = tiledlayout(3, 2, 'TileSpacing', 'Compact', 'Padding', 'Compact');

j = 1;

% Loop over each depth
for i = length(depths):-1:1
    nexttile(j); % Create the next subplot
    
    hold on;

    % Calculate min, max, and average for each horizon across conventional ML models
    bAcc_convML_min = min([bAcc_convML_SGD(i,:);bAcc_convML_KNN(i,:);bAcc_convML_SVM(i,:);bAcc_convML_MLP(i,:)], [],1); % Min values across conventional ML models
    bAcc_convML_max = max([bAcc_convML_SGD(i,:);bAcc_convML_KNN(i,:);bAcc_convML_SVM(i,:);bAcc_convML_MLP(i,:)], [], 1); % Max values across conventional ML models
    bAcc_convML_avg = mean([bAcc_convML_SGD(i,:);bAcc_convML_KNN(i,:);bAcc_convML_SVM(i,:);bAcc_convML_MLP(i,:)], 1); % Average values across conventional ML models

    % Bar plot for proposed technique
    b = bar(1:4, [bAcc_proposed(i, :);bAcc_convML_avg; bAcc_baseline(i, :)],...
        'BarWidth', .9,'EdgeColor','none'); % Proposed
    b(1).FaceColor = [0 0.4470 0.7410];
    b(2).FaceColor = [0.9290 0.6940 0.1250];
    b(3).FaceColor = [0.4660 0.6740 0.1880];  % Color for conventional ML models

    ylim([0 100]);
    yl = get(gca,'ylim');

    % Overlay error bars on top of the third bar (conventional ML)
    % Place error bars on the third bar by aligning them with its X coordinates
    x = b(2).XEndPoints;
    errorbar(x, bAcc_convML_avg, bAcc_convML_avg - bAcc_convML_min, bAcc_convML_max - bAcc_convML_avg, ...
        'k', 'LineWidth', 1.2, 'CapSize', 10, 'LineStyle', 'none');

    % add values over bars 1
    xtips1 = b(1).XEndPoints;
    ytips1 = yl(1)/2 + b(1).YEndPoints/2;
    labels1 = string(b(1).YData);
    text(xtips1,ytips1,strcat(labels1,'\%'),'HorizontalAlignment','center','Rotation',90,...
        'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','w');

    % add values over bars 2
    xtips2 = b(2).XEndPoints;
    ytips2 = yl(1)/2 + b(2).YEndPoints/2;
    labels2 = string(round(b(2).YData,2));
    text(xtips2,ytips2,strcat(labels2,'\%'),'HorizontalAlignment','center','Rotation',90,...
        'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','w');
    
    % add values over bars 3
    xtips3 = b(3).XEndPoints;
    ytips3 = yl(1)/2 + b(3).YEndPoints/2;
    labels3 = string(b(3).YData);
    for ii = 1:length(xtips3)
        if str2num(regexp(labels3(ii),'%','split')) < 40
            text(xtips3(ii),3*ytips3(ii),strcat(labels3(ii),'\%'),'HorizontalAlignment','center','Rotation',90,...
                'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','k');
        else
            text(xtips3(ii),ytips3(ii),strcat(labels3(ii),'\%'),'HorizontalAlignment','center','Rotation',90,...
                'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','w');
        end
    end
    
    % Set title for each subplot
    title(sprintf('Depth = %d cm', depths(i)), "Interpreter","latex",...
        "Position",[0.976456009913259,102.6699029126214,1.4210854715202e-14],...
        'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
    
    set(gca, 'Box', 'on', 'FontSize', 20, 'TickLabelInterpreter', 'latex', ...
'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'none', 'YGrid', 'on',...
'XTick', [1 2 3 4], 'xticklabels', {'+0 days', '+7 days', '+30 days', '+90 days'});

    
    hold off;
    j = j+2;
    
    if i == 2
        ylabel('Balanced Accuracy (\%)', 'FontSize', 30, 'interpreter', 'latex');
    end
end

% % Add a common legend
% lgd = legend('Proposed technique', 'Baseline model', 'Orientation', 'horizontal', 'Location', 'northoutside');
% lgd.Layout.Tile = 'north'; % Place the legend above the plots
% set(lgd,'Interpreter','latex','FontSize',20);

% % Common X and Y labels for the entire plot
% xlabel(t, 'Prediction Horizon (days)', 'FontSize', 30, 'interpreter', 'latex');
% 
% exportgraphics(t,'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\mainResults_ToolikLake_bAcc.pdf') % Use vector for best quality

% Toolik Lake - FAR
clc
% clear
% Data for performance
depths = [16, 8, 0];  % Depths in cm (y-axis)
horizons = [0, 7, 30, 90];  % Prediction horizons (x-axis)

% Example data for False Alarm Rate (FAR) for baseline and proposed models
FAR_baseline = [27.57, 33.33, 1.06, 79.01; 29.66, 36.59, 2.33, 80.26; 33.73, 29.35, 2.17, 70.46];
FAR_proposed = [1.35, 3.31, 1.48, 1.75; 0.99, 4.34, 5.61, 4.05; 1.75, 2.51, 2.91, 3.59];

% Average performance of conventional ML models (from  16 --> 8 __> 0)
FAR_convML_RF = [1.84	3.19	1.60	1.63;	1.24	4.46	6.48	4.18;	2.13	2.38	2.91	3.59];
FAR_convML_SGD = [1.59	3.92	6.29	3.50;	0.62	4.71	8.23	6.46;	1.25	2.63	8.47	10.27];
FAR_convML_KNN = [0.98	4.04	3.95	3.63;	1.73	4.71	7.23	3.80;	2.13	3.26	5.18	4.49];
FAR_convML_SVM = [1.59	5.27	2.96	1.88;	0.87	5.08	7.48	3.04;	1.25	3.39	4.17	3.59];
FAR_convML_MLP = [0.98	3.68	2.47	2.13;	1.36	5.20	6.98	3.04;	2.13	3.76	3.41	4.24]; % 

% figure('units','normalized','OuterPosition',[0 0 1 1]);
% Create a tiled layout with 3 tiles (one for each depth)
% t = tiledlayout(3, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');

j = 2;
% Loop over each depth
for i = length(depths):-1:1
    nexttile(j); % Create the next subplot
    
    hold on;
    
    % Calculate min, max, and average for each horizon across conventional ML models
    FAR_convML_min = min([FAR_convML_SGD(i,:);FAR_convML_KNN(i,:);FAR_convML_SVM(i,:);FAR_convML_MLP(i,:)], [],1); % Min values across conventional ML models
    FAR_convML_max = max([FAR_convML_SGD(i,:);FAR_convML_KNN(i,:);FAR_convML_SVM(i,:);FAR_convML_MLP(i,:)], [], 1); % Max values across conventional ML models
    FAR_convML_avg = mean([FAR_convML_SGD(i,:);FAR_convML_KNN(i,:);FAR_convML_SVM(i,:);FAR_convML_MLP(i,:)], 1); % Average values across conventional ML models

    % Bar plot for proposed technique
    b = bar(1:4, [FAR_proposed(i, :); FAR_convML_avg; FAR_baseline(i, :)],...
        'BarWidth', .9,'EdgeColor','none'); % Proposed
    b(1).FaceColor = [0 0.4470 0.7410];
    b(2).FaceColor = [0.9290 0.6940 0.1250];
    b(3).FaceColor = [0.4660 0.6740 0.1880];  % Color for conventional ML models

    ylim([0 100]);
    yl = get(gca,'ylim');

    % Overlay error bars on top of the third bar (conventional ML)
    % Place error bars on the third bar by aligning them with its X coordinates
    x = b(2).XEndPoints;
    errorbar(x, FAR_convML_avg, FAR_convML_avg - FAR_convML_min, FAR_convML_max - FAR_convML_avg, ...
        'k', 'LineWidth', 1.2, 'CapSize', 10, 'LineStyle', 'none');

    % add values over bars 1
    xtips1 = b(1).XEndPoints;
    ytips1 = 20 + b(1).YEndPoints/2;
    labels1 = string(b(1).YData);
    text(xtips1,ytips1,strcat(labels1,'\%'),'HorizontalAlignment','center','Rotation',90,...
        'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','k');

    % add values over bars 2
    xtips2 = b(2).XEndPoints;
    ytips2 = 25 + b(2).YEndPoints/2;
    labels2 = string(round(b(2).YData,2));
    text(xtips2,ytips2,strcat(labels2,'\%'),'HorizontalAlignment','center','Rotation',90,...
        'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','k');


    % add values over bars 3
    xtips3 = b(3).XEndPoints;
    ytips3 = yl(1)/2 + b(3).YEndPoints/2;
    labels3 = string(b(3).YData);
    for ii = 1:length(xtips3)
        if 10 <= str2num(regexp(labels3(ii),'%','split')) && str2num(regexp(labels3(ii),'%','split')) < 40
            text(xtips3(ii),3.5*ytips3(ii),strcat(labels3(ii),'\%'),'HorizontalAlignment','center','Rotation',90,...
                'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','k');
        else 
            if str2num(regexp(labels3(ii),'%','split')) < 10
                text(xtips3(ii),ytips3(ii)+20,strcat(labels3(ii),'\%'),'HorizontalAlignment','center','Rotation',90,...
                    'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','k');            
            else
            text(xtips3(ii),ytips3(ii),strcat(labels3(ii),'\%'),'HorizontalAlignment','center','Rotation',90,...
                'VerticalAlignment','middle', 'Interpreter','latex','FontSize',20, 'Color','w');
            end
        end
    end
    
    % Add 'days' to the x-tick labels
    xticklabels({'+0 days', '+7 days', '+30 days', '+90 days'});

    % Set title for each subplot
    title(sprintf(' '), "Interpreter","latex");
    
    set(gca, 'Box', 'on', 'FontSize', 20, 'TickLabelInterpreter', 'latex', ...
'YMinorGrid', 'on', 'YMinorTick', 'on', 'TickDir', 'none', 'YGrid', 'on',...
'XTick', [1 2 3 4], 'xticklabels', {'+0 days', '+7 days', '+30 days', '+90 days'});

    hold off;
    j = j+2;

    if i == 2
        ylabel('False Alarm Rate (\%)', 'FontSize', 30, 'interpreter', 'latex');
    end
end

% Add a common legend
lgd = legend('Proposed technique', 'Conventional ML baseline', 'Naive baseline', 'Orientation', 'horizontal', 'Location', 'northoutside');
lgd.Layout.Tile = 'north'; % Place the legend above the plots
set(lgd,'Interpreter','latex','FontSize',20);

% Common X and Y labels for the entire plot
xlabel(t, 'Prediction Horizon (days)', 'FontSize', 30, 'interpreter', 'latex');


exportgraphics(t,'C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\mainResults_ToolikLake.pdf', 'Resolution', 300) % Use vector for best quality

%% *Monthly TimePlots (separated)
addpath('C:\Users\mohamed.ahajjam\Desktop\Misc\MEDIUM\Article1')
close('all')

clear
clc

hrz = {'0', '90'};%'7','30',
loc = {'Deadhorse', 'Toolik'};

fprintf('Location, Depth, Horizon, Frozen class - Correct, Frozen class - Incorrect, Thawing class - Correct, Thawing class - Incorrect\n')    
for L = 1:length(loc)
    close('all')
    if strcmp(loc{L},'Deadhorse')
        target = {'T0', 'T_12'};%'T_07', 
    else
        target = {'T0', 'T16'};% 'T8', 
    end
    for K = 1:length(target)
        errorRate_by_month_freezing = NaN(12,1);
        errorRate_by_month_thawing = NaN(12,1);
        lowerBound_by_month_freezing = NaN(12,1);
        lowerBound_by_month_thawing = NaN(12,1);
        upperBound_by_month_freezing = NaN(12,1);
        upperBound_by_month_thawing = NaN(12,1);
        for M = 1:length(hrz)
            fprintf('%s, %s, %s', loc{L}, target{K}, hrz{M})
            % File path for data
            path1 = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\modelResults\', ...
                ['FTstates_' loc{L} '_' target{K} '_' target{K} '_testresults_' hrz{M} 'Days.csv']);
            opts = detectImportOptions(path1);
            data = readtable(path1, opts); %data already has M as the month of the year as a column

            % Calculate correct and incorrect predictions for frozen (Class 0) and thawing (Class 1)
            correct_freezing = sum((data.Predicted == data.Targets) & (data.Targets == 0));  % Correct for frozen (Class 0)
            correct_thawing = sum((data.Predicted == data.Targets) & (data.Targets == 1));   % Correct for thawing (Class 1)

            wrong_freezing = sum((data.Predicted ~= data.Targets) & (data.Targets == 0));  % Incorrect for frozen (Class 0)
            wrong_thawing = sum((data.Predicted ~= data.Targets) & (data.Targets == 1));   % Incorrect for thawing (Class 1)

            % Aggregate by month and year
            if strcmp(loc{L}, 'Toolik') && strcmp(target{K},'T8')
                path2 = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\modelResults\', ...
                    ['FTstates_' loc{L} '_' target{K} '_' target{K} '_testresults_' hrz{M} 'Days_withM.csv']);
                opts = detectImportOptions(path2);
                data2 = readtable(path2, opts); %data already has M as the month of the year as a column
                data.M = data2.M;
                data = movevars(data, "M", "Before", "S");
            end
            if strcmp(hrz{M},'90')
                for i = 1:length(data.M)
                    tmp_tmp(i,1) = datetime(sprintf('%g-%g',data.Y(i), data.M(i)),"InputFormat","yyyy-M") + days(90);
                end
                [tmp_Y, tmp_M, ~] = ymd(tmp_tmp);
                data.Y = tmp_Y;
                data.M = tmp_M;                
            end
            months = unique(data.M);
            correct_by_month_freezing = arrayfun(@(m) sum((data.Predicted == data.Targets) & (data.M == m) & (data.Targets == 0)), months);
            correct_by_month_thawing = arrayfun(@(m) sum((data.Predicted == data.Targets) & (data.M == m) & (data.Targets == 1)), months);

            wrong_by_month_freezing = arrayfun(@(m) sum((data.Predicted ~= data.Targets) & (data.M == m) & (data.Targets == 0)), months);
            wrong_by_month_thawing = arrayfun(@(m) sum((data.Predicted ~= data.Targets) & (data.M == m) & (data.Targets == 1)), months);

            % Compute the 95% percentage error bounds
            fprintf('****************\n')
            fprintf('Month, error rate Thawing, error rate Freezing\n') 
            for jj = 1:12
                % Check for thawing class and freezing class counts before calculating CI
                if (correct_by_month_freezing(jj) + wrong_by_month_freezing(jj)) > 0
                    [errorRate_by_month_freezing(jj,1), lowerBound_by_month_freezing(jj,1), upperBound_by_month_freezing(jj,1)] = ...
                        computeBinomialCI(wrong_by_month_freezing(jj), wrong_by_month_freezing(jj) + correct_by_month_freezing(jj) + wrong_by_month_thawing(jj) + correct_by_month_thawing(jj), 0.95);
                else
                    errorRate_by_month_freezing(jj,1) = NaN;
                    lowerBound_by_month_freezing(jj,1) = NaN;
                    upperBound_by_month_freezing(jj,1) = NaN;
                    % fprintf('No freezing data for month %d\n', jj);
                end

                if (correct_by_month_thawing(jj) + wrong_by_month_thawing(jj)) > 0
                    [errorRate_by_month_thawing(jj,1), lowerBound_by_month_thawing(jj,1), upperBound_by_month_thawing(jj,1)] = ...
                        computeBinomialCI(wrong_by_month_thawing(jj), wrong_by_month_thawing(jj) + correct_by_month_thawing(jj) + wrong_by_month_freezing(jj) + correct_by_month_freezing(jj), 0.95);
                else
                    errorRate_by_month_thawing(jj,1) = NaN;
                    lowerBound_by_month_thawing(jj,1) = NaN;
                    upperBound_by_month_thawing(jj,1) = NaN;
                    % fprintf('No thawing data for month %d\n', jj);
                end
                % Debugging: Print the number of correct and incorrect predictions for thawing
                fprintf('%d, %.2f, %.2f\n', jj, errorRate_by_month_thawing(jj), errorRate_by_month_freezing(jj));
            end


            % Calculate general error rates per soil state
            [errorRate_freezing, lowerBound_freezing, upperBound_freezing] = computeBinomialCI(sum(wrong_by_month_freezing), sum(wrong_by_month_freezing+correct_by_month_freezing), 0.95);
            [errorRate_thawing, lowerBound_thawing, upperBound_thawing] = computeBinomialCI(sum(wrong_by_month_thawing), sum(wrong_by_month_thawing+correct_by_month_thawing), 0.95);
            [errorRate_freezing_correct, lowerBound_freezing_correct, upperBound_freezing_correct] = computeBinomialCI(sum(correct_by_month_freezing), sum(wrong_by_month_freezing+correct_by_month_freezing), 0.95);
            [errorRate_thawing_correct, lowerBound_thawing_correct, upperBound_thawing_correct] = computeBinomialCI(sum(correct_by_month_thawing), sum(wrong_by_month_thawing+correct_by_month_thawing), 0.95);

            % Create legend entries with percentages
            legend_entries = {
                sprintf('Correct Freezing predictions $(%.2f^{+%.3f}_{-%.3f})$', errorRate_freezing_correct, upperBound_freezing_correct-errorRate_freezing_correct, errorRate_freezing_correct-lowerBound_freezing_correct), ...
                sprintf('Wrong Freezing predictions'), ...
                sprintf('Correct Thawing predictions $(%.2f^{+%.3f}_{-%.3f})$', errorRate_thawing_correct, upperBound_thawing_correct-errorRate_thawing_correct, errorRate_thawing_correct-lowerBound_thawing_correct), ...
                sprintf('Wrong Thawing predictions')};
            
            for jjj = 1:length(legend_entries)
                fprintf(', %s', cell2mat(regexp(legend_entries{jjj},'\d^','match')))
            end
            fprintf('\n')
            
            month_names = {'Jan.', 'Feb.', 'Mar.', 'Apr.', 'May', 'Jun.', 'Jul.', 'Aug.', 'Sept.', 'Oct.', 'Nov.', 'Dec.'};
            % Plot the correct and incorrect predictions for each class per month
            createQuickPlots(months, ...
                [correct_by_month_freezing, wrong_by_month_freezing, correct_by_month_thawing, wrong_by_month_thawing], ...
                'bar', 'BarWidth', .95, ...
                'YLabel', sprintf('Number of instances (Depth = %s cm)',string(regexp(target{K},'\d*','match'))), ...
                'Legend', legend_entries, 'LegendOrientation', 'vertical', ...
                'LegendColumns', 2,'BarLayout', 'grouped','ShowValues', true, 'RotateTextValue', true,'TextValueOffset',0.05,...
                'RotateXlabels', true, 'CustomXTickLabels', month_names, ...
                'BarDivider', true,'lgndTitle',sprintf('Prediction horizon = +%s days',hrz{M}))%,'lgndTitle',sprintf('Performance at %d cm soil depth (+%s days horizon)', str2double(string(regexp(target{K},'\d*','match'))),hrz{M}));

            % % Export the plot as a PDF
            % exportgraphics(gca, ['C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\', ...
            %     'BarPlot_' loc{L} '_' target{K} '_' hrz{M} 'Days.eps'], "Resolution", 300)
        end
    end
end


%% *Different learning approaches figure - Toolik
clc
clear
 
% Format: [bAcc0, FAR0, bAcc7, FAR7, bAcc30, FAR30, bAcc90, FAR90] for three depths (Depth = 0 cm, Mid, Last)
Toolik2Deadhorse = [94.43	5.67	93.94	3.55	93.35	5.43	96.38	5.52;
                    80.13	9.90	82.30	7.65	82.04	10.00	80.70	5.35;
                   	86.25	9.65	86.99	10.87	86.59	10.54	86.21	12.50];
Deadhorse2Deadhorse = [96.85	1.84	96.96	1.28	96.96	3.00	97.61	2.03;
                       98.83	1.30	98.05	0.49	99.18	1.64	98.50	1.17;
                   	   98.94	0.54	99.40	0.40	98.67	0.27	97.47	0.69];

Agnostic2Deadhorse = [97.98	2.06	95.07	2.40	94.88	3.36	95.20	3.27;
                      97.74	1.47	97.62	1.97	97.00	2.20	97.32	2.45;
                  	  97.63	0.90	98.17	0.90	98.42	0.71	97.75	1.11];

DepthAgnostic2Deadhorse = [97.30	1.98	97.17	3.27	96.19	3.86	97.20	3.20
                           93.61	1.79	92.21	0.65	94.20	2.13	93.59	1.34
                       	   95.42	3.22	95.53	4.56	94.84	5.95	95.25	4.26];

% Toolik lake as test set 
Deadhorse2Toolik = [91.97	3.13	89.20	4.14	89.48	4.80	88.57	5.91;
                    83.82	24.75	81.66	25.65	77.87	29.30	77.85	32.53;
                	76.71	22.52	74.84	24.51	76.63	23.18	75.45	21.78];
Toolik2Toolik = [97.81	1.75	94.92	2.51	94.97	2.91	95.10	3.59;
                 98.16	0.99	94.28	4.34	91.80	5.61	95.28	4.05;
             	 98.20	1.35	95.96	3.31	96.38	1.48	96.99	1.75];
Agnostic2Toolik	= [97.24	1.73	95.16	3.06	95.00	3.96	95.44	3.07;
                   97.79	1.90	95.78	4.01	94.41	4.61	95.23	2.96;
               	   98.34	0.70	96.71	2.11	96.65	1.94	95.85	2.62];
DepthAgnostic2Toolik	= [98.80	0.25	98.38	0.13	98.38	0.38	98.19	0.51
                           98.77	0.50	98.71	0.62	98.77	0.75	98.32	1.39
                       	   98.76	1.22	98.40	2.21	98.45	1.85	98.18	1.63];

% Prediction horizons (+0, +7, +30, +90 days)
horizons = [0, 7, 30, 90];
point_sizes = [40, 100, 190, 250]; % Adjust the point sizes according to the prediction horizons


% ******* Deadhorse as test set 
% Create a figure
figure('units','normalized','OuterPosition',[0 0 1 1]);
% Create a tiled layout with 3 tiles (one for each depth)
t = tiledlayout(3, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');

% Define common axis limits
x_limits = [0 35];  % Set appropriate limits for FAR (False Alarm Rate)
y_limits = [74 100];  % Set appropriate limits for bAcc (Balanced Accuracy)


% Depth = 0 cm
nexttile;
hold on;
scatter(Deadhorse2Deadhorse(1, 2:2:8), Deadhorse2Deadhorse(1, 1:2:7), point_sizes, 'o', 'filled', 'DisplayName','Location specific');
scatter(Toolik2Deadhorse(1, 2:2:8), Toolik2Deadhorse(1, 1:2:7), point_sizes, 'd', 'filled', 'DisplayName','Cross Location');
scatter(Agnostic2Deadhorse(1, 2:2:8), Agnostic2Deadhorse(1, 1:2:7), point_sizes, '^', 'filled', 'DisplayName','Location agnostic');
scatter(DepthAgnostic2Deadhorse(1, 2:2:8), DepthAgnostic2Deadhorse(1, 1:2:7), point_sizes, 'v', 'filled', 'DisplayName','Depth agnostic');
title('Depth = 0 cm', "Interpreter","latex",'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
ax = gca;
ax.TitleHorizontalAlignment = 'left';
xlim(x_limits);  % Set the same x limits
ylim(y_limits);  % Set the same y limits
set(gca, 'Box', 'on', 'FontSize', 20, 'TickLabelInterpreter', 'latex', 'YMinorGrid', 'on', 'YMinorTick', 'on', 'XMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on');
hold off;

% Legend
lgd = legend('show', 'Location', 'best', 'Orientation','vertical','Location','northeastoutside');
% lgd.Layout.Tile = 'outside'; % Place the legend above the plots
set(lgd,'Interpreter','latex','FontSize',20);
title(lgd, 'Learning approaches')

% Depth = Mid
nexttile;
hold on;
scatter(Deadhorse2Deadhorse(2, 2:2:8), Deadhorse2Deadhorse(2, 1:2:7), point_sizes, 'o', 'filled', 'DisplayName','Location specific');
scatter(Toolik2Deadhorse(2, 2:2:8), Toolik2Deadhorse(2, 1:2:7), point_sizes, 'd', 'filled', 'DisplayName','Cross Location');
scatter(Agnostic2Deadhorse(2, 2:2:8), Agnostic2Deadhorse(2, 1:2:7), point_sizes, '^', 'filled', 'DisplayName','Location agnostic');
scatter(DepthAgnostic2Deadhorse(2, 2:2:8), DepthAgnostic2Deadhorse(2, 1:2:7), point_sizes, 'v', 'filled', 'DisplayName','Depth agnostic');
title('Depth = 7 cm', "Interpreter","latex",'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
ax = gca;
ax.TitleHorizontalAlignment = 'left';
xlim(x_limits);  % Set the same x limits
ylim(y_limits);  % Set the same y limits
set(gca, 'Box', 'on', 'FontSize', 20, 'TickLabelInterpreter', 'latex', 'YMinorGrid', 'on', 'YMinorTick', 'on', 'XMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on');
hold off;

% Depth = Last
nexttile;
hold on;
a1 = scatter(Deadhorse2Deadhorse(3, 2:2:8), Deadhorse2Deadhorse(3, 1:2:7), point_sizes, 'o', 'filled', 'DisplayName','Location specific');
a2 = scatter(Toolik2Deadhorse(3, 2:2:8), Toolik2Deadhorse(3, 1:2:7), point_sizes, 'D', 'filled', 'DisplayName','Cross Location');
a3 = scatter(Agnostic2Deadhorse(3, 2:2:8), Agnostic2Deadhorse(3, 1:2:7), point_sizes, '^', 'filled', 'DisplayName','Location agnostic');
a4 = scatter(DepthAgnostic2Deadhorse(3, 2:2:8), DepthAgnostic2Deadhorse(3, 1:2:7), point_sizes, 'v', 'filled', 'DisplayName','Depth agnostic');
xlabel(t, 'False Alarm Rate (\%)', 'FontSize', 30, 'interpreter', 'latex');
ylabel(t, 'Balanced Accuracy (\%)', 'FontSize', 30, 'interpreter', 'latex');
title('Depth = 12 cm', "Interpreter","latex",'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
ax = gca;
ax.TitleHorizontalAlignment = 'left';
xlim(x_limits);  % Set the same x limits
ylim(y_limits);  % Set the same y limits
set(gca, 'Box', 'on', 'FontSize', 20, 'TickLabelInterpreter', 'latex', 'YMinorGrid', 'on', 'YMinorTick', 'on', 'XMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on');
hold off;


ah1 = axes('position',get(gcf,'position'),'visible','off');
lgd = legend(ah1, [a1(1) a2(1) a3(1) a4(1)], {'+0 days','+7 days', '+30 days', '+90 days'}, 'Location','northeastoutside');
set(lgd, 'Position',[0.85677301103741 0.1041486970640979 0.122821579932223 0.191037968567076],...
    'Interpreter','latex',...
    'FontSize',20);
title(lgd,'Prediction horizons');

exportgraphics(gcf, ['C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\','Scatterplots_deadhorse.pdf'])

% ******* Toolik lake as test set
% Create a figure
figure('units','normalized','OuterPosition',[0 0 1 1]);
% Create a tiled layout with 3 tiles (one for each depth)
t = tiledlayout(3, 1, 'TileSpacing', 'Compact', 'Padding', 'Compact');

% Define common axis limits
x_limits = [0 35];  % Set appropriate limits for FAR (False Alarm Rate)
y_limits = [74 100];  % Set appropriate limits for bAcc (Balanced Accuracy)


% Depth = 0 cm
nexttile;
hold on;
scatter(Toolik2Toolik(1, 2:2:8), Toolik2Toolik(1, 1:2:7), point_sizes, 'o', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Location specific');
scatter(Deadhorse2Toolik(1, 2:2:8), Deadhorse2Toolik(1, 1:2:7), point_sizes, 'd', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Cross location');
scatter(Agnostic2Toolik(1, 2:2:8), Agnostic2Toolik(1, 1:2:7), point_sizes, '^', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Location agnostic');
scatter(DepthAgnostic2Toolik(1, 2:2:8), DepthAgnostic2Toolik(1, 1:2:7), point_sizes, 'v', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Depth agnostic');
title('Depth = 0 cm', "Interpreter","latex",'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
ax = gca;
ax.TitleHorizontalAlignment = 'left';
xlim(x_limits);  % Set the same x limits
ylim(y_limits);  % Set the same y limits
set(gca, 'Box', 'on', 'FontSize', 20, 'TickLabelInterpreter', 'latex', 'YMinorGrid', 'on', 'YMinorTick', 'on', 'XMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on');
hold off;

% Legend
lgd = legend('show','Location', 'best', 'Orientation','vertical','Location','northeastoutside');
% lgd.Layout.Tile = 'outside'; % Place the legend above the plots
set(lgd,'Interpreter','latex','FontSize',20);
title(lgd,'Learning approaches');

% Depth = Mid
nexttile;
hold on;
scatter(Toolik2Toolik(2, 2:2:8), Toolik2Toolik(2, 1:2:7), point_sizes, 'o', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Location specific');
scatter(Deadhorse2Toolik(2, 2:2:8), Deadhorse2Toolik(2, 1:2:7), point_sizes, 'd', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Cross location');
scatter(Agnostic2Toolik(2, 2:2:8), Agnostic2Toolik(2, 1:2:7), point_sizes, '^', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Location agnostic');
scatter(DepthAgnostic2Toolik(2, 2:2:8), DepthAgnostic2Toolik(2, 1:2:7), point_sizes, 'v', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Depth agnostic');
title('Depth = 8 cm', "Interpreter","latex",'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
ax = gca;
ax.TitleHorizontalAlignment = 'left';
xlim(x_limits);  % Set the same x limits
ylim(y_limits);  % Set the same y limits
set(gca, 'Box', 'on', 'FontSize', 20, 'TickLabelInterpreter', 'latex', 'YMinorGrid', 'on', 'YMinorTick', 'on', 'XMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on');
hold off;

% Depth = Last
nexttile;
hold on;
a1 = scatter(Toolik2Toolik(3, 2:2:8), Toolik2Toolik(3, 1:2:7), point_sizes, 'o', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Specific Location');
a2 = scatter(Deadhorse2Toolik(3, 2:2:8), Deadhorse2Toolik(3, 1:2:7), point_sizes, 'D', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Cross location');
a3 = scatter(Agnostic2Toolik(3, 2:2:8), Agnostic2Toolik(3, 1:2:7), point_sizes, '^', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Location agnostic');
a4 = scatter(DepthAgnostic2Toolik(3, 2:2:8), DepthAgnostic2Toolik(3, 1:2:7), point_sizes, 'v', 'filled', 'MarkerFaceAlpha',.8, 'DisplayName','Depth agnostic');
xlabel(t, 'False Alarm Rate (\%)', 'FontSize', 30, 'interpreter', 'latex');
ylabel(t, 'Balanced Accuracy (\%)', 'FontSize', 30, 'interpreter', 'latex');
title('Depth = 16 cm', "Interpreter","latex",'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
ax = gca;
ax.TitleHorizontalAlignment = 'left';
xlim(x_limits);  % Set the same x limits
ylim(y_limits);  % Set the same y limits
set(gca, 'Box', 'on', 'FontSize', 20, 'TickLabelInterpreter', 'latex', 'YMinorGrid', 'on', 'YMinorTick', 'on', 'XMinorTick', 'on', 'TickDir', 'in', 'YGrid', 'on');
hold off;


% % Add a custom annotation for prediction horizons
% annotation('textbox', [0.840277539286161 0.0996960525575504 0.13209033235438 0.161843967705875],...
%     'String',{'Prediction horizons:','\hspace{0.1cm}+0 days','\hspace{0.2cm}+7 days','\hspace{0.3cm}+30 days','\hspace{0.4cm}+90 days'},...
%     'FontSize',20, 'interpreter', 'latex',...
%     'EdgeColor',[0.149019607843137 0.149019607843137 0.149019607843137],...
%     'BackgroundColor',[1 1 1]);

ah1 = axes('position',get(gcf,'position'),'visible','off');
lgd = legend(ah1, [a1(1) a2(1) a3(1) a4(1)], {'+0 days','+7 days', '+30 days', '+90 days'}, 'Location','northeastoutside');
set(lgd, 'Position',[0.85677301103741 0.1041486970640979 0.122821579932223 0.191037968567076],...
    'Interpreter','latex',...
    'FontSize',20);
title(lgd,'Prediction horizons');

exportgraphics(gcf, ['C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\','Scatterplots_toolik.pdf'])

%% TimePlot with Line Plots
addpath('C:\Users\mohamed.ahajjam\Desktop\Misc\MEDIUM\Article1')
close('all')

clear
clc
loc = {'Deadhorse'}; L = 1;
target = {'T0', 'T_07', 'T_12'};
hrz = {'0','7','30','90'}; % Time horizons

% Define colors for different time horizons
colors = lines(length(hrz));  % Generate distinct colors for each time horizon

for K = 1:length(target)
    close('all')
    
    % Initialize figure
    figure('units','normalized','outerposition',[0 0 1 1]);
    hold on; % Hold on to plot multiple lines on the same figure

    for M = 1:length(hrz)
        % File path for data
        path1 = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\modelResults\', ...
                         ['FTstates_' loc{L} '_' target{K} '_' target{K} '_testresults_' hrz{M} 'Days.csv']);
        opts = detectImportOptions(path1);
        data = readtable(path1, opts);
        data.Date = datetime(data.Y, 1, 1);  % Only keep the year (January 1 for simplicity)

        % Apply the same thresholding logic as in your Python script
        data.Targets = double(data.Targets > 0);  % Class 0 = freezing soil (Targets ≤ 0), Class 1 = thawing soil (Targets > 0)
        data.Predicted = double(data.Predicted > 0);  % Apply same thresholding to predicted values

        % Calculate correct and incorrect predictions
        correct_predictions = (data.Predicted == data.Targets);  % Logical array for correct predictions
        wrong_predictions = ~correct_predictions;  % Logical array for incorrect predictions

        % Aggregate by year
        years = unique(data.Y);
        correct_by_year = arrayfun(@(y) sum(correct_predictions & (data.Y == y)), years);
        wrong_by_year = arrayfun(@(y) sum(wrong_predictions & (data.Y == y)), years);

        % Plot correct predictions with different colors for each time horizon
        plot(years, correct_by_year, '-o', 'LineWidth', 1.5, 'DisplayName', ['Correct - ' hrz{M} ' Days'], 'Color', colors(M,:));
        
        % Plot wrong predictions with dashed lines
        plot(years, wrong_by_year, '--x', 'LineWidth', 1.5, 'DisplayName', ['Wrong - ' hrz{M} ' Days'], 'Color', colors(M,:));
    end
    
    % Customize plot
    xlabel('Year');
    ylabel('Number of Predictions');
    title(['Predictions for ' loc{L} ' at Depth ' target{K}]);
    legend('Location', 'northwest');
    grid on;
    set(gca, 'XTick', years);  % Set x-axis to show years
    xtickformat('yyyy');  % Display years in 'yyyy' format

    % Export the plot as a PDF
    % exportgraphics(gca, ['C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\', ...
    %                        'LinePlot_' loc{L} '_' target{K} '_AllHorizons.pdf'])  % Use vector for best quality

    hold off; % Release hold for the next plot
end

%% Scatter Plot: Correct vs Incorrect Instances per Class and Depth
addpath('C:\Users\mohamed.ahajjam\Desktop\Misc\MEDIUM\Article1')
close('all')

clear
clc
loc = {'Deadhorse'}; L = 1;
target = {'T0', 'T_07', 'T_12'};
hrz = {'0','7','30','90'}; % Time horizons

% Define markers and colors for different depths
markers = {'o', 's', 'd'};  % Markers for T0, T_07, T_12
colors = lines(length(target));  % Colors for different depths

figure('units', 'normalized', 'outerposition', [0 0 1 1]);
hold on;

for K = 1:length(target)
    for M = 1:length(hrz)
        % File path for data
        path1 = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\modelResults\', ...
                         ['FTstates_' loc{L} '_' target{K} '_' target{K} '_testresults_' hrz{M} 'Days.csv']);
        opts = detectImportOptions(path1);
        data = readtable(path1, opts);

        % Apply the same thresholding logic
        data.Targets = double(data.Targets > 0);  % Class 0 = freezing soil, Class 1 = thawing soil
        data.Predicted = double(data.Predicted > 0);  % Threshold predicted values
        
        % Calculate correct and incorrect predictions for each class
        correct_predictions = (data.Predicted == data.Targets);
        wrong_predictions = ~correct_predictions;

        class_0 = (data.Targets == 0);  % Freezing soil (Class 0)
        class_1 = (data.Targets == 1);  % Thawing soil (Class 1)

        % Correct and incorrect counts for each class
        correct_class_0 = sum(correct_predictions & class_0);  % Correct frozen
        wrong_class_0 = sum(wrong_predictions & class_0);      % Incorrect frozen

        correct_class_1 = sum(correct_predictions & class_1);  % Correct thawing
        wrong_class_1 = sum(wrong_predictions & class_1);      % Incorrect thawing

        % Plot the scatter points for Class 0 (Frozen) and Class 1 (Thawing)
        scatter(correct_class_0, wrong_class_0, 100, markers{K}, 'MarkerEdgeColor', colors(K,:), 'DisplayName', ['Frozen - ' target{K} ' (' hrz{M} ' Days)']);
        scatter(correct_class_1, wrong_class_1, 100, markers{K}, 'MarkerEdgeColor', colors(K,:), 'MarkerFaceColor', colors(K,:), 'DisplayName', ['Thawing - ' target{K} ' (' hrz{M} ' Days)']);

        % Add text annotation for the time horizon
        text(correct_class_0, wrong_class_0, hrz{M}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        text(correct_class_1, wrong_class_1, hrz{M}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
end

% Customize the plot
xlabel('Number of Correct Predictions');
ylabel('Number of Incorrect Predictions');
title(['Scatter Plot of Correct vs Incorrect Predictions for ' loc{L}]);
legend('Location', 'northeastoutside');
grid on;

% % Export the plot as a PDF
% exportgraphics(gca, ['C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\', ...
%                      'ScatterPlot_' loc{L} '_Correct_vs_Incorrect.pdf']);  % Use vector for best quality

% hold off;


%% Scatter Plot: Correct vs Incorrect Instances per Class (One Depth per Figure)
addpath('C:\Users\mohamed.ahajjam\Desktop\Misc\MEDIUM\Article1')
close('all')

clear
clc
loc = {'Deadhorse'}; L = 1;
target = {'T0', 'T_07', 'T_12'};
hrz = {'0','7','30','90'}; % Time horizons

% Define markers and colors for different time horizons
colors = lines(length(hrz));  % Generate distinct colors for each time horizon

for K = 1:length(target) % Loop over each depth
    figure('units', 'normalized', 'outerposition', [0 0 1 1]);
    hold on;
    
    for M = 1:length(hrz) % Loop over each time horizon
        % File path for data
        path1 = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\modelResults\', ...
                         ['FTstates_' loc{L} '_' target{K} '_' target{K} '_testresults_' hrz{M} 'Days.csv']);
        opts = detectImportOptions(path1);
        data = readtable(path1, opts);

        % Apply the same thresholding logic
        data.Targets = double(data.Targets > 0);  % Class 0 = freezing soil, Class 1 = thawing soil
        data.Predicted = double(data.Predicted > 0);  % Threshold predicted values
        
        % Calculate correct and incorrect predictions for each class
        correct_predictions = (data.Predicted == data.Targets);
        wrong_predictions = ~correct_predictions;

        class_0 = (data.Targets == 0);  % Freezing soil (Class 0)
        class_1 = (data.Targets == 1);  % Thawing soil (Class 1)

        % Correct and incorrect counts for each class
        correct_class_0 = sum(correct_predictions & class_0);  % Correct frozen
        wrong_class_0 = sum(wrong_predictions & class_0);      % Incorrect frozen

        correct_class_1 = sum(correct_predictions & class_1);  % Correct thawing
        wrong_class_1 = sum(wrong_predictions & class_1);      % Incorrect thawing

        % Plot the scatter points for Class 0 (Frozen) and Class 1 (Thawing)
        scatter(correct_class_0, wrong_class_0, 100, 'o', 'MarkerEdgeColor', colors(M,:), 'DisplayName', ['Frozen (' hrz{M} ' Days)']);
        scatter(correct_class_1, wrong_class_1, 100, 's', 'MarkerEdgeColor', colors(M,:), 'MarkerFaceColor', colors(M,:), 'DisplayName', ['Thawing (' hrz{M} ' Days)']);

        % Add text annotation for the time horizon
        text(correct_class_0, wrong_class_0, hrz{M}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        text(correct_class_1, wrong_class_1, hrz{M}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
    
    % Customize the plot
    xlabel('Number of Correct Predictions');
    ylabel('Number of Incorrect Predictions');
    title(['Correct vs Incorrect Predictions for ' target{K} ' at ' loc{L}]);
    legend('Location', 'northeastoutside');
    grid on;

    % Export the plot as a PDF for this specific depth
    % exportgraphics(gca, ['C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\', ...
    %                      'ScatterPlot_' loc{L} '_' target{K} '_Correct_vs_Incorrect.pdf']);  % Use vector for best quality

    hold off;
end

%% Scatter Plot: Ratio of Correct Instances per Class (One Depth per Figure)
addpath('C:\Users\mohamed.ahajjam\Desktop\Misc\MEDIUM\Article1')
close('all')

clear
clc
loc = {'Deadhorse'}; L = 1;
target = {'T0', 'T_07', 'T_12'};
hrz = {'0','7','30','90'}; % Time horizons

% Define markers and colors for different time horizons
colors = lines(length(hrz));  % Generate distinct colors for each time horizon

for K = 1:length(target) % Loop over each depth
    figure('units', 'normalized', 'outerposition', [0 0 1 1]);
    hold on;
    
    for M = 1:length(hrz) % Loop over each time horizon
        % File path for data
        path1 = fullfile('C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\modelResults\', ...
                         ['FTstates_' loc{L} '_' target{K} '_' target{K} '_testresults_' hrz{M} 'Days.csv']);
        opts = detectImportOptions(path1);
        data = readtable(path1, opts);

        % Apply the same thresholding logic
        data.Targets = double(data.Targets > 0);  % Class 0 = freezing soil, Class 1 = thawing soil
        data.Predicted = double(data.Predicted > 0);  % Threshold predicted values
        
        % Calculate correct and incorrect predictions for each class
        correct_predictions = (data.Predicted == data.Targets);
        
        class_0 = (data.Targets == 0);  % Freezing soil (Class 0)
        class_1 = (data.Targets == 1);  % Thawing soil (Class 1)

        % Total number of instances per class
        total_class_0 = sum(class_0);  % Total number of freezing instances
        total_class_1 = sum(class_1);  % Total number of thawing instances

        % Number of correct predictions for each class
        correct_class_0 = sum(correct_predictions & class_0);  % Correct frozen
        correct_class_1 = sum(correct_predictions & class_1);  % Correct thawing

        % Compute ratios of correct predictions per class
        ratio_class_0 = correct_class_0 / total_class_0;  % Ratio of correct freezing predictions
        ratio_class_1 = correct_class_1 / total_class_1;  % Ratio of correct thawing predictions

        % Plot the ratios (x-axis: thawing ratio, y-axis: freezing ratio)
        scatter(ratio_class_1, ratio_class_0, 100, 'o', 'MarkerEdgeColor', colors(M,:), 'DisplayName', [hrz{M} ' Days']);

        % Add text annotation for the time horizon
        text(ratio_class_1, ratio_class_0, hrz{M}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
    
    % Customize the plot
    xlabel('Ratio of Correct Thawing Predictions');
    ylabel('Ratio of Correct Freezing Predictions');
    title(['Correct Prediction Ratios for ' target{K} ' at ' loc{L}]);
    legend('Location', 'northeastoutside');
    grid on;
    xlim([0 1]);  % Ensure x-axis is between 0 and 1 (as ratios)
    ylim([0 1]);  % Ensure y-axis is between 0 and 1 (as ratios)

    % Export the plot as a PDF for this specific depth
    % exportgraphics(gca, ['C:\Users\mohamed.ahajjam\Desktop\UND\Defense resiliency platform\Datasets\FreezeThaw\', ...
    %                      'ScatterPlot_' loc{L} '_' target{K} '_Correct_Ratios.pdf']);  % Use vector for best quality

    hold off;
end

%% Functions
function [errorRate, lowerBound, upperBound] = computeBinomialCI(numErrors, totalPredictions, confidenceLevel)
    % Function to compute the binomial confidence interval for binary classification errors
    %
    % Inputs:
    % numErrors - Number of incorrect predictions
    % totalPredictions - Total number of predictions made by the model
    % confidenceLevel - Desired confidence level (e.g., 0.95 for 95%)
    %
    % Outputs:
    % errorRate - The error rate (proportion of incorrect predictions)
    % lowerBound - The lower bound of the confidence interval
    % upperBound - The upper bound of the confidence interval
    
    if totalPredictions ~= 0
        % Calculate the error rate
        errorRate = numErrors / totalPredictions;
        
        % Compute the binomial confidence interval using the Clopper-Pearson method
        alpha = 1 - confidenceLevel;
        
        % if numErrors == 0
        %     % Handle the special case when there are zero errors
        %     lowerBound = 0;  % The lower bound is always zero with no errors
        % else
        % General case for non-zero errors
        lowerBound = betainv(alpha / 2, numErrors, totalPredictions - numErrors + 1);
        % end
        upperBound = betainv(1 - alpha / 2, numErrors + 1, totalPredictions - numErrors);  % Upper bound only
    else
        errorRate = NaN;
        upperBound = NaN;
        lowerBound = NaN;
    end
    % % Display the results
    % fprintf('Error Rate: %.4f\n', errorRate);
    % fprintf('%.2f%% Confidence Interval: [%.4f, %.4f]\n', confidenceLevel * 100, lowerBound, upperBound);
end


function idx = find_consecutive_days(temp_data, threshold, direction, num_days, start_idx)
    % Function to find the start index where the temperature meets a condition
    % for a specified number of consecutive days
    % direction: 'above' for thawing, 'below' for freezing
    % num_days: minimum consecutive days to consider season start
    
    if nargin < 5
        start_idx = 1;
    end
    
    % Initialize index
    idx = [];
    
    % Check condition based on direction
    if strcmp(direction, 'above')
        condition = temp_data > threshold;
    else
        condition = temp_data < threshold;
    end
    
    % Check for consecutive days meeting the condition
    for i = start_idx:length(condition) - num_days + 1
        if all(condition(i:i + num_days - 1))
            idx = i;
            return;
        end
    end
end
