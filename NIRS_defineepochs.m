function [length_blocks,epochs] = NIRS_defineepochs(cfg,Hbf,HbOf,marks,pre,post)
    beg_blocks = marks(1:2:end,2);
    end_blocks = marks(2:2:end,2);
    length_blocks = mode(end_blocks-beg_blocks);
    
    length_pre = round(cfg.sf * pre);
    length_post = round(cfg.sf * post);

    epoch_start = zeros(1,cfg.nblocks); 
    epoch_end = zeros(1,cfg.nblocks);
    durations = zeros(1,cfg.nblocks);
for b = 1:cfg.nblocks 
    epoch_start(b) = beg_blocks(b) - length_pre;
    epoch_end(b) = end_blocks(b) + length_post;
    
    durations(b) = epoch_end(b) - epoch_start(b);
end

duration = mode(durations);

%epochs = zeros(duration,,cfg.nblocks,2);
for b = 1:cfg.nblocks 
    epoch_end(b) = epoch_start(b) + duration-1;
    epochs(:,:,b,1) = Hbf(epoch_start(b):epoch_end(b),:);
    epochs(:,:,b,2) = HbOf(epoch_start(b):epoch_end(b),:);
end

end