clc
clear

filelist = dir('ABRAPresults_5*.mat');
names = {filelist.name};
parnum = numel(names);
resultsIP = zeros(5, parnum);
resultsEP = zeros(5, parnum);
resultsIPt = zeros(5, parnum);
resultsEPt = zeros(5, parnum);
resultsOL = zeros(5, parnum);
resultsOLt = zeros(5, parnum);
variable = 21;
during = 1; %1 is during stim, 0 is poststim
norm = 0; %0 is no normalization, 1 is normalization
norm2what = 1; %0 is normalize to preinj baseline, 1 is normalize to postinj baseline, 2 is normalize to start of stim
normtype = 1; %1 is delta type normalization, 2 is fold normalization, 3 is percent change normalization
numend = 10;

for j = 1:parnum
    filename = names{j};
    load(filename)
    EPstims = round(EPresults(:, 17)/0.05);
    IPstims = round(IPresults(:, 17)/0.05);

    IPresults(:, 18) = (IPresults(:, 11)+IPresults(:, 16))./(IPresults(:, 3)+IPresults(:, 4));
    EPresults(:, 18) = (EPresults(:, 11)+EPresults(:, 16))./(EPresults(:, 3)+EPresults(:, 4));

    for k = 1:5
        idxIP = (IPstims == k);
        idxEP = (EPstims == k);
        if variable <= 18
            if during == 1
                resultsIP(k, j) = mean(IPresults(idxIP, variable));
                resultsEP(k, j) = mean(EPresults(idxEP, variable));
            elseif during == 0
                resultsIP(k, j) = mean(IPresults(find(idxIP == 1, 1, 'last')+1:find(idxIP == 1, 1, 'last')+numend, variable));
                if find(idxEP == 1, 1, 'last')+numend < numel(EPresults(:, variable))
                    resultsEP(k, j) = mean(EPresults(find(idxEP == 1, 1, 'last')+1:find(idxEP == 1, 1, 'last')+numend, variable));
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
        elseif variable == 21 & during == 0
            baselineE = mean(POSTresults(:, 15));
            baselineI = mean(POSTresults(:, 13));
            resultsIP(k, j) = mean((IPresults(find(idxIP == 1, 1, 'last')+1:find(idxIP == 1, 1, 'last')+numend, 15)-baselineE))/mean((IPresults(find(idxIP == 1, 1, 'last')+1:find(idxIP == 1, 1, 'last')+numend, 13)-baselineI));
            resultsEP(k, j) = mean((EPresults(find(idxEP == 1, 1, 'last')+1:find(idxEP == 1, 1, 'last')+numend, 15)-baselineE))/mean((EPresults(find(idxEP == 1, 1, 'last')+1:find(idxEP == 1, 1, 'last')+numend, 13)-baselineI));
        elseif variable == 21 && during == 1
            baselineE = mean(POSTresults(:, 15));
            baselineI = mean(POSTresults(:, 13));
            resultsIP(k, j) = mean((IPresults(idxIP, 15)-baselineE))/mean((IPresults(idxIP, 13)-baselineI));
            resultsEP(k, j) = mean((EPresults(idxEP, 15)-baselineE))/mean((EPresults(idxEP, 13)-baselineI));
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

    EPtstims = round(EPtresults(:, 17)/0.05);
    IPtstims = round(IPtresults(:, 17)/0.05);

    IPtresults(:, 18) = (IPtresults(:, 11)+IPtresults(:, 16))./(IPtresults(:, 3)+IPtresults(:, 4));
    EPtresults(:, 18) = (EPtresults(:, 11)+EPtresults(:, 16))./(EPtresults(:, 3)+EPtresults(:, 4));

    for k = 1:5
        idxIPt = (IPtstims == k);
        idxEPt = (EPtstims == k);
        if variable <= 18
            if during == 1
                resultsIPt(k, j) = mean(IPtresults(idxIPt, variable));
                resultsEPt(k, j) = mean(EPtresults(idxEPt, variable));
            elseif during == 0
                resultsIPt(k, j) = mean(IPtresults(find(idxIPt == 1, 1, 'last')+1:find(idxIPt == 1, 1, 'last')+numend, variable));
                if find(idxEPt == 1, 1, 'last')+numend < numel(EPtresults(:, variable))
                    resultsEPt(k, j) = mean(EPtresults(find(idxEPt == 1, 1, 'last')+1:find(idxEPt == 1, 1, 'last')+numend, variable));
                else
                    resultsEPt(k, j) = mean(EPtresults(find(idxEPt == 1, 1, 'last')+1:end, variable));
                end
            end
        elseif variable == 19
            resultsIPt(k, j) = sum(idxIPt);
            resultsEPt(k, j) = sum(idxEPt);
        elseif variable == 20
            resultsIPt(k, j) = IPtresults(find(idxIPt == 1, 1, 'last'), 2) - IPtresults(find(idxIPt == 1, 1, 'first'), 1);
            try
                resultsEPt(k, j) = EPtresults(find(idxEPt == 1, 1, 'last'), 2) - EPtresults(find(idxEPt == 1, 1, 'first'), 1);
            catch
                resultsEPt(k, j) = 1/0;
            end
        elseif variable == 21 && during == 1
            baselineEt = mean(POSTtresults(:, 15));
            baselineIt = mean(POSTtresults(:, 13));
            resultsIPt(k, j) = mean((IPtresults(idxIPt, 15)-baselineEt))/mean((IPtresults(idxIPt, 13)-baselineIt));
            resultsEPt(k, j) = mean((EPtresults(idxEPt, 15)-baselineEt))/mean((EPtresults(idxEPt, 13)-baselineIt));
        elseif variable == 21 && during == 0 
            baselineEt = mean(POSTtresults(:, 15));
            baselineIt = mean(POSTtresults(:, 13));
            resultsIPt(k, j) = mean((IPtresults(find(idxIPt == 1, 1, 'last')+1:find(idxIPt == 1, 1, 'last')+numend, 15)-baselineEt))/mean((IPtresults(find(idxIPt == 1, 1, 'last')+1:find(idxIPt == 1, 1, 'last')+numend, 13)-baselineIt));
            resultsEPt(k, j) = mean((EPtresults(find(idxEPt == 1, 1, 'last')+1:find(idxEPt == 1, 1, 'last')+numend, 15)-baselineEt))/mean((EPtresults(find(idxEPt == 1, 1, 'last')+1:find(idxEPt == 1, 1, 'last')+numend, 13)-baselineIt));
        end
        

    end

    if norm == 1
        if norm2what == 0
            normalizevalIPt = mean(PREresults(:, variable));
            normalizevalEPt = mean(PREresults(:, variable));
        elseif norm2what == 1
            normalizevalIPt = mean(POSTtresults(:, variable));
            normalizevalEPt = mean(POSTtresults(:, variable));
        elseif norm2what == 2
            idxIPt = (IPtstims == 1);
            normalizevalIPt = mean(IPtresults(1:find(idxIPt == 1, 1, 'first')-1, variable));
            idxEPt = (EPtstims == 1);
            normalizevalEPt = mean(EPtresults(1:find(idxEPt == 1, 1, 'first')-1, variable));
        end

        if normtype == 1
            resultsIPt(:, j) = resultsIPt(:, j) - normalizevalIPt;
            resultsEPt(:, j) = resultsEPt(:, j) - normalizevalEPt;
        elseif normtype == 2
            resultsIPt(:, j) = resultsIPt(:, j)/normalizevalIPt;
            resultsEPt(:, j) = resultsEPt(:, j)/normalizevalEPt;
        elseif normtype == 3
            resultsIPt(:, j) = (resultsIPt(:, j) - normalizevalIPt)/normalizevalIPt;
            resultsEPt(:, j) = (resultsEPt(:, j) - normalizevalEPt)/normalizevalEPt;
        end
    end
    

    OLtstims = round(OLtresults(:, 17)/0.05);
    OLstims = round(OLresults(:, 17)/0.05);

    OLresults(:, 18) = (OLresults(:, 11)+OLresults(:, 16))./(OLresults(:, 3)+OLresults(:, 4));
    OLtresults(:, 18) = (OLtresults(:, 11)+OLtresults(:, 16))./(OLtresults(:, 3)+OLtresults(:, 4));

    for k = 1:5
        idxOL = (OLstims == k);
        idxOLt = (OLtstims == k);
        if variable <= 18
            if during == 1
                resultsOL(k, j) = mean(OLresults(idxOL, variable));
                resultsOLt(k, j) = mean(OLtresults(idxOLt, variable));
            elseif during == 0
                resultsOL(k, j) = mean(OLresults(find(idxOL == 1, 1, 'last')+1:find(idxOL == 1, 1, 'last')+numend, variable));
                if find(idxOLt == 1, 1, 'last')+numend < numel(OLtresults(:, variable))
                    resultsOLt(k, j) = mean(OLtresults(find(idxOLt == 1, 1, 'last')+1:find(idxOLt == 1, 1, 'last')+numend, variable));
                else
                    resultsOLt(k, j) = mean(OLtresults(find(idxOLt == 1, 1, 'last')+1:end, variable));
                end
            end
        elseif variable == 19
            resultsOL(k, j) = sum(idxOL);
            resultsOLt(k, j) = sum(idxOLt);
        elseif variable == 20
            resultsOL(k, j) = OLresults(find(idxOL == 1, 1, 'last'), 2) - OLresults(find(idxOL == 1, 1, 'first'), 1);
            try
                resultsOLt(k, j) = OLtresults(find(idxOLt == 1, 1, 'last'), 2) - OLtresults(find(idxOLt == 1, 1, 'first'), 1);
            catch
                resultsOLt(k, j) = 1/0;
            end
        elseif variable == 21 && during == 1
            baselineE = mean(POSTresults(:, 15));
            baselineI = mean(POSTresults(:, 13));
            baselineEt = mean(POSTtresults(:, 15));
            baselineIt = mean(POSTtresults(:, 13));
            resultsOL(k, j) = mean((OLresults(idxOL, 15)-baselineE))/mean((OLresults(idxOL, 13)-baselineI));
            resultsOLt(k, j) = mean((OLtresults(idxOLt, 15)-baselineEt))/mean((OLtresults(idxOLt, 13)-baselineIt));
        elseif variable == 21 && during == 0
            baselineE = mean(POSTresults(:, 15));
            baselineI = mean(POSTresults(:, 13));
            baselineEt = mean(POSTtresults(:, 15));
            baselineIt = mean(POSTtresults(:, 13));
            resultsOL(k, j) = mean((OLresults(find(idxOL == 1, 1, 'last')+1:find(idxOL == 1, 1, 'last')+numend, 15)-baselineE))/mean((OLresults(find(idxOL == 1, 1, 'last')+1:find(idxOL == 1, 1, 'last')+numend, 13)-baselineI));
            resultsOLt(k, j) = mean((OLtresults(find(idxOLt == 1, 1, 'last')+1:find(idxOLt == 1, 1, 'last')+numend, 15)-baselineEt))/mean((OLtresults(find(idxOLt == 1, 1, 'last')+1:find(idxOLt == 1, 1, 'last')+numend, 13)-baselineIt));
        end
        

    end

    if norm == 1
        if norm2what == 0
            normalizevalOL = mean(PREresults(:, variable));
            normalizevalOLt = mean(PREresults(:, variable));
        elseif norm2what == 1
            normalizevalOL = mean(POSTresults(:, variable));
            normalizevalOLt = mean(POSTresults(:, variable));
        elseif norm2what == 2
            idxOL = (OLstims == 1);
            normalizevalOL = mean(OLresults(1:find(idxOL == 1, 1, 'first')-1, variable));
            idxOLt = (OLtstims == 1);
            normalizevalOLt = mean(OLtresults(1:find(idxOLt == 1, 1, 'first')-1, variable));
        end

        if normtype == 1
            resultsOL(:, j) = resultsOL(:, j) - normalizevalOL;
            resultsOLt(:, j) = resultsOLt(:, j) - normalizevalOLt;
        elseif normtype == 2
            resultsOL(:, j) = resultsOL(:, j)/normalizevalOL;
            resultsOLt(:, j) = resultsOLt(:, j)/normalizevalOLt;
        elseif normtype == 3
            resultsOL(:, j) = (resultsOL(:, j) - normalizevalOL)/normalizevalOL;
            resultsOLt(:, j) = (resultsOLt(:, j) - normalizevalOLt)/normalizevalOLt;
        end
    end
end


