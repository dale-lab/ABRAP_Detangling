clc
clear


filelist = dir('ABRAPresults_*.mat');
names = {filelist.name};
parnum = numel(names);


    resultsOL = zeros(6, 11);
    resultsOLptx = zeros(6, 11);


for j = 1:parnum
    filename = names{j};
    tokens = regexp(filename, 'ABRAPresults_(\d{2}).mat', 'tokens');
    number = tokens{1}{1};
    rat = str2num(number);
    load(filename);


    variable = 25;
    during = 1;
    numbreathave = 10;
    norm = 0;
    delta = 1;


    ind = rat;
    if rat == 10 || rat == 11
        ind = rat - 4;
    elseif rat == 6 || rat == 7 || rat == 8 || rat == 9
        ind = rat + 2;
    end


    OLptxresults = transpose(OLptxresults);


    for n = 1:numel(OLresults(:, 1))
        OLresults(n, 19) = OLresults(n, 10)/OLresults(n, 8);
        OLresults(n, 20) = (OLresults(n, 9)/OLresults(n, 4))/(OLresults(n, 7)/OLresults(n, 3));
        OLresults(n, 21) = OLresults(n, 15)/OLresults(n, 13);
        OLresults(n, 22) = (OLresults(n, 14)/OLresults(n, 4))/(OLresults(n, 12)/OLresults(n, 3));
        OLresults(n, 23) = (OLresults(n, 7)/OLresults(n, 3)) - (OLresults(n, 9)/OLresults(n, 4));
        OLresults(n, 24) = (OLresults(n, 7)/OLresults(n, 3));
        OLresults(n, 25) = (OLresults(n, 12)/OLresults(n, 3));
    end


    for n = 1:numel(OLptxresults(:, 1))
        OLptxresults(n, 19) = OLptxresults(n, 10)/OLptxresults(n, 8);
        OLptxresults(n, 20) = (OLptxresults(n, 9)/OLptxresults(n, 4))/(OLptxresults(n, 7)/OLptxresults(n, 3));
        OLptxresults(n, 21) = OLptxresults(n, 15)/OLptxresults(n, 13);
        OLptxresults(n, 22) = (OLptxresults(n, 14)/OLptxresults(n, 4))/(OLptxresults(n, 12)/OLptxresults(n, 3));
        OLptxresults(n, 23) = (OLptxresults(n, 7)/OLptxresults(n, 3)) - (OLptxresults(n, 9)/OLptxresults(n, 4));
        OLptxresults(n, 24) = (OLptxresults(n, 7)/OLptxresults(n, 3));
        OLptxresults(n, 25) = (OLptxresults(n, 12)/OLptxresults(n, 3));
    end




    classification1 = zeros(numel(OLresults(:, 1)), 1);
    last = 0;


    for i = 1:numel(OLresults(:, 1))
        OLresults(i, 17) = round(OLresults(i, 17)/0.05);
        if OLresults(i, 17) > 0
            classification1(i, 1) = OLresults(i, 17);
            last = OLresults(i, 17);
        else
            classification1(i, 1) = last*-1;
        end
    end


    classification2 = zeros(numel(OLptxresults(:, 1)), 1);
    last = 0;


    for i = 1:numel(OLptxresults(:, 1))
        OLptxresults(i, 17) = round(OLptxresults(i, 17)/0.05);
        if OLptxresults(i, 17) > 0
            classification2(i, 1) = OLptxresults(i, 17);
            last = OLptxresults(i, 17);
        else
            classification2(i, 1) = last*-1;
        end
    end


    if during == 1
        for k = 0:5
            idx = find(classification1 == k);
            resultsOL(k+1, ind) = mean(OLresults(idx, variable));
            idx2 = find(classification2 == k);
            resultsOLptx(k+1, ind) = mean(OLptxresults(idx2, variable));
        end
    else
        for k = 0:-1:-5
            t = 1;
            while classification1(t) ~= k
                t = t+1;
            end
            if t + 30 <= numel(OLresults(:, 1))
                resultsOL((k*-1)+1, ind) = mean(OLresults(t:t+numbreathave, variable));
            else
                resultsOL((k*-1)+1, ind) = mean(OLresults(t:end, variable));
            end
        end
        for k = 0:-1:-5
            t = 1;
            while classification2(t) ~= k
                t = t+1;
            end
            if t + 30 <= numel(OLptxresults(:, 1))
                resultsOLptx((-1*k)+1, ind) = mean(OLptxresults(t:t+numbreathave, variable));
            else
                resultsOLptx((-1*k)+1, ind) = mean(OLptxresults(t:end, variable));
            end
        end


    end


    if norm == 1
        for k = 6:-1:1
            for h = 1:11
                resultsOL(k, h) = resultsOL(k, h) - resultsOL(1, h);
                resultsOLptx(k, h) = resultsOLptx(k, h) - resultsOLptx(1, h);
            end
        end
    end

    if delta == 1
        resultsDelta = resultsOLptx - resultsOL;
    end




end








