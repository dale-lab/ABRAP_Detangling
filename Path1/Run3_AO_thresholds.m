function [structure] = Run3_AO_thresholds(parameters, data, dataTimes)
%% assign arguments, overall variables 

SLOPEsmooth = parameters(1, 1);
RMSsmooth = parameters(1, 2);
SECave = 3;
MOAVEnum = 50;
CUToff = 1;
THRESHfraction = parameters(1, 3);
ENDthresh = parameters(1, 4);

MOAVEnum = ceil(MOAVEnum);
if rem(MOAVEnum, 2) == 1
    MOAVEnum = MOAVEnum + 1;
end

FREQUENCY = 1/dataTimes(1);
LENGTH = numel(data);
TIMElengths = 1/FREQUENCY;
RMSsgfilt = ceil(0.051/TIMElengths);
SLOPEsgfilt = ceil(SLOPEsmooth/TIMElengths);
RMSnum = ceil(RMSsmooth/TIMElengths);

if rem(RMSsgfilt, 2) == 0
    RMSsgfilt = RMSsgfilt + 1;
end
if rem(SLOPEsgfilt, 2) == 0
    SLOPEsgfilt = SLOPEsgfilt + 1;
end

structure = struct;

%% initial calculations

structure.FREQUENCY = FREQUENCY;
structure.RAW = data;
structure.TIME = dataTimes; 

INITIALsum = 0;
%for the first segment, add everything up squared
for a = 1:RMSnum
    INITIALsum = INITIALsum + data(a)^2;
end

%calculate first section of RMS, assign initial to current
RMSinitial = sqrt(INITIALsum/RMSnum);
RMScurrent = INITIALsum;
CENTER = ceil(RMSnum/2);
RMS = zeros(numel(data), 1);

%assign first section of placeholder data
for b = 1:CENTER
    RMS(b) = RMSinitial;
end

%compute RMS for rest of the data
for c = RMSnum+1:LENGTH
    RMScurrent = RMScurrent - data(c-RMSnum)^2 + data(c)^2;
    RMSnew = sqrt(RMScurrent/RMSnum);
    RMS(c-CENTER) = RMSnew;
end

%'recenter' the data so that incalculable part is split between beginning
%and end, reassign to structure
for z = 1:CENTER
    RMS(end-z) = RMSnew;
end
structure.RMS = RMS;

%apply golay filter
sgfilt = sgolayfilt(RMS(:,1), 3, RMSsgfilt); 
SLOPE = zeros(numel(data), 1);

for x = 1:numel(sgfilt)
    if sgfilt(x) < 0
        sgfilt(x) = 0;
    end
end
structure.RMSsgfilt = sgfilt;

%determine the instantaneous slope between each point, assign
for d = 1:LENGTH-1
    slope = (sgfilt(d+1)-sgfilt(d))/TIMElengths;
    SLOPE(d) = slope;
end

%assign same slope to last value
SLOPE(LENGTH) = slope;


%apply golay filter
slopesgfilt = sgolayfilt(SLOPE(:, 1), 3, SLOPEsgfilt); 
structure.SLOPEsgfilt = slopesgfilt;

%% find the slope critical points 

count = 1;
%find all the rising zeros and assign to array, determine how many rises
for h = 1:LENGTH-1
    if slopesgfilt(h) < 0 && slopesgfilt(h+1) > 0
        RISINGzeros(count) = dataTimes(h);
        SLOPErmsrisezero(count) = sgfilt(h);
        count = count + 1;
    end
end
RISElengths = count-1;
structure.RISINGzeros = RISINGzeros;


count = 1; %reset count
%find all falling zeros and assign, determine how many falls
for i = 1:LENGTH-1
    if slopesgfilt(i) > 0 && slopesgfilt(i+1) < 0
        FALLINGzeros(count) = dataTimes(i);
        SLOPErmsfallzero(count) = sgfilt(i); 
        count = count + 1;
    end
end
FALLlengths = count-1;
structure.FALLINGzeros = FALLINGzeros;


TIMEind = 0;
%find the HIGHEST time and value after each rising zero
for j = 1:RISElengths-1
    FIRSTtime = ceil(FREQUENCY*RISINGzeros(j));
    NEXTtime = ceil(RISINGzeros(j+1)*FREQUENCY);
    HIGHEST = 0;
    for x = FIRSTtime:NEXTtime
        if x < LENGTH && slopesgfilt(x) > HIGHEST
            HIGHEST = slopesgfilt(x);
            TIMEind = x;
        end
    end
    SLOPEhightime(j) = dataTimes(TIMEind);
    SLOPEhighvalue(j) = HIGHEST;
    SLOPErmshigh(j) = sgfilt(TIMEind);
