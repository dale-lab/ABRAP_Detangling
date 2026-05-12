clear
clc

%Put in folder which has rat number as the name with all the subfiles
filelist = dir('*.mat');
names = {filelist.name};
parnum = numel(names);

%variables

frequency = 26316;

%set up file parts
starts = struct;
ends = struct;
Stim = struct;
RawContra = struct;
RawIpsi = struct;
RawTongue = struct;
[~, name, ~] = fileparts(pwd);
endname = strcat("ABRAPstructure_", name, ".mat");
name = str2double(name);

for j = 1:parnum
    %load file, load variables
    filename = names{j};
    load(filename)
    filename = extractAfter(filename, '_');
    segment = regexp(filename, '\d');
    segment = str2double(filename(segment));
    STIM = strcat(who('*Ch1'), '.values');
    stim = eval(STIM{1});
    if name == 55 || name == 56 || name == 58
        IPSI = strcat(who('*Ch6'), '.values');
        ipsi = eval(IPSI{1});
        CONTRA = strcat(who('*Ch4'), '.values');
        contra = eval(CONTRA{1});
    else
        IPSI = strcat(who('*Ch4'), '.values');
        ipsi = eval(IPSI{1});
        CONTRA = strcat(who('*Ch6'), '.values');
        contra = eval(CONTRA{1});
    end
    TONGUE = strcat(who('*Ch2'), '.values');
    tongue = eval(TONGUE{1});
    if rem(name, 2) == 0
        if segment == 1
            Stim.EP = stim;
            RawIpsi.EP = ipsi;
            RawContra.EP = contra;
            RawTongue.EP = tongue;
        elseif segment == 2
            Stim.IP = stim;
            RawIpsi.IP = ipsi;
            RawContra.IP = contra;
            RawTongue.IP = tongue;
        elseif segment == 4
            Stim.EPt = stim;
            RawIpsi.EPt = ipsi;
            RawContra.EPt = contra;
            RawTongue.EPt = tongue;
        elseif segment == 5
            Stim.IPt = stim;
            RawIpsi.IPt = ipsi;
            RawContra.IPt = contra;
            RawTongue.IPt = tongue;
        end
    end
    if rem(name, 2) == 1
        if segment == 2
            Stim.EP = stim;
            RawIpsi.EP = ipsi;
            RawContra.EP = contra;
            RawTongue.EP = tongue;
        elseif segment == 1
            Stim.IP = stim;
            RawIpsi.IP = ipsi;
            RawContra.IP = contra;
            RawTongue.IP = tongue;
        elseif segment == 5
            Stim.EPt = stim;
            RawIpsi.EPt = ipsi;
            RawContra.EPt = contra;
            RawTongue.EPt = tongue;
        elseif segment == 4
            Stim.IPt = stim;
            RawIpsi.IPt = ipsi;
            RawContra.IPt = contra;
            RawTongue.IPt = tongue;
        end
    end

    if segment == 3
        Stim.OL = stim;
        RawIpsi.OL = ipsi;
        RawContra.OL = contra;
        RawTongue.OL = tongue;
    end

    if segment == 6
        Stim.OLt = stim;
        RawIpsi.OLt = ipsi;
        RawContra.OLt = contra;
        RawTongue.OLt = tongue;
    end

    if segment == 10
        Stim.PRE = stim;
        RawIpsi.PRE = ipsi;
        RawContra.PRE = contra;
        RawTongue.PRE = tongue;
    end
    if segment == 20
        Stim.POST = stim;
        RawIpsi.POST = ipsi;
        RawContra.POST = contra;
        RawTongue.POST = tongue;
    end
    if segment == 30
        Stim.POSTt = stim;
        RawIpsi.POSTt = ipsi;
        RawContra.POSTt = contra;
        RawTongue.POSTt = tongue;
    end
end
tic
save(endname, "Stim", "RawContra", "RawIpsi", "RawTongue", "frequency")
toc