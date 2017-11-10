function [Fperm] = anova_f(donneesoxy,condition,sujet,nbabies,nt,nch);

P = [];
for bb=1:nbabies;
    donnees = [donneesoxy(bb,1,:,:) donneesoxy(bb,2,:,:) donneesoxy(bb,3,:,:)];
    perm_index = randperm(3);
    perm = donnees(:,perm_index,:,:);
    P=cat(1,P,perm); %tableau de donn�es avec les conditions permut�es
end

%on remplit la variable vd qui contiendra les concentrations en hb (vecteur
%colonne avec les conditions l'une apr�s l'autre). Refait � chaque �chantillon-canal.
seuil=3.34; %d�finition libre, en fonction de la distribution du F ou pas.
Fperm=cell(nch,nt);
for ch=1:nch
    for t=1:nt
        vd=reshape(P(:,:,t,ch)',[],1);
        [p, table]=anovan(vd,{sujet condition},'random',1,'sstype',3,'model',3,'display','off');
        Fperm(ch,t)=table(3,6);
    end
end
Fperm = cell2mat(Fperm); %Matrice des valeurs de F par canal et par �chantillon temporel
Fperm = Fperm>= seuil;
