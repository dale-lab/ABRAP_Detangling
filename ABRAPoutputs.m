clear
clc


filelist = dir('*.mat');
names = {filelist.name};

parnum = numel(names);
frequency = 25000;

for j = 1:parnum
    filename = names{j};
    segment = regexp(filename, '\d');
    segment = filename(segment);
    endname = strcat(segment, "_results.mat");
    segment = str2double(segment);
    

    MAContra= load(filename, "MAContra");
    MAIpsi = load(filename,"MAIpsi");
    Stim = load(filename, "Stim");
    starts = load(filename,"starts");
    ends = load(filename, "ends");
    MAContra = MAContra.MAContra;
    MAIpsi = MAIpsi.MAIpsi;
    Stim = Stim.Stim;
    starts = starts.starts;
    ends = ends.ends;

    PREresults = zeros(1, 16);
    POSTresults = zeros(1, 16);
    IPresults = zeros(1, 16);
    OOPresults = zeros(1, 16);
    FREQUENCYresults = zeros(1, 16);
    IPlatency = zeros(10, 525);
    OOPlatency = zeros(10, 525);
    FREQUENCYlatency = zeros(10, 525);


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

        for j = startind:endind
            if Stim.IP(j) < 0.05 && Stim.IP(j+1) >= 0.05
                during = during + 1;
            end
        end

        for j = endind:nextind
            if Stim.IP(j) < 0.05 && Stim.IP(j+1) >= 0.05
                between = between + 1;
            end
        end

        IPresults(i, 11) = during;
        IPresults(i, 16) = between;


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

    for i = 1:numel(IPresults(:, 1))
        if IPresults(i, 4) >= 0.75
            IPresults(i, :) = 0;
        end
    end
    
    IPresults = transpose(IPresults);
    IPresults(:, all(IPresults == 0)) = [];
    IPresults = transpose(IPresults);


    OOPbreaths = zeros(1, 6);
    for i = 1:numel(starts.OOP)-1
        startind = ceil(starts.OOP(i)*frequency);
            endind = ceil(ends.OOP(i)*frequency);
            nextind = ceil(starts.OOP(i+1)*frequency);
    
            during = 0;
            between = 0;
    
            for j = startind:endind
                if Stim.OOP(j) < 0.05 && Stim.OOP(j+1) >= 0.05
                    during = during + 1;
                end
            end
    
            for j = endind:nextind
                if Stim.OOP(j) < 0.05 && Stim.OOP(j+1) >= 0.05
                    between = between + 1;
                end
            end
            OOPbreaths(i, 1) = starts.OOP(i);
            OOPbreaths(i, 2) = ends.OOP(i);
            OOPbreaths(i, 3) = ends.OOP(i) - starts.OOP(i);
            OOPbreaths(i, 4) = starts.OOP(i+1) - ends.OOP(i);
            OOPbreaths(i, 5) = during;
            OOPbreaths(i, 6) = between;
    
    end
    i = 2;
    while i <= numel(OOPbreaths(:, 1))-1
        if OOPbreaths(i, 5) > 10
                OOPbreaths(i-1, 2) = OOPbreaths(i, 1);
                OOPbreaths(i-1, 3) = OOPbreaths(i-1, 4) + OOPbreaths(i-1, 3) + OOPbreaths(i, 3);
                OOPbreaths(i-1, 4) = OOPbreaths(i, 4);
                OOPbreaths(i-1, 5) = OOPbreaths(i-1, 5) + OOPbreaths(i-1, 6);
                OOPbreaths(i-1, 6) = OOPbreaths(i, 5);
                OOPbreaths(i+1, 5) = OOPbreaths(i, 6);
                OOPbreaths(i, :) = [];
        end
        i = i + 1;
    end
    
    starts.OOP = OOPbreaths(:, 1);
    ends.OOP = OOPbreaths(:, 2);


    for i = 1:numel(starts.OOP)-1
        startind = ceil(starts.OOP(i)*frequency);
        endind = ceil(ends.OOP(i)*frequency);
        nextind = ceil(starts.OOP(i+1)*frequency);

        during = 0;
        between = 0;

        for j = startind:endind
            if Stim.OOP(j) < 0.05 && Stim.OOP(j+1) >= 0.05
                during = during + 1;
            end
        end

        for j = endind:nextind
            if Stim.OOP(j) < 0.05 && Stim.OOP(j+1) >= 0.05
                between = between + 1;
            end
        end

        OOPresults(i, 11) = during;
        OOPresults(i, 16) = between;


        OOPresults(i, 1) = starts.OOP(i);
        OOPresults(i, 2) = ends.OOP(i);
        OOPresults(i, 3) = OOPresults(i, 2) - OOPresults(i, 1);
        OOPresults(i, 4) = starts.OOP(i+1) - OOPresults(i, 2);
        OOPresults(i, 5) = OOPresults(i, 3)/(OOPresults(i, 3)+OOPresults(i, 4));
        OOPresults(i, 6) = 60/(OOPresults(i, 3)+OOPresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = startind:endind
            if cpeak < MAContra.OOP(k)
                cpeak = MAContra.OOP(k);
            end
            if ipeak < MAIpsi.OOP(k)
                ipeak = MAIpsi.OOP(k);
            end
            cauc = cauc + MAContra.OOP(k)/frequency;
            iauc = iauc + MAIpsi.OOP(k)/frequency;
        end
        OOPresults(i, 7) = cauc;
        OOPresults(i, 8) = cpeak;
        OOPresults(i, 12) = iauc;
        OOPresults(i, 13) = ipeak;

        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.OOP(k)
                cpeak = MAContra.OOP(k);
            end
            if ipeak < MAIpsi.OOP(k)
                ipeak = MAIpsi.OOP(k);
            end
            cauc = cauc + MAContra.OOP(k)/frequency;
            iauc = iauc + MAIpsi.OOP(k)/frequency;
        end
        OOPresults(i, 9) = cauc;
        OOPresults(i, 10) = cpeak;
        OOPresults(i, 14) = iauc;
        OOPresults(i, 15) = ipeak;
    end

    for i = 1:numel(OOPresults(:, 1))
        if OOPresults(i, 4) >= 0.75
            OOPresults(i, :) = 0;
        end
    end
    
    OOPresults = transpose(OOPresults);
    OOPresults(:, all(OOPresults == 0)) = [];
    OOPresults = transpose(OOPresults);

     for i = 1:numel(starts.FREQUENCY)-1
        startind = ceil(starts.FREQUENCY(i)*frequency);
        endind = ceil(ends.FREQUENCY(i)*frequency);
        nextind = ceil(starts.FREQUENCY(i+1)*frequency);

        during = 0;
        between = 0;

        for j = startind:endind
            if Stim.FREQUENCY(j) < 0.05 && Stim.FREQUENCY(j+1) >= 0.05
                during = during + 1;
            end
        end

        for j = endind:nextind
            if Stim.FREQUENCY(j) < 0.05 && Stim.FREQUENCY(j+1) >= 0.05
                between = between + 1;
            end
        end

        FREQUENCYresults(i, 11) = during;
        FREQUENCYresults(i, 16) = between;


        FREQUENCYresults(i, 1) = starts.FREQUENCY(i);
        FREQUENCYresults(i, 2) = ends.FREQUENCY(i);
        FREQUENCYresults(i, 3) = FREQUENCYresults(i, 2) - FREQUENCYresults(i, 1);
        FREQUENCYresults(i, 4) = starts.FREQUENCY(i+1) - FREQUENCYresults(i, 2);
        FREQUENCYresults(i, 5) = FREQUENCYresults(i, 3)/(FREQUENCYresults(i, 3)+FREQUENCYresults(i, 4));
        FREQUENCYresults(i, 6) = 60/(FREQUENCYresults(i, 3)+FREQUENCYresults(i, 4));
        
        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = startind:endind
            if cpeak < MAContra.FREQUENCY(k)
                cpeak = MAContra.FREQUENCY(k);
            end
            if ipeak < MAIpsi.FREQUENCY(k)
                ipeak = MAIpsi.FREQUENCY(k);
            end
            cauc = cauc + MAContra.FREQUENCY(k)/frequency;
            iauc = iauc + MAIpsi.FREQUENCY(k)/frequency;
        end
        FREQUENCYresults(i, 7) = cauc;
        FREQUENCYresults(i, 8) = cpeak;
        FREQUENCYresults(i, 12) = iauc;
        FREQUENCYresults(i, 13) = ipeak;

        cpeak = 0;
        cauc = 0;
        ipeak = 0;
        iauc = 0;
        for k = endind:nextind
            if cpeak < MAContra.FREQUENCY(k)
                cpeak = MAContra.FREQUENCY(k);
            end
            if ipeak < MAIpsi.FREQUENCY(k)
                ipeak = MAIpsi.FREQUENCY(k);
            end
            cauc = cauc + MAContra.FREQUENCY(k)/frequency;
            iauc = iauc + MAIpsi.FREQUENCY(k)/frequency;
        end
        FREQUENCYresults(i, 9) = cauc;
        FREQUENCYresults(i, 10) = cpeak;
        FREQUENCYresults(i, 14) = iauc;
        FREQUENCYresults(i, 15) = ipeak;
    end

    for i = 1:numel(FREQUENCYresults(:, 1))
        if FREQUENCYresults(i, 4) >= 0.75
            FREQUENCYresults(i, :) = 0;
        end
    end
    
    FREQUENCYresults = transpose(FREQUENCYresults);
    FREQUENCYresults(:, all(FREQUENCYresults == 0)) = [];
    FREQUENCYresults = transpose(FREQUENCYresults);


    save(endname, "PREresults", "POSTresults", "IPresults", "OOPresults", "FREQUENCYresults")

end




       










