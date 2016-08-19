% three_pos_touch.m
% Script to load, plot and save-out touch data 

%% CD to touch folder: eventually do this in a loop or something
dates =  [3,7,29,32,35,38,41,45,47,49,50,56]; % 32. Done (as of 11/08/16): 1,2,3,4 (chloe),5,6

for i = [7:numel(dates)]
    i
    cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/32/
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})


%% Pollock plot code from touch_gui
ff = dir('*_touch.mat');
kappa_touch = [];
theta_touch = [];
kappa_nontouch = [];
theta_nontouch = [];

for i = 1:numel(ff);
    disp(['Loading data from trial ',ff(i).name(1:end-10)])
    if exist([ff(i).name(1:end-10),'.tr'],'file')
        load([ff(i).name(1:end-10),'.tr'],'kappa_all','theta_all','-mat');
        kappa = kappa_all;
        theta = theta_all;
    elseif exist([ff(i).name(1:end-10),'_clean.mat'],'file')
        load([ff(i).name(1:end-10),'_clean.mat'],'theta_w','kappa_w');
        kappa = kappa_w;
        theta = theta_w;
    else
        error(['No .tr or _clean.mat file available. Track video with chimera.m or Whikerman before continuing'])
    end
    
    load([ff(i).name],'touches')
    
    % CREATE LONG VECTORS OF ALL DATA
    %         plot(touches); title(ff(i).name);drawnow; % debugging
    %     keyboard
    if exist('touches','var')
 %       if numel(find(touches))
            kappa_touch = [kappa_touch,kappa(find(touches))];
            kappa(find(touches)) = [];
            kappa_nontouch = [kappa_nontouch,kappa];
            
            theta_touch = [theta_touch,theta(find(touches))];
            theta(find(touches)) = [];
            theta_nontouch = [theta_nontouch,theta];
%         end
    end
    clear touches
end

% PLOT
figure;
plot(conv(theta_nontouch,gausswin(10,1),'same')./10,conv(kappa_nontouch,gausswin(10,1),'same')./10,'k.','markersize',1)
hold all
plot(conv(theta_touch,gausswin(10,1),'same')./10,conv(kappa_touch,gausswin(10,1),'same')./10,'r.','markersize',1)
set(gca,'Xdir','reverse')
xlabel('Whisker angle')
ylabel('Whisker curvature')


%% One loop to load each trial with touches, compute first touch time, and whether pro/ret
ff = dir('*_touch.mat');

for i = 1:numel(ff);
    disp(['Loading data from trial ',ff(i).name(1:end-10)])
    if exist([ff(i).name(1:end-10),'.tr'],'file')
        load([ff(i).name(1:end-10),'.tr'],'kappa_all','theta_all','-mat');
        kappa = kappa_all;
        theta = theta_all;
    elseif exist([ff(i).name(1:end-10),'_clean.mat'],'file')
        load([ff(i).name(1:end-10),'_clean.mat'],'theta_w','kappa_w');
        kappa = kappa_w;
        theta = theta_w;
    else
        error(['No .tr or _clean.mat file available. Track video with chimera.m or Whikerman before continuing'])
    end
    
    load([ff(i).name],'touches','start_frame','trialtype')
    
    
    theta_ts = timeseries(theta,(1:numel(theta))./1000);
    bandpass = [6,30];
    theta_filt = idealfilter(theta_ts,bandpass,'pass');
    H = hilbert(theta_filt.data);
    
    pro = find(angle(H)<=0);
    
    pro_ret = zeros(size(theta));
    pro_ret(pro) = 1;
    
    touches_s = circshift(touches',[-start_frame,0]);
    pro_ret_s = circshift(pro_ret',[-start_frame,0]);
    pro = find(pro_ret_s);
    
    firsttouch = 0;
    protraction_touch = 0;
    
    if numel(find(touches)) >= 1
        first_touch = find(touches,1,'first');
        first_touch = mod(first_touch + start_frame, numel(theta));
        
        
        if ismember(first_touch,pro)
            protraction_touch = 2
            
            % Compute first touch frame in un-circshifted video
            dummy_array = zeros(size(pro_ret));
            dummy_array(first_touch) = 1;
            first_touch_array = circshift(dummy_array,[start_frame,0]);
            first_touch = find(first_touch_array)
            
        else
            protraction_touch = 1
        end
        
    else
        protraction_touch = 0;
        display('NO touches')
    end
    
  
    
    protouch(i) = protraction_touch;
    ttype(i) = trialtype;

end


%% Plot mean/median protouch per trial type
for i = 1:3
    valid = find(protouch);
    mean_protouch(i) = mean(protouch(valid(find(ttype(valid)==i))) - 1);
    sem_protouch(i) = std(protouch(valid(find(ttype(valid)==i))) - 1)./sqrt(numel(find(ttype(valid)==i)));
    
end

errorbar(mean_protouch,sem_protouch) 
ylim([0,1])
    