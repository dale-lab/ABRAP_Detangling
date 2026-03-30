clear
clc

filelist = dir('*.mat');
names = {filelist.name};

parnum = numel(names);

for j = 1:parnum
    filename = names{j};
    segment = regexp(filename, '\d');
    segment = str2double(filename(segment));
    load(filename)

    frequency = 25000;
    
    STIM = strcat(who('*Ch1'), '.values');
    stim = eval(STIM{1});
    CONTRA = strcat(who('*Ch2'), '.values');
    contra = eval(CONTRA{1});
    IPSI = strcat(who('*Ch4'), '.values');
    ipsi = eval(IPSI{1});
    PRESSURE = strcat(who('*Ch8'), '.values');
    pressure = eval(PRESSURE{1});
    CO2 = strcat(who('*Ch10'), '.values');
    co2 = eval(CO2{1});
    time = transpose(1/frequency:1/frequency:numel(contra)/frequency);
    
    clear AO*

    count = 1;
    for i = 1:numel(stim)-1
        if stim(i) >= 0.02 && stim(i + 1) < 0.02
            stimind(count) = i;
            count = count + 1;
        end
    end

    if segment == 31 || segment == 82 || segment == 123
        values = zeros(numel(stimind), 1);
        for i = 1:numel(stimind)
            high = 0;
            for j = stimind(i)-10:stimind(i)
                if stim(j) > high
                    high = stim(j);
                end
            end
            values(i) = high;
        end
        values = round(values/0.05);
        if segment == 31
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            MEPs1 = zeros(40, 525);
            MEPs1Contra = zeros(40, 525);
            level = 1;
            i = 1;
            count = 0;
            while i <= numel(values) && level <= 31
                while i <= numel(values) && values(i) == level && level <= 31
                    k = stimind(i);
                    MEPs1(level, 1:525) = MEPs1(level, 1:525) + ipsi(1, k:k+524);
                    MEPs1Contra(level, 1:525) = MEPs1Contra(level, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                MEPs1(level, :) = MEPs1(level, :)/count;
                MEPs1Contra(level, :) = MEPs1Contra(level, :)/count;
                level = level + 1;
                count = 0;
            end
        elseif segment == 82
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            MEPs2 = zeros(40, 525);
            MEPs2Contra = zeros(40, 525);
            level = 1;
            i = 1;
            count = 0;
            while i <= numel(values) && level <= 31
                while i <= numel(values) && values(i) == level && level <= 31
                    k = stimind(i);
                    MEPs2(level, 1:525) = MEPs2(level, 1:525) + ipsi(1, k:k+524);
                    MEPs2Contra(level, 1:525) = MEPs2Contra(level, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                MEPs2(level, :) = MEPs2(level, :)/count;
                MEPs2Contra(level, :) = MEPs2Contra(level, :)/count;
                level = level + 1;
                count = 0;
            end
        elseif segment == 123
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            MEPs3 = zeros(40, 525);
            MEPs3Contra = zeros(40, 525);
            level = 1;
            i = 1;
            count = 0;
            while i <= numel(values) && level <= 31
                while i <= numel(values) && values(i) == level && level <= 31
                    k = stimind(i);
                    MEPs3(level, 1:525) = MEPs3(level, 1:525) + ipsi(1, k:k+524);
                    MEPs3Contra(level, 1:525) = MEPs3Contra(level, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                MEPs3(level, :) = MEPs3(level, :)/count;
                MEPs3Contra(level, :) = MEPs3Contra(level, :)/count;
                level = level + 1;
                count = 0;
            end
        end
    end

    if segment == 51 || segment == 62 || segment == 73 || segment == 94 || segment == 105 || segment == 116
        try
        if segment == 51
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            Stim1 = zeros(30, 525);
            Stim1Contra = zeros(30, 525);
            starttime = 1;
            i = 1;
            count = 0;
            while i <= numel(stimind) && starttime <= 30
                while i <= numel(stimind) && time(stimind(i)) >= (starttime-1)*10 && time(stimind(i)) < starttime*10 && starttime <= 30
                    k = stimind(i);
                    Stim1(starttime, 1:525) = Stim1(starttime, 1:525) + ipsi(1, k:k+524);
                    Stim1Contra(starttime, 1:525) = Stim1Contra(starttime, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                Stim1(starttime, :) = Stim1(starttime, :)/count;
                Stim1Contra(starttime, :) = Stim1Contra(starttime, :)/count;
                starttime = starttime + 1;
                count = 0;
            end
        elseif segment == 62
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            Stim2 = zeros(30, 525);
            Stim2Contra = zeros(30, 525);
            starttime = 1;
            i = 1;
            count = 0;
            while i <= numel(stimind) && starttime <= 30
                while i <= numel(stimind) && time(stimind(i)) >= (starttime-1)*10 && time(stimind(i)) < starttime*10 && starttime <= 30
                    k = stimind(i);
                    Stim2(starttime, 1:525) = Stim2(starttime, 1:525) + ipsi(1, k:k+524);
                    Stim2Contra(starttime, 1:525) = Stim2Contra(starttime, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                Stim2(starttime, :) = Stim2(starttime, :)/count;
                Stim2Contra(starttime, :) = Stim2Contra(starttime, :)/count;
                starttime = starttime + 1;
                count = 0;
            end
        elseif segment == 73
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            Stim3 = zeros(30, 525);
            Stim3Contra = zeros(30, 525);
            starttime = 1;
            i = 1;
            count = 0;
            while i <= numel(stimind) && starttime <= 30
                while i <= numel(stimind) && time(stimind(i)) >= (starttime-1)*10 && time(stimind(i)) < starttime*10 && starttime <= 30
                    k = stimind(i);
                    Stim3(starttime, 1:525) = Stim3(starttime, 1:525) + ipsi(1, k:k+524);
                    Stim3Contra(starttime, 1:525) = Stim3Contra(starttime, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                Stim3(starttime, :) = Stim3(starttime, :)/count;
                Stim3Contra(starttime, :) = Stim3Contra(starttime, :)/count;
                starttime = starttime + 1;
                count = 0;
            end
        elseif segment == 94
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            Stim4 = zeros(30, 525);
            Stim4Contra = zeros(30, 525);
            starttime = 1;
            i = 1;
            count = 0;
            while i <= numel(stimind) && starttime <= 30
                while i <= numel(stimind) && time(stimind(i)) >= (starttime-1)*10 && time(stimind(i)) < starttime*10 && starttime <= 30
                    k = stimind(i);
                    Stim4(starttime, 1:525) = Stim4(starttime, 1:525) + ipsi(1, k:k+524);
                    Stim4Contra(starttime, 1:525) = Stim4Contra(starttime, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                Stim4(starttime, :) = Stim4(starttime, :)/count;
                Stim4Contra(starttime, :) = Stim4Contra(starttime, :)/count;
                starttime = starttime + 1;
                count = 0;
            end
        elseif segment == 105
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            Stim5 = zeros(30, 525);
            Stim5Contra = zeros(30, 525);
            starttime = 1;
            i = 1;
            count = 0;
            while i <= numel(stimind) && starttime <= 30
                while i <= numel(stimind) && time(stimind(i)) >= (starttime-1)*10 && time(stimind(i)) < starttime*10 && starttime <= 30
                    k = stimind(i);
                    Stim5(starttime, 1:525) = Stim5(starttime, 1:525) + ipsi(1, k:k+524);
                    Stim5Contra(starttime, 1:525) = Stim5Contra(starttime, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                Stim5(starttime, :) = Stim5(starttime, :)/count;
                Stim5Contra(starttime, :) = Stim5Contra(starttime, :)/count;
                starttime = starttime + 1;
                count = 0;
            end
        elseif segment == 116
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            Stim6 = zeros(30, 525);
            Stim6Contra = zeros(30, 525);
            starttime = 1;
            i = 1;
            count = 0;
            while i <= numel(stimind) && starttime <= 30
                while i <= numel(stimind) && time(stimind(i)) >= (starttime-1)*10 && time(stimind(i)) < starttime*10 && starttime <= 30
                    k = stimind(i);
                    Stim6(starttime, 1:525) = Stim6(starttime, 1:525) + ipsi(1, k:k+524);
                    Stim6Contra(starttime, 1:525) = Stim6Contra(starttime, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                Stim6(starttime, :) = Stim6(starttime, :)/count;
                Stim6Contra(starttime, :) = Stim6Contra(starttime, :)/count;
                starttime = starttime + 1;
                count = 0;
            end
        end
        catch
        end
    end

    clear co2 CO2 contra CONTRA count high i ipsi IPSI j filelist file pressure PRESSURE segment stim STIM stimind time values



end

time = 1/frequency:1/frequency:0.021;
time = time*1000;
z = 0.05:0.05:1.6;
z = transpose(z);
y = MEPs1(1:32, 1:525);

try
tiledlayout(2, 1)
nexttile
[X, Z] = meshgrid(time, z);
surf(X, Z, y);
caxis([-0.1 0.1])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Current (mA)')
title('Ipsilesional PreStim')
view ([0 0 90])

nexttile
y = MEPs1Contra(1:32, 1:525);
surf(X, Z, y);
caxis([-0.1 0.1])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Current (mA)')
title('Contralesional PreStim')
view ([0 0 90])
colorbar

x = 0;
catch
end

try
tiledlayout(2, 1)
nexttile
y = MEPs2(1:32, 1:525);
surf(X, Z, y);
caxis([-0.1 0.1])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Current (mA)')
title('Ipsilesional MidStim')
view ([0 0 90])

nexttile
y = MEPs2Contra(1:32, 1:525);
surf(X, Z, y);
caxis([-0.1 0.1])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Current (mA)')
title('Contralesional MidStim')
view ([0 0 90])
colorbar

x = 0;
catch
end

try
tiledlayout(2, 1)
nexttile
y = MEPs3(1:32, 1:525);
surf(X, Z, y);
caxis([-0.1 0.1])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Current (mA)')
title('Ipsilesional PostStim')
view ([0 0 90])


nexttile
y = MEPs3Contra(1:32, 1:525);
surf(X, Z, y);
colorbar
caxis([-0.1 0.1])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Current (mA)')
title('Contralesional PostStim')
view ([0 0 90])
colorbar

x = 0;
catch 
end

try
time = 1/frequency:1/frequency:0.021;
time = time*1000;
z = 10:10:300;
z = transpose(z);
y = Stim1(1:30, 1:525);

tiledlayout(2, 1)
nexttile
[X, Z] = meshgrid(time, z);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Current (mA)')
title('Ipsilesional Stim1')
view ([0 0 90])

nexttile
y = Stim1Contra(1:30, 1:525);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Time (s)')
title('Contralesional Stim1')
view ([0 0 90])
colorbar

x = 0;
catch
end

try
tiledlayout(2, 1)
nexttile
y = Stim2(1:30, 1:525);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Time (s)')
title('Ipsilesional Stim2')
view ([0 0 90])

nexttile
y = Stim2Contra(1:30, 1:525);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Time (s)')
title('Contralesional Stim2')
view ([0 0 90])
colorbar

x = 0;
catch
end

try
tiledlayout(2, 1)
nexttile
y = Stim3(1:30, 1:525);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Time (s)')
title('Ipsilesional Stim3')
view ([0 0 90])

nexttile
y = Stim3Contra(1:30, 1:525);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Time (s)')
title('Contralesional Stim3')
view ([0 0 90])
colorbar

x = 0;
catch
end

try
tiledlayout(2, 1)
nexttile
y = Stim4(1:30, 1:525);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Time (s)')
title('Ipsilesional Stim4')
view ([0 0 90])

nexttile
y = Stim4Contra(1:30, 1:525);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Time (s)')
title('Contralesional Stim4')
view ([0 0 90])
colorbar

x = 0;
catch
end

try
tiledlayout(2, 1)
nexttile
y = Stim5(1:30, 1:525);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Time (s)')
title('Ipsilesional Stim5')
view ([0 0 90])

nexttile
y = Stim5Contra(1:30, 1:525);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Time (s)')
title('Contralesional Stim5')
view ([0 0 90])
colorbar

x = 0;
catch
end

try
tiledlayout(2, 1)
nexttile
y = Stim6(1:30, 1:525);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Time (s)')
title('Ipsilesional Stim6')
view ([0 0 90])

nexttile
y = Stim6Contra(1:30, 1:525);
surf(X, Z, y);
caxis([-0.01 0.01])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Time (s)')
title('Contralesional Stim6')
view ([0 0 90])
colorbar

x = 0;
catch
end

try
save('Analyzed.mat', 'Stim1', 'Stim1Contra')
catch
end
try
    save('Analyzed.mat', 'Stim2', 'Stim2Contra', '-append')
catch
end
try
    save('Analyzed.mat', 'Stim3', 'Stim3Contra', '-append')
catch
end
try
    save('Analyzed.mat', 'Stim4', 'Stim4Contra', '-append')
catch
end
try
    save('Analyzed.mat', 'Stim5', 'Stim5Contra', '-append')
catch
end
try
    save('Analyzed.mat', 'Stim6', 'Stim6Contra', '-append')
catch
end
try
    save('Analyzed.mat', 'MEPs1', 'MEPs1Contra', '-append')
catch
end
try
    save('Analyzed.mat', 'MEPs2', 'MEPs2Contra', '-append')
catch
end
try
    save('Analyzed.mat', 'MEPs3', 'MEPs3Contra', '-append')
catch
end
