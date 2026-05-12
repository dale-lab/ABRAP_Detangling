function [characteristics] = Run4_AO_findevents(stim, parameters, structure, OOP)

STARTtype = parameters(5);
ABOVE = parameters(6);
ENDtype = parameters(7);
BEFOREorAFTER = parameters(8);
THRESH = structure.THRESHOLD;
ENDTHRESH = structure.ENDthreshold;
SGfilt = structure.RMSsgfilt;
FREQUENCY = structure.FREQUENCY;

if STARTtype == 1
    STARTS = structure.RISINGzeros;
elseif STARTtype == 2
    STARTS = structure.SLOPEhightime;
elseif STARTtype == 3
    STARTS = structure.SLOPEhighriseave;
elseif STARTtype == 4
    STARTS = structure.FALLINGzeros;
elseif STARTtype == 5
    STARTS = structure.SLOPElowtime;
elseif STARTtype == 6
    STARTS = structure.SLOPElowfallave;
elseif STARTtype == 7
    STARTS = structure.ALLvalues;
end

if ENDtype == 1
    ENDS = structure.RISINGzeros;
elseif ENDtype == 2
    ENDS = structure.SLOPEhightime;
elseif ENDtype == 3
    ENDS = structure.SLOPEhighriseave;
elseif ENDtype == 4
    ENDS = structure.FALLINGzeros;
elseif ENDtype == 5
    ENDS = structure.SLOPElowtime;
elseif ENDtype == 6
    ENDS = structure.SLOPElowfallave;
elseif ENDtype == 7
    ENDS = structure.ALLvalues;
end

characteristics = struct;
%% find the events
INDEX = 1;
COUNT = 1;
STARTtimes = zeros(1, 1);
ENDtimes = zeros(1, 1);
start = 0;
whiles = 0;

if  STARTS(1) > ENDS(1)
    ENDS = ENDS(2:end);
end

if BEFOREorAFTER == 1
    for j = 2:numel(THRESH)
        TIMEind = j/FREQUENCY;
        if start == 0 && INDEX <= numel(STARTS)-1 && SGfilt(j) > THRESH(j) && SGfilt(j-1) < THRESH(j)
            STARTcross = TIMEind;
            TIMEstart = STARTcross;
            TIMEstart2 = STARTS(INDEX + 1);
            while INDEX <= numel(STARTS) - 1 && STARTS(INDEX) < TIMEind
                TIMEstart = STARTS(INDEX);
                TIMEstart2 = STARTS(INDEX + 1);
                INDEX = INDEX + 1;
                whiles = 1;
            end
            if whiles == 1
                if abs(TIMEind - TIMEstart) < abs(TIMEind - TIMEstart2)
                    STARTtimes(COUNT, 1) = TIMEstart;
                    ENDtimes(COUNT, 1) = 0;
                    start = 1;
                    INDEX = INDEX - 1;
                else
                    STARTtimes(COUNT, 1) = TIMEstart2;
                    ENDtimes(COUNT, 1) = 0;
                    start = 1;
                end
            end
            whiles = 0;
        elseif start == 1 && INDEX <= numel(STARTS)-1 && SGfilt(j) < ENDTHRESH(j) && SGfilt(j-1) > ENDTHRESH(j) 
            STOPcross = TIMEind;
            TIMEend2 = ENDS(INDEX);
            if STOPcross - STARTtimes(COUNT) >= ABOVE 
                while INDEX <= numel(ENDS) - 1 && ENDS(INDEX) < TIMEind
                    TIMEend2 = ENDS(INDEX + 1);
                    TIMEend = ENDS(INDEX);
                    INDEX = INDEX+1;
                    whiles = 1;
                end
                if whiles == 0
                    ENDtimes(COUNT, 1) = TIMEend2;
                end
                if whiles == 1
                    if INDEX <= numel(ENDS) && abs(TIMEind - TIMEend) < abs(TIMEind - TIMEend2) 
                        ENDtimes(COUNT, 1) = TIMEend;
                        INDEX = INDEX - 1;
                    elseif INDEX <= numel(ENDS) && abs(TIMEind - TIMEend) > abs(TIMEind - TIMEend2) 
                        ENDtimes(COUNT, 1) = TIMEend2;
                    end
                end
                if ENDtimes(COUNT, 1) - STARTtimes(COUNT, 1) <= 2 && ENDtimes(COUNT, 1) - STARTtimes(COUNT, 1) >= 0.1
                    COUNT = COUNT + 1;
                    INDEX = INDEX + 1;
                end
                start = 0;
                whiles = 0;
            elseif COUNT > 1 && STOPcross - STARTtimes(COUNT - 1, 1) <= 0.7
                while INDEX <= numel(ENDS) - 1 && ENDS(INDEX) < TIMEind
                    whiles = 1;
                    TIMEend2 = ENDS(INDEX + 1);
                    INDEX = INDEX+1;
                    TIMEend = ENDS(INDEX);
                    whiles = 1;
                end
                if whiles == 0
                    ENDtimes(COUNT - 1, 1) = TIMEend2;
                    INDEX = INDEX + 2;
                end
                if whiles == 1
                    if INDEX <= numel(ENDS) && abs(TIMEind - TIMEend) < abs(TIMEind - TIMEend2) 
                        ENDtimes(COUNT - 1, 1) = TIMEend;
                        INDEX = INDEX - 1;
                    elseif INDEX <= numel(ENDS) && abs(TIMEind - TIMEend) > abs(TIMEind - TIMEend2) 
                        ENDtimes(COUNT - 1, 1) = TIMEend2;
                    end
                end
                start = 0;
                whiles = 0;
            else
                start = 1;
            end
        else
            continue
        end
    end
