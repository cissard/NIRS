babies = input('Which babies to plot? e.g. [1,4,6] ');

time = 660;
begstim = 5/bb(1).measure.samplingperiod;
endstim = 24/bb(1).measure.samplingperiod;

for subjectn=babies;
    for C = 'NCD'
    nstim = size(bb(subjectn).(C).blks, 1);
    reject = zeros(nstim, AnP.nchannels);
        for t = 1:nstim
            scrsz = get(0,'ScreenSize');
            figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)]);
            for ch=1:24
                subplot(4,6,ch)
                plot(bb(subjectn).(C).blocks(t).data(:,ch,1),'r','LineWidth',1.5);
                hold on;
                plot(bb(subjectn).(C).blocks(t).data(:,ch,2),'b','LineWidth',1.5);
                axis([0 time -0.3 0.3]);
                timeX=[0,time];%tracer l'axe des abcisses au centre
                timeY=[0,0];
                line(timeX,timeY,'Color','k');
                startX=[begstim,begstim];%barre verticale pour marquer le début de la stimulation
                startY=[-0.1,0.1];
                line(startX,startY,'Color','k');
                endX=[endstim,endstim];%barre verticale pour marquer la fin de la stimulation
                endY=[-0.1,0.1];
                line(endX,endY,'Color','k');
                title({['Baby ',num2str(subjectn)];['Channel ',num2str(ch)]});
            end
            prompt = 'reject the trial ? [1/0]';
            r = input(prompt);
%             if r == 1
                rej(subjectn).(C)(t,:) = r;
%             end
            close
            
        end;
    end
end

% save('rejmanual','rej')