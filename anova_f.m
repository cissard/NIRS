function [donneesoxy, condition, sujet, F] = anova_f(avg,nbabies,nt,nch);
%construction de la matrice de données
donneesoxy=zeros(nbabies,3,nt,nch);

for bb=1:nbabies
    for cond = 'NCD'
        for t=1:nt
            for cl=1:nch
                if cond == 'N'
                    donneesoxy(bb,1,t,cl)=avg(bb).(cond)(t,cl,1);
                elseif cond == 'C'
                    donneesoxy(bb,2,t,cl)=avg(bb).(cond)(t,cl,1);
                elseif cond == 'D'
                    donneesoxy(bb,3,t,cl)=avg(bb).(cond)(t,cl,1);
                end
            end
        end
    end
end

%on remplit les vecteurs condition et sujet qui indiqueront la condition et le sujet dans le tableau de
%données
condition=repmat(['N','C','D']',nbabies,1);
sujet=reshape(repmat([1:nbabies],3,1),[],1);

%on remplace les valeurs manquantes par la moyenne (echantillon-condition-canal)
%pour pouvoir obtenir plus tard le F de Fisher.
for cl=1:nch
    for cond=1:3
        for t=1:nt
            ech=donneesoxy(:,cond,t,cl);
            nan=isnan(ech);
            ech(nan)=nanmean(ech);
            donneesoxy(:,cond,t,cl)=ech;
        end
    end
end
clear('ech')

%on remplit la variable vd qui contiendra les concentrations en hb (vecteur
%colonne avec les conditions l'une après l'autre). Refait à chaque échantillon-canal.
seuil=3.34; %définition libre, en fonction de la distribution du F ou pas.
F=cell(nch,nt);
for cl=1:nch
    for t=1:nt
        vd=reshape(donneesoxy(:,:,t,cl)',[],1);
        [p, table]=anovan(vd,{sujet condition},'random',1,'sstype',3,'model',3,'display','off');
        F(cl,t)=table(3,6);
    end
end
F = cell2mat(F); %Matrice des valeurs de F par canal et par échantillon temporel
F = F>= seuil;
