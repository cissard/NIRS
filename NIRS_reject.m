function [GoodBlocks] = NIRS_reject(cfg,length_blocks,epochs)

GoodBlocks = zeros(cfg.nblocks,1);
for b=1:cfg.nblocks
    %plot each trial
    time = length(epochs);
    begstim = round(5*cfg.sf);
    endstim = round(5*cfg.sf+length_blocks);
    scrsz = get(0,'ScreenSize');
    figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)]);
    for ch=1:24
        h = subplot(4,6,ch);
        hold on
        plot(epochs(:,ch,b,1),'b')
        plot(epochs(:,ch,b,2),'r')
        set(h,'xlim',[0 size(epochs,1)])
        set(h,'xtick',[begstim endstim])
        set(gca,'xticklabel',[0 round(length_blocks/cfg.sf)])
        timeX=[0,time];%tracer l'axe des abcisses au centre
		timeY=[0,0];
		line(timeX,timeY,'Color','k');
        startX=[begstim,begstim];%barre verticale pour marquer le début de la stimulation
		startY=[min(epochs(:,ch,b,2)),max(epochs(:,ch,b,2))];
		line(startX,startY,'Color','k');
        endX=[endstim,endstim];%barre verticale pour marquer la fin de la stimulation
		endY=[min(epochs(:,ch,b,2)),max(epochs(:,ch,b,2))];
        line(endX,endY,'Color','k');
    end
    %manually reject bad trials for all channels
    prompt = 'keep the trial ? [1/0]';
    GoodBlocks(b) = input(prompt);
    close
end

%automatically reject bad trials
GoodBlocks = repmat(GoodBlocks,1,cfg.nch);

for b = 1:cfg.nblocks
    for ch = 1:cfg.nch
        for Hb = 1:2
            % (by z-scores computed along blocks i.e. each time point-channel-Hb is centered around 0)
            epochz = zscore(epochsdt(:,ch,b,Hb));
            if any(abs(epochz) >= 4)
                GoodBlocks(b,ch) = 0;
            else
                GoodBlocks(b,ch) = 1;
            end
            
            % by variation or absolute threshold
            nsampart = round(cfg.artifactperiod * cfg.sf);
            for t = 1:length(epochsdt)-nsampart
                dif = epochsdt(t+nsampart,ch,b,Hb)-epochsdt(t,ch,b,Hb);
                if dif >= cfg.artifactthreshold || abs(epochsdt(t,ch,b,Hb)) >= 0.15
                    GoodBlocks(b,ch) = 0;
                    break
                end
            end
        end
    end
end
GoodBlocks=logical(GoodBlocks);

end