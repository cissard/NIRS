nbabies = length(avg);
nperm = 1000;

%construction de la matrice d'adjacence qui spécifie les relations entre
%les canaux
adjacence=false(24,24);
adjacence(1,2)=true;adjacence(1,3)=true;adjacence(1,4)=true;
adjacence(2,1)=true;adjacence(2,5)=true;adjacence(2,4)=true;
adjacence(3,1)=true;adjacence(3,6)=true;adjacence(3,8)=true;
adjacence(4,1)=true;adjacence(4,2)=true;adjacence(4,6)=true;adjacence(4,7);adjacence(4,9)=true;
adjacence(5,2)=true;adjacence(5,7)=true;adjacence(5,10)=true;
adjacence(6,3)=true;adjacence(6,4)=true;adjacence(6,7)=true;adjacence(6,8)=true;adjacence(6,9)=true;
adjacence(7,4)=true;adjacence(7,5)=true;adjacence(6,7)=true;adjacence(7,9)=true;adjacence(7,10)=true;
adjacence(8,3)=true;adjacence(8,6)=true;adjacence(8,11)=true;
adjacence(9,4)=true;adjacence(9,6)=true;adjacence(9,7)=true;adjacence(9,11)=true;adjacence(9,12)=true;
adjacence(10,5)=true;adjacence(10,7)=true;adjacence(10,12)=true;
adjacence(11,8)=true;adjacence(11,9)=true;adjacence(11,12)=true;
adjacence(12,10)=true;adjacence(12,9)=true;adjacence(11,12)=true;
adjacence(13,14)=true;adjacence(13,15)=true;adjacence(13,16)=true;
adjacence(14,13)=true;adjacence(14,16)=true;adjacence(14,17)=true;
adjacence(15,13)=true;adjacence(15,18)=true;adjacence(15,20)=true;
adjacence(16,13)=true;adjacence(16,14)=true;adjacence(16,18)=true;adjacence(16,19)=true;adjacence(16,21)=true;
adjacence(17,14)=true;adjacence(17,19)=true;adjacence(17,22)=true;
adjacence(18,15)=true;adjacence(18,16)=true;adjacence(18,19)=true;adjacence(18,20)=true;adjacence(18,21)=true;
adjacence(19,16)=true;adjacence(19,17)=true;adjacence(19,18)=true;adjacence(19,21)=true;adjacence(19,22)=true;
adjacence(20,15)=true;adjacence(20,18)=true;adjacence(20,23)=true;
adjacence(21,16)=true;adjacence(21,18)=true;adjacence(21,19)=true;adjacence(21,23)=true;adjacence(21,24)=true;
adjacence(22,17)=true;adjacence(22,19)=true;adjacence(22,24)=true;
adjacence(23,20)=true;adjacence(23,21)=true;adjacence(23,24)=true;
adjacence(24,21)=true;adjacence(24,22)=true;adjacence(24,23)=true;

%donneesOxy, matrice des moyennes par sujet et par condition [sujet x canal x condition]
donneesOxy=zeros(nbabies,24,3);
condition=[];
sujet=[];

for i=1:nbabies
    donneesOxy(i,:,1)=nanmean(wavg(i).N(3:6,:,1),1);
    donneesOxy(i,:,2)=nanmean(wavg(i).C(3:6,:,1),1);
    donneesOxy(i,:,3)=nanmean(wavg(i).D(3:6,:,1),1);
end

%on remplace les valeurs manquantes par la moyenne du couple
%(condition-canal) pour pouvoir obtenir plus tard le F de Fisher.
for j=1:3
  for k=1:24 
    canal=donneesOxy(:,k,j);
    nan=isnan(canal);
    canal(nan)=nanmean(canal);
    donneesOxy(:,k,j)=canal;
  end
end

%on remplit les vecteurs condition et sujet qui indiqueront la condition et le sujet dans le tableau de
%données
for b=1:nbabies;
    condition=cat(1,condition,'N');
    sujet=cat(1,sujet,b);
    condition=cat(1,condition,'C');
    sujet=cat(1,sujet,b);
    condition=cat(1,condition,'D');
    sujet=cat(1,sujet,b);
end

%on remplit la variable vd qui contiendra les concentrations en hb (vecteur
%colonne avec les conditions l'une après l'autre). Refait à chaque canal. 
F=[]; %F : vecteur des 24 valeurs de F (une par canal)
for c=1:24
    vd=[];
    for b=1:nbabies;
        vd=cat(1,vd,donneesOxy(b,c,1));
        vd=cat(1,vd,donneesOxy(b,c,2));
        vd=cat(1,vd,donneesOxy(b,c,3));  
    end
%     tableau=table(vd,sujet,condition)
    [p, table]=anovan(vd,{sujet condition},'random',1,'sstype',3,'model',3,'display','off');
    F=cat(1,F,table(3,6));
end
F=cell2mat(F);

%on refait les anovas en permutant les conditions
Permutations=[];
Fmax=[];
tailles=[];
for i=1:nperm;
    Fperm=[];
    for c=1:24
        P=[];
        for b=1:nbabies;
            p=[donneesOxy(b,c,1);donneesOxy(b,c,2);donneesOxy(b,c,3)]; 
            p=p(randperm(3));
            P=cat(1,P,p); %tableau de données avec les conditions permutées
        end
        [p, table]=anovan(P,{sujet condition},'random',1,'sstype',3,'model',3,'display','off');
        Fperm=cat(1, Fperm, table(3,6));
    end
    Fperm=cell2mat(Fperm);  
    Permutations=cat(2,Permutations,Fperm);
end

%détermination de la valeur critique au-dessus de laquelle les canaux
%seront considérés comme significatifs
Fmax=max(Permutations);
Fmax=sort(Fmax,'descend');
CV=Fmax(0.05*nperm+1);

%On commence par créer un compteur qui va compter le
%nombre de permutations ayant donné un cluster supérieur au plus grand cluster des données réelles.
pvalues=[]
significantchannels=[]
for t=1:length(F)
    counter=0;
    for k=1:nperm;
        if Fmax(k)>F(t)==1;
            counter=counter+1;
        end
    end
    if F(t)>=CV
        significantchannels=cat(1,significantchannels,t);
    end
    pvalue=counter/nperm;
    pvalues=cat(1,pvalues,pvalue);
end