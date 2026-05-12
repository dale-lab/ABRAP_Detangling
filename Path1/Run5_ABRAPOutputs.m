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


    save(endname, "PREresults", "POSTresults", "IPresults", "EPresults", "IPdelete", "EPdelete")
end


