function [length_clusters,clusters]=identify_clusters(F,adjacence)
% --------Part adapted from scripts written by Mar�a Clemencia Ortiz Barajas-----------%
%trouver s'il existe des r�gions d'activit� dans les donn�es originales
[active_ch,active_t] = find(F);
active_ch = unique(active_ch);

active_ch_LH = intersect(active_ch,[1:12]);
active_ch_RH = intersect(active_ch,[13:24]);

% Trouver les clusters (dans le temps, pour chaque canal)
activity = [];
nb_moments = [];
for k1 = 1:length(active_ch)
    who1 = active_ch(k1);
    t_who1 = find(F(who1,:));
    nclusters = 1;
    limL(nclusters) = 1;
    for slide = 1:length(t_who1)-1
        if t_who1(slide+1) ~= t_who1(slide)+1 % si les �chantillons ne se succ�dent pas, donc qu'ils ne sont pas dans le m�me cluster
            limH(nclusters) = slide; %le cluster s'arr�te ici
            nclusters = nclusters+1; %on cr�� un nouveau cluster
            limL(nclusters) = slide+1;
        end
    end
    limH(nclusters) = length(t_who1);
    activity_temp(1,1:length(limL)) = who1; % canal o� se situe le cluster, autant de colonnes que de moments d'activit� dans le canal
    activity_temp(2,:) = t_who1(limL); % �chantillon o� commence le(s) cluster(s)
    activity_temp(3,:) = t_who1(limH); % �chantillon o� s'arr�te le(s) cluster(s)
    activity_temp(4,:) = t_who1(limH) - t_who1(limL) +1; % dur�e du/des cluster(s)
    activity = cat(2,activity,activity_temp);
    nb_moments = cat(2,nb_moments,nclusters); % nombre de moments d'activit� par canal
    clear limH limL slide activity_temp t_who1 who1 cont
end
% ------------------------------------------------------------------------%
%locate clusters
clusters = struct;
for c1 = 1:size(activity,2)
    cluster = [];
    cluster = activity(:,c1);
    
    for c2 = (c1+1):size(activity,2)
        A = activity(2,c1):activity(3,c1);
        B = activity(2,c2):activity(3,c2);
        inter = intersect(A,B);
        if adjacence(activity(1,c1),activity(1,c2)) && c1~=c2 && ~isempty(inter)
            
            cluster = cat(2,cluster,activity(:,c2));
        end
    end
    clusters(c1).channels = cluster(1,:);
    clusters(c1).start = cluster(2,:);
    clusters(c1).end = cluster(3,:);
    clusters(c1).length = cluster(4,:);
end

%remove one-channel clusters that are part of a bigger cluster
for l1 = 1:length(clusters)
    clusters(l1).usage=0;
    for l2 = 1:l1-1
        if length(clusters(l1).channels)==1 && length(clusters(l2).channels)>1 ...
                && ~isempty(intersect(clusters(l1).channels,clusters(l2).channels)) ...
                && ~isempty(intersect(clusters(l1).start,clusters(l2).start))
            clusters(l1).usage=1;
            
        end
    end
end

for l1 = fliplr(1:length(clusters))
    if clusters(l1).usage == 1
        clusters(l1) = [];
    end
end

%merge connected clusters
for i = 1:length(clusters)
    for j = i+1:length(clusters)
        if length(clusters(i).channels) > 1 && length(clusters(j).channels)> 1 ...% cases with one channel treated above
                && ~isempty(intersect(clusters(i).channels,clusters(j).channels)) ...
                && ~isempty(intersect(clusters(i).start,clusters(j).start))% same ch same time
            
            inter_ch = intersect(clusters(i).channels,clusters(j).channels);
            pos = find(clusters(i).channels==inter_ch);
            clusters(i).channels(pos) = [];
            clusters(i).start(pos) = [];
            clusters(i).end(pos) = [];
            clusters(i).length(pos) = [];
            clusters(i).usage = 1;

            clusters(j).channels = cat(2,clusters(i).channels,clusters(j).channels);
            clusters(j).start = cat(2,clusters(i).start,clusters(j).start);
            clusters(j).end = cat(2,clusters(i).end,clusters(j).end);
            clusters(j).length = cat(2,clusters(i).length,clusters(j).length);
            
        end
    end
end

for l1 = fliplr(1:size(clusters,2))
    clusters(l1).length = sum(clusters(l1).length);
    if clusters(l1).usage == 1
        clusters(l1) = [];
    end
end

%save the length of the clusters to replace them in the null distribution
%later
length_clusters = zeros(size(clusters,2),1);
for i = 1:size(clusters,2)
    length_clusters(i,1) = clusters(i).length;
    %     length(min(clusters(i).start):max(clusters(i).end))
end