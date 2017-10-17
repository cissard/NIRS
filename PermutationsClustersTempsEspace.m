%Script écrit par Cécile Issard, doctorante au laboratoire psychologie de
%la perception, Université Paris Descartes

%Si message d'erreur : "Attempted to access cluster(1,:); index out of bounds because size(cluster)=[0,0].
%Error in permutationClusters (line 96)
%region{1}=[cluster(1,:)];
%c'est qu'aucun canal n'atteint la valeur seuil donc aucun canal significatif.

nbabies = length(avg);

%construction de la matrice d'adjacence qui spécifie les relations entre
%les canaux
adjacence=zeros(24,24);
adjacence(1,2)=1;adjacence(1,3)=1;adjacence(1,4)=1;
adjacence(2,1)=1;adjacence(2,5)=1;adjacence(2,4)=1;
adjacence(3,1)=1;adjacence(3,6)=1;adjacence(3,8)=1;
adjacence(4,1)=1;adjacence(4,2)=1;adjacence(4,6);adjacence(4,7);adjacence(4,9)=1;
adjacence(5,2)=1;adjacence(5,7)=1;adjacence(5,10)=1;
adjacence(6,3)=1;adjacence(6,4)=1;adjacence(6,7)=1;adjacence(6,8)=1;adjacence(6,9)=1;
adjacence(7,4)=1;adjacence(7,5)=1;adjacence(6,7)=1;adjacence(7,9)=1;adjacence(7,10)=1;
adjacence(8,3)=1;adjacence(8,6)=1;adjacence(8,11)=1;
adjacence(9,4)=1;adjacence(9,6)=1;adjacence(9,7)=1;adjacence(9,11)=1;adjacence(9,12)=1;
adjacence(10,5)=1;adjacence(10,7)=1;adjacence(10,12)=1;
adjacence(11,8)=1;adjacence(11,9)=1;adjacence(11,12)=1;
adjacence(12,10)=1;adjacence(12,9)=1;adjacence(11,12)=1;
adjacence(13,14)=1;adjacence(13,15)=1;adjacence(13,16)=1;
adjacence(14,13)=1;adjacence(14,16)=1;adjacence(14,17)=1;
adjacence(15,13)=1;adjacence(15,18)=1;adjacence(15,20)=1;
adjacence(16,13)=1;adjacence(16,14)=1;adjacence(16,18)=1;adjacence(16,19)=1;adjacence(16,21)=1;
adjacence(17,14)=1;adjacence(17,19)=1;adjacence(17,22)=1;
adjacence(18,15)=1;adjacence(18,16)=1;adjacence(18,19)=1;adjacence(18,20)=1;adjacence(18,21)=1;
adjacence(19,16)=1;adjacence(19,17)=1;adjacence(19,18)=1;adjacence(19,21)=1;adjacence(19,22)=1;
adjacence(20,15)=1;adjacence(20,18)=1;adjacence(20,23)=1;
adjacence(21,16)=1;adjacence(21,18)=1;adjacence(21,19)=1;adjacence(21,23)=1;adjacence(21,24)=1;
adjacence(22,17)=1;adjacence(22,19)=1;adjacence(22,24)=1;
adjacence(23,20)=1;adjacence(23,21)=1;adjacence(23,24)=1;
adjacence(24,21)=1;adjacence(24,22)=1;adjacence(24,23)=1;
adjacence = logical(adjacence);

%construction de la matrice des données
donneesoxy=zeros(nbabies,3,length(avg(1).N),24);

for k=1:24
    donneesOxy=[];
    for e=1:length(avg(1).N)
        donneesOxyech=[];
        for bb=1:nbabies
            echantillon=avg(bb).N(e,k,1);
            donneesOxyech=cat(1,donneesOxyech,echantillon);
        end
    donneesOxy=cat(3,donneesOxy,donneesOxyech);
    end
    donneesoxy(:,1,:,k)=donneesOxy;
    
    donneesOxy=[];
    for e=1:length(avg(1).C)
        donneesOxyech=[];
        for bb=1:nbabies
            echantillon=avg(bb).C(e,k,1);
            donneesOxyech=cat(1,donneesOxyech,echantillon);
        end
    donneesOxy=cat(3,donneesOxy,donneesOxyech);
    end
    donneesoxy(:,2,:,k)=donneesOxy;
    
    donneesOxy=[];
    for e=1:length(avg(1).D)
        donneesOxyech=[];
        for bb=1:nbabies
            echantillon=avg(bb).D(e,k,1);
            donneesOxyech=cat(1,donneesOxyech,echantillon);
        end
    donneesOxy=cat(3,donneesOxy,donneesOxyech);
    end
    donneesoxy(:,3,:,k)=donneesOxy;
end

%on remplace les valeurs manquantes par la moyenne (echantillon-condition-canal) 
%pour pouvoir obtenir plus tard le F de Fisher.
for k=1:24
    for e=1:length(avg(1).N)
        for cond=1:3
            ech=donneesoxy(:,cond,e,k);
            nan=isnan(ech);
            ech(nan)=nanmean(ech);
            donneesoxy(:,cond,e,k)=ech;
        end
    end
end

%on remplit les vecteurs condition et sujet qui indiqueront la condition et le sujet dans le tableau de
%données
condition=[];
sujet=[];
for b=1:nbabies;
    condition=cat(1,condition,'N');
    sujet=cat(1,sujet,b);
    condition=cat(1,condition,'C');
    sujet=cat(1,sujet,b);
    condition=cat(1,condition,'D');
    sujet=cat(1,sujet,b);
end

