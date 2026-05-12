clear
clc

IPContraResults = zeros(10, 8, 4);
IPIpsiResults = zeros(10, 8, 4);
EPContraResults = zeros(10, 8, 4);
EPIpsiResults = zeros(10, 8, 4);
frequency = 25000;

%descending
% IPContraResults = zeros(10, 7, 4);
% IPIpsiResults = zeros(10, 7, 4);
% EPContraResults = zeros(10, 7, 4);
% EPIpsiResults = zeros(10, 7, 4);
% peaktime = zeros(10, 7, 4);
% peakwidth = zeros(10, 7, 4);

three = ceil(0.003*frequency);
six = ceil(0.006*frequency);
nine = ceil(0.009*frequency);
twelve = ceil(0.012*frequency);

for i = 15:22
    rat = num2str(i);
    
    %intact
    if i == 15
        rat = '27';
    elseif i == 16
        rat = '28';
    elseif i == 17
        rat = '29';
    elseif i == 18
        rat = '30';
    elseif i == 19
        rat = '31';
    elseif i == 20
        rat = '32';
    elseif i == 21
        rat = '35';
    elseif i == 22
        rat = '36';
    end

    % %descending
    % if i == 15
    %     rat = '24';
    % elseif i == 16
    %     rat = '25';
    % elseif i == 17
    %     rat = '26';
    % elseif i == 18
    %     rat = '33';
    % elseif i == 19
    %     rat = '34';
    % elseif i == 20
    %     rat = '37';
    % elseif i == 21
    %     rat = '38';
    % elseif i == 22
    %     continue
    % end

    ratname = strcat('ABRAPlatency_', rat, '.mat');
    load(ratname);
    ind = i - 14;

    startlevel = ceil(0.001*frequency);

    maxlevel = 0;
    maxtime = 0;
    minlevel = 0;
    mintime = 0;

    for h = 1:10
        for k = startlevel:numel(IPContra(1, :))
            if IPContra(h, k) > maxlevel
                maxlevel = IPContra(h, k);
                maxtime = k;
            end
            if IPContra(h, k) < minlevel
                minlevel = IPContra(h, k);
                mintime = k;
            end
        end
        if maxtime < mintime
            peaktime(h, ind, 1) = maxtime;
        else
            peaktime(h, ind, 1) = mintime;
        end
        peakwidth(h, ind, 1) = abs(maxtime - mintime);
        maxlevel = 0;
        maxtime = 0;
        minlevel = 0;
        mintime = 0;
    end


    maxlevel = 0;
    maxtime = 0;
    minlevel = 0;
    mintime = 0;

    for h = 1:10
        for k = startlevel:numel(IPIpsi(1, :))
            if IPIpsi(h, k) > maxlevel
                maxlevel = IPIpsi(h, k);
                maxtime = k;
            end
            if IPIpsi(h, k) < minlevel
                minlevel = IPIpsi(h, k);
                mintime = k;
            end
        end
        if maxtime < mintime
            peaktime(h, ind, 2) = maxtime;
        else
            peaktime(h, ind, 2) = mintime;
        end
        peakwidth(h, ind, 2) = abs(maxtime - mintime);
        maxlevel = 0;
        maxtime = 0;
        minlevel = 0;
        mintime = 0;
    end

    maxlevel = 0;
    maxtime = 0;
    minlevel = 0;
    mintime = 0;

    for h = 1:10
        for k = startlevel:numel(EPContra(1, :))
            if EPContra(h, k) > maxlevel
                maxlevel = EPContra(h, k);
                maxtime = k;
            end
            if EPContra(h, k) < minlevel
                minlevel = EPContra(h, k);
                mintime = k;
            end
        end
        if maxtime < mintime
            peaktime(h, ind, 3) = maxtime;
        else
            peaktime(h, ind, 3) = mintime;
        end
        peakwidth(h, ind, 3) = abs(maxtime - mintime);
        maxlevel = 0;
        maxtime = 0;
        minlevel = 0;
        mintime = 0;
    end

    maxlevel = 0;
    maxtime = 0;
    minlevel = 0;
    mintime = 0;

    for h = 1:10
        for k = startlevel:numel(EPIpsi(1, :))
            if EPIpsi(h, k) > maxlevel
                maxlevel = EPIpsi(h, k);
                maxtime = k;
            end
            if EPIpsi(h, k) < minlevel
                minlevel = EPIpsi(h, k);
                mintime = k;
            end
        end
        if maxtime < mintime
            peaktime(h, ind, 4) = maxtime;
        else
            peaktime(h, ind, 4) = mintime;
        end
        peakwidth(h, ind, 4) = abs(maxtime - mintime);
        maxlevel = 0;
        maxtime = 0;
        minlevel = 0;
        mintime = 0;
    end

    % peakwidth = peakwidth/frequency;
    % peaktime = peaktime/frequency;


    IPContra = abs(IPContra);
    IPIpsi = abs(IPIpsi);
    EPContra = abs(EPContra);
    EPIpsi = abs(EPIpsi);

    for g = 1:10
        IPContraResults(g, ind, 1) = mean(IPContra(g, 1:three));
        IPContraResults(g, ind, 2) = mean(IPContra(g, three+1:six));
        IPContraResults(g, ind, 3) = mean(IPContra(g, six+1:nine));
        IPContraResults(g, ind, 4) = mean(IPContra(g, nine+1:twelve));
        IPIpsiResults(g, ind, 1) = mean(IPIpsi(g, 1:three));
        IPIpsiResults(g, ind, 2) = mean(IPIpsi(g, three+1:six));
        IPIpsiResults(g, ind, 3) = mean(IPIpsi(g, six+1:nine));
        IPIpsiResults(g, ind, 4) = mean(IPIpsi(g, nine+1:twelve));        
        EPContraResults(g, ind, 1) = mean(EPContra(g, 1:three));
        EPContraResults(g, ind, 2) = mean(EPContra(g, three+1:six));
        EPContraResults(g, ind, 3) = mean(EPContra(g, six+1:nine));
        EPContraResults(g, ind, 4) = mean(EPContra(g, nine+1:twelve));
        EPIpsiResults(g, ind, 1) = mean(EPIpsi(g, 1:three));
        EPIpsiResults(g, ind, 2) = mean(EPIpsi(g, three+1:six));
        EPIpsiResults(g, ind, 3) = mean(EPIpsi(g, six+1:nine));
        EPIpsiResults(g, ind, 4) = mean(EPIpsi(g, nine+1:twelve));
    end
end
