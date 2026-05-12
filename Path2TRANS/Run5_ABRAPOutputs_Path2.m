clear
clc

filelist = dir('ABRAPanalyzed_*.mat');
names = {filelist.name};
parnum = numel(names);

for j = 1:parnum
    filename = names{j};
    rat = regexp(filename, '\d');
    rat = filename(rat);
    endname = strcat("ABRAPresults_", rat, ".mat");
    stimfile = strcat("ABRAPstructure_", rat, ".mat");
    rat = str2double(rat);


    load(filename);
    Stim = load(stimfile, "Stim");
    Stim = Stim.Stim;

    PREresults = zeros(1, 17);
    POSTresults = zeros(1, 17);
    IPresults = zeros(1, 17);
    EPresults = zeros(1, 17);
    POSTtresults = zeros(1, 17);
    IPtresults = zeros(1, 17);
    EPtresults = zeros(1, 17);
    OLresults = zeros(1, 17);
    OLtresults = zeros(1, 17);

    for i = 1:numel(starts.PRE)-1
        startind = ceil(starts.PRE(i)*frequency);
        endind = ceil(ends.PRE(i)*frequency);
        nextind = ceil(starts.PRE(i+1)*frequency);

        PREresults(i, 1) = starts.PRE(i);
        PREresults(i, 2) = ends.PRE(i);
        PREresults(i, 3) = PREresults(i, 2) - PREresults(i, 1);
        PREresults(i, 4) = starts.PRE(i+1) - PREresults(i, 2);
        PREresults(i, 5) = PREresults(i, 3)/(PREresults(i, 3)+PREresults(i, 4));
        PREresults(i, 6) = 60/(PREresults(i, 3)+PREresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = startind:endind
            if cpeak < MAContra.PRE(k)
                cpeak = MAContra.PRE(k);
            end
            if ipeak < MAIpsi.PRE(k)
                ipeak = MAIpsi.PRE(k);
            end
            cauc = cauc + MAContra.PRE(k)/frequency;
            iauc = iauc + MAIpsi.PRE(k)/frequency;
        end
        PREresults(i, 7) = cauc;
        PREresults(i, 8) = cpeak;
        PREresults(i, 12) = iauc;
        PREresults(i, 13) = ipeak;

        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.PRE(k)
                cpeak = MAContra.PRE(k);
            end
            if ipeak < MAIpsi.PRE(k)
                ipeak = MAIpsi.PRE(k);
            end
            cauc = cauc + MAContra.PRE(k)/frequency;
            iauc = iauc + MAIpsi.PRE(k)/frequency;
        end
        PREresults(i, 9) = cauc;
        PREresults(i, 10) = cpeak;
        PREresults(i, 14) = iauc;
        PREresults(i, 15) = ipeak;
    end

    for i = 1:numel(PREresults(:, 1))
        if PREresults(i, 4) >= 0.75
            PREresults(i, :) = 0;
        end
    end
    
    PREresults = transpose(PREresults);
    PREresults(:, all(PREresults == 0)) = [];
    PREresults = transpose(PREresults);

    maxlengthexp = mean(PREresults(:, 3))+mean(PREresults(:, 4));
    for i = 1:numel(starts.POST)-1
        startind = ceil(starts.POST(i)*frequency);
        endind = ceil(ends.POST(i)*frequency);
        nextind = ceil(starts.POST(i+1)*frequency);

        POSTresults(i, 1) = starts.POST(i);
        POSTresults(i, 2) = ends.POST(i);
        POSTresults(i, 3) = POSTresults(i, 2) - POSTresults(i, 1);
        POSTresults(i, 4) = starts.POST(i+1) - POSTresults(i, 2);
        POSTresults(i, 5) = POSTresults(i, 3)/(POSTresults(i, 3)+POSTresults(i, 4));
        POSTresults(i, 6) = 60/(POSTresults(i, 3)+POSTresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = startind:endind
            if cpeak < MAContra.POST(k)
                cpeak = MAContra.POST(k);
            end
            if ipeak < MAIpsi.POST(k)
                ipeak = MAIpsi.POST(k);
            end
            cauc = cauc + MAContra.POST(k)/frequency;
            iauc = iauc + MAIpsi.POST(k)/frequency;
        end
        POSTresults(i, 7) = cauc;
        POSTresults(i, 8) = cpeak;
        POSTresults(i, 12) = iauc;
        POSTresults(i, 13) = ipeak;

        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.POST(k)
                cpeak = MAContra.POST(k);
            end
            if ipeak < MAIpsi.POST(k)
                ipeak = MAIpsi.POST(k);
            end
            cauc = cauc + MAContra.POST(k)/frequency;
            iauc = iauc + MAIpsi.POST(k)/frequency;
        end
        POSTresults(i, 9) = cauc;
        POSTresults(i, 10) = cpeak;
        POSTresults(i, 14) = iauc;
        POSTresults(i, 15) = ipeak;
    end

    for i = 1:numel(POSTresults(:, 1))
        if POSTresults(i, 4) >= 0.75
            POSTresults(i, :) = 0;
        end
    end
    
    POSTresults = transpose(POSTresults);
    POSTresults(:, all(POSTresults == 0)) = [];
    POSTresults = transpose(POSTresults);

    for i = 1:numel(starts.POSTt)-1
        startind = ceil(starts.POSTt(i)*frequency);
        endind = ceil(ends.POSTt(i)*frequency);
        nextind = ceil(starts.POSTt(i+1)*frequency);

        POSTtresults(i, 1) = starts.POSTt(i);
        POSTtresults(i, 2) = ends.POSTt(i);
        POSTtresults(i, 3) = POSTtresults(i, 2) - POSTtresults(i, 1);
        POSTtresults(i, 4) = starts.POSTt(i+1) - POSTtresults(i, 2);
        POSTtresults(i, 5) = POSTtresults(i, 3)/(POSTtresults(i, 3)+POSTtresults(i, 4));
        POSTtresults(i, 6) = 60/(POSTtresults(i, 3)+POSTtresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = startind:endind
            if cpeak < MAContra.POSTt(k)
                cpeak = MAContra.POSTt(k);
            end
            if ipeak < MAIpsi.POSTt(k)
                ipeak = MAIpsi.POSTt(k);
            end
            cauc = cauc + MAContra.POSTt(k)/frequency;
            iauc = iauc + MAIpsi.POSTt(k)/frequency;
        end
        POSTtresults(i, 7) = cauc;
        POSTtresults(i, 8) = cpeak;
        POSTtresults(i, 12) = iauc;
        POSTtresults(i, 13) = ipeak;

        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.POSTt(k)
                cpeak = MAContra.POSTt(k);
            end
            if ipeak < MAIpsi.POSTt(k)
                ipeak = MAIpsi.POSTt(k);
            end
            cauc = cauc + MAContra.POSTt(k)/frequency;
            iauc = iauc + MAIpsi.POSTt(k)/frequency;
        end
        POSTtresults(i, 9) = cauc;
        POSTtresults(i, 10) = cpeak;
        POSTtresults(i, 14) = iauc;
        POSTtresults(i, 15) = ipeak;
    end

    for i = 1:numel(POSTtresults(:, 1))
        if POSTtresults(i, 4) >= 0.75
            POSTtresults(i, :) = 0;
        end
    end
    
    POSTtresults = transpose(POSTtresults);
    POSTtresults(:, all(POSTtresults == 0)) = [];
    POSTtresults = transpose(POSTtresults);



    for i = 1:numel(starts.IP)-1
        startind = ceil(starts.IP(i)*frequency);
        endind = ceil(ends.IP(i)*frequency);
        nextind = ceil(starts.IP(i+1)*frequency);

        during = 0;
        between = 0;
        maxstim = 0;

        for j = startind:endind
            if Stim.IP(j) < 0.01 && Stim.IP(j+1) >= 0.01
                during = during + 1;
            end
            if Stim.IP(j) > maxstim
                maxstim = Stim.IP(j);
            end
        end

        for j = endind:nextind
            if Stim.IP(j) < 0.01 && Stim.IP(j+1) >= 0.01
                between = between + 1;
            end
            if Stim.IP(j) > maxstim
                maxstim = Stim.IP(j);
            end
        end

        IPresults(i, 11) = during;
        IPresults(i, 16) = between;
        IPresults(i, 17) = maxstim;

        IPresults(i, 1) = starts.IP(i);
        IPresults(i, 2) = ends.IP(i);
        IPresults(i, 3) = IPresults(i, 2) - IPresults(i, 1);
        IPresults(i, 4) = starts.IP(i+1) - IPresults(i, 2);
        IPresults(i, 5) = IPresults(i, 3)/(IPresults(i, 3)+IPresults(i, 4));
        IPresults(i, 6) = 60/(IPresults(i, 3)+IPresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = startind:endind
            if cpeak < MAContra.IP(k)
                cpeak = MAContra.IP(k);
            end
            if ipeak < MAIpsi.IP(k)
                ipeak = MAIpsi.IP(k);
            end
            cauc = cauc + MAContra.IP(k)/frequency;
            iauc = iauc + MAIpsi.IP(k)/frequency;
        end
        IPresults(i, 7) = cauc;
        IPresults(i, 8) = cpeak;
        IPresults(i, 12) = iauc;
        IPresults(i, 13) = ipeak;

        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.IP(k)
                cpeak = MAContra.IP(k);
            end
            if ipeak < MAIpsi.IP(k)
                ipeak = MAIpsi.IP(k);
            end
            cauc = cauc + MAContra.IP(k)/frequency;
            iauc = iauc + MAIpsi.IP(k)/frequency;
        end
        IPresults(i, 9) = cauc;
        IPresults(i, 10) = cpeak;
        IPresults(i, 14) = iauc;
        IPresults(i, 15) = ipeak;
    end
    
    IPdelete = 0;
    for i = 1:numel(IPresults(:, 1))
        if IPresults(i, 4) >= maxlengthexp || IPresults(i, 16) >= 10 || IPresults(i, 3) > 1.5*mean(PREresults(:, 3))
            IPresults(i, :) = 0;
            IPdelete = IPdelete + 1;
        end
    end
    
    IPresults = transpose(IPresults);
    IPresults(:, all(IPresults == 0)) = [];
    IPresults = transpose(IPresults);

    for i = 1:numel(starts.IPt)-1
        startind = ceil(starts.IPt(i)*frequency);
        endind = ceil(ends.IPt(i)*frequency);
        nextind = ceil(starts.IPt(i+1)*frequency);

        during = 0;
        between = 0;
        maxstim = 0;

        for j = startind:endind
            if Stim.IPt(j) < 0.01 && Stim.IPt(j+1) >= 0.01
                during = during + 1;
            end
            if Stim.IPt(j) > maxstim
                maxstim = Stim.IPt(j);
            end
        end

        for j = endind:nextind
            if Stim.IPt(j) < 0.01 && Stim.IPt(j+1) >= 0.01
                between = between + 1;
            end
            if Stim.IPt(j) > maxstim
                maxstim = Stim.IPt(j);
            end
        end

        IPtresults(i, 11) = during;
        IPtresults(i, 16) = between;
        IPtresults(i, 17) = maxstim;

        IPtresults(i, 1) = starts.IPt(i);
        IPtresults(i, 2) = ends.IPt(i);
        IPtresults(i, 3) = IPtresults(i, 2) - IPtresults(i, 1);
        IPtresults(i, 4) = starts.IPt(i+1) - IPtresults(i, 2);
        IPtresults(i, 5) = IPtresults(i, 3)/(IPtresults(i, 3)+IPtresults(i, 4));
        IPtresults(i, 6) = 60/(IPtresults(i, 3)+IPtresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = startind:endind
            if cpeak < MAContra.IPt(k)
                cpeak = MAContra.IPt(k);
            end
            if ipeak < MAIpsi.IPt(k)
                ipeak = MAIpsi.IPt(k);
            end
            cauc = cauc + MAContra.IPt(k)/frequency;
            iauc = iauc + MAIpsi.IPt(k)/frequency;
        end
        IPtresults(i, 7) = cauc;
        IPtresults(i, 8) = cpeak;
        IPtresults(i, 12) = iauc;
        IPtresults(i, 13) = ipeak;

        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.IPt(k)
                cpeak = MAContra.IPt(k);
            end
            if ipeak < MAIpsi.IPt(k)
                ipeak = MAIpsi.IPt(k);
            end
            cauc = cauc + MAContra.IPt(k)/frequency;
            iauc = iauc + MAIpsi.IPt(k)/frequency;
        end
        IPtresults(i, 9) = cauc;
        IPtresults(i, 10) = cpeak;
        IPtresults(i, 14) = iauc;
        IPtresults(i, 15) = ipeak;
    end
    
    IPtdelete = 0;
    for i = 1:numel(IPtresults(:, 1))
        if IPtresults(i, 4) >= maxlengthexp || IPtresults(i, 16) >= 10 || IPtresults(i, 3) > 1.5*mean(PREresults(:, 3))
            IPtresults(i, :) = 0;
            IPtdelete = IPtdelete + 1;
        end
    end
    
    IPtresults = transpose(IPtresults);
    IPtresults(:, all(IPtresults == 0)) = [];
    IPtresults = transpose(IPtresults);


    for i = 1:numel(starts.EP)-1
        startind = ceil(starts.EP(i)*frequency);
        endind = ceil(ends.EP(i)*frequency);
        nextind = ceil(starts.EP(i+1)*frequency);

        during = 0;
        between = 0;
        maxstim = 0;

        for j = startind:endind
            if Stim.EP(j) < 0.01 && Stim.EP(j+1) >= 0.01
                during = during + 1;
            end
            if Stim.EP(j) > maxstim
                maxstim = Stim.EP(j);
            end
        end

        for j = endind:nextind
            if Stim.EP(j) < 0.01 && Stim.EP(j+1) >= 0.01
                between = between + 1;
            end
            if Stim.EP(j) > maxstim
                maxstim = Stim.EP(j);
            end
        end

        EPresults(i, 11) = during;
        EPresults(i, 16) = between;
        EPresults(i, 17) = maxstim;


        EPresults(i, 1) = starts.EP(i);
        EPresults(i, 2) = ends.EP(i);
        EPresults(i, 3) = EPresults(i, 2) - EPresults(i, 1);
        EPresults(i, 4) = starts.EP(i+1) - EPresults(i, 2);
        EPresults(i, 5) = EPresults(i, 3)/(EPresults(i, 3)+EPresults(i, 4));
        EPresults(i, 6) = 60/(EPresults(i, 3)+EPresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = startind:endind
            if cpeak < MAContra.EP(k)
                cpeak = MAContra.EP(k);
            end
            if ipeak < MAIpsi.EP(k)
                ipeak = MAIpsi.EP(k);
            end
            cauc = cauc + MAContra.EP(k)/frequency;
            iauc = iauc + MAIpsi.EP(k)/frequency;
        end
        EPresults(i, 7) = cauc;
        EPresults(i, 8) = cpeak;
        EPresults(i, 12) = iauc;
        EPresults(i, 13) = ipeak;

        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.EP(k)
                cpeak = MAContra.EP(k);
            end
            if ipeak < MAIpsi.EP(k)
                ipeak = MAIpsi.EP(k);
            end
            cauc = cauc + MAContra.EP(k)/frequency;
            iauc = iauc + MAIpsi.EP(k)/frequency;
        end
        EPresults(i, 9) = cauc;
        EPresults(i, 10) = cpeak;
        EPresults(i, 14) = iauc;
        EPresults(i, 15) = ipeak;
    end

    EPdelete = 0;
    for i = 1:numel(EPresults(:, 1))
        if EPresults(i, 4) >= maxlengthexp || EPresults(i, 11) >= 10 || EPresults(i, 3) > 1.5*mean(PREresults(:, 3))
            EPdelete = EPdelete + 1;
            EPresults(i, :) = 0;
        end
    end

    EPresults = transpose(EPresults);
    EPresults(:, all(EPresults == 0)) = [];
    EPresults = transpose(EPresults);

    for i = 1:numel(starts.EPt)-1
        startind = ceil(starts.EPt(i)*frequency);
        endind = ceil(ends.EPt(i)*frequency);
        nextind = ceil(starts.EPt(i+1)*frequency);

        during = 0;
        between = 0;
        maxstim = 0;

        for j = startind:endind
            if Stim.EPt(j) < 0.01 && Stim.EPt(j+1) >= 0.01
                during = during + 1;
            end
            if Stim.EPt(j) > maxstim
                maxstim = Stim.EPt(j);
            end
        end

        for j = endind:nextind
            if Stim.EPt(j) < 0.01 && Stim.EPt(j+1) >= 0.01
                between = between + 1;
            end
            if Stim.EPt(j) > maxstim
                maxstim = Stim.EPt(j);
            end
        end

        EPtresults(i, 11) = during;
        EPtresults(i, 16) = between;
        EPtresults(i, 17) = maxstim;


        EPtresults(i, 1) = starts.EPt(i);
        EPtresults(i, 2) = ends.EPt(i);
        EPtresults(i, 3) = EPtresults(i, 2) - EPtresults(i, 1);
        EPtresults(i, 4) = starts.EPt(i+1) - EPtresults(i, 2);
        EPtresults(i, 5) = EPtresults(i, 3)/(EPtresults(i, 3)+EPtresults(i, 4));
        EPtresults(i, 6) = 60/(EPtresults(i, 3)+EPtresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = startind:endind
            if cpeak < MAContra.EPt(k)
                cpeak = MAContra.EPt(k);
            end
            if ipeak < MAIpsi.EPt(k)
                ipeak = MAIpsi.EPt(k);
            end
            cauc = cauc + MAContra.EPt(k)/frequency;
            iauc = iauc + MAIpsi.EPt(k)/frequency;
        end
        EPtresults(i, 7) = cauc;
        EPtresults(i, 8) = cpeak;
        EPtresults(i, 12) = iauc;
        EPtresults(i, 13) = ipeak;

        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.EPt(k)
                cpeak = MAContra.EPt(k);
            end
            if ipeak < MAIpsi.EPt(k)
                ipeak = MAIpsi.EPt(k);
            end
            cauc = cauc + MAContra.EPt(k)/frequency;
            iauc = iauc + MAIpsi.EPt(k)/frequency;
        end
        EPtresults(i, 9) = cauc;
        EPtresults(i, 10) = cpeak;
        EPtresults(i, 14) = iauc;
        EPtresults(i, 15) = ipeak;
    end

    EPtdelete = 0;
    for i = 1:numel(EPtresults(:, 1))
        if EPtresults(i, 4) >= maxlengthexp || EPtresults(i, 11) >= 10 || EPtresults(i, 3) > 1.5*mean(PREresults(:, 3))
            EPtdelete = EPtdelete + 1;
            EPtresults(i, :) = 0;
        end
    end

    EPtresults = transpose(EPtresults);
    EPtresults(:, all(EPtresults == 0)) = [];
    EPtresults = transpose(EPtresults);


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
        for k = startind:endind
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

    try
    for i = 1:numel(starts.OLt)-1
        startind = ceil(starts.OLt(i)*frequency);
        endind = ceil(ends.OLt(i)*frequency);
        nextind = ceil(starts.OLt(i+1)*frequency);

        during = 0;
        between = 0;
        maxstim = 0;

        for j = startind:endind
            if Stim.OLt(j) < 0.01 && Stim.OLt(j+1) >= 0.01
                during = during + 1;
            end
            if Stim.OLt(j) > maxstim
                maxstim = Stim.OLt(j);
            end
        end

        for j = endind:nextind
            if Stim.OLt(j) < 0.01 && Stim.OLt(j+1) >= 0.01
                between = between + 1;
            end
            if Stim.OLt(j) > maxstim
                maxstim = Stim.OLt(j);
            end
        end

        OLtresults(i, 11) = during;
        OLtresults(i, 16) = between;
        OLtresults(i, 17) = maxstim;


        OLtresults(i, 1) = starts.OLt(i);
        OLtresults(i, 2) = ends.OLt(i);
        OLtresults(i, 3) = OLtresults(i, 2) - OLtresults(i, 1);
        OLtresults(i, 4) = starts.OLt(i+1) - OLtresults(i, 2);
        OLtresults(i, 5) = OLtresults(i, 3)/(OLtresults(i, 3)+OLtresults(i, 4));
        OLtresults(i, 6) = 60/(OLtresults(i, 3)+OLtresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = startind:endind
            if cpeak < MAContra.OLt(k)
                cpeak = MAContra.OLt(k);
            end
            if ipeak < MAIpsi.OLt(k)
                ipeak = MAIpsi.OLt(k);
            end
            cauc = cauc + MAContra.OLt(k)/frequency;
            iauc = iauc + MAIpsi.OLt(k)/frequency;
        end
        OLtresults(i, 7) = cauc;
        OLtresults(i, 8) = cpeak;
        OLtresults(i, 12) = iauc;
        OLtresults(i, 13) = ipeak;

        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.OLt(k)
                cpeak = MAContra.OLt(k);
            end
            if ipeak < MAIpsi.OLt(k)
                ipeak = MAIpsi.OLt(k);
            end
            cauc = cauc + MAContra.OLt(k)/frequency;
            iauc = iauc + MAIpsi.OLt(k)/frequency;
        end
        OLtresults(i, 9) = cauc;
        OLtresults(i, 10) = cpeak;
        OLtresults(i, 14) = iauc;
        OLtresults(i, 15) = ipeak;
    end

    for i = 1:numel(OLtresults(:, 1))
        if OLtresults(i, 4) >= maxlengthexp
            OLtresults(i, :) = 0;
        end
    end

    OLtresults = transpose(OLtresults);
    OLtresults(:, all(OLtresults == 0)) = [];
    OLtresults = transpose(OLtresults);
    catch
        x = 'no OLt'
        filename
    end

    save(endname, "PREresults", "POSTresults", "POSTtresults", "IPresults", "IPtresults", "EPresults", "EPtresults", "OLresults", "OLtresults", "IPdelete", "EPdelete", "IPtdelete", "EPtdelete")
end


