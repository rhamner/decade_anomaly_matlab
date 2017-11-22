clear all
close all

%Load the file
path = 'D:\Users\rober\Documents\city rating system\matlab\data\berkley earth historical\Complete_TAVG_LatLong1.nc';
ncdisp(path);
file = netcdf.open(path, 'NC_NOWRITE');
rawLat = netcdf.getVar(file, 1); 
rawLon = netcdf.getVar(file, 0);
time = netcdf.getVar(file, 2);
rawTemp = netcdf.getVar(file, 4);

%Remove unused data for US
p = find(rawLat >= 20 & rawLat <= 50);
q = find(rawLon >= -130 & rawLon <= -60);
lat = rawLat(p);
lon = rawLon(q);
temp = rawTemp(q, p, :);

%Figure out the average temperature (anomaly) in each decade
decadeTemp = zeros(length(lon), length(lat), 17);
year = 1;
for k = 1081:120:(length(time) - 120)
    decadeTemp(:, :, year) = mean(temp(:, :, k:(k + 119)), 3);
    year = year + 1;
end

%plot lines
fig = figure(1)
set(fig, 'Color', [0.24 0.21 0.28])
hold on

%plot gridlines
% for i = 2:2:16
%     plot([i i], [-2 2], 'Color', [0.95 0.95 0.95 0.5])
% end
% for i = -2:0.5:2
%     plot(1:16, i + zeros(1, 16), 'Color', [0.95 0.95 0.95 1])
% end

count = 0;
for i = 1:length(lon)
    for j = 1:length(lat)
        if(~isnan(decadeTemp(i, j, 1)))
            h = plot(squeeze(squeeze(decadeTemp(i, j, :))));
            h.Color = [.95, .95, .95, 0.05];
            hold on
            count = count + 1;
        end
    end
end

%Remove unused data for Europe
p = find(rawLat >= 35 & rawLat <= 65);
q = find(rawLon >= -10 & rawLon <= 35);
lat = rawLat(p);
lon = rawLon(q);
temp = rawTemp(q, p, :);

%Figure out the average temperature (anomaly) in each decade
decadeTemp = zeros(length(lon), length(lat), 16);
year = 1;
for k = 1081:120:(length(time) - 120)
    decadeTemp(:, :, year) = mean(temp(:, :, k:(k + 119)), 3);
    year = year + 1;
end

%plot lines
for i = 1:length(lon)
    for j = 1:length(lat)
        if(~isnan(decadeTemp(i, j, 1)))
            h = plot(squeeze(squeeze(decadeTemp(i, j, :))));
            h.Color = [.95, .95, .95, 0.05];
            hold on
            count = count + 1;
        end
    end
end

xlim([1 17])
ylim([-2 2])
xlabel('Decade')
ylabel('Temperature Anomaly (C)')
set(gca, 'xtick', ([2 4 6 8 10 12 14 16]));
set(gca, 'xticklabels', {'1850''s', '1870''s', '1890''s', '1910''s', '1930''s', '1950''s', '1970''s', '1990''s'});
set(gca, 'Fontsize', 16)
set(gca, 'XColor', [0.95 0.95 0.95], 'YColor', [0.95 0.95 0.95], 'Color', [0.24 0.21 0.28])
title('Average Temperature Anomaly by Decade for 1863 Lat/Lon Locations in Europe and North America', 'Fontsize', 16, 'Color', [0.95 0.95 0.95])

%add second y axis and customize
[ax, h1, h2] = plotyy(1:17, -100 + zeros(1, 17), 1:17, -100 + zeros(1, 17));
xlim([1 17])
set(ax(2), 'YLim', [-2 2], 'YTick', [-2, -1, 0, 1, 2], 'YTickLabel', {'-3.6', '-1.8', '0', '1.8', '3.6'}, 'FontSize', 16', 'TickDir', 'out', 'YColor', [0.95 0.95 0.95]);
set(ax(1), 'TickDir', 'out', 'YColor', [0.95 0.95 0.95])
ylabel(ax(2), 'Temperature Anomaly (F)', 'rot', -90, 'Position', [19.5, 0, 0])
set(gca, 'box', 'off')
        