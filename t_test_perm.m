function [t_values, h_matrix] = t_test(donneesoxy,nbabies,nt,nch,conditions);

P = [];
for bb=1:nbabies;
    donnees = [donneesoxy(bb,1,:,:) donneesoxy(bb,2,:,:) donneesoxy(bb,3,:,:) donneesoxy(bb,4,:,:)];
    perm_index = randperm(4);
    perm = donnees(:,perm_index,:,:);
    P=cat(1,P,perm); %tableau de données avec les conditions permutées
end

%on remplit la variable vd qui contiendra les concentrations en hb (vecteur
%colonne avec les conditions l'une après l'autre). Refait à chaque échantillon-canal.
%seuil=2.045; %définition libre, en fonction de la distribution du t ou pas.
t_values=zeros(nch,nt);
for ch=1:nch
    for t=1:nt
        if strcmp(conditions,'AN') || strcmp(conditions,'NA')
            cond1 = P(:,3,t,ch);
            cond2 = P(:,2,t,ch);
        elseif strcmp(conditions,'AB') || strcmp(conditions,'BA')
            cond1 = P(:,3,t,ch);
            cond2 = P(:,1,t,ch);
        elseif strcmp(conditions,'NB') || strcmp(conditions,'BN')
            cond1 = P(:,2,t,ch);
            cond2 = P(:,1,t,ch); 
        elseif strcmp(conditions,'CB') || strcmp(conditions,'BC')
            cond1 = P(:,3,t,ch); 
            cond2 = P(:,1,t,ch);
        elseif strcmp(conditions,'DB') || strcmp(conditions,'BD')
            cond1 = P(:,4,t,ch);
            cond2 = P(:,1,t,ch);
        elseif strcmp(conditions,'NC') || strcmp(conditions,'CN')
            cond1 = P(:,2,t,ch);
            cond2 = P(:,3,t,ch);
        elseif strcmp(conditions,'ND') || strcmp(conditions,'DN')
            cond1 = P(:,2,t,ch);
            cond2 = P(:,4,t,ch);
        elseif strcmp(conditions,'CD') || strcmp(conditions,'DC')
            cond1 = P(:,3,t,ch);
            cond2 = P(:,4,t,ch);
        end
        [h, p, ci, stats] = ttest(cond1,cond2);
        t_values(ch,t) = stats(1).tstat;
        h_matrix(ch,t) = h;
    end
end
%t_values = t_values>= seuil;
