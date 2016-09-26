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
    meta_32{i} = session_data;
end

save ~/work/whiskfree/data/meta_32.mat meta_32
save ~/Dropbox/Data/3posdata/meta_32.mat meta_32

clear behav_32 meta_32

% 33
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

% 34
% Load data structure
load ~/Dropbox/Data/3posdata/behav_34b.mat
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

clear behav_34 meta_34

% 36
% Load data structure
load ~/Dropbox/Data/3posdata/behav_36b.mat
for i = 1:numel(behav_36);
    date_str = behav_36{i}.name; % dir_str(end-20:end-11);
    display(['Processing session ',date_str])
    mouse = date_str(8:10);
    d = date_str(1:2);
    y = date_str(5:6);
    m_num = str2num(date_str(3:4));
    
    % Determine month name
    m = month_names{m_num};
    
    % Behaviour files are formatted like behaviour_38a_16-Jul-2015_session_data.mat
    load(['/run/user/1000/gvfs/smb-share:server=130.88.94.172,share=test/Dario/Behavioral_movies/BehavStat/behaviour_',mouse,'_',d,'-',m,'-20',y,'_session_data.mat'])
    meta_36{i} = session_data;

end

save ~/work/whiskfree/data/meta_36.mat meta_36
save ~/Dropbox/Data/3posdata/meta_36.mat meta_36

clear behav_36 meta_36


%% Load data, parse into 'on' and 'AB' sections for analysis
% Note done 32, 36
% (33 has missing policy data, 34 only has 2 tracked sessions)
load ~/Dropbox/Data/3posdata/behav_36b.mat
load ~/Dropbox/Data/3posdata/meta_36.mat

this_mouse = behav_36;
meta = meta_36;

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
% DONE: 36

month_names = {'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};


load ~/Dropbox/Data/3posdata/behav_32b.mat

for i = 1:numel(behav_32)
    date_str = behav_32{i}.name; % dir_str(end-20:end-11);
    display(['Processing session ',date_str])
    mouse = date_str(8:10);
    d = date_str(1:2);
    y = date_str(5:6);
    m_num = str2num(date_str(3:4));
    
    % Determine month name
    m = month_names{m_num};

    filestring = ['/run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk,share=flsrss$/snapped/replicated/Petersen/Dario Campagner/behavior_test_rsp/',d,'-',m,'-20',y,'/',mouse,'/'];
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
    
    licks_32{i} = licktimes;
end

save ~/Dropbox/Data/3posdata/licks_32.mat licks_32

%% Example: Load raw behaviour data to determine lick times. Sampling rate = 24414.0625Hz

sfz = 24414.0625; % 25000 % 

for j = 198%40:numtrials
    this_data = load(['behaviour_',mouse,'_',d,'-',m,'-20',y,'_',num2str(j),'.mat']);
    
    % Plot some stuff
    clf;
    ax(1) = subplot(2,2,1);
    plot(this_data.read.piezoleft); hold all
    plot(this_data.read.piezoright);
    legend('piezoleft','piezoright')
    ax(2) = subplot(2,2,2);
    plot(this_data.read.lickleft); hold all
    plot(this_data.read.lickright)
    title([num2str(find(this_data.read.lickleft,1,'first')/sfz),', ',num2str(find(this_data.read.lickright,1,'first')/sfz)])
    legend('lickleft','lickright')
    ax(3) = subplot(2,2,3);
    plot(this_data.read.lickvalveleft); hold all
    plot(this_data.read.lickvalveright);
    title([num2str(find(this_data.read.lickvalveleft,1,'first')/sfz),', ',num2str(find(this_data.read.lickvalveright,1,'first')/sfz)])
    legend('lickvalveleft','lickvalveright')
    ax(4) = subplot(2,2,4);
    plot(this_data.read.resp); hold all;
    plot(this_data.read.airpuffvalve); 
    plot(this_data.read.drink);
    plot(this_data.read.timeout);
    title([num2str(find(this_data.read.resp,1,'first')/sfz),', ',num2str(find(this_data.read.drink,1,'first')/sfz),', ',num2str(find(this_data.read.timeout,1,'first')/sfz)])
    legend('resp','airpuffvalve','drink','timeout')
    
    suptitle(['Trial ',num2str(j),' trialtype ',num2str(this_data.read.trialtype)])
    drawnow;
    linkaxes(ax,'x')
    pause(0.2);
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





