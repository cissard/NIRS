function [Hb, HbO] = NIRS_light2Hb(cfg,data, baseline)
% partialVolCorr=1;
Distance = 3; %cm

wl1=cfg.wls(1);
wl2=cfg.wls(2);

%DPF - Equation retrieved from Scholkmann & Wolf (2013) J. Biomedical Optics
A = 0; %age of participants (years)
DPF1= 223.3 + 0.05624*(A^0.8493)+(-5.723*10^(-7))*wl1^3+0.001245*wl1^2+(-0.9025)*wl1;
DPF2= 223.3 + 0.05624*(A^0.8493)+(-5.723*10^(-7))*wl2^3+0.001245*wl2^2+(-0.9025)*wl2; 

load e_coef;%[wl aHb aHbO]
wlidx = zeros(1,cfg.nwls);
for i = 1:cfg.nwls
    wlidx(i) = find( e_coef(:,1) == cfg.wls(i) );
end

%absorption coefficients
a_hb_wl1 = e_coef(wlidx(1),2);
a_hb_wl2 = e_coef(wlidx(2),2);
a_hbo_wl1 = e_coef(wlidx(1),3);
a_hbo_wl2 = e_coef(wlidx(2),3);

%baselines as estimates of emitted light to the tissue
baseline_wl1 = transpose(baseline(:,1));
baseline_wl2 = transpose(baseline(:,2));

%The signal is the detected light intensity in each channel
sig_wl1 = data(:,:,1);
sig_wl2 = data(:,:,2);

%Normalize data to the mean (or baseline) dividing each point of the time
%serie by the baseline
OD_wl1 = zeros(length(data),cfg.nch);
OD_wl2 = zeros(length(data),cfg.nch);
for t = 1:length(data)
    OD_wl1(t,:)=abs(sig_wl1(t,:)./baseline_wl1); 
    OD_wl2(t,:)=abs(sig_wl2(t,:)./baseline_wl2);
end
% compute log (optical density)
OD_wl1 = -log(OD_wl1);
OD_wl2 = -log(OD_wl2);

OD = [OD_wl1 ; OD_wl2];

%Modified Beer-Lambert law
a=[a_hb_wl1 a_hbo_wl1 ; a_hb_wl2  a_hbo_wl2];

ae = [a_hb_wl1*DPF1 a_hbo_wl1*DPF1 ; a_hb_wl2*DPF2 a_hbo_wl2*DPF2]*Distance;


% aC_wl1=OD_wl1/(DPF1*Distance);
% aC_wl2=OD_wl2/(DPF2*Distance);

% Hb = zeros(length(data),cfg.nch);
% HbO = zeros(length(data),cfg.nch);


for ch = 1:cfg.nch;
    chn = [OD_wl1(:,ch) OD_wl2(:,ch)]';
    Hb_HbO = ae\chn;
    Hb_HbO = Hb_HbO';
    %Code Ardalan
%     ainv = inv( a'*a )*a';
%     Hb_HbO = ainv*chn;
%     Hb_HbO = Hb_HbO';

    Hb(:,ch) = Hb_HbO(:,1);
    HbO(:,ch) = Hb_HbO(:,2);
end

% h1=figure;plot(Hb(:,:));saveas(h1,cfg.pID,'jpg');
% h2=figure;plot(HbO(:,:));saveas(h2,cfg.pID,'jpg');
end