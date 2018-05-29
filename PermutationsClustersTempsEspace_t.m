%Script écrit par Cécile Issard, doctorante au laboratoire psychologie de
%la perception, Université Paris Descartes

for cond = 1:length(contrastes)
    cond = contrastes{1,cond};
    [t_values, h_matrix, donneesoxy] = t_test(avg,nbabies,nt,nch,cond);
    imagesc(h_matrix)
    
    [length_clusters,t_clusters,clusters] = identify_clusters(h_matrix,t_values,adjacence);
    
    
    biggest_clusters = zeros(1,nperm);
    
    tic
    for perm = 1:nperm
        [t_perm,h_perm] = t_test_perm(donneesoxy,nbabies,nt,nch,cond);
        if ~isempty(find(h_perm))
            [length_clusters_perm,t_clusters_perm,clusters_perm] = identify_clusters(h_perm,t_perm,adjacence);
            biggest_clusters(1,perm) = max(t_clusters_perm);
            %perm
        else
            biggest_clusters(1,perm) = 0;
        end
    end
    toc
    biggest_clusters=sort(biggest_clusters);
    hist = histogram(biggest_clusters)
    
    pvalues = zeros(size(length_clusters,1),1);
    for i=1:size(length_clusters,1)
        pvalue = [];
        n = find(biggest_clusters>length_clusters(i));
        n = length(n);
        pvalue = n./nperm;
        %pvalues = cat(1,pvalues,pvalue);
        clusters(i).pvalues = pvalue;
    end
    

    save([file '_' cond],'clusters','biggest_clusters','pvalues')
end