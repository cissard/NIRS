%Script écrit par Cécile Issard, doctorante au laboratoire psychologie de
%la perception, Université Paris Descartes

%Si message d'erreur : "Attempted to access cluster(1,:); index out of bounds because size(cluster)=[0,0].
%Error in permutationClusters (line 96)
%region{1}=[cluster(1,:)];
%c'est qu'aucun canal n'atteint la valeur seuil donc aucun canal significatif.

nbabies = length(avg);
nt = length(avg(1).N);
nch = 24;
%construction de la matrice d'adjacence qui spécifie les relations entre
%les canaux
adjacence = logical(zeros(nch,nch)); 
%si nch ~= 24 adapter les lignes ci-dessous
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

%construction de la matrice de données
donneesoxy=zeros(nbabies,3,nt,nch);

for bb=1:nbabies
    for cond = 'NCD'
        for t=1:nt
            for ch=1:nch
            if cond == 'N'
                donneesoxy(bb,1,t,ch)=avg(bb).(cond)(t,ch,1);
            elseif cond == 'C'
                donneesoxy(bb,2,t,ch)=avg(bb).(cond)(t,ch,1);
            elseif cond == 'D'
                donneesoxy(bb,3,t,ch)=avg(bb).(cond)(t,ch,1);
            end
            end
        end
    end
end

%on remplit les vecteurs condition et sujet qui indiqueront la condition et le sujet dans le tableau de
%données
condition=repmat(['N','C','D']',29,1);
sujet=reshape(repmat([1:29],3,1),[],1);

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
seuil=3.59; %définition libre, en fonction de la distribution du F ou pas. 
F=cell(nch,nt);
for ch=1:nch
    for t=1:nt
        vd=reshape(donneesoxy(:,:,t,ch)',[],1);
        [p, table]=anovan(vd,{sujet condition},'random',1,'sstype',3,'model',3,'display','off');
        F(ch,t)= table(3,6)>= seuil;
    end
end
F=cell2mat(F); %Matrice des valeurs de F par canal et par échantillon temporel
F = F>= seuil;
%trouver les canaux actifs dans les données originales

%--------Part written by María Clemencia Ortiz Barajas-----------%
%trouver s'il existe des régions d'activité dans les données originales
[active_ch,active_t] = find(F);
active_ch = unique(active_ch);

active_ch_LH = intersect(active_ch,[1:12]);
active_ch_RH = intersect(active_ch,[13:24]);

% Trouver les clusters (dans le temps, pour chaque canal)
cluster_info = [];
nb_cluster = [];
for k1 = 1:length(active_ch)    
    who1 = active_ch(k1);
    t_who1 = find(F(who1,:));
    nclusters = 1;
    limL(nclusters) = 1;
    for slide = 1:length(t_who1)-1
        if t_who1(slide+1) ~= t_who1(slide)+1 % si les échantillons ne se succèdent pas, donc qu'ils ne sont pas dans le même cluster
            limH(nclusters) = slide; %le cluster s'arrête ici
            nclusters = nclusters+1; %on créé un nouveau cluster
            limL(nclusters) = slide+1;
        end        
    end
    limH(nclusters) = length(t_who1);
    cluster_info_temp(1,1:length(limL)) = who1; % canal où se situe le cluster, autant de colonnes que de moments d'activité dans le canal
    cluster_info_temp(2,:) = t_who1(limL); % échantillon où commence le(s) cluster(s)
    cluster_info_temp(3,:) = t_who1(limH); % échantillon où s'arrête le(s) cluster(s)
    cluster_info_temp(4,:) = t_who1(limH) - t_who1(limL) +1; % durée du/des cluster(s)
    cluster_info = cat(2,cluster_info,cluster_info_temp);
    nb_cluster = cat(2,nb_cluster,nclusters); % nombe de moments d'activité par canal
    clear limH limL slide cluster_info_temp t_who1 who1 cont
end   
clear k1
%------------------------------------------------------------------------%

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
