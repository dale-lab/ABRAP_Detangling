clear
clc


%load files
filelist = dir('ABRAPanalyzed_*.mat');
names = {filelist.name};
parnum = numel(names);


for j = 1:parnum
    %load file and make new name
    filename = names{j};
    rat = regexp(filename, '\d');
    rat = filename(rat);
    endname = strcat("ABRAPresults_", rat, ".mat");
    stimfile = strcat("ABRAPstructure_", rat, ".mat");
    rat = str2double(rat);
    
    %load data from structures
    MAContra= load(filename, "MAContra");
    MAIpsi = load(filename,"MAIpsi");
    RawTongue = load(filename, "RawTongue");
    MATongue = load(filename, "MATongue");
    Stim = load(stimfile, "Stim");
    starts = load(filename,"starts");
    ends = load(filename, "ends");
    frequency = load(filename, "frequency");
    frequency = frequency.frequency;
    RawTongue = RawTongue.RawTongue;
    MATongue = MATongue.MATongue;
    MAContra = MAContra.MAContra;
    MAIpsi = MAIpsi.MAIpsi;
    Stim = Stim.Stim;
    starts = starts.starts;
    ends = ends.ends;
    
    %generate results variables


    OLresults = zeros(1, 18);
    OLptxresults = zeros(1, 18);


    maxlengthexp = 0.7;


    prestim = Stim.OL;
    predata = RawTongue.OL;
    predataMA = MATongue.OL;


    hadstim = zeros(numel(prestim), 1);
    isstim = zeros(numel(prestim), 1);


    thresh1 = zeros(1, 1);
    thresh2 = zeros(1, 1);
    for p = 30:numel(prestim)-1
        if prestim(p) > -0.01 && prestim(p+1) <= -0.01
            isstim(p) = 1;
            thresh2(1, end+1) = predata(p-68);
            thresh1(1, end+1) = predataMA(p-68);
        end
    end


    threshpre1 = prctile(thresh1, 10);
    threshpre2 = mode(round(thresh2, 3));


    i = 1;


    while i <= numel(isstim)-30
        if predataMA(i) > threshpre1 && predata(i) > threshpre2
            hadstim(i) = 1;
            i = i + 30;
        end
        i = i + 1;
    end


    for i = 1:numel(starts.OL)-1
        startind = ceil(starts.OL(i)*frequency);
        endind = ceil(ends.OL(i)*frequency);
        nextind = ceil(starts.OL(i+1)*frequency);


        during = 0;
        between = 0;
        maxstim = 0;
        for j = startind:endind
            if Stim.OL(j) < 0.01 && Stim.OL(j+1) >= 0.01
                during = during + 1;
            end
            if Stim.OL(j) > maxstim
                maxstim = Stim.OL(j);
            end
        end


        for j = endind:nextind
            if Stim.OL(j) < 0.01 && Stim.OL(j+1) >= 0.01
                between = between + 1;
            end
            if Stim.OL(j) > maxstim
                maxstim = Stim.OL(j);
            end
        end


        OLresults(i, 11) = during;
        OLresults(i, 16) = between;
        OLresults(i, 17) = maxstim;


        OLresults(i, 1) = starts.OL(i);
        OLresults(i, 2) = ends.OL(i);
        OLresults(i, 3) = OLresults(i, 2) - OLresults(i, 1);
        OLresults(i, 4) = starts.OL(i+1) - OLresults(i, 2);
        OLresults(i, 5) = OLresults(i, 3)/(OLresults(i, 3)+OLresults(i, 4));
        OLresults(i, 6) = 60/(OLresults(i, 3)+OLresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        potentialstims = 0;
        for k = startind:endind
            if hadstim(k) == 1
                potentialstims = potentialstims+1;
            end
            if cpeak < MAContra.OL(k)
                cpeak = MAContra.OL(k);
            end
            if ipeak < MAIpsi.OL(k)
                ipeak = MAIpsi.OL(k);
            end
            cauc = cauc + MAContra.OL(k)/frequency;
            iauc = iauc + MAIpsi.OL(k)/frequency;
        end
        OLresults(i, 7) = cauc;
        OLresults(i, 8) = cpeak;
        OLresults(i, 12) = iauc;
        OLresults(i, 13) = ipeak;
        OLresults(i, 18) = potentialstims;


        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.OL(k)
                cpeak = MAContra.OL(k);
            end
            if ipeak < MAIpsi.OL(k)
                ipeak = MAIpsi.OL(k);
            end
            cauc = cauc + MAContra.OL(k)/frequency;
            iauc = iauc + MAIpsi.OL(k)/frequency;
        end
        OLresults(i, 9) = cauc;
        OLresults(i, 10) = cpeak;
        OLresults(i, 14) = iauc;
        OLresults(i, 15) = ipeak;
    end


    for i = 1:numel(OLresults(:, 1))
        if OLresults(i, 4) >= maxlengthexp
            OLresults(i, :) = 0;
        end
    end


    
    OLresults = transpose(OLresults);
    OLresults(:, all(OLresults == 0)) = [];
    OLresults = transpose(OLresults);








    prestim = Stim.OLptx;
    predata = RawTongue.OLptx;
    predataMA = MATongue.OLptx;


    hadstim = zeros(numel(prestim), 1);
    isstim = zeros(numel(prestim), 1);


    thresh1 = zeros(1, 1);
    thresh2 = zeros(1, 1);
    for p = 30:numel(prestim)-1
        if prestim(p) > -0.01 && prestim(p+1) <= -0.01
            isstim(p) = 1;
            thresh2(1, end+1) = predata(p-68);
            thresh1(1, end+1) = predataMA(p-68);
        end
    end


    threshpre1 = prctile(thresh1, 10);
    threshpre2 = mode(round(thresh2, 3));


    i = 1;


    while i <= numel(isstim)-30
        if predataMA(i) > threshpre1 && predata(i) > threshpre2
            hadstim(i) = 1;
            i = i + 30;
        end
        i = i + 1;
    end


    for i = 1:numel(starts.OLptx)-1
        startind = ceil(starts.OLptx(i)*frequency);
        endind = ceil(ends.OLptx(i)*frequency);
        nextind = ceil(starts.OLptx(i+1)*frequency);


        during = 0;
        between = 0;
        maxstim = 0;
        for j = startind:endind
            if Stim.OLptx(j) < 0.01 && Stim.OLptx(j+1) >= 0.01
                during = during + 1;
            end
            if Stim.OLptx(j) > maxstim
                maxstim = Stim.OLptx(j);
            end
        end


        for j = endind:nextind
            if Stim.OLptx(j) < 0.01 && Stim.OLptx(j+1) >= 0.01
                between = between + 1;
            end
            if Stim.OLptx(j) > maxstim
                maxstim = Stim.OLptx(j);
            end
        end


        OLptxresults(i, 11) = during;
        OLptxresults(i, 16) = between;
        OLptxresults(i, 17) = maxstim;


        OLptxresults(i, 1) = starts.OLptx(i);
        OLptxresults(i, 2) = ends.OLptx(i);
        OLptxresults(i, 3) = OLptxresults(i, 2) - OLptxresults(i, 1);
        OLptxresults(i, 4) = starts.OLptx(i+1) - OLptxresults(i, 2);
        OLptxresults(i, 5) = OLptxresults(i, 3)/(OLptxresults(i, 3)+OLptxresults(i, 4));
        OLptxresults(i, 6) = 60/(OLptxresults(i, 3)+OLptxresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        potentialstims = 0;
        for k = startind:endind
            if hadstim(k) == 1
                potentialstims = potentialstims+ 1;
            end
            if cpeak < MAContra.OLptx(k)
                cpeak = MAContra.OLptx(k);
            end
            if ipeak < MAIpsi.OLptx(k)
                ipeak = MAIpsi.OLptx(k);
            end
            cauc = cauc + MAContra.OLptx(k)/frequency;
            iauc = iauc + MAIpsi.OLptx(k)/frequency;
        end
        OLptxresults(i, 7) = cauc;
        OLptxresults(i, 8) = cpeak;
        OLptxresults(i, 12) = iauc;
        OLptxresults(i, 13) = ipeak;
        OLptxresults(i, 18) = potentialstims;


        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.OLptx(k)
                cpeak = MAContra.OLptx(k);
            end
            if ipeak < MAIpsi.OLptx(k)
                ipeak = MAIpsi.OLptx(k);
            end
            cauc = cauc + MAContra.OLptx(k)/frequency;
            iauc = iauc + MAIpsi.OLptx(k)/frequency;
        end
        OLptxresults(i, 9) = cauc;
        OLptxresults(i, 10) = cpeak;
        OLptxresults(i, 14) = iauc;
        OLptxresults(i, 15) = ipeak;
    end


    for i = 1:numel(OLptxresults(:, 1))
        if OLptxresults(i, 4) >= maxlengthexp
            OLptxresults(i, :) = 0;
        end
    end
    
    OLptxresults = transpose(OLptxresults);
    OLptxresults(:, all(OLptxresults == 0)) = [];


    save(endname, "OLresults", "OLptxresults")


end


