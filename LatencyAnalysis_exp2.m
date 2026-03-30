clear
clc

filelist = dir('*.mat');
names = {filelist.name};

parnum = numel(names);

maxwidth = 500;%maximum width of EKG contaminations to blank on either side of event identification
catchlow = -0.005;%lower limit of ipsilesional noise
catchhigh = 0.005;%upper limit of ipsilesional noise
thresh = 0.03;%threshold to identify breaths of contralesional moving average
high = 3;%slope value indicating EKG contamination
toohigh = 4;
artificialadd = 0; %# of extra data points to blank even if slope is below low (use if negative dip in slope after EKG based on pattern)
contrazero = 0.0015; %moving average noise level above 0

%likely don't change these variables
blank = 1;%1 or 0 for blank EKG or not
low = 0;%slope value to cut off EKG blanking time
frequency = 25000;%sampling frequency of imported data
wiggle = 500; %how far off +/- expected distance of EKGs should be searched for missing event
% % 
% load('2PostInj.mat')
%     STIM = strcat(who('*Ch1'), '.values');
%     stim = eval(STIM{1});
%     CONTRA = strcat(who('*Ch2'), '.values');
%     contra = eval(CONTRA{1});
%     IPSI = strcat(who('*Ch4'), '.values');
%     ipsi = eval(IPSI{1});
%     PRESSURE = strcat(who('*Ch8'), '.values');
%     pressure = eval(PRESSURE{1});
%     CO2 = strcat(who('*Ch10'), '.values');
%     co2 = eval(CO2{1});
%     time = transpose(1/frequency:1/frequency:numel(contra)/frequency);
%     contrasmooth = strcat(who('*Ch3'), '.values');
%     contraSMOOTH = eval(contrasmooth{1});
%     ipsiRAW = ipsi;
%     contraRAW = contra;
%     STIM = stim; 
% 
%     clear AO*
% 
%     plot(time, ipsi, time, contraSMOOTH)
%     xlim([0 10])
%     ylim([-0.05 0.1])
%     x = 0;



