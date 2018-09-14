%Script écrit par Cécile Issard, doctorante au laboratoire psychologie de
%la perception, Université Paris Descartes

[donneesoxy, condition, sujet, F, h_matrix] = anova_f(avg,nbabies,nt,nch);
imagesc(h_matrix)

[length_clusters,F_clusters,clusters] = identify_clusters(h_matrix,F,adjacence);

%%
biggest_clusters = zeros(1,nperm);

tic
for perm = 1:nperm
    [Fperm, h_perm] = anova_perm(donneesoxy,condition,sujet,nbabies,nt,nch);
    if ~isempty(find(h_perm))
        [length_clusters_perm, F_clusters_perm] = identify_clusters(h_perm,Fperm,adjacence);
        biggest_clusters(1,perm) = max(length_clusters_perm);
    else
        biggest_clusters(1,perm) = 0;
    end
    perm
    
end
biggest_clusters=sort(biggest_clusters);
hist = histogram(biggest_clusters)
toc

pvalues = zeros(size(length_clusters,1),1);
for i=1:size(length_clusters,1)
    pvalue = [];
    n = find(biggest_clusters>length_clusters(i));
    n = length(n);
    pvalue = n./nperm;
    clusters(i).pvalues = pvalue;
end

save('Ang32_Nonalt_F','clusters','biggest_clusters','pvalues')