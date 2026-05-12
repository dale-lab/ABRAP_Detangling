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
        contrablank = PTX_BlankStim(contra, stim);
        ipsiblank = PTX_BlankStim(ipsi, stim);
        tongueblank = PTX_BlankStim(tongue, stim);
        RawTongue.PRE = tongueblank;
        RawIpsi.PRE = ipsiblank;
        RawContra.PRE = contrablank;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contrablank, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsiblank, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2_PTX(parameters, tongueblank, tonguetimes);
        characteristics_T = Run4_AO_findevents_PTX(stim, parameters, structure_T, OOP);
        MAContra.PRE = structure_L.RMSsgfilt;
        MAIpsi.PRE = structure_R.RMSsgfilt;
        MATongue.PRE = structure_T.RMSsgfilt;
        starts.PRE = characteristics_T.STARTtimes;
        ends.PRE = characteristics_T.ENDtimes;
    else
        x = 'No PRE'
        filename

    end

    if isfield(RawIpsi, 'PREptx') == 1
        contra = RawContra.PREptx;
        ipsi = RawIpsi.PREptx;
        tongue = RawTongue.PREptx;
        stim = Stim.PREptx;
        contrablank = PTX_BlankStim(contra, stim);
        ipsiblank = PTX_BlankStim(ipsi, stim);
        tongueblank = PTX_BlankStim(tongue, stim);
        RawTongue.PREptx = tongueblank;
        RawIpsi.PREptx = ipsiblank;
        RawContra.PREptx = contrablank;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contrablank, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsiblank, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2_PTX(parameters, tongueblank, tonguetimes);
        characteristics_T = Run4_AO_findevents_PTX(stim, parameters, structure_T, OOP);
        MAContra.PREptx = structure_L.RMSsgfilt;
        MAIpsi.PREptx = structure_R.RMSsgfilt;
        MATongue.PREptx = structure_T.RMSsgfilt;
        starts.PREptx = characteristics_T.STARTtimes;
        ends.PREptx = characteristics_T.ENDtimes;
    else
        x = 'No PREptx'
        filename

    end

    if isfield(RawIpsi, 'IP') == 1
        contra = RawContra.IP;
        ipsi = RawIpsi.IP;
        tongue = RawTongue.IP;
        stim = Stim.IP;
        contrablank = PTX_BlankStim(contra, stim);
        ipsiblank = PTX_BlankStim(ipsi, stim);
        tongueblank = PTX_BlankStim(tongue, stim);
        RawTongue.IP = tongueblank;
        RawIpsi.IP = ipsiblank;
        RawContra.IP = contrablank;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contrablank, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsiblank, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2_PTX(parameters, tongueblank, tonguetimes);
        characteristics_T = Run4_AO_findevents_PTX(stim, parameters, structure_T, OOP);
        MAContra.IP = structure_L.RMSsgfilt;
        MAIpsi.IP = structure_R.RMSsgfilt;
        MATongue.IP = structure_T.RMSsgfilt;
        starts.IP = characteristics_T.STARTtimes;
        ends.IP = characteristics_T.ENDtimes;
    else
        x = 'No IP'
        filename

    end

    if isfield(RawIpsi, 'IPptx') == 1
        contra = RawContra.IPptx;
        ipsi = RawIpsi.IPptx;
        tongue = RawTongue.IPptx;
        stim = Stim.IPptx;
        contrablank = PTX_BlankStim(contra, stim);
        ipsiblank = PTX_BlankStim(ipsi, stim);
        tongueblank = PTX_BlankStim(tongue, stim);
        RawTongue.IPptx = tongueblank;
        RawIpsi.IPptx = ipsiblank;
        RawContra.IPptx = contrablank;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contrablank, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsiblank, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2_PTX(parameters, tongueblank, tonguetimes);
        characteristics_T = Run4_AO_findevents_PTX(stim, parameters, structure_T, OOP);
        MAContra.IPptx = structure_L.RMSsgfilt;
        MAIpsi.IPptx = structure_R.RMSsgfilt;
        MATongue.IPptx = structure_T.RMSsgfilt;
        starts.IPptx = characteristics_T.STARTtimes;
        ends.IPptx = characteristics_T.ENDtimes;
    else
        x = 'No IPptx'
        filename

    end

    if isfield(RawIpsi, 'OL') == 1
        contra = RawContra.OL;
        ipsi = RawIpsi.OL;
        tongue = RawTongue.OL;
        stim = Stim.OL;
        contrablank = PTX_BlankStim(contra, stim);
        ipsiblank = PTX_BlankStim(ipsi, stim);
        tongueblank = PTX_BlankStim(tongue, stim);
        RawTongue.OL = tongueblank;
        RawIpsi.OL = ipsiblank;
        RawContra.OL = contrablank;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contrablank, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsiblank, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2_PTX(parameters, tongueblank, tonguetimes);
        characteristics_T = Run4_AO_findevents_PTX(stim, parameters, structure_T, OOP);
        MAContra.OL = structure_L.RMSsgfilt;
        MAIpsi.OL = structure_R.RMSsgfilt;
        MATongue.OL = structure_T.RMSsgfilt;
        starts.OL = characteristics_T.STARTtimes;
        ends.OL = characteristics_T.ENDtimes;
    else
        x = 'No OL'
        filename

    end

    if isfield(RawIpsi, 'OLptx') == 1
        contra = RawContra.OLptx;
        ipsi = RawIpsi.OLptx;
        tongue = RawTongue.OLptx;
        stim = Stim.OLptx;
        contrablank = PTX_BlankStim(contra, stim);
        ipsiblank = PTX_BlankStim(ipsi, stim);
        tongueblank = PTX_BlankStim(tongue, stim);
        RawTongue.OLptx = tongueblank;
        RawIpsi.OLptx = ipsiblank;
        RawContra.OLptx = contrablank;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contrablank, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsiblank, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2_PTX(parameters, tongueblank, tonguetimes);
        characteristics_T = Run4_AO_findevents_PTX(stim, parameters, structure_T, OOP);
        MAContra.OLptx = structure_L.RMSsgfilt;
        MAIpsi.OLptx = structure_R.RMSsgfilt;
        MATongue.OLptx = structure_T.RMSsgfilt;
        starts.OLptx = characteristics_T.STARTtimes;
        ends.OLptx = characteristics_T.ENDtimes;
    else
        x = 'No OLptx'
        filename

    end

    OOP = 1;

    if isfield(RawIpsi, 'EP') == 1
        contra = RawContra.EP;
        ipsi = RawIpsi.EP;
        tongue = RawTongue.EP;
        stim = Stim.EP;
        contrablank = PTX_BlankStim(contra, stim);
        ipsiblank = PTX_BlankStim(ipsi, stim);
        tongueblank = PTX_BlankStim(tongue, stim);
        RawTongue.EP = tongueblank;
        RawIpsi.EP = ipsiblank;
        RawContra.EP = contrablank;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contrablank, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsiblank, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2_PTX(parameters, tongueblank, tonguetimes);
        characteristics_T = Run4_AO_findevents_PTX(stim, parameters, structure_T, OOP);
        MAContra.EP = structure_L.RMSsgfilt;
        MAIpsi.EP = structure_R.RMSsgfilt;
        MATongue.EP = structure_T.RMSsgfilt;
        starts.EP = characteristics_T.STARTtimes;
        ends.EP = characteristics_T.ENDtimes;
    else
        x = 'No EP'
        filename

    end

    if isfield(RawIpsi, 'EPptx') == 1
        contra = RawContra.EPptx;
        ipsi = RawIpsi.EPptx;
        tongue = RawTongue.EPptx;
        stim = Stim.EPptx;
        contrablank = PTX_BlankStim(contra, stim);
        ipsiblank = PTX_BlankStim(ipsi, stim);
        tongueblank = PTX_BlankStim(tongue, stim);
        RawTongue.EPptx = tongueblank;
        RawIpsi.EPptx = ipsiblank;
        RawContra.EPptx = contrablank;
        contratimes = 1/frequency:1/frequency:numel(contra)/frequency;
        ipsitimes = 1/frequency:1/frequency:numel(ipsi)/frequency;
        tonguetimes = 1/frequency:1/frequency:numel(tongue)/frequency;
        structure_L = Run3_AO_RMSonly(parameters, contrablank, contratimes);
        structure_R = Run3_AO_RMSonly(parameters, ipsiblank, ipsitimes);
        structure_T = Run3_AO_thresholds_Path2_PTX(parameters, tongueblank, tonguetimes);
        characteristics_T = Run4_AO_findevents_PTX(stim, parameters, structure_T, OOP);
        MAContra.EPptx = structure_L.RMSsgfilt;
        MAIpsi.EPptx = structure_R.RMSsgfilt;
        MATongue.EPptx = structure_T.RMSsgfilt;
        starts.EPptx = characteristics_T.STARTtimes;
        ends.EPptx = characteristics_T.ENDtimes;
    else
        x = 'No EPptx'
        filename

    end
    

    save(finalname, "MAContra", "MAIpsi", "MATongue", "RawTongue", "RawIpsi", "RawContra", "starts", "ends", "frequency");
    toc

end





