clear
clc

%Put in folder which has rat number as the name with all the subfiles
name = '58';

ogfile = strcat('ABRAPstructure_', name, '.mat');
resultsfile = strcat('ABRAPresults_', name, '.mat');
savefile = strcat('ABRAPlatency_', name, '.mat');

load(resultsfile)

RawTongue = load(ogfile, 'RawTongue');
RawTongue = RawTongue.RawTongue;

RawIpsi = load(ogfile, 'RawIpsi');
RawIpsi = RawIpsi.RawIpsi;

frequency = load(ogfile, 'frequency');
frequency = frequency.frequency;

Stim = load(ogfile, 'Stim');
Stim = Stim.Stim;

numbers = ceil(0.025*frequency);

IPTongue = zeros(5, numbers);
EPTongue = zeros(5, numbers);

IPIpsi = zeros(5, numbers);
EPIpsi = zeros(5, numbers);

numstim = zeros(1, 5);
for i = 1:numel(IPresults(:, 1))
    ind1 = ceil(IPresults(i, 1)*frequency);
    ind2 = ceil(IPresults(i, 2)*frequency);
    level = round(IPresults(i, 17)/0.05);
    if level > 0 && level <= 5
        for j = ind1:ind2-1
            if Stim.IP(j) > 0.01 && Stim.IP(j+1) <= 0.01
                numstim(1, level) = numstim(1, level) + 1;
                IPTongue(level, :) = IPTongue(level, :) + transpose(RawTongue.IP(j+1:j+numbers, 1));
                IPIpsi(level, :) = IPIpsi(level, :) + transpose(RawIpsi.IP(j+1:j+numbers, 1));
            end
        end
    end
end

for k = 1:5
    IPIpsi(k, :) = IPIpsi(k, :)/numstim(1, k);
    IPTongue(k, :) = IPTongue(k, :)/numstim(1, k);
end


numstim = zeros(1, 5);
for i = 1:numel(EPresults(:, 1))
    ind1 = ceil(EPresults(i, 2)*frequency);
    ind2 = ceil(EPresults(i, 2)*frequency+EPresults(i, 4)*frequency);
    level = round(EPresults(i, 17)/0.05);
    if level > 0 && level <= 5
        for j = ind1:ind2-1
            if Stim.EP(j) > 0.01 && Stim.EP(j+1) <= 0.01
                numstim(1, level) = numstim(1, level) + 1;
                EPTongue(level, :) = EPTongue(level, :) + transpose(RawTongue.EP(j+1:j+numbers, 1));
                EPIpsi(level, :) = EPIpsi(level, :) + transpose(RawIpsi.EP(j+1:j+numbers, 1));
            end
        end
    end
end

for k = 1:5
    EPIpsi(k, :) = EPIpsi(k, :)/numstim(1, k);
    EPTongue(k, :) = EPTongue(k, :)/numstim(1, k);
end


IPtTongue = zeros(5, numbers);
EPtTongue = zeros(5, numbers);

IPtIpsi = zeros(5, numbers);
EPtIpsi = zeros(5, numbers);

numstim = zeros(1, 5);
for i = 1:numel(IPtresults(:, 1))
    ind1 = ceil(IPtresults(i, 1)*frequency);
    ind2 = ceil(IPtresults(i, 2)*frequency);
    level = round(IPtresults(i, 17)/0.05);
    if level > 0 && level <= 5
        for j = ind1:ind2-1
            if Stim.IPt(j) > 0.01 && Stim.IPt(j+1) <= 0.01
                numstim(1, level) = numstim(1, level) + 1;
                IPtTongue(level, :) = IPtTongue(level, :) + transpose(RawTongue.IPt(j+1:j+numbers, 1));
                IPtIpsi(level, :) = IPtIpsi(level, :) + transpose(RawIpsi.IPt(j+1:j+numbers, 1));
            end
        end
    end
end

for k = 1:5
    IPtIpsi(k, :) = IPtIpsi(k, :)/numstim(1, k);
    IPtTongue(k, :) = IPtTongue(k, :)/numstim(1, k);
end


numstim = zeros(1, 5);
for i = 1:numel(EPtresults(:, 1))
    ind1 = ceil(EPtresults(i, 2)*frequency);
    ind2 = ceil(EPtresults(i, 2)*frequency+EPtresults(i, 4)*frequency);
    level = round(EPtresults(i, 17)/0.05);
    if level > 0 && level <= 5
        for j = ind1:ind2-1
            if Stim.EPt(j) > 0.01 && Stim.EPt(j+1) <= 0.01
                numstim(1, level) = numstim(1, level) + 1;
                EPtTongue(level, :) = EPtTongue(level, :) + transpose(RawTongue.EPt(j+1:j+numbers, 1));
                EPtIpsi(level, :) = EPtIpsi(level, :) + transpose(RawIpsi.EPt(j+1:j+numbers, 1));
            end
        end
    end
end

for k = 1:5
    EPtIpsi(k, :) = EPtIpsi(k, :)/numstim(1, k);
    EPtTongue(k, :) = EPtTongue(k, :)/numstim(1, k);
end

