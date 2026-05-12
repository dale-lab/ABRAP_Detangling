clear
clc
tic
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
    stimtype = filename(1);
    STIM = strcat(who('*Ch1'), '.values');
    stim = eval(STIM{1});
    IPSI = strcat(who('*Ch4'), '.values');
    ipsi = eval(IPSI{1});
    CONTRA = strcat(who('*Ch6'), '.values');
    contra = eval(CONTRA{1});
    TONGUE = strcat(who('*Ch2'), '.values');
    tongue = eval(TONGUE{1});
    if segment == 1
        if stimtype == 'b'
            Stim.PRE = stim;
            RawIpsi.PRE = ipsi;
            RawContra.PRE = contra;
            RawTongue.PRE = tongue;
        elseif stimtype == 'I'
            Stim.IP = stim;
            RawIpsi.IP = ipsi;
            RawContra.IP = contra;
            RawTongue.IP = tongue;
        elseif stimtype == 'O'
            Stim.EP = stim;
            RawIpsi.EP = ipsi;
            RawContra.EP = contra;
            RawTongue.EP = tongue;
        elseif stimtype == 'C'
            Stim.OL = stim;
            RawIpsi.OL = ipsi;
            RawContra.OL = contra;
            RawTongue.OL = tongue;
        end
    end

    if segment == 2
        if stimtype == 'b'
            Stim.PREptx = stim;
            RawIpsi.PREptx = ipsi;
            RawContra.PREptx = contra;
            RawTongue.PREptx = tongue;
        elseif stimtype == 'I'
            Stim.IPptx = stim;
            RawIpsi.IPptx = ipsi;
            RawContra.IPptx = contra;
            RawTongue.IPptx = tongue;
        elseif stimtype == 'O'
            Stim.EPptx = stim;
            RawIpsi.EPptx = ipsi;
            RawContra.EPptx = contra;
            RawTongue.EPptx = tongue;
        elseif stimtype == 'C'
            Stim.OLptx = stim;
            RawIpsi.OLptx = ipsi;
            RawContra.OLptx = contra;
            RawTongue.OLptx = tongue;
        end
    end
   
end

save(endname, "Stim", "RawContra", "RawIpsi", "RawTongue", "frequency")
toc