else
    for j = 2:numel(THRESH)
        TIMEind = j/FREQUENCY;
        if start == 0 && INDEX <= numel(STARTS)-1 && SGfilt(j) > THRESH(j) && SGfilt(j-1) < THRESH(j)
            STARTcross = TIMEind;
            TIMEstart = STARTcross;
            while INDEX <= numel(STARTS) && STARTS(INDEX) < TIMEind
                TIMEstart = STARTS(INDEX);
                INDEX = INDEX + 1;
                whiles = 1;
            end
            if whiles == 1
                STARTtimes(COUNT, 1) = TIMEstart;
                ENDtimes(COUNT, 1) = 0;
                start = 1;
                INDEX = INDEX - 1;
            end
            whiles = 0;
        elseif start == 1 && INDEX <= numel(STARTS)-1 && SGfilt(j) < ENDTHRESH(j) && SGfilt(j-1) > ENDTHRESH(j) 
            STOPcross = TIMEind;
            TIMEend2 = ENDS(INDEX);
            if STOPcross - STARTtimes(COUNT) >= ABOVE 
                while INDEX <= numel(ENDS) - 1 && ENDS(INDEX) < TIMEind
                    TIMEend2 = ENDS(INDEX + 1);
                    INDEX = INDEX+1;
                end
                ENDtimes(COUNT, 1) = TIMEend2;
                if ENDtimes(COUNT, 1) - STARTtimes(COUNT, 1) <= 2 && ENDtimes(COUNT, 1) - STARTtimes(COUNT, 1) >= 0.1
                    COUNT = COUNT + 1;
                    INDEX = INDEX + 1;
                end
                start = 0;
            elseif COUNT > 1 && STOPcross - STARTtimes(COUNT - 1, 1) <= 0.7
                while INDEX <= numel(ENDS) - 1 && ENDS(INDEX) < TIMEind
                    whiles = 1;
                    TIMEend2 = ENDS(INDEX + 1);
                    INDEX = INDEX+1;
                end
                if whiles == 0
                    INDEX = INDEX + 2;
                end
                ENDtimes(COUNT - 1, 1) = TIMEend2;
                start = 0;
                whiles = 0;
            else
                start = 1;
            end
        else
            continue
        end
    end
