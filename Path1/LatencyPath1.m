clear
clc

%Put in folder which has rat number as the name with all the subfiles
name = '36';


ogfile = strcat('ABRAPstructure_', name, '.mat');
resultsfile = strcat('ABRAPresults_', name, '.mat');
savefile = strcat('ABRAPlatency_', name, '.mat');

load(resultsfile)

RawContra = load(ogfile, 'RawContra');
RawContra = RawContra.RawContra;

frequency = load(ogfile, 'frequency');
frequency = frequency.frequency;

RawIpsi = load(ogfile, 'RawIpsi');
RawIpsi = RawIpsi.RawIpsi;

Stim = load(ogfile, 'Stim');
Stim = Stim.Stim;

numbers = ceil(0.015*frequency);

IPContra = zeros(10, numbers);
EPContra = zeros(10, numbers);

IPIpsi = zeros(10, numbers);
EPIpsi = zeros(10, numbers);

numstim = zeros(1, 10);
for i = 1:numel(IPresults(:, 1))
    ind1 = ceil(IPresults(i, 1)*frequency);
    ind2 = ceil(IPresults(i, 2)*frequency);
    level = round(IPresults(i, 17)/0.025);
    if level > 0 && level <= 10
        for j = ind1:ind2-1
            if Stim.IP(j) > 0.01 && Stim.IP(j+1) <= 0.01
                numstim(1, level) = numstim(1, level) + 1;
                IPContra(level, :) = IPContra(level, :) + transpose(RawContra.IP(j+1:j+numbers, 1));
                IPIpsi(level, :) = IPIpsi(level, :) + transpose(RawIpsi.IP(j+1:j+numbers, 1));
            end
        end
    end
end

for k = 1:10
    IPIpsi(k, :) = IPIpsi(k, :)/numstim(1, k);
    IPContra(k, :) = IPContra(k, :)/numstim(1, k);
end


numstim = zeros(1, 10);
for i = 1:numel(EPresults(:, 1))
    ind1 = ceil(EPresults(i, 2)*frequency);
    ind2 = ceil(EPresults(i, 2)*frequency+EPresults(i, 4)*frequency);
    level = round(EPresults(i, 17)/0.025);
    if level > 0 && level <= 10
        for j = ind1:ind2-1
            if Stim.EP(j) > 0.01 && Stim.EP(j+1) <= 0.01
                numstim(1, level) = numstim(1, level) + 1;
                EPContra(level, :) = EPContra(level, :) + transpose(RawContra.EP(j+1:j+numbers, 1));
                EPIpsi(level, :) = EPIpsi(level, :) + transpose(RawIpsi.EP(j+1:j+numbers, 1));
            end
        end
    end
end

for k = 1:10
    EPIpsi(k, :) = EPIpsi(k, :)/numstim(1, k);
    EPContra(k, :) = EPContra(k, :)/numstim(1, k);
end

save(savefile, 'IPIpsi', 'IPContra', 'EPIpsi', 'EPContra')

figure
Z = IPContra;
[X, Y] = meshgrid(1/frequency:1/frequency:size(Z, 2)/frequency, 0.025:0.025:0.25);
surf(X, Y, Z);
colorbar
colormap(turbo)
ylim([0.025 0.25])
clim([-0.25 0.25])
view(2)
shading flat

figure
Z = IPIpsi;
[X, Y] = meshgrid(1/frequency:1/frequency:size(Z, 2)/frequency, 0.025:0.025:0.25);
surf(X, Y, Z);
colorbar
colormap(turbo)
ylim([0.025 0.25])
clim([-0.25 0.25])
view(2)
shading flat

figure
Z = EPContra;
[X, Y] = meshgrid(1/frequency:1/frequency:size(Z, 2)/frequency, 0.025:0.025:0.25);
surf(X, Y, Z);
colorbar
colormap(turbo)
ylim([0.025 0.25])
clim([-0.25 0.25])
view(2)
shading flat

figure
Z = EPIpsi;
[X, Y] = meshgrid(1/frequency:1/frequency:size(Z, 2)/frequency, 0.025:0.025:0.25);
surf(X, Y, Z);
colorbar
colormap(turbo)
ylim([0.025 0.25])
clim([-0.25 0.25])
view(2)
shading flat