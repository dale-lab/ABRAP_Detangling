clear
clc

%Put in folder which has rat number as the name with all the subfiles
filelist = dir('*.mat');
names = {filelist.name};
parnum = numel(names);

%variables
parameters = [0.031, 0.05, 0.4, 0.7, 3, 0.05, 1, 1];
frequency = 25000;

%set up file parts
starts = struct;
ends = struct;
Stim = struct;
RawContra = struct;
RawIpsi = struct;
[~, name, ~] = fileparts(pwd);
endname = strcat("ABRAPstructure_", name, ".mat");
name = str2double(name);

for j = 1:parnum
    %load file, load variables
    filename = names{j};
    load(filename)
    segment = regexp(filename, '\d');
    segment = str2double(filename(segment));
    STIM = strcat(who('*Ch1'), '.values');
    stim = eval(STIM{1});
    IPSI = strcat(who('*Ch4'), '.values');
    ipsi = eval(IPSI{1});
    CONTRA = strcat(who('*Ch2'), '.values');
    contra = eval(CONTRA{1});
    if rem(name, 2) == 0
        if segment == 31
            Stim.EP = stim;
            RawIpsi.EP = ipsi;
            RawContra.EP = contra;
        elseif segment == 42
            Stim.IP = stim;
            RawIpsi.IP = ipsi;
            RawContra.IP = contra;
        end
    end
    if rem(name, 2) == 1
        if segment == 42
            Stim.EP = stim;
            RawIpsi.EP = ipsi;
            RawContra.EP = contra;
        elseif segment == 31
            Stim.IP = stim;
            RawIpsi.IP = ipsi;
            RawContra.IP = contra;
        end
    end
    if segment == 1
        Stim.PRE = stim;
        RawIpsi.PRE = ipsi;
        RawContra.PRE = contra;
    end
    if segment == 2
        Stim.POST = stim;
        RawIpsi.POST = ipsi;
        RawContra.POST = contra;
    end
end

save(endname, "Stim", "RawContra", "RawIpsi", "frequency")
