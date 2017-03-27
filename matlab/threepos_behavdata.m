% threepos_behavdata.m
% Script to load behaviour data matlab files for the relevant sessions in
% the 3 position task corpus.
% Save this data in a behav_.. style array that matches the data array

month_names = {'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};

%% 32
% Load data structure
load ~/Dropbox/Data/3posdata/behav_32b.mat
% Use behav_32{i}.name to work out which data file to load
for i = 1:numel(behav_32);
    date_str = behav_32{i}.name; % dir_str(end-20:end-11);
    display(['Processing session ',date_str])
    mouse = date_str(8:10);
    d = date_str(1:2);
    y = date_str(5:6);
    m_num = str2num(date_str(3:4));
    
    % Determine month name
    m = month_names{m_num};
    
    % Behaviour files are formatted like behaviour_38a_16-Jul-2015_session_data.mat
    load(['/run/user/1000/gvfs/smb-share:server=130.88.94.172,share=test/Dario/Behavioral_movies/BehavStat/behaviour_',mouse,'_',d,'-',m,'-20',y,'_session_data.mat'])
    
    trial_id = 1:numel(behav_32{i}.trial);
    % Load resynced trial_id for 7 ,10, 11
    if (i==7 || i==10 || i==11)
        load(['/run/user/1000/gvfs/smb-share:server=130.88.94.172,share=test/Dario/Behavioral_movies/BehavStat/resync_trials_',date_str])
    end
    % resync? i = 7,10,11
    session_data.trial_id = trial_id;
    
    meta_32{i} = session_data;
    
end

save ~/work/whiskfree/data/meta_32.mat meta_32
save ~/Dropbox/Data/3posdata/meta_32.mat meta_32

clear behav_32 meta_32

%% 33
% Load data structure
load ~/Dropbox/Data/3posdata/behav_33b.mat
for i = 1:numel(behav_33);
    date_str = behav_33{i}.name; % dir_str(end-20:end-11);
    display(['Processing session ',date_str])
    mouse = date_str(8:10);
    d = date_str(1:2);
    y = date_str(5:6);
    m_num = str2num(date_str(3:4));
    
    % Determine month name
    m = month_names{m_num};
    
    % Behaviour files are formatted like behaviour_38a_16-Jul-2015_session_data.mat
    load(['/run/user/1000/gvfs/smb-share:server=130.88.94.172,share=test/Dario/Behavioral_movies/BehavStat/behaviour_',mouse,'_',d,'-',m,'-20',y,'_session_data.mat'])
    meta_33{i} = session_data;
    
end

save ~/work/whiskfree/data/meta_33.mat meta_33
save ~/Dropbox/Data/3posdata/meta_33.mat meta_33

clear behav_33 meta_33

%% 34
% Load data structure
% load ~/Dropbox/Data/3posdata/behav_34c.mat
load ~/work/whiskfree/data/behav_34c.mat
for i = 1:numel(behav_34);
    date_str = behav_34{i}.name; % dir_str(end-20:end-11);
    display(['Processing session ',date_str])
    mouse = date_str(8:10);
    d = date_str(1:2);
    y = date_str(5:6);
    m_num = str2num(date_str(3:4));
    
    % Determine month name
    m = month_names{m_num};
    
    % Behaviour files are formatted like behaviour_38a_16-Jul-2015_session_data.mat
    load(['/run/user/1000/gvfs/smb-share:server=130.88.94.172,share=test/Dario/Behavioral_movies/BehavStat/behaviour_',mouse,'_',d,'-',m,'-20',y,'_session_data.mat'])
    meta_34{i} = session_data;
    
end

save ~/work/whiskfree/data/meta_34.mat meta_34
save ~/Dropbox/Data/3posdata/meta_34.mat meta_34

% clear behav_34 meta_34

%% Attempt to load single-trial policy meta data. Save into arrays.
% NB policy data is MISSING for old sessions

month_names = {'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};


for i = [1,2,4,5]
    
    cd /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'/Dario' Campagner'/behavior_test_rsp
    
    date_str = behav_34{i}.name;
    mouse = date_str(8:10);
    d = date_str(1:2);
    y = date_str(5:6);
    m_num = str2num(date_str(3:4));
    
    % Determine month name
    m = month_names{m_num};
    
    cd([d,'-',m,'-20',y]);
    cd(mouse)
    
    files = dir('*.mat');
    for j = 1:numel(files) - 1
        load(['behaviour_',mouse,'_',d,'-',m,'-20',y,'_',num2str(j),'.mat'])
        
    end
    
    
    
end

%% 36
% Load data structure
load ~/Dropbox/Data/3posdata/behav_36b.mat
for i = 1:numel(behav_36);
    date_str = behav_36{i}.name;% dir_str(end-20:end-11);
    display(['Processing session ',date_str])
    mouse = date_str(8:10);
    d = date_str(1:2);
    y = date_str(5:6);
    m_num = str2num(date_str(3:4));
    
    % Determine month name
    m = month_names{m_num};
    
    % Behaviour files are formatted like behaviour_38a_16-Jul-2015_session_data.mat
    load(['/run/user/1000/gvfs/smb-share:server=130.88.94.172,share=test/Dario/Behavioral_movies/BehavStat/behaviour_',mouse,'_',d,'-',m,'-20',y,'_session_data.mat'])
    load(['/run/user/1000/gvfs/smb-share:server=130.88.94.172,share=test/Dario/Behavioral_movies/BehavStat/resync_trials_',date_str])
    
    session_data.trial_id = trial_id;
    meta_36{i} = session_data;
    
end

save ~/work/whiskfree/data/meta_36.mat meta_36
save ~/Dropbox/Data/3posdata/meta_36.mat meta_36

clear behav_36 meta_36

%% 38
% Load data structure
load ~/work/whiskfree/data/behav_38b.mat
for i = 1:numel(behav_38);
    date_str = behav_38{i}.name;% dir_str(end-20:end-11);
    display(['Processing session ',date_str])
    mouse = date_str(8:10);
    d = date_str(1:2);
    y = date_str(5:6);
    m_num = str2num(date_str(3:4));
    
    % Determine month name
    m = month_names{m_num};
    
    % Behaviour files are formatted like behaviour_38a_16-Jul-2015_session_data.mat
    load(['/run/user/1000/gvfs/smb-share:server=130.88.94.172,share=test/Dario/Behavioral_movies/BehavStat/behaviour_',mouse,'_',d,'-',m,'-20',y,'_session_data.mat'])
    load(['/run/user/1000/gvfs/smb-share:server=130.88.94.172,share=test/Dario/Behavioral_movies/BehavStat/resync_trials_',date_str])
    
    session_data.trial_id = trial_id;
    meta_38{i} = session_data;
    
end

save ~/work/whiskfree/data/meta_38.mat meta_38
save ~/Dropbox/Data/3posdata/meta_38.mat meta_38

% clear behav_36 meta_36


%% Load data, parse into 'on' and 'AB' sections for analysis
% Note done 32, 36, 38
% (33 has missing policy data, 34 only has 2 tracked sessions)
load ~/Dropbox/Data/3posdata/behav_38b.mat
load ~/Dropbox/Data/3posdata/meta_38.mat

this_mouse = behav_38;
meta = meta_38;

t = [];
k = [];
tt = [];
ch = [];
sess = [];
AB = [];
for s = 1:numel(meta)
    v = 1:min([this_mouse{s}.sync,numel(meta{s}.policy)]);
    
    
    pu = this_mouse{s}.poleup(v);
    if ~isempty(pu)
        t2 = zeros(numel(v),5000);
        k2 = zeros(numel(v),5000);
        for j = 1:numel(pu)
            t2(j,:) = circshift(this_mouse{s}.theta(v(j),:),[1,1000-pu(j)]);
            k2(j,:) = circshift(this_mouse{s}.kappa(v(j),:),[1,1000-pu(j)]);
        end
        
        t = [t;t2]; % [t;circshift(this_mouse{s}.theta(v,:)',1000-pu)'];
        k = [k;k2]; % [k;circshift(this_mouse{s}.kappa(v,:)',1000-pu)'];
        
        tt = [tt;this_mouse{s}.trialtype(v)]; % trialtype
        ch = [ch;this_mouse{s}.choice(v)];    % choice
        sess = [sess;s*ones(numel(pu),1)];            % session
        AB = [AB;strcmp(meta{s}.policy(v),'AB')'];
    end
end



csvwrite(['~/work/whiskfree/data/theta_',this_mouse{s}.name(end-2:end-1),'_r.csv'],t);
csvwrite(['~/work/whiskfree/data/kappa_',this_mouse{s}.name(end-2:end-1),'_r.csv'],k);
csvwrite(['~/work/whiskfree/data/trialtype_',this_mouse{s}.name(end-2:end-1),'_r.csv'],tt);
csvwrite(['~/work/whiskfree/data/choice_',this_mouse{s}.name(end-2:end-1),'_r.csv'],ch);
csvwrite(['~/work/whiskfree/data/session_',this_mouse{s}.name(end-2:end-1),'_r.csv'],sess);
csvwrite(['~/work/whiskfree/data/AB_',this_mouse{s}.name(end-2:end-1),'_r.csv'],AB);


%% Load, record and save lick times.
% To process more mice, change the mouse number
% DONE: 36, 32, 34

month_names = {'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};
sfz = 24414.0625; % 25000 %

load /media/mathew/Data_1/3posdata/behav_34t.mat %~/Dropbox/Data/3posdata/behav_34t.mat
behav = behav_34;

for i = 1:numel(behav)
    date_str = behav{i}.name; % dir_str(end-20:end-11);
    display(['Processing session ',date_str])
    mouse = date_str(8:10);
    d = date_str(1:2);
    y = date_str(5:6);
    m_num = str2num(date_str(3:4));
    
    % Determine month name
    m = month_names{m_num};
    
    %     filestring = ['/run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk,share=flsrss$/snapped/replicated/Petersen/Dario Campagner/behavior_test_rsp/',d,'-',m,'-20',y,'/',mouse,'/'];
    filestring = ['/mnt/isilon/fls/Dario Campagner/behavior_test_rsp/',d,'-',m,'-20',y,'/',mouse,'/'];
    
    cd (filestring);
    
    numtrials = numel(dir) - 3; % All files apart from ., .., and _session_data
    
    licktimes = zeros(numtrials,2);
    for j = 1:numtrials
        this_data = load(['behaviour_',mouse,'_',d,'-',m,'-20',y,'_',num2str(j),'.mat']);
        ll = find(this_data.read.lickleft,1,'first');
        lr = find(this_data.read.lickright,1,'first');
        if ll
            licktimes(j,1) =  ll/sfz;
        end
        if lr
            licktimes(j,2) =  lr/sfz;
        end
    end
    
    licktimes = ceil(1000*licktimes);
    
    licks_34{i} = licktimes;
end

save ~/Dropbox/Data/3posdata/licks_34.mat licks_34

%% Example: Load raw behaviour data to determine lick times. Sampling rate = 24414.0625Hz

sfz = 24414.0625; % 25000 %

for j = 181:210 %25:numtrials
    this_data = load([filestring,'behaviour_',mouse,'_',d,'-',m,'-20',y,'_',num2str(j),'.mat']);
    
    % Plot some stuff
    clf;
    xrange = [1:200000]/sfz;
    
    ax(1) = subplot(2,2,1);
    plot(xrange,this_data.read.piezoleft); hold all
    plot(xrange,this_data.read.piezoright);
    xlim([0,5])
    legend('piezoleft','piezoright')
    ax(2) = subplot(2,2,2);
    plot(xrange,this_data.read.lickleft); hold all
    plot(xrange,this_data.read.lickright)
    title([num2str(find(this_data.read.lickleft,1,'first')/sfz),', ',num2str(find(this_data.read.lickright,1,'first')/sfz)])
    xlim([0,5])
    legend('lickleft','lickright')
    ax(3) = subplot(2,2,3);
    plot(xrange,this_data.read.lickvalveleft); hold all
    plot(xrange,this_data.read.lickvalveright);
    title([num2str(find(this_data.read.lickvalveleft,1,'first')/sfz),', ',num2str(find(this_data.read.lickvalveright,1,'first')/sfz)])
    xlim([0,5])
    legend('lickvalveleft','lickvalveright')
    ax(4) = subplot(2,2,4);
    plot(xrange,this_data.read.resp); hold all;
    plot(xrange,this_data.read.airpuffvalve);
    plot(xrange,this_data.read.drink);
    plot(xrange,this_data.read.timeout);
    title([num2str(find(this_data.read.resp,1,'first')/sfz),', ',num2str(find(this_data.read.drink,1,'first')/sfz),', ',num2str(find(this_data.read.timeout,1,'first')/sfz)])
    xlim([0,5])
    legend('resp','airpuffvalve','drink','timeout')
    
    suptitle(['Trial ',num2str(j),' trialtype ',num2str(this_data.read.trialtype)])
    drawnow;
    linkaxes(ax,'x')
    pause;%(0.2);
end

%% Variables of interest re lick times are lickvalveleft/right and
% drink/timeout
licktimes = zeros(numtrials,2);
for j = 1:numtrials
    this_data = load(['behaviour_',mouse,'_',d,'-',m,'-20',y,'_',num2str(j),'.mat']);
    ll = find(this_data.read.lickleft,1,'first');
    lr = find(this_data.read.lickright,1,'first');
    if ll
        licktimes(j,1) =  ll/sfz;
    end
    if lr
        licktimes(j,2) =  lr/sfz;
    end
end

licktimes = ceil(licktimes * 1000);

%% Image licking on top of whisking to show late licks
load ~/Dropbox/Data/3posdata/behav_38t.mat
load ~/Dropbox/Data/3posdata/licks_38.mat

b = behav_38;
l = licks_38;

for i = 1:numel(b)
    clf;
    imagesc(b{i}.theta); hold all
    plot(b{i}.poleup(1) + l{i}(find(l{i}(:,1)),1),find(l{i}(:,1)),'m.')
    plot(b{i}.poleup(1) + l{i}(find(l{i}(:,2)),2),find(l{i}(:,2)),'g.')
    plot(b{i}.poleup(1)*ones(2,1),[1,numel(l{i}(:,1))],'r--')
    plot(2500+b{i}.poleup(1)*ones(2,1),[1,numel(l{i}(:,1))],'b--')
    xlim([0,max([(b{i}.poleup(1) + max(max(l{i}))),5000])])
    pause
end

%% Test re-assignment of trial outcome based on lick direction
lick_choice = 3*ones(size(b{i}.choice));
lick_choice(find(l{i}(:,1))) = 1;
lick_choice(find(l{i}(:,2))) = 2;

% Fix late licks
lick_choice([find(l{i}(:,1) > 2500);find(l{i}(:,2) > 2500)]) = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHANGING THREEPOS LICKING DATA 03.17.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Loop to load and save more licking information, for the sessions in Threepos (threepos_retracked.m)
load ~/Dropbox/Data/3posdata/Threepos.mat

month_names = {'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};
sfz = 24414.0625;
plotting = 0;
a = [32,33,34,36,38];
for i = 1:5
    clear licks
    for j = 1:numel(Threepos{i}.behav)
        
        date_str = Threepos{i}.behav{j}.name; % dir_str(end-20:end-11);
        display(['Processing session ',date_str])
        mouse = date_str(8:10);
        d = date_str(1:2);
        y = date_str(5:6);
        m_num = str2num(date_str(3:4));
        
        % Determine month name
        m = month_names{m_num};
        
        %     filestring = ['/run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk,share=flsrss$/snapped/replicated/Petersen/Dario Campagner/behavior_test_rsp/',d,'-',m,'-20',y,'/',mouse,'/'];
        filestring = ['/mnt/isilon/fls/Dario Campagner/behavior_test_rsp/',d,'-',m,'-20',y,'/',mouse,'/'];
        
        cd (filestring);
        
        numtrials = numel(dir) - 3; % All files apart from ., .., and _session_data
        
        licktimes = zeros(numtrials,2);
        licktimes_sf = zeros(numtrials,2);
        valvetimes = zeros(numtrials,2);
        timeout = zeros(numtrials,1);
        for k = 1:numtrials
            this_data = load(['behaviour_',mouse,'_',d,'-',m,'-20',y,'_',num2str(k),'.mat']);
            %%
            if plotting
                clf;
                xrange = [1:200000]/sfz;
                
                ax(1) = subplot(4,1,1);
                plot(xrange,this_data.read.piezoleft); hold all
                plot(xrange,this_data.read.piezoright);
                xlim([0,5])
                legend('piezoleft','piezoright')
                ax(2) = subplot(4,1,2);
                plot(xrange,this_data.read.lickleft); hold all
                plot(xrange,this_data.read.lickright)
                title([num2str(find(this_data.read.lickleft,1,'first')/sfz),', ',num2str(find(this_data.read.lickright,1,'first')/sfz)])
                xlim([0,5])
                legend('lickleft','lickright')
                ax(3) = subplot(4,1,3);
                plot(xrange,this_data.read.lickvalveleft); hold all
                plot(xrange,this_data.read.lickvalveright);
                title([num2str(find(this_data.read.lickvalveleft,1,'first')/sfz),', ',num2str(find(this_data.read.lickvalveright,1,'first')/sfz)])
                xlim([0,5])
                legend('lickvalveleft','lickvalveright')
                ax(4) = subplot(4,1,4);
                plot(xrange,this_data.read.resp); hold all;
                plot(xrange,this_data.read.airpuffvalve);
                plot(xrange,this_data.read.drink);
                plot(xrange,this_data.read.timeout);
                title([num2str(find(this_data.read.resp,1,'first')/sfz),', ',num2str(find(this_data.read.drink,1,'first')/sfz),', ',num2str(find(this_data.read.timeout,1,'first')/sfz)])
                xlim([0,5])
                legend('resp','airpuffvalve','drink','timeout')
                
                suptitle(['Trial ',num2str(j),' trialtype ',num2str(this_data.read.trialtype)])
                drawnow;
                linkaxes(ax,'x')
                pause
            end
            %%
            ll = find(this_data.read.lickleft,1,'first');
            lr = find(this_data.read.lickright,1,'first');
            vl = find(this_data.read.lickvalveleft,1,'first');
            vr = find(this_data.read.lickvalveright,1,'first');
            to = find(this_data.read.timeout,1,'first');
            
            if ll
                licktimes(k,1) =  ll/sfz;
                licktimes_sf(k,1) =  ll;
            end
            if lr
                licktimes(k,2) =  lr/sfz;
                licktimes_sf(k,2) =  lr;
            end
            
            if vl
                valvetimes(k,1) =  vl/sfz;
            end
            if vr
                valvetimes(k,2) =  vr/sfz;
            end
            if to 
                timeout(k) = to/sfz;
            end

            
        end
        
        licktimes = ceil(1000*licktimes);

        licks{j}.licks_all = licktimes;
        licks{j}.licks_sf = licktimes_sf;
        licks{j}.valve = valvetimes;
        licks{j}.timeout = timeout;
    end
    Threepos{i}.licks = licks;
end

save ~/Dropbox/Data/3posdata/Threepos Threepos

%% Set Threepos.behav.choice variable by lick direction and resolve simultaneous licking (either by high-sampling-rate lick time or reward delivery)

for i = 1:5
    
    this_licks = Threepos{i}.licks;

    for j = 1:numel(this_licks)
        trial_id = Threepos{i}.behav{j}.trial_id;

        tid = trial_id(find(trial_id));
        l = this_licks{j}.licks_all(tid,:);
        
   
        
        % Fix choice with lick direction within grace period
        lick_choice = 3*ones(numel(Threepos{i}.meta{j}.pole_location),1);
        ll = find(l(:,1));
        lr = find(l(:,2));
        lick_choice(ll) = 1;
        lick_choice(lr) = 2;
        
        % Fix late licks
        lick_choice([find(l(:,1) > 2500);find(l(:,2) > 2500)]) = 3;
        
        % Licking on both ports
        two_licks = ll(find(ismember(ll,lr)));
        for tl = 1:numel(two_licks)
            [mn,mi] = min(l(two_licks(tl),:));
            if mn > 2500
                lick_choice(two_licks(tl)) = 3;
            else
                lick_choice(two_licks(tl)) = mi;
                
            
            
                if l(two_licks(tl),1) == l(two_licks(tl),2)
                    display(['Simultaneous licks in trial i:',num2str(i),' j:',num2str(j),' t:',num2str(two_licks(tl))])
                    display(['Licks: ',num2str(l(two_licks(tl),:))])
                    display(['Licks (24kHz): ',num2str(Threepos{i}.licks{j}.licks_sf(tid(two_licks(tl)),:))])
                    display(['Trialtype: ',num2str(Threepos{i}.behav{j}.trialtype(two_licks(tl))),' Choice: ',num2str(Threepos{i}.behav{j}.choice_m(two_licks(tl)))])
                    display(['Valves open: ',num2str(this_licks{j}.valve(tid(two_licks(tl)),:))]);
                    display(' ')
                    pause;
%                     [mn,mi] = min(Threepos{i}.licks{j}.licks_sf(tid(two_licks(tl)),:));
                    lick_choice(two_licks(tl)) = Threepos{i}.behav{j}.choice_m(two_licks(tl));
                end
            end
        end
        
        
        
        Threepos{i}.behav{j}.choice = lick_choice;
    end
end
