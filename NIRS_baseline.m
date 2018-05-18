% This function retrieves portions of the signal where no sound was
% presented to use them as baseline. 

function [baseline_mean] = NIRS_baseline(cfg,data,triggers,pre,post)
%baseline : moyenne de toutes les périodes de 5s avant les blocs et du
%début et la fin de la manip.
beg_blocks = triggers(1:2:end,2);
end_blocks = triggers(2:2:end,2);

length_baseline = round(cfg.sf * pre); %number of samples used as baseline before each block
length_end = round(cfg.sf * post);
%add as much signal as possible in the baseline
baseline_beg = data(1:beg_blocks(1)-1,:,:); 
baseline_end = data(end_blocks(end)+length_end:end,:,:);

baselines = baseline_beg;

for b = 2:length(end_blocks)-1 %don't use the first and last blocks as they were already used in beg_ and end_blocks
    bstart = beg_blocks(b) - length_baseline;
    baseline = data(bstart:beg_blocks(b)-1,:,:);
    baselines = cat(1,baselines,baseline);
end

%mean value for each channel*wavelength
baselines = cat(1,baselines,baseline_end);
baseline_mean = mean(baselines,1);
baseline_mean = squeeze(baseline_mean);
end