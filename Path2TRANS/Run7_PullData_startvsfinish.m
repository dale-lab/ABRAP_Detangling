clc
clear


filelist = dir('ABRAPresults_5*.mat');
names = {filelist.name};
parnum = numel(names);


results1 = zeros(5, 6);
results2 = zeros(5, 6);


for j = 1:parnum
    %load file and make new name
    filename = names{j};
    load(filename)


    data = OLresults;
    variable = 13;
    numaverage = 5;


    stimlevel = data(:, 17);
    stimlevel = round(stimlevel/0.05);


    ind = 1;
    while stimlevel(ind) == 0
        ind = ind + 1;
    end


    if ind > 31
        baseline = mean(data(ind-31:ind-1, variable));
    else
        baseline = mean(data(1:ind-1, variable));
    end


    for k = 1:5
        values = data(find(stimlevel == k), :);
        if isempty(values) == 1
            results1(k, j) = 1/0;
            results2(k, j) = 1/0;
            results3(k, j) = 1/0;
            continue
        end
        try
            results1(k, j) = mean(values(1:numaverage, variable))-baseline;
            results2(k, j) = mean(values(end-numaverage:end, variable))-baseline;
        catch
            results1(k, j) = 1/0;
            results2(k, j) = 1/0;
        end


    end


end

deltaresults = results2 - results1;