clear
clc

filelist = dir('*.mat');
names = {filelist.name};

parnum = numel(names);
parameters = [0.031, 0.05, 0.4, 0.7, 3, 0.05, 1, 1];
frequency = 25000;


MAContra = struct;
MAIpsi = struct;
starts = struct;
ends = struct;
Stim = struct;
RawContra = struct;
RawIpsi = struct;
[~, name, ~] = fileparts(pwd);
endname = strcat("ABRAP_", name, ".mat");
name = str2double(name);
tic

for j = 1:parnum
    filename = names{j};
    load(filename)
    segment = regexp(filename, '\d');
    segment = str2double(filename(segment));
    STIM = strcat(who('*Ch1'), '.values');
    stim = eval(STIM{1});
    CONTRA = strcat(who('*Ch2'), '.values');
    contra = eval(CONTRA{1});
    IPSI = strcat(who('*Ch4'), '.values');
    ipsi = eval(IPSI{1});
    contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
    ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
    structure_L = AO_thresholds(parameters, contra, contratimes);
    structure_R = AO_thresholds(parameters, ipsi, ipsitimes);
    characteristics_L = AO_findevents(parameters, structure_L);
    % hold off
    % plot(contratimes, contra)
    % hold on
    % xlim([0 1000])
    % plot(contratimes, structure_L.RMSsgfilt)
    % plot(contratimes, structure_L.THRESHOLD)
    % zerovals = zeros(numel(characteristics_L.STARTtimes), 1);
    % plot(characteristics_L.STARTtimes, zerovals, '*')
    % plot(characteristics_L.ENDtimes, zerovals, '*')

    if segment == 1
        MAContra.PRE = structure_L.RMSsgfilt;
        MAIpsi.PRE = structure_R.RMSsgfilt;
        starts.PRE = characteristics_L.STARTtimes;
        ends.PRE = characteristics_L.ENDtimes;
        Stim.PRE = stim;
        RawContra.PRE = contra;
        RawIpsi.PRE = ipsi;
    end

    if segment == 2
        MAContra.POST = structure_L.RMSsgfilt;
        MAIpsi.POST = structure_R.RMSsgfilt;
        starts.POST = characteristics_L.STARTtimes;
        ends.POST = characteristics_L.ENDtimes;
        Stim.POST = stim;
        RawContra.POST = contra;
        RawIpsi.POST = ipsi;
    end

    if segment == 31
        if rem(name, 2) == 1
            MAContra.IP = structure_L.RMSsgfilt;
            MAIpsi.IP = structure_R.RMSsgfilt;
            starts.IP = characteristics_L.STARTtimes;
            ends.IP = characteristics_L.ENDtimes;
            Stim.IP = stim;
            RawContra.IP = contra;
            RawIpsi.IP = ipsi;
        end
        if rem(name, 2) == 0
            MAContra.OOP = structure_L.RMSsgfilt;
            MAIpsi.OOP = structure_R.RMSsgfilt;
            starts.OOP = characteristics_L.STARTtimes;
            ends.OOP = characteristics_L.ENDtimes;
            Stim.OOP = stim;
            RawContra.OOP = contra;
            RawIpsi.OOP = ipsi;
        end
    end

    if segment == 42
        if rem(name, 2) == 0
            MAContra.IP = structure_L.RMSsgfilt;
            MAIpsi.IP = structure_R.RMSsgfilt;
            starts.IP = characteristics_L.STARTtimes;
            ends.IP = characteristics_L.ENDtimes;
            Stim.IP = stim;
            RawContra.IP = contra;
            RawIpsi.IP = ipsi;
        end
        if rem(name, 2) == 1
            MAContra.OOP = structure_L.RMSsgfilt;
            MAIpsi.OOP = structure_R.RMSsgfilt;
            starts.OOP = characteristics_L.STARTtimes;
            ends.OOP = characteristics_L.ENDtimes;
            Stim.OOP = stim;
            RawContra.OOP = contra;
            RawIpsi.OOP = ipsi;
        end
    end

    if segment == 5
        MAContra.FREQUENCY = structure_L.RMSsgfilt;
        MAIpsi.FREQUENCY = structure_R.RMSsgfilt;
        starts.FREQUENCY = characteristics_L.STARTtimes;
        ends.FREQUENCY = characteristics_L.ENDtimes;
        Stim.FREQUENCY = stim;
        RawContra.FREQUENCY = contra;
        RawIpsi.FREQUENCY = ipsi;
    end

end

toc

tic
save(endname, "MAContra", "MAIpsi", "starts", "ends", "Stim", "RawContra", "RawIpsi")

toc