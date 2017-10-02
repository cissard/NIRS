function [data marks] = loadNIRxdata(cfg);
cfg.dir = pwd; 
cd(cfg.dir)
cfg.files = dir('NIRS-*');
cfg.pID = transpose(strread(cfg.files(1).name,'%c',19));

wl1file = sprintf('%s.wl1',cfg.pID);
wl1 = importdata(wl1file,' ',0);

wl2file = sprintf('%s.wl2',cfg.pID);
wl2 = importdata(wl2file,' ',0);

hdrfile = sprintf('%s.hdr',cfg.pID);
hdr = importdata(hdrfile,'\t',38);

wls=cat(3,wl1,wl2);

ch=find(cfg.SD);
data = zeros(length(wl1),cfg.nch,cfg.nwls);
for c=1:cfg.nch
    idx=ch(c);
    data(:,c,:)=wls(:,idx,:);
end
% h1=figure;plot(data(:,:,1));saveas(h1,cfg.pID,'jpg');
% h2=figure;plot(data(:,:,2));saveas(h2,cfg.pID,'jpg');

%hdr file: contains the triggers. 1st column is time, 2nd is the mark
%sent, and 3rd is the nb of the marked time sample.
marks = hdr.data(:,2:3);
end

