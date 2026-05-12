clear
clc

%Put in folder which has rat number as the name with all the subfiles
filelist = dir('*.mat');
names = {filelist.name};
parnum = numel(names);

%variables
parameters = [0.031, 0.05, 0.4, 0.7, 3, 0.05, 1, 1];

MAContra = struct;
MAIpsi = struct;

for j = 1:parnum
    tic
    filename = names{j};
    load(filename)
    name = extractAfter(filename, "structure_");
    finalname = strcat("ABRAPanalyzed_", name);

    OOP = 0;
    contra = RawContra.PRE;
    ipsi = RawIpsi.PRE;
    stim = Stim.PRE;
    contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
    ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
    structure_L = Run3_AO_thresholds(parameters, contra, contratimes);
    structure_R = Run3_AO_thresholds(parameters, ipsi, ipsitimes);
    characteristics_L = Run4_AO_findevents(stim, parameters, structure_L, OOP);
    MAContra.PRE = structure_L.RMSsgfilt;
    MAIpsi.PRE = structure_R.RMSsgfilt;
    starts.PRE = characteristics_L.STARTtimes;
    ends.PRE = characteristics_L.ENDtimes;

    contra = RawContra.POST;
    ipsi = RawIpsi.POST;
    stim = Stim.POST;
    contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
    ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
    structure_L = Run3_AO_thresholds(parameters, contra, contratimes);
    structure_R = Run3_AO_thresholds(parameters, ipsi, ipsitimes);
    characteristics_L = Run4_AO_findevents(stim, parameters, structure_L, OOP);
    MAContra.POST = structure_L.RMSsgfilt;
    MAIpsi.POST = structure_R.RMSsgfilt;
    starts.POST = characteristics_L.STARTtimes;
    ends.POST = characteristics_L.ENDtimes;

    contra = RawContra.IP;
    ipsi = RawIpsi.IP;
    stim = Stim.IP;
    contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
    ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
    structure_L = Run3_AO_thresholds(parameters, contra, contratimes);
    structure_R = Run3_AO_thresholds(parameters, ipsi, ipsitimes);
    characteristics_L = Run4_AO_findevents(stim, parameters, structure_L, OOP);
    MAContra.IP = structure_L.RMSsgfilt;
    MAIpsi.IP = structure_R.RMSsgfilt;
    starts.IP = characteristics_L.STARTtimes;
    ends.IP = characteristics_L.ENDtimes;

    OOP = 1;
    contra = RawContra.EP;
    ipsi = RawIpsi.EP;
    stim = Stim.EP;
    contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
    ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
    structure_L = Run3_AO_thresholds(parameters, contra, contratimes);
    structure_R = Run3_AO_thresholds(parameters, ipsi, ipsitimes);
    characteristics_L = Run4_AO_findevents(stim, parameters, structure_L, OOP);
    MAContra.EP = structure_L.RMSsgfilt;
    MAIpsi.EP = structure_R.RMSsgfilt;
    starts.EP = characteristics_L.STARTtimes;
    ends.EP = characteristics_L.ENDtimes;

    save(finalname, "MAContra", "MAIpsi", "starts", "ends", "frequency");
    toc

end