end

for x = 1:numel(STARTtimes)
    if STARTtimes(x) == 0 || ENDtimes(x) == 0
        STARTtimes(x) = -1000;
        ENDtimes(x) = -1000;
    end
end

delete = (STARTtimes == -1000);
STARTtimes(delete, :) = [];
delete = (ENDtimes == -1000);
ENDtimes(delete, :) = [];



STARTvalues = zeros(numel(STARTtimes), 1);
ENDvalues = zeros(numel(STARTtimes), 1);
for z = 1:numel(STARTtimes)
    STARTind = ceil(STARTtimes(z)*FREQUENCY);
    ENDind = ceil(ENDtimes(z)*FREQUENCY);
    STARTvalues(z) = SGfilt(STARTind);
    ENDvalues(z) = SGfilt(ENDind);
end

if numel(ENDtimes) > numel(STARTtimes)
    ENDtimes = ENDtimes(1:numel(STARTtimes));
end

for k = 1:numel(STARTtimes)
    startind = ceil(STARTtimes(k)*FREQUENCY);
    endind = ceil(ENDtimes(k)*FREQUENCY);
    breath = SGfilt(startind:endind);
    [pks, locs] = findpeaks(breath);
    [values, indexes] = maxk(pks, 4);
    if numel(values) > 1
        ind1 = locs(indexes(1));
        ind2 = locs(indexes(2));
        highest = values(1);
        highest2 = values(2);
        if highest2/highest > 0.95 && (abs(ind2 - ind1))/FREQUENCY > 0.15
            STARTtimes(k) = -1000;
            ENDtimes(k) = -1000;
        end
        if numel(values) > 3
            ind3 = locs(indexes(3));
            ind4 = locs(indexes(4));
            highest3 = values(3);
            highest4 = values(4);
            if highest3/highest > 0.95 && (abs(ind3 - ind1))/FREQUENCY > 0.15
                STARTtimes(k) = -1000;
                ENDtimes(k) = -1000;
            elseif highest4/highest > 0.95 && (abs(ind4 - ind1))/FREQUENCY > 0.15
                STARTtimes(k) = -1000;
                ENDtimes(k) = -1000;
            end
        end
    end
end

delete = (STARTtimes == -1000);
STARTtimes(delete, :) = [];
delete = (ENDtimes == -1000);
ENDtimes(delete, :) = [];

if OOP == 1
    stimcount = 0;
    for j = 1:numel(STARTtimes)
        breathlength = (ENDtimes(j) - STARTtimes(j))*2/3;
        thirdlength = (ENDtimes(j) - STARTtimes(j))/3+STARTtimes(j);
        for k = ceil(FREQUENCY*thirdlength):ceil(FREQUENCY*ENDtimes(j))
            if stim(k) < 0.01 && stim(k+1) >= 0.01
                stimcount = stimcount + 1;
            end
        end
        density = stimcount/breathlength;
        if density >= 10
            STARTtimes(j) = -1000;
            ENDtimes(j) = -1000;
        end
        stimcount = 0;
    end
delete = (STARTtimes == -1000);
STARTtimes(delete, :) = [];
delete = (ENDtimes == -1000);
ENDtimes(delete, :) = [];   

hold off
plot(structure.TIME, structure.RAW)
xlim([0 1000])
hold on
zerovals = zeros(numel(STARTtimes), 1);
plot(STARTtimes, zerovals, '*')
plot(ENDtimes, zerovals, 'o')
y = 0;
end


characteristics.STARTtimes = STARTtimes;
characteristics.ENDtimes = ENDtimes; 
characteristics.STARTvalues = STARTvalues;
characteristics.ENDvalues = ENDvalues; 

end