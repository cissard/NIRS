function [t_values, donneesoxy] = t_test(avg,nbabies,nt,nch,conditions,seuil);
%construction de la matrice de données
donneesoxy=zeros(nbabies,4,nt,nch);

for bb=1:nbabies
    for cond = conditions
        for t=1:nt
            for ch=1:nch
                if cond == 'B'
                    donneesoxy(bb,1,t,ch)=0;
                elseif cond == 'N'
                    donneesoxy(bb,2,t,ch)=avg(bb).(cond)(t,ch,1);
                elseif cond == 'A'
                    donneesoxy(bb,3,t,ch)=avg(bb).(cond)(t,ch,1);
                elseif cond == 'C'
                    donneesoxy(bb,3,t,ch)=avg(bb).(cond)(t,ch,1);
                elseif cond == 'D'
                    donneesoxy(bb,4,t,ch)=avg(bb).(cond)(t,ch,1);
                end
            end
        end
    end
end

%on remplace les valeurs manquantes par la moyenne (echantillon-condition-canal)
%pour pouvoir obtenir plus tard le F de Fisher.
for ch=1:nch
    for cond=1:3
        for t=1:nt
            ech=donneesoxy(:,cond,t,ch);
            nan=isnan(ech);
            ech(nan)=nanmean(ech);
            donneesoxy(:,cond,t,ch)=ech;
        end
    end
end
clear('ech')

%on remplit la variable vd qui contiendra les concentrations en hb (vecteur
%colonne avec les conditions l'une après l'autre). Refait à chaque échantillon-canal.
t_values=zeros(nch,nt);
for ch=1:nch
    for t=1:nt
        if strcmp(conditions,'AN') || strcmp(conditions,'NA')
            cond1 = donneesoxy(:,3,t,ch);
            cond2 = donneesoxy(:,2,t,ch);
        elseif strcmp(conditions,'NC') || strcmp(conditions,'CN')
            cond1 = donneesoxy(:,2,t,ch);
            cond2 = donneesoxy(:,3,t,ch);
        elseif strcmp(conditions,'ND') || strcmp(conditions,'DN')
            cond1 = donneesoxy(:,2,t,ch);
            cond2 = donneesoxy(:,4,t,ch);
        elseif strcmp(conditions,'AB') || strcmp(conditions,'BA')
            cond1 = donneesoxy(:,3,t,ch);
            cond2 = donneesoxy(:,1,t,ch);
        elseif strcmp(conditions,'NB') || strcmp(conditions,'BN')
            cond1 = donneesoxy(:,2,t,ch);
            cond2 = donneesoxy(:,1,t,ch);
        elseif strcmp(conditions,'CB') || strcmp(conditions,'BC')
            cond1 = donneesoxy(:,3,t,ch);
            cond2 = donneesoxy(:,1,t,ch);
        elseif strcmp(conditions,'DB') || strcmp(conditions,'DB')
            cond1 = donneesoxy(:,4,t,ch);
            cond2 = donneesoxy(:,1,t,ch);
        elseif strcmp(conditions,'CD') || strcmp(conditions,'DC')
            cond1 = donneesoxy(:,4,t,ch);
            cond2 = donneesoxy(:,1,t,ch);
        end
        [h, p, ci, stats] = ttest(cond1,cond2);
        t_values(ch,t)=stats(1).tstat;
    end
end
t_values = t_values>= seuil;
