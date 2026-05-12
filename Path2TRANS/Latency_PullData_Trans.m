clear
clc

IPTongueResultst = zeros(5, 6, 4);
IPIpsiResultst = zeros(5, 6, 4);
EPTongueResultst = zeros(5, 6, 4);
EPIpsiResultst = zeros(5, 6, 4);
IPTongueResults = zeros(5, 6, 4);
IPIpsiResults = zeros(5, 6, 4);
EPTongueResults = zeros(5, 6, 4);
EPIpsiResults = zeros(5, 6, 4);
frequency = 26316;


three = ceil(0.003*frequency);
six = ceil(0.006*frequency);
nine = ceil(0.009*frequency);
twelve = ceil(0.012*frequency);

for i = 1:6
    
    if i == 1
        rat = '54';
    elseif i == 2
        rat = '55';
    elseif i == 3
        rat = '56';
    elseif i == 4
        rat = '57';
    elseif i == 5
        rat = '58';
    elseif i == 6
        rat = '59';
    end

    ratname = strcat('ABRAPlatency_', rat, '.mat');
    load(ratname);
    ind = i;

    startlevel = ceil(0.001*frequency);

    maxlevel = 0;
    maxtime = 0;
    minlevel = 0;
    mintime = 0;

    for h = 1:5
        for k = startlevel:numel(IPtTongue(1, :))
            if IPtTongue(h, k) > maxlevel
                maxlevel = IPtTongue(h, k);
                maxtime = k;
            end
            if IPtTongue(h, k) < minlevel
                minlevel = IPtTongue(h, k);
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

    for h = 1:5
        for k = startlevel:numel(IPtIpsi(1, :))
            if IPtIpsi(h, k) > maxlevel
                maxlevel = IPtIpsi(h, k);
                maxtime = k;
            end
            if IPtIpsi(h, k) < minlevel
                minlevel = IPtIpsi(h, k);
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

    for h = 1:5
        for k = startlevel:numel(EPtTongue(1, :))
            if EPtTongue(h, k) > maxlevel
                maxlevel = EPtTongue(h, k);
                maxtime = k;
            end
            if EPtTongue(h, k) < minlevel
                minlevel = EPtTongue(h, k);
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

    for h = 1:5
        for k = startlevel:numel(EPtIpsi(1, :))
            if EPtIpsi(h, k) > maxlevel
                maxlevel = EPtIpsi(h, k);
                maxtime = k;
            end
            if EPtIpsi(h, k) < minlevel
                minlevel = EPtIpsi(h, k);
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


    IPtTongue = abs(IPtTongue);
    IPtIpsi = abs(IPtIpsi);
    EPtTongue = abs(EPtTongue);
    EPtIpsi = abs(EPtIpsi);

    IPTongue = abs(IPTongue);
    IPIpsi = abs(IPIpsi);
    EPTongue = abs(EPTongue);
    EPIpsi = abs(EPIpsi);

    for g = 1:5
        IPTongueResultst(g, ind, 1) = mean(IPtTongue(g, 1:three));
        IPTongueResultst(g, ind, 2) = mean(IPtTongue(g, three+1:six));
        IPTongueResultst(g, ind, 3) = mean(IPtTongue(g, six+1:nine));
        IPTongueResultst(g, ind, 4) = mean(IPtTongue(g, nine+1:twelve));
        IPIpsiResultst(g, ind, 1) = mean(IPtIpsi(g, 1:three));
        IPIpsiResultst(g, ind, 2) = mean(IPtIpsi(g, three+1:six));
        IPIpsiResultst(g, ind, 3) = mean(IPtIpsi(g, six+1:nine));
        IPIpsiResultst(g, ind, 4) = mean(IPtIpsi(g, nine+1:twelve));        
        EPTongueResultst(g, ind, 1) = mean(EPtTongue(g, 1:three));
        EPTongueResultst(g, ind, 2) = mean(EPtTongue(g, three+1:six));
        EPTongueResultst(g, ind, 3) = mean(EPtTongue(g, six+1:nine));
        EPTongueResultst(g, ind, 4) = mean(EPtTongue(g, nine+1:twelve));
        EPIpsiResultst(g, ind, 1) = mean(EPtIpsi(g, 1:three));
        EPIpsiResultst(g, ind, 2) = mean(EPtIpsi(g, three+1:six));
        EPIpsiResultst(g, ind, 3) = mean(EPtIpsi(g, six+1:nine));
        EPIpsiResultst(g, ind, 4) = mean(EPtIpsi(g, nine+1:twelve));

        IPTongueResults(g, ind, 1) = mean(IPTongue(g, 1:three));
        IPTongueResults(g, ind, 2) = mean(IPTongue(g, three+1:six));
        IPTongueResults(g, ind, 3) = mean(IPTongue(g, six+1:nine));
        IPTongueResults(g, ind, 4) = mean(IPTongue(g, nine+1:twelve));
        IPIpsiResults(g, ind, 1) = mean(IPIpsi(g, 1:three));
        IPIpsiResults(g, ind, 2) = mean(IPIpsi(g, three+1:six));
        IPIpsiResults(g, ind, 3) = mean(IPIpsi(g, six+1:nine));
        IPIpsiResults(g, ind, 4) = mean(IPIpsi(g, nine+1:twelve));        
        EPTongueResults(g, ind, 1) = mean(EPTongue(g, 1:three));
        EPTongueResults(g, ind, 2) = mean(EPTongue(g, three+1:six));
        EPTongueResults(g, ind, 3) = mean(EPTongue(g, six+1:nine));
        EPTongueResults(g, ind, 4) = mean(EPTongue(g, nine+1:twelve));
        EPIpsiResults(g, ind, 1) = mean(EPIpsi(g, 1:three));
        EPIpsiResults(g, ind, 2) = mean(EPIpsi(g, three+1:six));
        EPIpsiResults(g, ind, 3) = mean(EPIpsi(g, six+1:nine));
        EPIpsiResults(g, ind, 4) = mean(EPIpsi(g, nine+1:twelve));
    end
end
