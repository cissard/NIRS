nbabies = length(wavg);
nperm = 1000;

%donneesOxy, matrice des moyennes par sujet et par condition [sujet x canal x condition]
donneesOxy=zeros(nbabies,24,2);
condition=[];
sujet=[];

for i=1:nbabies
%     donneesOxy(i,:,1) = 0;
    donneesOxy(i,:,2)=nanmean(wavg(i).C(3:6,:,1),1);
%     donneesOxy(i,:,2)=nanmean(wavg(i).D(3:6,:,1),1);
    donneesOxy(i,:,1)=nanmean(wavg(i).N(3:6,:,1),1);
%     donneesOxy(i,:,2)=nanmean(wavg(i).A(3:6,:,1),1);
end

%on remplace les valeurs manquantes par la moyenne du couple
%(condition-canal) pour pouvoir obtenir plus tard le F de Fisher.
for j=1:2
  for k=1:24 
    canal=donneesOxy(:,k,j);
    nan=isnan(canal);
    canal(nan)=nanmean(canal);
    donneesOxy(:,k,j)=canal;
  end
end

%on remplit la variable vd qui contiendra les concentrations en hb (vecteur
%colonne avec les conditions l'une après l'autre). Refait à chaque canal. 
t=[]; %F : vecteur des 24 valeurs de F (une par canal)
for c=1:24
    x=donneesOxy(:,c,1);
    y=donneesOxy(:,c,2);
    [h,p,ci,stats]=ttest(x,y);
    t=cat(1,t,stats.tstat);
end

%on recalcule les t en permutant les conditions
Permutations=[];
tmax=[];
for i=1:nperm;
    tperm=[];
    for c=1:24
        P=[];
        for b=1:nbabies;
            perm=[donneesOxy(b,c,1) donneesOxy(b,c,2)]; 
            perm=perm(randperm(2));
            P=cat(1,P,perm); %tableau de données avec les conditions permutées
        end
        x=P(:,1);
        y=P(:,2);
        [h,p,ci,stats]=ttest(x,y);
        tperm=cat(1,tperm,stats.tstat);
    end
    Permutations=cat(2,Permutations,tperm);
end

%détermination de la valeur critique au-dessus de laquelle les canaux
%seront considérés comme significatifs
tmax=max(Permutations);
tmax=sort(tmax,'descend');
CV=tmax(0.05*nperm+1); %(nombre de permutations*5%)+1

%On commence par créer un compteur qui va compter le
%nombre de permutations ayant donné un cluster supérieur au plus grand cluster des données réelles.
pvalues=[];
significantchannels=[];
for l=1:length(t)
    counter=0;
    for k=1:nperm;
        if tmax(k)>abs(t(l))==1;
            counter=counter+1;
        end
    end
    if abs(t(l))>=CV
        significantchannels=cat(1,significantchannels,t);
    end
    pvalue=counter/nperm;
    pvalues=cat(1,pvalues,pvalue);
end