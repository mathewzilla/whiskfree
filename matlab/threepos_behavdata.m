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
% Note done 32, 
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







