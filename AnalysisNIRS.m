% clear all;close all;clc;
bb = 1
%Specify channels (source-detectors pairs)
% SD=false(8,10);
% SD(1,1)=true;SD(1,2)=true;SD(1,3)=true;
% SD(2,1)=true;SD(2,2)=true;SD(2,4)=true;
% SD(3,2)=true;SD(3,3)=true;SD(3,5)=true;
% SD(4,2)=true;SD(4,4)=true;SD(4,5)=true;
% SD(5,6)=true;SD(5,7)=true;SD(5,8)=true;
% SD(6,6)=true;SD(6,7)=true;SD(6,9)=true;
% SD(7,7)=true;SD(7,8)=true;SD(7,10)=true;
% SD(8,7)=true;SD(8,9)=true;SD(8,10)=true;
% SD=transpose(SD);
% cfg.SD = SD;
% clear SD

cfg.sf = 15.625;
cfg.nwls=2;
cfg.wls = [760 850];
cfg.nch = 24;
cfg.ns = 8;
cfg.nd = 10;
cfg.artifactperiod = 0.2; %in seconds
cfg.artifactthreshold = 0.05;

[data, marks] = NIRS_loadNIRxdata(cfg);
cfg.nblocks = length(marks)/2;

[baseline] = NIRS_baseline(cfg,data,marks,5,15);
[Hb, HbO] = NIRS_light2Hb(cfg,data,baseline);
%filter 
[b, a] = butter(1,[0.01 0.5]*2/cfg.sf,'bandpass');
Hbf = filtfilt(b,a,Hb);
HbOf = filtfilt(b,a,HbO);
clear b a
% h1=figure;plot(Hbf(:,:));saveas(h1,cfg.pID,'jpg');
% h2=figure;plot(HbOf(:,:));saveas(h2,cfg.pID,'jpg');

%epochs = [time * channels * blocks * Hb)
[length_blocks,epochs] = NIRS_defineepochs(cfg,Hbf,HbOf,marks,5,15);

% %detrend each trial
% for b=1:cfg.nblocks
%     epoch_Hb = epochs(:,:,b,1);
%     epoch_HbO = epochs(:,:,b,2);
%     epochsdt(:,:,b,1) = detrend(epoch_Hb);
%     epochsdt(:,:,b,2) = detrend(epoch_HbO);
% end

%reject bad trials
[GoodBlocks]=NIRS_reject(cfg,length_blocks,epochs);

%average trials from the same condition
[avg, sem] = NIRS_average(cfg,marks,epochs,GoodBlocks);
save(sprintf('avgbb%d',bb),'avg')
save(sprintf('sembb%d',bb),'sem')
save(sprintf('GoodBlocksbb%d',bb),'GoodBlocks')
%plot simple blocks
PlotAverageSimpleBlocks

%plot alt/non-alt blocks

AVG.(bb) = avg; 
