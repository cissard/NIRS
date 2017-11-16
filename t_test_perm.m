function [t_values] = t_test(donneesoxy,nbabies,nt,nch,conditions);

P = [];
for bb=1:nbabies;
    donnees = [donneesoxy(bb,1,:,:) donneesoxy(bb,2,:,:) donneesoxy(bb,3,:,:)];
    perm_index = randperm(3);
    perm = donnees(:,perm_index,:,:);
    P=cat(1,P,perm); %tableau de données avec les conditions permutées
end

%on remplit la variable vd qui contiendra les concentrations en hb (vecteur
%colonne avec les conditions l'une après l'autre). Refait à chaque échantillon-canal.
seuil=2.045; %définition libre, en fonction de la distribution du t ou pas.
t_values=cell(nch,nt);
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
        t_values(ch,t)=stats(1);
    end
end
t_values = t_values>= seuil;
