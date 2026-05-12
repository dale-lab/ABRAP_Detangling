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

end