end
structure.SLOPEhightime = SLOPEhightime;


TIMEind = 0;
%find the LOWEST time and value after each falling zero
for k = 1:FALLlengths-1
    FIRSTtime = ceil(FREQUENCY*FALLINGzeros(k));
    NEXTtime = ceil(FALLINGzeros(k+1)*FREQUENCY);
    LOWEST = 0;
    for m = FIRSTtime:NEXTtime
        if m < LENGTH && slopesgfilt(m) < LOWEST
            LOWEST = slopesgfilt(m);
            TIMEind = m;
        end
    end
    SLOPElowtime(k) = dataTimes(TIMEind);
    SLOPElowvalue(k) = LOWEST;
    SLOPErmslow(k) = sgfilt(TIMEind); 
end
structure.SLOPElowtime = SLOPElowtime;


%find the average of the times between the rising zero and HIGHEST point
for m = 1:numel(SLOPEhightime)
    SLOPEhighriseave(m) = (RISINGzeros(m) + SLOPEhightime(m))/2;
end
structure.SLOPEhighriseave = SLOPEhighriseave;


%find average of the times between falling zero and LOWEST point
for n = 1:numel(SLOPElowtime)
    SLOPElowfallave(n) = (FALLINGzeros(n) + SLOPElowtime(n))/2;
end
structure.SLOPElowfallave = SLOPElowfallave;

ALLvalues = cat(2, structure.RISINGzeros, structure.SLOPEhightime, structure.SLOPEhighriseave, structure.FALLINGzeros, structure.SLOPElowtime, structure.SLOPElowfallave);
ALLvalues = sort(ALLvalues);
structure.ALLvalues = ALLvalues; 
%% set the thresholds
%initialize thresholds, set averaging index, placeholder for highs
THRESHhighs = zeros(LENGTH, 1);
THRESHhighmoave = zeros(LENGTH, 1);
THRESHlows = zeros(LENGTH, 1);
THRESHlowmoave = zeros(LENGTH, 1);
THRESHOLD = zeros(LENGTH, 1);

TIMEave = ceil(FREQUENCY * SECave);


HIGHSplacehold = zeros(1,4);
%find the index and value of the falling zero, assign to placeholder
%(falling for highs, rising for lows)
for n = 1:numel(FALLINGzeros)-1
    TIMEvalue = ceil(FREQUENCY*FALLINGzeros(n));
    value = sgfilt(TIMEvalue);
    HIGHSplacehold(n, 1) = TIMEvalue;
    HIGHSplacehold(n, 2) = value;
end
average = 0;

for t = 1:MOAVEnum
    average = average + HIGHSplacehold(t, 2);
end

for b = 1:MOAVEnum/2
    HIGHSplacehold(b, 3) = average/MOAVEnum;
end

%compute moving average for rest of the data
for c = MOAVEnum+1:numel(FALLINGzeros)-1
    average = average - HIGHSplacehold(c-MOAVEnum, 2) + HIGHSplacehold(c, 2);
    HIGHSplacehold(c-MOAVEnum/2, 3) = average/MOAVEnum;
end
%'recenter' the data so that incalculable part is split between beginning
%and end, reassign to structure
for z = 1:MOAVEnum
    HIGHSplacehold(end-z, 3) = average/MOAVEnum;
end

%cutoff is LOWEST value that can be considered a breath high point
HIGHSplacehold(:, 3) = HIGHSplacehold(:, 3)/CUToff;
HIGHSplacehold(:, 4) = HIGHSplacehold(:, 3)*4*CUToff;
%replace each high point that is too k with -1000 and delete it
for p = 1:numel(FALLINGzeros)-1
    if HIGHSplacehold(p, 2) < HIGHSplacehold(p, 3) || HIGHSplacehold(p, 2) > HIGHSplacehold(p, 4)
        HIGHSplacehold(p, 1) = -1000;
    end
end
delete = (HIGHSplacehold == -1000);
HIGHSplacehold(delete,:) = [];



%start time is the time of the second slope event
STARTtime = HIGHSplacehold(2,1);
NEXT = STARTtime - 1;
PLACEHOLDlength = numel(HIGHSplacehold(:,1));
%prior to start time, define the high value as that of the second event
for q = 1:NEXT
    THRESHhighs(q) = sgfilt(STARTtime - 1);
