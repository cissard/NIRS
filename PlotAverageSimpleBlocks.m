
ylimval=0.07;

time=1:length(avg);
begstim=round(5*cfg.sf);
endstim=round(5*cfg.sf+length_blocks);

ordre_ch = [2 4 1 5 7 10 6 3 8 9 12 11 13 16 14 15 18 20 19 17 22 21 23 24];%ordre dans la matrice de données
channels=[5 10 2 7 12 4 9 1 6 11 3 8 20 15 23 18 13 21 16 24 19 14 22 17];%pour subplot
scrsz = get(0,'ScreenSize');
f = figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)]);

RECT=[0.10 0.67 0.12 0.10
0.28 0.67 0.12 0.10
0.02 0.56 0.12 0.10
0.19 0.56 0.12 0.10
0.36 0.56 0.12 0.10
0.10 0.45 0.12 0.10
0.28 0.45 0.12 0.10
0.02 0.34 0.12 0.10
0.19 0.34 0.12 0.10
0.36 0.34 0.12 0.10
0.10 0.23 0.12 0.10
0.28 0.23 0.12 0.10
0.60 0.67 0.12 0.10
0.78 0.67 0.12 0.10
0.52 0.56 0.12 0.10
0.69 0.56 0.12 0.10
0.86 0.56 0.12 0.10
0.60 0.45 0.12 0.10
0.78 0.45 0.12 0.10
0.52 0.34 0.12 0.10
0.69 0.34 0.12 0.10
0.86 0.34 0.12 0.10
0.60 0.23 0.12 0.10
0.78 0.23 0.12 0.10];

colorSEMHb = [.2 .2 1;
              .2 1 1;
              .5 1 1];
          
colorMeanHb = [0 0 1;
               0 1 1;
               0 1 1];
           
colorSEMHbO = [1 0.2 0.2;
               1 .2 1;
               1 .5 1];

colorMeanHbO = [1 0 0;
                1 0 1;
                1 0 1];

for ch=1:24
    chnl = find(ordre_ch == channels(ch));
    
    subplot('position', RECT(ch,:));
    box off
    hold on
    
    plot([0 begstim begstim endstim endstim time(end)],[0 0 ylimval/3  ylimval/3 0 0],'k-')
    
    for cond = 1:3
        X = [time fliplr(time)];
        %deoxy
        Y = [(avg(:,chnl,cond,1)+sem(:,chnl,cond,1))' fliplr((avg(:,chnl,cond,1)-sem(:,chnl,cond,1))')];
        p = patch(X,Y,colorSEMHb(cond,:));
        p.FaceAlpha = .2;
        p.EdgeColor = 'none';
        if cond==3
        h(cond) = plot(avg(:,chnl,cond,1),'Color',colorMeanHb(cond,:),'LineStyle','--','LineWidth',1);
        else
            h(cond) = plot(avg(:,chnl,cond,1),'Color',colorMeanHb(cond,:),'LineWidth',1);
        end     
        %oxy
        Y = [(avg(:,chnl,cond,2)+sem(:,chnl,cond,2))' fliplr((avg(:,chnl,cond,2)-sem(:,chnl,cond,2))')];
        p = patch(X,Y,colorSEMHbO(cond,:));
        p.FaceAlpha = .2;
        p.EdgeColor = 'none';
        if cond==3
        h(cond) = plot(avg(:,chnl,cond,2),'Color',colorMeanHbO(cond,:),'LineStyle','--','LineWidth',1);
        else
            h(cond) = plot(avg(:,chnl,cond,2),'Color',colorMeanHbO(cond,:),'LineWidth',1);
        end     
    end
    
    set(gca,'ylim',[-ylimval ylimval])
    set(gca,'xlim',[0 time(end)])
    set(gca,'xtick',[begstim endstim time(end)])
    set(gca,'xticklabel',[5 round(length_blocks/cfg.sf)+5 round(time(end)/cfg.sf)])
    set(gca,'ytick',[-ylimval:0.05:ylimval])

    title({['Channel ',num2str(channels(ch))]});
    if ~(ch==11 | ch==23);axis off;end

end

clear stim timeX timeY ylimval xlimval time channels

%légende
subplot('position',[0.05 0.12  0.75 0.05])
hold on

plot([0.05 0.10],[0.50 0.50],'r','LineWidth',1.5)
plot([0.25 0.30],[0.50 0.50],'b','LineWidth',1.5)
plot([0.50 0.55],[0.50 0.50],'m','LineWidth',1.5)
plot([0.70 0.75],[0.50 0.50],'c','LineWidth',1.5)
plot([0.90 0.95],[0.50 0.50],'--m','LineWidth',1.5)
plot([1.10 1.15],[0.50 0.50],'--c','LineWidth',1.5)

text(0.11,0.25,'Normal Oxy')
text(0.31,0.45,'Normal Deoxy')
text(0.56,0.70,'60% Oxy')
text(0.76, 0.90,'60% Deoxy')
text(0.96, 1.10,'30% Oxy')
text(1.16, 1.30,'30% Deoxy')
axis off

saveas(f,'PlotAverageSimpleBlocksBB','jpg')

close