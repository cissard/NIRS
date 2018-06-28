function [Fperm, h_perm] = anova_perm(donneesoxy,condition,sujet,nbabies,nt,nch);

P = [];
for bb=1:nbabies;
    donnees = [donneesoxy(bb,1,:,:) donneesoxy(bb,2,:,:) donneesoxy(bb,3,:,:)];
    perm_index = randperm(3);
    perm = donnees(:,perm_index,:,:);
    P=cat(1,P,perm); %tableau de données avec les conditions permutées
end

%on remplit la variable vd qui contiendra les concentrations en hb (vecteur
%colonne avec les conditions l'une après l'autre). Refait à chaque échantillon-canal.

% seuil=3.34; %définition libre, en fonction de la distribution du F ou pas.
Fperm=cell(nch,nt);
for ch=1:nch
    for t=1:nt
        vd=reshape(P(:,:,t,ch)',[],1);
        [p, table]=anovan(vd,{sujet condition},'random',1,'sstype',3,'model',3,'display','off');
        Fperm(ch,t)=table(3,6);
        p_values (ch,t) = p(2);
    end
end
Fperm = cell2mat(Fperm); %Matrice des valeurs de F par canal et par échantillon temporel
h_perm = zeros(ch,t);
sig=find(p_values <= 0.05);
h_perm(sig)=1;