for j = 1:parnum
    filename = names{j};
    segment = regexp(filename, '\d');
    segment = str2double(filename(segment));
    load(filename)

    frequency = 25000;
    
    STIM = strcat(who('*Ch1'), '.values');
    stim = eval(STIM{1});
    CONTRA = strcat(who('*Ch2'), '.values');
    contra = eval(CONTRA{1});
    IPSI = strcat(who('*Ch4'), '.values');
    ipsi = eval(IPSI{1});
    PRESSURE = strcat(who('*Ch8'), '.values');
    pressure = eval(PRESSURE{1});
    CO2 = strcat(who('*Ch10'), '.values');
    co2 = eval(CO2{1});
    time = transpose(1/frequency:1/frequency:numel(contra)/frequency);
    contrasmooth = strcat(who('*Ch3'), '.values');
    contraSMOOTH = eval(contrasmooth{1});
    ipsiRAW = ipsi;
    contraRAW = contra;
    STIM = stim; 
    
    clear AO*



    count = 1;
    for i = 1:numel(stim)-1
        if stim(i) >= 0.02 && stim(i + 1) < 0.02
            stimind(count) = i;
            count = count + 1;
        end
    end

    if segment == 31 || segment == 42 || segment == 5
        values = zeros(numel(stimind), 1);
        if segment == 31 || segment == 42
        for i = 1:numel(stimind)
                high = 0;
                for j = stimind(i)-10:stimind(i)
                    if stim(j) > high
                        high = stim(j);
                    end
                end
                values(i) = high;
            end
            values = round(values/0.025);
        else
            FREQU = 1;
            for j = 1:numel(stimind)-1
                if stimind(j+1) - stimind(j) < 750000
                    values(j) = FREQU;
                else
                    values(j) = FREQU;
                    FREQU = FREQU + 1;
                end
            end
            values(1:end-1);
        end
        if segment == 31
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            Stim1 = zeros(10, 525);
            Stim1Contra = zeros(10, 525);
            level = 1;
            i = 1;
            count = 0;
            while i <= numel(values) && level <= 10
                while i <= numel(values) && values(i) == level && level <= 10
                    k = stimind(i);
                    Stim1(level, 1:525) = Stim1(level, 1:525) + ipsi(1, k:k+524);
                    Stim1Contra(level, 1:525) = Stim1Contra(level, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                Stim1(level, :) = Stim1(level, :)/count;
                Stim1Contra(level, :) = Stim1Contra(level, :)/count;
                level = level + 1;
                count = 0;
            end
        elseif segment == 42
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            Stim2 = zeros(10, 525);
            Stim2Contra = zeros(10, 525);
            level = 1;
            i = 1;
            count = 0;
            while i <= numel(values) && level <= 10
                while i <= numel(values) && values(i) == level && level <= 10
                    k = stimind(i);
                    Stim2(level, 1:525) = Stim2(level, 1:525) + ipsi(1, k:k+524);
                    Stim2Contra(level, 1:525) = Stim2Contra(level, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                Stim2(level, :) = Stim2(level, :)/count;
                Stim2Contra(level, :) = Stim2Contra(level, :)/count;
                level = level + 1;
                count = 0;
            end
        elseif segment == 5
            ipsi = transpose(ipsi);
            contra = transpose(contra);
            Freq = zeros(20, 525);
            FreqContra = zeros(20, 525);
            level = 1;
            i = 1;
            count = 0;
            while i <= numel(values) && level <= 20
                while i <= numel(values) && values(i) == level && level <= 20
                    k = stimind(i);
                    Freq(level, 1:525) = Freq(level, 1:525) + ipsi(1, k:k+524);
                    FreqContra(level, 1:525) = FreqContra(level, 1:525) + contra(1, k:k+524);
                    count = count + 1;
                    i = i + 1;
                end
                Freq(level, :) = Freq(level, :)/count;
                FreqContra(level, :) = FreqContra(level, :)/count;
                level = level + 1;
                count = 0;
            end
        end
    end


        
    maxpeak = 0;
    AUC = 0; %these three characteristic holders reset each breath below
    breath = 1;%results index
    i = 1; %moves through contralesional data
    w = 0;%how far moved in a single breath; makes sure it's long enough
    
    results = zeros(1, 13);
    starts = zeros(1, 1);
    ends = zeros(1, 1);


    while i < numel(time) - 1
        if contraSMOOTH(i) > thresh
            starttime = i;%start of breath
            while i <= numel(contraSMOOTH) && contraSMOOTH(i) > thresh
                w = w + 1;
                i = i + 1;
            end
            endtime = i;%end of breath
            if w >= 4000%check breath is long enough, w/frequency seconds minimum
                starts(breath) = ceil(starttime);
                ends(breath) = ceil(endtime);
                for t = starttime:endtime
                    if t <= numel(contraSMOOTH)
                        AUC = contraSMOOTH(t)/frequency - contrazero/frequency + AUC;  %calculate modulus, subtract zero value
                        if contraSMOOTH(t)-contrazero > maxpeak
                            maxpeak = contraSMOOTH(t) - contrazero; %find highest point, subtract zero value
                        end
                        
                    end
                end
                %save results, move onto next breath
                results(breath, 1) = starttime/frequency;
                results(breath, 2) = endtime/frequency;
                results(breath, 3) = (endtime-starttime)/frequency;
                results(breath, 4) = maxpeak;
                results(breath, 5) = AUC;
                breath = 1 + breath;
            end
            maxpeak = 0;
            AUC = 0;
            w = 0;
        end
        i = i + 1;
    end

    pulses = 0;


    for i = 1:numel(results(:, 1))-1
        for t = ceil(results(i, 1)*frequency):ceil(results(i+1, 1)*frequency)
            if t < numel(STIM) && STIM(t) < 0.02 && STIM(t+1) >= 0.02
                pulses = pulses + 1;
            end
        end
        results(i, 8) = pulses;
        pulses = 0;
    end


    
    for u = 1:numel(results(:, 1))-1
        total = results(u+1, 1) - results(u, 1); %full length of breathing cycle
        results(u, 6) = results(u, 3)/total; %duty cycle
        results(u, 7) = 60/total; %rate
    end
    
    
    %% Get mean centered and cumulative values on ipsilesional side
    
    meancentered = zeros(1, numel(ipsiRAW));
    cumulativesum = zeros(1, numel(ipsiRAW));
    
    %delete noise contribution
    for f = 1:numel(ipsiRAW)
        if ipsiRAW(f) > catchhigh
            meancentered(f) = ipsiRAW(f) - catchhigh;
        elseif ipsiRAW(f) < catchlow
            meancentered(f) = ipsiRAW(f) - catchlow;
        else
            meancentered(f) = 0;
        end
    end
    
    %calculate cumulative sum
    cumulativesum(1) = abs(meancentered(1));
    for g = 2:numel(meancentered)
        cumulativesum(g) = cumulativesum(g-1) + abs(meancentered(g));
    end
    
    %calculate slope of cumulative sum
    sumslope = zeros(1, numel(cumulativesum));
    for i = 251:numel(sumslope)
    sumslope(i) = (cumulativesum(i)-cumulativesum(i-250));
    end
    
    
    % %% First pass blank major EKG contributions
    % 
     fixedcumulative = zeros(1, numel(cumulativesum)); %holds blanked qsum
     allowed = ones(1, numel(cumulativesum)); %holds if EKG blanked or not; 1 = no blank, 0 = blank
    o = 1; %moves through sumslope
    k = 0; %holds number moved forwards from detection reset each breath
    m = 0; %holds number move backwards from detection reset each breath
    highval = 0;

    while o <= numel(sumslope)
        if sumslope(o) > high && sumslope(o) < toohigh
            r = o;
            highval = 0;
            while r <= numel(sumslope) && sumslope(r) > high
                if sumslope(r) > highval
                    highval = sumslope(r);
                end
                r = r + 1;
            end
            if highval <= toohigh
                t = o;
                while t <= numel(sumslope) && sumslope(t) > low && m < maxwidth %blank forwards
                    allowed(t) = 0;
                    t = t + 1;
                    m = m + 1;
                end
                for r = t:t + artificialadd %if need to blank further forwards, does the blanking
                    if r <= numel(cumulativesum)
                        allowed(r) = 0;
                    end
                end
                b = o;
                while b > 0 && sumslope(b) > low && k < maxwidth %blank backwards
                    allowed(b) = 0;
                    b = b - 1;
                    k = k + 1;
                end
                o = t + 1;  
                k = 0;
                m = 0;
            end
        end
        o = o + 1;
    end

     plot(time(1:end-1), meancentered(1:numel(time)-1), time(1:end-1), sumslope(1:numel(time)-1), time(1:end-1), allowed(1:numel(time)-1))


    %% Second pass blank additional detections based on EKG rate

    count = 1;%index
    ekgs = zeros(1,1);%stores time of all EKG events
    widths = zeros(1, 1); %stores width of detected EKG events
    p = 1;%moves through allowed
    l = 0;%stores width of detected EKGs


    if blank == 1
        while p <= numel(allowed)
            if allowed(p) < 1 %find time and width of all detections
                ekgs(count) = p; %stores width of detected EKGs
                p = p + 1;
                while p <= numel(allowed) && allowed(p) < 1
                    p = p + 1;
                    l = l + 1;
                end
                widths(count, 1) = l;
                count = count + 1;
                l = 0;
            end
            p = p + 1;
        end

        diff = zeros(numel(ekgs)-1, 1); %holds distance between each EKG event

        for h = 2:numel(ekgs)
            diff(h-1) = ekgs(h) - ekgs(h-1); %calculate distances
        end

        sorted = sort(diff); %sort distances between by length

        typical = median(diff);
        LOW = median(diff) - wiggle;

        for i = 1:numel(diff)
            if diff(i) < LOW
                k = ekgs(i);
                while allowed(k) < 1
                    allowed(k) = 1;
                    k = k +1;
                end
            end
        end

         plot(time(1:end-1), meancentered(1:numel(time)-1), time(1:end-1), sumslope(1:numel(time)-1), time(1:end-1), allowed(1:numel(time)-1))


        clear widths diff sorted ekgs

        count = 1;%index
        ekgs = zeros(1,1);%stores time of all EKG events
        widths = zeros(1, 1); %stores width of detected EKG events
        p = 1;%moves through allowed
        l = 0;%stores width of detected EKGs

        while p <= numel(allowed)
            if allowed(p) < 1 %find time and width of all detections
                ekgs(count) = p; %stores width of detected EKGs
                p = p + 1;
                while p <= numel(allowed) && allowed(p) < 1
                    p = p + 1;
                    l = l + 1;
                end
                widths(count, 1) = l;
                count = count + 1;
                l = 0;
            end
            p = p + 1;
        end

        diff = zeros(numel(ekgs)-1, 1); %holds distance between each EKG event

        for h = 2:numel(ekgs)
            diff(h-1) = ekgs(h) - ekgs(h-1); %calculate distances
        end

        sorted = sort(diff); %sort distances between by length


        highindex = (typical/100+1.5)*100;  %allow for variety of times between EKGs for heart rate changes
        lowindex = (typical/100-1.5)*100;

        sum = 0; 
        num = 0;
        for o = 1:numel(diff)
            if diff(o) < highindex && diff(o) > lowindex %if the distance between EKGs is correct
                sum = sum + widths(o);
                num = num + 1;
            end
        end
        blanks = ceil(sum/num);
        %find average blanking time for correctly identified EKGs

        %if EMG bursts are high enough, EKGs are not as obvious, possible that they are mis-identified, treat differently
        for h = 2:numel(ekgs)-1
            if ekgs(h) - ekgs(h-1) > highindex || ekgs(h) - ekgs(h-1) < lowindex || ekgs(h+1) - ekgs(h) > highindex || ekgs(h+1) - ekgs(h) < lowindex
                %if the distance between EKGs is greater or less than
                %expected, get rid of that whole blanked EKG section as it
                %is likely a breath
                for l = ekgs(h-1):ekgs(h+1)
                    allowed(l) = 1;
                end
            end
        end


        jump = ceil(blanks/2) + typical; %distance that you need to move from one detection to find the next 

        b = ekgs(1)+jump;%starting point index for moving through allowed
        t = 1;%starting point index for moving through EKGs
        h = -1;

        %go back through and identify any missed EKGs
        while b < numel(allowed)
            %reinitialize
            yes = 0;%0 or 1 for if the next event was detected or not
            max = 0;%highest slope value found in range
            newind = 0;%where highest slope value is found in range
            for i = b-wiggle:b+wiggle%search area around where next EKG should be +/- wiggle value
                if i <= numel(sumslope) && sumslope(ceil(i)) >= max%find the maximum slope and location in that detection area
                    max = sumslope(ceil(i));
                    newind = i;
                end
                if i <= numel(sumslope) && allowed(ceil(i)) == 0%check to see if the area at highest slope is already blanked
                    yes = 1;
                end
            end
            if yes == 1 && t < numel(ekgs)%if area is already blanked, move on to the next one
                t = t + 1;
                while ekgs(t) + jump < b-wiggle
                    t = t + 1;
                end
                b = ekgs(t) + jump;
            else%if area is not blanked, do so
                if newind == 0 && t <numel(ekgs)% check for case that max slope is at very beginning (no blank)
                    t = t + 1;
                    b = ekgs(t) + jump;
                elseif newind == 0 && t >=numel(ekgs)% check for case that max slope is at the beginning (no blank) plus working past last detected EKG
                    b = numel(allowed);
                else
                    for k = newind-blanks/2:newind+blanks/2%blank the EKG
                        allowed(ceil(k)) = 0;
                    end
                    %move index over 
                    if b ~= h
                        h = b;
                        b = newind + jump;
                    else
                        b = numel(allowed);
                    end
                end
            end
        end
    end
    
    
    %% get output characteristic
    
    %get new cumulative values with EKG blanking
    fixedcumulative(1) = 0;
    for y = 2:numel(sumslope)
       if allowed(y) == 1
           fixedcumulative(y) = fixedcumulative(y-1) + abs(meancentered(y));
       else
           fixedcumulative(y) = fixedcumulative(y-1) + 0;
       end
    end
    
    
    %find the increase in cumulative sum throughout each breath and between
    %breaths
    for t = 1:breath - 1
        Ti = starts(t);
        Te = ends(t);
        if Te > numel(fixedcumulative)
            Te = numel(fixedcumulative);
        end
        if t < breath - 1
            Ti2 = starts(t+1);
        else
            Ti2 = numel(fixedcumulative);
        end
        during = fixedcumulative(Te) - fixedcumulative(Ti);
        between = fixedcumulative(Ti2) - fixedcumulative(Te);
        results(t, 9) = during;
        results(t, 10) = between;
    end
    

    for i = 1:numel(results(:, 1))

    results(i, 11) = results(i, 8)/results(i, 3);

    end

    hold off
    plot(time(1:end-1), allowed(1:numel(time)-1))
    hold on
    plot(time(1:end-1), meancentered(1:numel(time)-1))
    ylim([-0.2 1.2])
       x = 0; 


       if segment == 5
           FrequencyResults = results;
       elseif segment == 42
           Stim2Results = results;
       elseif segment == 31
           Stim1Results = results;
       elseif segment == 2
           PostInjuryResults = results;
       elseif segment == 1
           PreInjuryResults = results;
       end

    
    

    clear co2 CO2 contra CONTRA count i ipsi IPSI j filelist file pressure PRESSURE segment stim STIM stimind time values



end

clear sum

averageduring = mean(PreInjuryResults(:, 9));
averagebetween = mean(PreInjuryResults(:, 10));

PreInjuryResults(:, 12) = 100*PreInjuryResults(:, 9)/averageduring;
PreInjuryResults(:, 13) = 100*PreInjuryResults(:, 10)/averagebetween;

PostInjuryResults(:, 12) = 100*PostInjuryResults(:, 9)/averageduring;
PostInjuryResults(:, 13) = 100*PostInjuryResults(:, 10)/averagebetween;

Stim1Results(:, 12) = 100*Stim1Results(:, 9)/averageduring;
Stim1Results(:, 13) = 100*Stim1Results(:, 10)/averagebetween;

Stim2Results(:, 12) = 100*Stim2Results(:, 9)/averageduring;
Stim2Results(:, 13) = 100*Stim2Results(:, 10)/averagebetween;

FrequencyResults(:, 12) = 100*FrequencyResults(:, 9)/averageduring;
FrequencyResults(:, 13) = 100*FrequencyResults(:, 10)/averagebetween;


PowerLatency = zeros(4, 20, 3);
PowerLatencyContra = zeros(4, 20, 3);

values1 = abs(Stim1);
values1Contra = abs(Stim1Contra);

    for j = 1:10
        PowerLatency(1, j, 1) = sum(values1(j, 1:75))/75;
        PowerLatencyContra(1, j, 1) = sum(values1Contra(j, 1:75))/75;
        PowerLatency(2, j, 1) = sum(values1(j, 75:163))/89;
        PowerLatencyContra(2, j, 1) = sum(values1Contra(j, 75:163))/89;
        PowerLatency(3, j, 1) = sum(values1(j, 163:263))/100;
        PowerLatencyContra(3, j, 1) = sum(values1Contra(j, 163:263))/100;
        PowerLatency(4, j, 1) = sum(values1(j, 263:375))/112;
        PowerLatencyContra(4, j, 1) = sum(values1Contra(j, 263:375))/112;
    end

values1 = abs(Stim2);
values1Contra = abs(Stim2Contra);

    for j = 1:10
        PowerLatency(1, j, 2) = sum(values1(j, 1:75))/75;
        PowerLatencyContra(1, j, 2) = sum(values1Contra(j, 1:75))/75;
        PowerLatency(2, j, 2) = sum(values1(j, 75:163))/89;
        PowerLatencyContra(2, j, 2) = sum(values1Contra(j, 75:163))/89;
        PowerLatency(3, j, 2) = sum(values1(j, 163:263))/100;
        PowerLatencyContra(3, j, 2) = sum(values1Contra(j, 163:263))/100;
        PowerLatency(4, j, 2) = sum(values1(j, 263:375))/112;
        PowerLatencyContra(4, j, 2) = sum(values1Contra(j, 263:375))/112;
    end

    
values1 = abs(Freq);
values1Contra = abs(FreqContra);

    for j = 1:20
        PowerLatency(1, j, 3) = sum(values1(j, 1:75))/75;
        PowerLatencyContra(1, j, 3) = sum(values1Contra(j, 1:75))/75;
        PowerLatency(2, j, 3) = sum(values1(j, 75:163))/89;
        PowerLatencyContra(2, j, 3) = sum(values1Contra(j, 75:163))/89;
        PowerLatency(3, j, 3) = sum(values1(j, 163:263))/100;
        PowerLatencyContra(3, j, 3) = sum(values1Contra(j, 163:263))/100;
        PowerLatency(4, j, 3) = sum(values1(j, 263:375))/112;
        PowerLatencyContra(4, j, 3) = sum(values1Contra(j, 263:375))/112;
    end



time = 1/frequency:1/frequency:0.021;
time = time*1000;
z = 0.025:0.025:0.25;
z = transpose(z);
y = Stim1(1:10, 1:525);

try
tiledlayout(2, 1)
nexttile
[X, Z] = meshgrid(time, z);
surf(X, Z, y);
caxis([-0.05 0.05])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Current (mA)')
title('Ipsilesional Stim1')
view ([0 0 90])

nexttile
y = Stim1Contra(1:10, 1:525);
surf(X, Z, y);
caxis([-0.05 0.05])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Current (mA)')
title('Contralesional Stim1')
view ([0 0 90])
colorbar

x = 0;
catch
end

try
tiledlayout(2, 1)
nexttile
y = Stim2(1:10, 1:525);
surf(X, Z, y);
caxis([-0.05 0.05])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Current (mA)')
title('Ipsilesional Stim2')
view ([0 0 90])

nexttile
y = Stim2Contra(1:10, 1:525);
surf(X, Z, y);
caxis([-0.05 0.05])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Current (mA)')
title('Contralesional Stim2')
view ([0 0 90])
colorbar

x = 0;
catch
end

z = 25:25:500;
z = transpose(z);
[X, Z] = meshgrid(time, z);

try
tiledlayout(2, 1)
nexttile
y = Freq(1:20, 1:525);
surf(X, Z, y);
caxis([-0.05 0.05])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Frequency (Hz)')
title('Ipsilesional Frequency')
view ([0 0 90])


nexttile
y = FreqContra(1:20, 1:525);
surf(X, Z, y);
colorbar
caxis([-0.05 0.05])
xlabel('Time (ms)');
xlim([0 15])
ylabel('Frequency (Hz)')
title('Contralesional Frequency')
view ([0 0 90])
colorbar

x = 0;
catch 
end



save('Analyzed.mat', 'Stim1', 'Stim1Contra', 'Stim2', 'Stim2Contra', 'Freq', 'FreqContra', 'PreInjuryResults', 'PostInjuryResults', 'FrequencyResults', 'Stim1Results', 'Stim2Results', 'PowerLatency', 'PowerLatencyContra')