end
%from event 2 and beyond, assign the value of the high for that period of
%time (threshold 1 is time, 2 is high value)
for r = 2:PLACEHOLDlength
    TIMEvalue1 = ceil(HIGHSplacehold(r,1));
    if r < PLACEHOLDlength
        TIMEvalue2 = ceil(HIGHSplacehold(r+1,1));
    elseif r == PLACEHOLDlength 
        TIMEvalue2 = LENGTH - 1 + 1;
    end
    for s = TIMEvalue1:TIMEvalue2
        THRESHhighs(s) = sgfilt(TIMEvalue1);
    end
end


%start process over with the lows, same exact idea as above
LOWSplacehold = zeros(1,3);
for n = 1:numel(RISINGzeros)-1
    TIMEvalue = ceil(FREQUENCY*RISINGzeros(n));
    value = sgfilt(TIMEvalue);
    LOWSplacehold(n, 1) = TIMEvalue;
    LOWSplacehold(n, 2) = value;
end

average = 0;


for t = 1:MOAVEnum
    average = average + LOWSplacehold(t, 2);
end

for b = 1:MOAVEnum/2
    LOWSplacehold(b, 3) = average/MOAVEnum;
end

%compute RMS for rest of the data
for c = MOAVEnum+1:numel(RISINGzeros)-1
    average = average - LOWSplacehold(c-MOAVEnum, 2) + LOWSplacehold(c, 2);
    LOWSplacehold(c-MOAVEnum/2, 3) = average/MOAVEnum;
end
%'recenter' the data so that incalculable part is split between beginning
%and end, reassign to structure
for z = 1:MOAVEnum
    LOWSplacehold(end-z, 3) = average/MOAVEnum;
end


LOWSplacehold(:, 3) = LOWSplacehold(:, 3)*0.9*CUToff;
%replace each high point that is too k with -1000 and delete it
for p = 1:numel(RISINGzeros)-1
    if LOWSplacehold(p, 2) > LOWSplacehold(p, 3)
        LOWSplacehold(p, 1) = -1000;
    end
end
delete = (LOWSplacehold == -1000);
LOWSplacehold(delete,:) = [];



STARTtime = LOWSplacehold(2,1);
NEXT = STARTtime - 1;
PLACEHOLDlength = numel(LOWSplacehold(:,1));
for q = 1:NEXT
    THRESHlows(q) = sgfilt(STARTtime - 1);
end
for r = 2:PLACEHOLDlength
    TIMEvalue1 = ceil(LOWSplacehold(r,1));
    if r < PLACEHOLDlength
        TIMEvalue2 = ceil(LOWSplacehold(r+1,1));
    elseif r == PLACEHOLDlength
        TIMEvalue2 = LENGTH - 1 + 1;
    end
    for s = TIMEvalue1:TIMEvalue2
        THRESHlows(s) = sgfilt(TIMEvalue1);
    end
end



%determine the movingaverage and actual threshold value
%initialize variables
NUMindex = TIMEave/2; 
AVEhigh = 0;
AVElow = 0;


%add up high and k values for beginning seconds, find average
for t = 1:TIMEave
    AVEhigh = AVEhigh + THRESHhighs(t);
    AVElow = AVElow + THRESHlows(t);
end
HIGHval = AVEhigh/TIMEave;
LOWval = AVElow/TIMEave;

%assign 1st half of averaging time to initial high/k value
THRESHhighmoave(1:ceil(NUMindex)) = HIGHval;
THRESHlowmoave(1:ceil(NUMindex)) = LOWval;

%complete moving average of high and k
for u = NUMindex+1:numel(dataTimes(:))-NUMindex
    AVEhigh = AVEhigh - THRESHhighs(u-NUMindex) + THRESHhighs(u+NUMindex);
    AVElow = AVElow - THRESHlows(u-NUMindex) + THRESHlows(u+NUMindex);  
    HIGHval = AVEhigh/TIMEave;
    LOWval = AVElow/TIMEave;
    THRESHhighmoave(ceil(u)) = HIGHval;
    THRESHlowmoave(ceil(u)) = LOWval;
end


%assign 2nd half of unable to average time to last high/k value
THRESHhighmoave(end-ceil(NUMindex):end) = HIGHval;
THRESHlowmoave(end-ceil(NUMindex):end) = LOWval;

%compute threshold by finding some THRESHfraction between the two
for v = 1:numel(THRESHhighmoave)
    threshold = (THRESHhighmoave(v) + THRESHlowmoave(v))*THRESHfraction;
    THRESHOLD(v) = threshold;
end      
ENDthreshold = THRESHOLD*ENDthresh;
structure.ENDthreshold = ENDthreshold;
structure.THRESHhighmoave = THRESHhighmoave;
structure.THRESHlowmoave = THRESHlowmoave;
structure.THRESHOLD = THRESHOLD;
end