%on remplit la variable vd qui contiendra les concentrations en hb (vecteur
%colonne avec les conditions l'une après l'autre). Refait à chaque échantillon-canal. 
F=[]; %F : matrice des nb d'échantillons*24 valeurs de F (une par canal)
for c=1:24
    Fcanal=[];
    for e=1:length(avg(1).N)
        vd=[];
        for b=1:nbabies;
            vd=cat(1,vd,transpose(donneesoxy(b,:,e,c)));
        end
        [p, table]=anovan(vd,{sujet condition},'random',1,'sstype',3,'model',3,'display','off');
        Fcanal=cat(1,Fcanal,table(3,6));
    end
    F=cat(2,F,Fcanal);
end
F=cell2mat(F); %Matrice des valeurs de F par canal et par échantillon temporel

%trouver s'il existe des régions d'activité dans les données originales
seuil=3.59; %définition libre, en fonction de la distribution du F ou pas. 

clusters{1}=[];
for ch=1:24;
    temps=[];
    timecluster=[];
    t=0;
    for s=1:length(avg(1).N)-1;
        t=t+1;
        if F(s,ch)>seuil;
            temps=cat(2,temps,t);
            if F(s+1,ch)<seuil;
                timecluster=cat(1,timecluster,[min(temps) max(temps)])
                temps=[];
            end
            if t==length(avg(1).N);
                timecluster=cat(1,timecluster,[min(temps) max(temps)])
            end
        end
    end
    if isempty(timecluster);
        timecluster=[0 0]
    end
    clusters{ch}=[timecluster];
end

%trouver les clusters
tailleclusters=[]
for canal=1:23
    if ~clusters{canal}==[0 0]
        for canal2=canal+1:24
            if adjacence(canal,canal2)==1 && ~cluster{canal2}(1,:)==[0 0]
                %déterminer si il y a un croisement entre les moments des
                %deux canaux.
            end    
            if clusters{cluster}==[0 0]
                taille=
                tailleclusters=cat(1,tailleclusters,

        end
    end
end
region{1}=[cluster(1,:)];
for z=1:(size(cluster,1)-1);
        commun=intersect(cluster(z,:),cluster(z+1,:)); %on prend les couples de canaux > seuil et adjacents et on regarde s'il appartiennent au même cluster cad s'ils ont un canal en commun
        difference=setdiff(cluster(z+1,:),cluster(z,:));
        if ~isempty(commun);
            region{length(region)}=[region{length(region)} difference]; % si on reste dans le meme cluster on ajoute le canal sur la meme ligne
        else
            region{length(region)+1}=[cluster(z+1,:)]; % si nouveau cluster on passe à une autre cellule
        end
end

%retirer les doublons dans les cas où le cluster de contient qu'un seul
%canal, les canaux étant ajoutés à cluster par couple (cf l.91).
for i=1:length(region)
    if region{i}(1) == region{i}(2)
        region{i}(2)=[]
    end
end

%taille du plus grand cluster. Ajuster au nombre de cellules contenues dans region.
taille=[length(region{1}) length(region{2}) length(region{3})]
biggercluster=max(taille)

%on refait les anovas en permutant les conditions
biggerclusters=[]
Permutations=[];
Fmax=[];
tailles=[];
for i=1:1000;
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
    
    %trouver s'il existe des régions d'activité
    seuil=2.99;
    clusters=[];
    for k=1:24
        if Fperm(k)>seuil==1
            for j=k+1:length(F)
                if and(Fperm(j)>seuil,adjacence(k,j)==1) %Si un canal passe le seuil, on explore les autres canaux et on ne retient que ceux qui sont >CV et adjacents.
                    clusters=cat(1,clusters, [k j]);
                end
            end
            if isempty(find(clusters==i))
                clusters=cat(1,clusters,[i i]);
            end
        end
    end
    
    if isempty(clusters)
        clu=0;
    else
        regions{1}=[clusters(1,:)];
        for z=1:(size(clusters,1)-1)
            commun=intersect(clusters(z,:),clusters(z+1,:)); %on prend les couples de canaux > seuil et adjacents et on regarde s'il appartiennent au même cluster cad s'ils ont un canal en commun
            difference=setdiff(clusters(z+1,:),clusters(z,:));
            if ~isempty(commun)
                regions{length(regions)}=[regions{length(regions)} difference]; % si on reste dans le meme cluster on ajoute le canal sur la meme ligne
            else
                regions{length(regions)+1}=[clusters(z+1,:)]; % si nouveau cluster on passe à une autre cellule
            end
        end
    %retirer les doublons dans les cas où le cluster de contient qu'un seul
%canal, les canaux étant ajoutés à cluster par couple (cf l.91).
        for a=1:length(regions);
            if regions{a}(1) == regions{a}(2);
                regions{a}(2)=[];
            end
        end
        %taille du plus grand cluster.
        for i=length(regions)
            tailles=cat(2,tailles,length(regions{i}));
        end
        clu=max(tailles);
    end

    biggerclusters=cat(1,biggerclusters,clu);
    clear regions;
end

%détermination de la valeur critique au-dessus de laquelle les canaux
%seront considérés comme significatifs
biggerclusters=sort(biggerclusters,'descend');
CV=biggerclusters(51); %(nombre de permutations*5%)+1

%On commence par créer un compteur qui va compter le
%nombre de permutations ayant donné un cluster supérieur au plus grand cluster des données réelles.
pvalues=[]
for t=1:length(region)
    counter=0
    for k=1:10000;
        if biggerclusters(k)>size(region{t},2)==1;
            counter=counter+1;
        end
    end
    pvalue=counter/10000; 
    pvalues=cat(2,pvalues,pvalue)
end