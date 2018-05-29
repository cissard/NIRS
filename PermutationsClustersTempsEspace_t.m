%Script �crit par C�cile Issard, doctorante au laboratoire psychologie de
%la perception, Universit� Paris Descartes
%%
nbabies = length(avg);
nt = length(avg(1).N);
nch = 24;
nperm = 1000;
%contrastes = {'NB','CB','DB','NC','ND','CD'}
%seuil = 2.042; 

%construction de la matrice d'adjacence qui sp�cifie les relations entre
%les canaux
adjacence = logical(zeros(nch,nch));

%-----------------------si nch ~= 24 adapter les lignes ci-dessous--------%
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
%% ----------------------------------------------------------------------------------------------

for cond = 1:length(contrastes)
    cond = contrastes{1,cond};
    [t_values, h_matrix, donneesoxy] = t_test(avg,nbabies,nt,nch,cond);
    imagesc(h_matrix)
    
    [length_clusters,t_clusters,clusters] = identify_clusters(h_matrix,t_values,adjacence);
    %%
    
    biggest_clusters = zeros(1,nperm);
    
    tic
    for perm = 1:nperm
        [t_perm,h_perm] = t_test_perm(donneesoxy,nbabies,nt,nch,cond);
        if ~isempty(find(h_perm))
            [length_clusters_perm,t_clusters_perm,clusters_perm] = identify_clusters(h_perm,t_perm,adjacence);
            biggest_clusters(1,perm) = max(t_clusters_perm);
            perm
        else
            biggest_clusters(1,perm) = 0;
        end
    end
    toc
    biggest_clusters=sort(biggest_clusters);
    hist = histogram(biggest_clusters)
    %%
    
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