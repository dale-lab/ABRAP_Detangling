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
MATongue = struct;

for j = 1:parnum
    tic
    filename = names{j};
    load(filename)
    name = extractAfter(filename, "structure_");
    finalname = strcat("ABRAPanalyzed_", name);

    OOP = 0;

    if isfield(RawIpsi, 'PRE') == 1
        contra = RawContra.PRE;
        ipsi = RawIpsi.PRE;
        tongue = RawTongue.PRE;
        stim = Stim.PRE;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contra, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsi, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2(parameters, tongue, tonguetimes);
        characteristics_T = Run4_AO_findevents(stim, parameters, structure_T, OOP);
        MAContra.PRE = structure_L.RMSsgfilt;
        MAIpsi.PRE = structure_R.RMSsgfilt;
        MATongue.PRE = structure_T.RMSsgfilt;
        starts.PRE = characteristics_T.STARTtimes;
        ends.PRE = characteristics_T.ENDtimes;
    else
        x = 'No PRE'
        filename

    end

    if isfield(RawIpsi, 'POST') == 1
        contra = RawContra.POST;
        ipsi = RawIpsi.POST;
        tongue = RawTongue.POST;
        stim = Stim.POST;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contra, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsi, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2(parameters, tongue, tonguetimes);
        characteristics_T = Run4_AO_findevents(stim, parameters, structure_T, OOP);
        MAContra.POST = structure_L.RMSsgfilt;
        MAIpsi.POST = structure_R.RMSsgfilt;
        MATongue.POST = structure_T.RMSsgfilt;
        starts.POST = characteristics_T.STARTtimes;
        ends.POST = characteristics_T.ENDtimes;
    else
        x = 'No POST'
        filename

    end

    if isfield(RawIpsi, 'POSTt') == 1
        contra = RawContra.POSTt;
        ipsi = RawIpsi.POSTt;
        tongue = RawTongue.POSTt;
        stim = Stim.POSTt;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contra, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsi, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2(parameters, tongue, tonguetimes);
        characteristics_T = Run4_AO_findevents(stim, parameters, structure_T, OOP);
        MAContra.POSTt = structure_L.RMSsgfilt;
        MAIpsi.POSTt = structure_R.RMSsgfilt;
        MATongue.POSTt = structure_T.RMSsgfilt;
        starts.POSTt = characteristics_T.STARTtimes;
        ends.POSTt = characteristics_T.ENDtimes;
    else
        x = 'No POSTt'
        filename

    end

    if isfield(RawIpsi, 'IP') == 1
    contra = RawContra.IP;
    ipsi = RawIpsi.IP;
    tongue = RawTongue.IP;
    stim = Stim.IP;
    contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
    ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
    tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
    structure_L = Run3_AO_RMSonly(parameters, contra, contratimes);
    structure_R = Run3_AO_RMSonly(parameters, ipsi, ipsitimes);
    structure_T = Run3_AO_thresholds_Path2(parameters, tongue, tonguetimes);
    characteristics_T = Run4_AO_findevents(stim, parameters, structure_T, OOP);
    MAContra.IP = structure_L.RMSsgfilt;
    MAIpsi.IP = structure_R.RMSsgfilt;
    MATongue.IP = structure_T.RMSsgfilt;
    starts.IP = characteristics_T.STARTtimes;
    ends.IP = characteristics_T.ENDtimes;
    else
        x = 'No IP'
        filename

    end

    if isfield(RawIpsi, 'IPt') == 1
        contra = RawContra.IPt;
        ipsi = RawIpsi.IPt;
        tongue = RawTongue.IPt;
        stim = Stim.IPt;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contra, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsi, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2(parameters, tongue, tonguetimes);
        characteristics_T = Run4_AO_findevents(stim, parameters, structure_T, OOP);
        MAContra.IPt = structure_L.RMSsgfilt;
        MAIpsi.IPt = structure_R.RMSsgfilt;
        MATongue.IPt = structure_T.RMSsgfilt;
        starts.IPt = characteristics_T.STARTtimes;
        ends.IPt = characteristics_T.ENDtimes;
    else
        x = 'No IPt'
        filename

    end

    if isfield(RawIpsi, 'OL') == 1
        contra = RawContra.OL;
        ipsi = RawIpsi.OL;
        tongue = RawTongue.OL;
        stim = Stim.OL;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contra, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsi, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2(parameters, tongue, tonguetimes);
        characteristics_T = Run4_AO_findevents(stim, parameters, structure_T, OOP);
        MAContra.OL = structure_L.RMSsgfilt;
        MAIpsi.OL = structure_R.RMSsgfilt;
        MATongue.OL = structure_T.RMSsgfilt;
        starts.OL = characteristics_T.STARTtimes;
        ends.OL = characteristics_T.ENDtimes;
    else
        x = 'No OL'
        filename

    end

    if isfield(RawIpsi, 'OLt') == 1
        contra = RawContra.OLt;
        ipsi = RawIpsi.OLt;
        tongue = RawTongue.OLt;
        stim = Stim.OLt;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contra, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsi, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2(parameters, tongue, tonguetimes);
        characteristics_T = Run4_AO_findevents(stim, parameters, structure_T, OOP);
        MAContra.OLt = structure_L.RMSsgfilt;
        MAIpsi.OLt = structure_R.RMSsgfilt;
        MATongue.OLt = structure_T.RMSsgfilt;
        starts.OLt = characteristics_T.STARTtimes;
        ends.OLt = characteristics_T.ENDtimes;
    else
        x = 'No OLt'
        filename

    end
    
    OOP = 1;

    if isfield(RawIpsi, 'EP') == 1
        contra = RawContra.EP;
        ipsi = RawIpsi.EP;
        tongue = RawTongue.EP;
        stim = Stim.EP;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contra, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsi, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2(parameters, tongue, tonguetimes);
        characteristics_T = Run4_AO_findevents(stim, parameters, structure_T, OOP);
        MAContra.EP = structure_L.RMSsgfilt;
        MAIpsi.EP = structure_R.RMSsgfilt;
        MATongue.EP = structure_T.RMSsgfilt;
        starts.EP = characteristics_T.STARTtimes;
        ends.EP = characteristics_T.ENDtimes;
    else
        x = 'No EP'
        filename

    end

    if isfield(RawIpsi, 'EPt') == 1
        contra = RawContra.EPt;
        ipsi = RawIpsi.EPt;
        tongue = RawTongue.EPt;
        stim = Stim.EPt;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contra, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsi, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2(parameters, tongue, tonguetimes);
        characteristics_T = Run4_AO_findevents(stim, parameters, structure_T, OOP);
        MAContra.EPt = structure_L.RMSsgfilt;
        MAIpsi.EPt = structure_R.RMSsgfilt;
        MATongue.EPt = structure_T.RMSsgfilt;
        starts.EPt = characteristics_T.STARTtimes;
        ends.EPt = characteristics_T.ENDtimes;
    else
        x = 'No EPt'
        filename

    end

    save(finalname, "MAContra", "MAIpsi", "MATongue", "starts", "ends", "frequency");
    toc

end





