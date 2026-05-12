function [data] = PTX_BlankStim(data, stim)

    okay = ones(1, numel(stim));
    for i = 11:numel(stim)-12
        if stim(i) <= - 0.002 || stim(i) >= 0.002
            okay(i-10:i+10) = 0;
        end
    end


    for i = 1:numel(data)-1
        if okay(i) == 0
            data(i) = 0;
        end
    end



end