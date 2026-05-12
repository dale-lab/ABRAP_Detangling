clc
clear

filelist = dir('ABRAPresults_*.mat');
names = {filelist.name};
parnum = numel(names);
resultsIP = zeros(10, parnum);
resultsEP = zeros(10, parnum);
variable = 3;
during = 1; %1 is during stim, 0 is poststim
norm = 1; %0 is no normalization, 1 is normalization
norm2what = 1; %0 is normalize to preinj baseline, 1 is normalize to postinj baseline, 2 is normalize to start of stim
normtype = 1; %1 is delta type normalization, 2 is fold normalization, 3 is percent change normalization

for j = 1:parnum
    filename = names{j};
    load(filename)
    EPstims = round(EPresults(:, 17)/0.025);
    IPstims = round(IPresults(:, 17)/0.025);

    IPresults(:, 18) = (IPresults(:, 11)+IPresults(:, 16))./(IPresults(:, 3)+IPresults(:, 4));
    EPresults(:, 18) = (EPresults(:, 11)+EPresults(:, 16))./(EPresults(:, 3)+EPresults(:, 4));

    for k = 1:10
        idxIP = (IPstims == k);
        idxEP = (EPstims == k);
        if variable <= 18
            if during == 1
                resultsIP(k, j) = mean(IPresults(idxIP, variable));
                resultsEP(k, j) = mean(EPresults(idxEP, variable));
            elseif during == 0
                resultsIP(k, j) = mean(IPresults(find(idxIP == 1, 1, 'last')+1:find(idxIP == 1, 1, 'last')+30, variable));
                if find(idxEP == 1, 1, 'last')+30 < numel(EPresults(:, variable))
                    resultsEP(k, j) = mean(EPresults(find(idxEP == 1, 1, 'last')+1:find(idxEP == 1, 1, 'last')+30, variable));
                else
                    resultsEP(k, j) = mean(EPresults(find(idxEP == 1, 1, 'last')+1:end, variable));
                end
            end
        elseif variable == 19
            resultsIP(k, j) = sum(idxIP);
            resultsEP(k, j) = sum(idxEP);
        elseif variable == 20
            resultsIP(k, j) = IPresults(find(idxIP == 1, 1, 'last'), 2) - IPresults(find(idxIP == 1, 1, 'first'), 1);
            try
                resultsEP(k, j) = EPresults(find(idxEP == 1, 1, 'last'), 2) - EPresults(find(idxEP == 1, 1, 'first'), 1);
            catch
                resultsEP(k, j) = 1/0;
            end
        end
        

    end

    if norm == 1
        if norm2what == 0
            normalizevalIP = mean(PREresults(:, variable));
            normalizevalEP = mean(PREresults(:, variable));
        elseif norm2what == 1
            normalizevalIP = mean(POSTresults(:, variable));
            normalizevalEP = mean(POSTresults(:, variable));
        elseif norm2what == 2
            idxIP = (IPstims == 1);
            normalizevalIP = mean(IPresults(1:find(idxIP == 1, 1, 'first')-1, variable));
            idxEP = (EPstims == 1);
            normalizevalEP = mean(EPresults(1:find(idxEP == 1, 1, 'first')-1, variable));
        end

        if normtype == 1
            resultsIP(:, j) = resultsIP(:, j) - normalizevalIP;
            resultsEP(:, j) = resultsEP(:, j) - normalizevalEP;
        elseif normtype == 2
            resultsIP(:, j) = resultsIP(:, j)/normalizevalIP;
            resultsEP(:, j) = resultsEP(:, j)/normalizevalEP;
        elseif normtype == 3
            resultsIP(:, j) = (resultsIP(:, j) - normalizevalIP)/normalizevalIP;
            resultsEP(:, j) = (resultsEP(:, j) - normalizevalEP)/normalizevalEP;
        end
    end

end


