function [t_values, donneesoxy] = t_test(avg,nbabies,nt,nch,conditions);
%construction de la matrice de données
donneesoxy=zeros(nbabies,3,nt,nch);

for bb=1:nbabies
    for cond = 'ANB'
        for t=1:nt
            for ch=1:nch
                if cond == 'A'
                    donneesoxy(bb,1,t,ch)=avg(bb).(cond)(t,ch,1);
                elseif cond == 'N'
                    donneesoxy(bb,2,t,ch)=avg(bb).(cond)(t,ch,1);
                elseif cond == 'B'
                    donneesoxy(bb,3,t,ch)=0;
                    
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
seuil=2.045; %définition libre, en fonction de la distribution du t ou pas.
t_values=zeros(nch,nt);
for ch=1:nch
    for t=1:nt
        if strcmp(conditions,'AN')
            cond1 = donneesoxy(:,1,t,ch);
            cond2 = donneesoxy(:,2,t,ch);
        elseif strcmp(conditions,'AB')
            cond1 = donneesoxy(:,1,t,ch);
            cond2 = donneesoxy(:,3,t,ch);
        elseif strcmp(conditions,'NB')
            cond1 = donneesoxy(:,2,t,ch);
            cond2 = donneesoxy(:,3,t,ch);
        end
        [h, p, ci, stats] = ttest(cond1,cond2);
        t_values(ch,t)=stats(1).tstat;
    end
end
t_values = t_values>= seuil;
