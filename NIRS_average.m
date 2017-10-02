function [avg, sem] = NIRS_average(cfg,marks,epochsdt,GoodBlocks)
%normal
idx = find(marks(1:2:end,1) == 1 | marks(1:2:end,1) == 5);
gbcond = GoodBlocks(idx,:);
epochscond = epochsdt(:,:,idx,:);
for ch = 1:cfg.nch
    if isempty(find(gbcond(:,ch)))
        meancond(:,ch,:) = NaN(length(epochscond),1,2);
        SEM(:,ch,:) = NaN(length(epochscond),1,2);
    else
        epochch = epochscond(:,ch,gbcond(:,ch),:);
        meancond(:,ch,:) = mean(epochch,3);
        SEM(:,ch,:) = std(epochch,0,3)/sqrt(length(idx)-1);
    end
end
avg(:,:,1,:) = meancond;
sem(:,:,1,:) = SEM;

%60%
idx = find(marks(1:2:end,1) == 3);
gbcond = GoodBlocks(idx,:);
epochscond = epochsdt(:,:,idx,:);
for ch = 1:cfg.nch
    if isempty(find(gbcond(:,ch)))
        meancond(:,ch,:) = NaN(length(epochscond),1,2);
        SEM(:,ch,:) = NaN(length(epochscond),1,2);
    else
        epochch = epochscond(:,ch,gbcond(:,ch),:);
        meancond(:,ch,:) = mean(epochch,3);
        SEM(:,ch,:) = std(epochch,0,3)/sqrt(length(idx)-1);
    end
end
avg(:,:,2,:) = meancond;
sem(:,:,2,:) = SEM;

%30%
idx = find(marks(1:2:end,1) == 7);
gbcond = GoodBlocks(idx,:);
epochscond = epochsdt(:,:,idx,:);
for ch = 1:cfg.nch
    if isempty(find(gbcond(:,ch)))
        meancond(:,ch,:) = NaN(length(epochscond),1,2);
        SEM(:,ch,:) = NaN(length(epochscond),1,2);
    else
        epochch = epochscond(:,ch,gbcond(:,ch),:);
        meancond(:,ch,:) = mean(epochch,3);
        SEM(:,ch,:) = std(epochch,0,3)/sqrt(length(idx)-1);
    end
end
avg(:,:,3,:) = meancond;
sem(:,:,3,:) = SEM;

%Alt 60
idx = find(marks(1:2:end,1) == 2 | marks(1:2:end,1) == 4);
gbcond = GoodBlocks(idx,:);
epochscond = epochsdt(:,:,idx,:);
for ch = 1:cfg.nch
    if isempty(find(gbcond(:,ch)))
        meancond(:,ch,:) = NaN(length(epochscond),1,2);
        SEM(:,ch,:) = NaN(length(epochscond),1,2);
    else
        epochch = epochscond(:,ch,gbcond(:,ch),:);
        meancond(:,ch,:) = mean(epochch,3);
        SEM(:,ch,:) = std(epochch,0,3)/sqrt(length(idx)-1);
    end
end
avg(:,:,4,:) = meancond;
sem(:,:,4,:) = SEM;

%Alt 30
idx = find(marks(1:2:end,1) == 6 | marks(1:2:end,1) == 8);
gbcond = GoodBlocks(idx,:);
epochscond = epochsdt(:,:,idx,:);
for ch = 1:cfg.nch
    if isempty(find(gbcond(:,ch)))
        meancond(:,ch,:) = NaN(length(epochscond),1,2);
        SEM(:,ch,:) = NaN(length(epochscond),1,2);
    else
        epochch = epochscond(:,ch,gbcond(:,ch),:);
        meancond(:,ch,:) = mean(epochch,3);
        SEM(:,ch,:) = std(epochch,0,3)/sqrt(length(idx)-1);
    end
end
avg(:,:,5,:) = meancond;
sem(:,:,5,:) = SEM;

end