save(savefile, 'IPIpsi', 'IPTongue', 'EPIpsi', 'EPTongue', 'IPtIpsi', 'IPtTongue', 'EPtIpsi', 'EPtTongue')
figure('Units', 'centimeters', 'Position', [10 10 10 3]); 

figure
Z = IPTongue;
[X, Y] = meshgrid(1/frequency*1000:1/frequency*1000:size(Z, 2)/frequency*1000, 0.05:0.05:0.25);
surf(X, Y, Z);
colorbar_handle = colorbar;
set(gca, 'XTickMode', 'auto', 'YTickMode', 'auto');
set(gca, 'TickDir', 'out')
set(colorbar_handle, 'FontSize', 10)
set(gca, 'FontSize', 10)
colormap(hot)
ylim([0.05 0.25])
clim([-0.15 0.15])
xlim([0 25])
view(2)
shading flat

figure
Z = IPIpsi;
[X, Y] = meshgrid(1/frequency*1000:1/frequency*1000:size(Z, 2)/frequency*1000, 0.05:0.05:0.25);
surf(X, Y, Z);
colorbar_handle = colorbar;
set(gca, 'XTickMode', 'auto', 'YTickMode', 'auto');
set(gca, 'TickDir', 'out')
set(colorbar_handle, 'FontSize', 10)
set(gca, 'FontSize', 10)
colormap(hot)
ylim([0.05 0.25])
 clim([-0.15 0.15])
 xlim([0 25])
view(2)
shading flat

figure
Z = EPTongue;
[X, Y] = meshgrid(1/frequency*1000:1/frequency*1000:size(Z, 2)/frequency*1000, 0.05:0.05:0.25);
surf(X, Y, Z);
colorbar_handle = colorbar;
set(gca, 'XTickMode', 'auto', 'YTickMode', 'auto');
set(gca, 'TickDir', 'out')
set(colorbar_handle, 'FontSize', 10)
set(gca, 'FontSize', 10)
colormap(hot)
ylim([0.05 0.25])
clim([-0.15 0.15])
xlim([0 25])
view(2)
shading flat

figure
Z = EPIpsi;
[X, Y] = meshgrid(1/frequency*1000:1/frequency*1000:size(Z, 2)/frequency*1000, 0.05:0.05:0.25);
surf(X, Y, Z);
colorbar_handle = colorbar;
set(gca, 'XTickMode', 'auto', 'YTickMode', 'auto');
set(gca, 'TickDir', 'out')
set(colorbar_handle, 'FontSize', 10)
set(gca, 'FontSize', 10)
colormap(hot)
ylim([0.05 0.25])
clim([-0.15 0.15])
xlim([0 25])
view(2)
shading flat

figure
Z = IPtTongue;
[X, Y] = meshgrid(1/frequency*1000:1/frequency*1000:size(Z, 2)/frequency*1000, 0.05:0.05:0.25);
surf(X, Y, Z);
colorbar_handle = colorbar;
set(gca, 'XTickMode', 'auto', 'YTickMode', 'auto');
set(gca, 'TickDir', 'out')
set(colorbar_handle, 'FontSize', 10)
set(gca, 'FontSize', 10)
colormap(hot)
ylim([0.05 0.25])
clim([-0.15 0.15])
xlim([0 25])
view(2)
shading flat

figure
Z = IPtIpsi;
[X, Y] = meshgrid(1/frequency*1000:1/frequency*1000:size(Z, 2)/frequency*1000, 0.05:0.05:0.25);
surf(X, Y, Z);
colorbar_handle = colorbar;
set(gca, 'XTickMode', 'auto', 'YTickMode', 'auto');
set(gca, 'TickDir', 'out')
set(colorbar_handle, 'FontSize', 10)
set(gca, 'FontSize', 10)
colormap(hot)
ylim([0.05 0.25])
clim([-0.15 0.15])
xlim([0 25])
view(2)
shading flat

figure
Z = EPtTongue;
[X, Y] = meshgrid(1/frequency*1000:1/frequency*1000:size(Z, 2)/frequency*1000, 0.05:0.05:0.25);
surf(X, Y, Z);
colorbar_handle = colorbar;
set(gca, 'XTickMode', 'auto', 'YTickMode', 'auto');
set(gca, 'TickDir', 'out')
set(colorbar_handle, 'FontSize', 10)
set(gca, 'FontSize', 10)
colormap(hot)
ylim([0.05 0.25])
 clim([-0.15 0.15])
 xlim([0 25])
view(2)
shading flat

figure
Z = EPtIpsi;
[X, Y] = meshgrid(1/frequency*1000:1/frequency*1000:size(Z, 2)/frequency*1000, 0.05:0.05:0.25);
surf(X, Y, Z);
colorbar_handle = colorbar;
set(gca, 'XTickMode', 'auto', 'YTickMode', 'auto');
set(gca, 'TickDir', 'out')
set(colorbar_handle, 'FontSize', 10)
set(gca, 'FontSize', 10)
colormap(hot)
ylim([0.05 0.25])
clim([-0.15 0.15])
xlim([0 25])
view(2)
shading flat