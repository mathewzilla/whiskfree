% Script for counting re-tracked files. Involves reading in a master excel
% spreadsheet, then looking up session level spreadsheets and counting good
% trials



retrack_db = {};


% 32
dates =  [3,7,32,35,38,41,45];
for i = 1:numel (dates)
    cd /mnt/NAS1/Dario/Behavioral_movies/32
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})
    
    retrack_table = csvread('quality_touch_params.csv');
    all_files = retrack_table(:,12);
    tracked_files = find(all_files == 1);
    tracked_file_names = retrack_table(tracked_files,2);
    
    retrack_db{1,i}.session = files(dates(i)).name;
    retrack_db{1,i}.tracked_files = tracked_files;
    retrack_db{1,i}.tracked_file_names = tracked_file_names;
    retrack_db{1,i}.path = pwd;
end
% 33
dates = [4,5,6,19];
for i = 1:numel (dates)
    cd /mnt/NAS1/Dario/Behavioral_movies/33
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})
    
    retrack_table = csvread('quality_touch_params.csv');
    all_files = retrack_table(:,12);
    tracked_files = find(all_files == 1);
    tracked_file_names = retrack_table(tracked_files,2);
    
    retrack_db{2,i}.session = files(dates(i)).name;
    retrack_db{2,i}.tracked_files = tracked_files;
    retrack_db{2,i}.tracked_file_names = tracked_file_names;
    retrack_db{2,i}.path = pwd;
end

% 34
dates = [30,34,27,25,31,35,54,56,22,26];
for i = 1:numel (dates)
    cd /mnt/NAS1/Dario/Behavioral_movies/34
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})
    
    retrack_table = csvread('quality_touch_params.csv');
    all_files = retrack_table(:,12);
    tracked_files = find(all_files == 1);
    tracked_file_names = retrack_table(tracked_files,2);
    
    retrack_db{3,i}.session = files(dates(i)).name;
    retrack_db{3,i}.tracked_files = tracked_files;
    retrack_db{3,i}.tracked_file_names = tracked_file_names;
    retrack_db{3,i}.path = pwd;
end
% 36

dates = [60,64,67,68,12,14,17,21,24];
for i = 1:numel (dates)
    cd /mnt/isilon/fls/Dario' Campagner'/BEHAVIORAL' MOVIES'/36
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})
    
    retrack_table = csvread('quality_touch_params.csv');
    all_files = retrack_table(:,12);
    tracked_files = find(all_files == 1);
    tracked_file_names = retrack_table(tracked_files,2);
    
    retrack_db{4,i}.session = files(dates(i)).name;
    retrack_db{4,i}.tracked_files = tracked_files;
    retrack_db{4,i}.tracked_file_names = tracked_file_names;
    retrack_db{4,i}.path = pwd;
end
% 38
clear behav_38

% dates = [29,34,38,41,49,52,58,6,8,12,15,37,46,56,67,9,10,13,21];%,60,64,67,68];
dates = [58,6,8,12,46,56,67,10,13,21]; % Touch detected sessions

for i = 1:numel (dates)
    cd /mnt/isilon/fls/Dario' Campagner'/BEHAVIORAL' MOVIES'/38
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})
    
    retrack_table = csvread('quality_touch_params.csv');
    all_files = retrack_table(:,12);
    tracked_files = find(all_files == 1);
    tracked_file_names = retrack_table(tracked_files,2);
    
    retrack_db{5,i}.session = files(dates(i)).name;
    retrack_db{5,i}.tracked_files = tracked_files;
    retrack_db{5,i}.tracked_file_names = tracked_file_names;
    retrack_db{5,i}.path = pwd;
end

%% Save
save ~/Dropbox/Data/3posdata/retrack_db retrack_db

% Load spreadsheet.
% Count ones in column L.

%% Load retrack_db and count trials per mouse

load ~/Dropbox/Data/3posdata/retrack_db.mat
numtracked = zeros(5,1);
for i = 1:size(retrack_db,1)
    for j = 1:10;
        x = retrack_db{i,j};
        if numel(x)>=1
            numtracked(i) = numtracked(i) + numel(x.tracked_files);
        end
    end
    
end

%% Work out which trials are AB, and count remainder
load ~/Dropbox/Data/3posdata/retrack_db.mat
% Re-tracked sessions:
% 32: 1:3,5:8. 33: 1:3,6. 34: 1:2,4:11. 36: 1:7,9,10. 38: 1:10;
tracked_sess = zeros(5,13);
tracked_sess(1,[1:2,4:8]) = 1;
tracked_sess(2,[1:3,6]) = 1;
tracked_sess(3,[1,2,5,6,8:13]) = 1;%tracked_sess(3,[1,2,4:11]) = 1;
% % Dropping bad sessions
% tracked_sess(1,[1:3,5:7]) = 1;
% tracked_sess(2,[2:3,6]) = 1;
% tracked_sess(3,[1,2,5:11]) = 1;
tracked_sess(4,[1:7,9,10]) = 1;
tracked_sess(5,1:10) = 1;

% % Strip out bad retrack_db sessions
% retrack_db{1,7} = [];
% retrack_db{2,1} = retrack_db{2,2};
% retrack_db{2,2} = retrack_db{2,3};
% retrack_db{2,3} = retrack_db{2,4};
% retrack_db{2,4} = [];
% for j = 3:9; retrack_db{3,j} = retrack_db{3,j+1}; end
% retrack_db{3,10} = [];


a = [32,33,34,36,38];

tracked_all = zeros(5,1);
tracked_AB = zeros(5,1);

for i = 1:5;
    load(['~/Dropbox/Data/3posdata/meta_',num2str(a(i)),'.mat']);
%     load(['~/Dropbox/Data/3posdata/behav_',num2str(a(i)),'t.mat']);
%     this_mouse = eval(['behav_',num2str(a(i))]);
    % this_touch = touch_38;
    this_meta = eval(['meta_',num2str(a(i))]);
    
    t_id = find(tracked_sess(i,:));
    
    for j = 1:numel(t_id)
        % Conditional for sessions without policy in
        if (i==2 && t_id(j) == 6) || (i==3 && t_id(j) <6)
            policy = ones(size(this_meta{t_id(j)}.hit));
        else
            policy = strcmp(this_meta{t_id(j)}.policy,'AB')';
        end
        
        
        
        tracked = retrack_db{i,j}.tracked_files;
        %     tt_m = this_meta{t_id(j)}.trialtype(find(policy));
        %     tracked = this_mouse{i}.tracked;
        %     tt_b = this_mouse{i}.trialtype;
        tracked_all(i) = tracked_all(i) + numel(tracked);
        tracked_AB(i) = tracked_AB(i) + sum(ismember(tracked,find(policy)));
    end
end
tracked_all
tracked_AB

%% Load all tracking/touch information and save
% We will make a structure per mouse with 4 substructures: behave, meta, touch and licks
% Each substructure will have only the tracked files in them
load ~/Dropbox/Data/3posdata/retrack_db.mat
% Re-tracked sessions:
% 32: 1:3,5:8. 33: 1:3,6. 34: 1:2,4:11. 36: 1:7,9,10. 38: 1:10;
tracked_sess = zeros(5,13);
tracked_sess(1,[1:2,4:8]) = 1;
tracked_sess(2,[1:3,6]) = 1;
tracked_sess(3,[1,2,5,6,8:13]) = 1;
tracked_sess(4,[1:7,9,10]) = 1;
tracked_sess(5,1:10) = 1;

a = [32,33,34,36,38];
clear ThreePos

for i = 1:5;
    load(['~/Dropbox/Data/3posdata/meta_',num2str(a(i)),'.mat']);
    load(['~/Dropbox/Data/3posdata/licks_',num2str(a(i)),'.mat']);
    
    this_meta = eval(['meta_',num2str(a(i))]);
%     this_licks = eval(['licks_',num2str(a(i))]); % Licking now handled
%     in a separate loop (in threepos_behavdata.m)
    
    t_id = find(tracked_sess(i,:));
    
    
    clear behav licks meta kappa theta 
    for j = 1:numel(t_id)
        clear kappa_w theta_w r_base tracked_AB tracked policy retrack_table
        % Conditional for sessions without policy in
        if (i==2 && t_id(j) == 6) || (i==3 && t_id(j) <6)
            policy = ones(size(this_meta{t_id(j)}.hit));
        else
            policy = strcmp(this_meta{t_id(j)}.policy,'AB')';
        end
        
        cd (retrack_db{i,j}.path)
        % Load good_trials file
        xlsfile = 'good_trials.xlsx';
        xls_info = xlsread(xlsfile);
        
        tracked = retrack_db{i,j}.tracked_files;
        
        % trial_id of tracked files
        tracked_ids = xls_info(tracked,2);
        
        tracked_AB = tracked(ismember(tracked_ids,find(policy)));

        retrack_table = csvread('quality_touch_params.csv');
        
        var_files = dir('*.dat');
        kappa = zeros(numel(tracked_AB),5000);
        theta = zeros(numel(tracked_AB),5000);
        
        trialtypes = zeros(numel(tracked_AB),1);
        trials = zeros(numel(tracked_AB),1);
        choices = zeros(numel(tracked_AB),1);
        startframes = zeros(numel(tracked_AB),1);
        dropped = zeros(numel(tracked_AB),1);
        poleup = zeros(numel(tracked_AB),1);
        barPos = zeros(numel(tracked_AB),2);
        fp_1 = zeros(numel(tracked_AB),5000);
        fp_2 = zeros(numel(tracked_AB),5000);
        trial_id = zeros(numel(tracked_AB),1);
        
        % Touch variables
        touch_info = load('touch_params.csv');
        tch = zeros(numel(tracked_AB),5000);
        pro_ret_array = zeros(numel(tracked_AB),5000);
        gof_array = zeros(numel(tracked_AB),5000);
        
        first_tch = zeros(numel(tracked_AB),1);
        pro_tch = zeros(numel(tracked_AB),1);
        pro_tch_csv = -1*ones(numel(tracked_AB),1);
        tch_det = -1*ones(numel(tracked_AB),1);
                    
        for k = 1: numel(tracked_AB)
            trials(k) = str2double(var_files(tracked_AB(k)).name(end-9:end-4));
            trial_num = find(xls_info(:,1) == trials(k));
            
            % Setting up empty single-trial variables incase they are
            % missing
            kappa_w = zeros(5000,1);
            theta_w = zeros(5000,1);
            r_base = zeros(5000,2,3);
            touches = zeros(5000,1);
            protraction_touch = -1; % if missing
            
            
            % IF file isn't in good_trials, don't bother loading it
            if trial_num
                trialtypes(k) = xls_info(trial_num,204);
                choices(k) = xls_info(trial_num,205);
                startframes(k) = xls_info(trial_num,3);
                poleup(k) = xls_info(trial_num,4);
                trial_id(k) = xls_info(trial_num,2);
                
                try
                    load([var_files(tracked_AB(k)).name(1:end-4),'_clean.mat'],'kappa_w','theta_w','r_base');
                    
                    % Fill zeros (dropped frames) with previous good value
                    dropped_frames = find(kappa_w ==0);
                    if numel(dropped_frames >=1)
                        disp(['Filling in ',num2str(numel(dropped_frames)),' dropped frames']);
                        for f = dropped_frames;
%                             f
                            if f == 1;
                                kappa_w(f) = kappa(end);
                                theta_w(f) = theta(end);
                                r_base(f,:,:) = r_base(end,:,:);
                            else
                                kappa_w(f) = kappa_w(f-1);
                                theta_w(f) = theta_w(f-1);
                                r_base(f,:,:) = r_base(f-1,:,:);
                            end
                        end
                    end
                    
                    
                    kappa_w = [circshift(kappa_w,[0,-startframes(k)]),zeros(1,5000-numel(kappa_w))];
                    theta_w = [circshift(theta_w,[0,-startframes(k)]),zeros(1,5000-numel(theta_w))];
                    kappa(k,:) = kappa_w;
                    theta(k,:) = theta_w;
                    
                    % Base of tracked whisker, proxy for follicle position. Allows
                    % plotting angle to pole
                    fp_1(k,:) = [circshift(r_base(:,1,1)',[0,-startframes(k)]),zeros(1,5000-size(r_base,1))]';
                    fp_2(k,:) = [circshift(r_base(:,2,1)',[0,-startframes(k)]),zeros(1,5000-size(r_base,1))]';
                    
                    
                    % Touch variables
                    filename = [var_files(tracked_AB(k)).name(1:end-4),'_touch.mat'];
                    load(filename,'touches','protraction_touch','first_touch','pro_ret','gof');
                    
                    touches = [circshift(touches,[0,-startframes(k)]),zeros(1,5000-numel(touches))];
                    pro_ret = [circshift(pro_ret,[0,-startframes(k)]),zeros(1,5000-numel(pro_ret))];
                    gof = [circshift(gof,[0,-startframes(k)]),zeros(1,5000-numel(gof))];
                    
                    tch(k,:) = touches;
                    pro_ret_array(k,:) = pro_ret;
                    gof_array(k,:) = gof;
                    
                    first_tch(k) = first_touch;
                    pro_tch(k) = protraction_touch;
                    
                    pro_tch_csv(k) = touch_info(trial_num,15);
                    tch_det(k) = touch_info(trial_num,4);
                    
                    
                    fname = [var_files(tracked_AB(k)).name(1:end-4),'.dat'];
                    % Use pole tracker to plot video frame and store pole location
                    % for triggerframe + 10
                    
                    
                    [bp,frame] = poletracker(fname,14,1000,1);drawnow;
                    barPos(k,:) = bp';
                    
                    
                catch
                    display(['Something was wrong with file',var_files(tracked_AB(k)).name])
                    kappa(k,:) = zeros(1,5000);
                    theta(k,:) = zeros(1,5000);
                    
                    fp_1(k,:) = zeros(1,5000);
                    fp_2(k,:) = zeros(1,5000);
                    
                    trialtypes(k) = 0;
                    choices(k) = 0;
                    startframes(k) = 0;
                    dropped(k) = 1;
                    poleup(k) = 0;
                    barPos(k,:) = [0,0];
                    trial_id(k) = 0;
                end
            else
                kappa(k,:) = zeros(1,5000);
                theta(k,:) = zeros(1,5000);
                
                fp_1(k,:) = zeros(1,5000);
                fp_2(k,:) = zeros(1,5000);
                
                trialtypes(k) = 0;
                choices(k) = 0;
                startframes(k) = 0;
                dropped(k) = 1;
                poleup(k) = 0;
                barPos(k,:) = [0,0];
                trial_id(k) = 0;
            end
        end
        
        behav{j}.kappa = kappa;
        behav{j}.theta = theta;
        
        behav{j}.fp_1 = fp_1;
        behav{j}.fp_2 = fp_2;
        
        behav{j}.startframe = startframes;
        behav{j}.trial = trials;
        behav{j}.choice_m = choices;
        behav{j}.trialtype = trialtypes;
        behav{j}.dropped = dropped;
        behav{j}.poleup = poleup;
        behav{j}.barPos = barPos;
        behav{j}.trial_id = trial_id;
        
        behav{j}.name = retrack_db{i,j}.session;
        
        behav{j}.path = pwd;
        
        % Touch info
        behav{j}.tracked_AB = tracked_AB;
        behav{j}.touches = tch;
        behav{j}.first_touch = first_tch;
        behav{j}.pro_touch = pro_tch;
        behav{j}.pro_ret = pro_ret_array;
        
        behav{j}.pro_tch_csv = pro_tch_csv;
        behav{j}.tch_det = tch_det;
        
%         %% Licks - NOW HANDLED SEPARATELY IN THREEPOS_BEHAVDATA.m
%         l = this_licks{t_id(j)}.licks_all(tid,:);
%         
%         licks{j} = this_licks{t_id(j)};
%         
%         % Fix choice with lick direction within grace period
%         lick_choice = 3*ones(numel(Threepos{i}.meta{j}.pole_location),1);
%         ll = find(l(:,1));
%         lr = find(l(:,2));
%         lick_choice(ll) = 1;
%         lick_choice(lr) = 2;
%         
%         % Fix late licks
%         lick_choice([find(l(:,1) > 2500);find(l(:,2) > 2500)]) = 3;
%         
%         % Licking on both ports
%         two_licks = ll(find(ismember(ll,lr)));
%         for tl = 1:numel(two_licks)
%             [mn,mi] = min(l(two_licks(tl),:));
%             if mn > 2500
%                 lick_choice(two_licks(tl)) = 3;
%             else
%                 lick_choice(two_licks(tl)) = mi;
%             end
%         
%         end
%         
%         behav{j}.choice = lick_choice;
%         
%         %%
%         
%         licks{j} = this_licks{t_id(j)};
%         
%         % Fix choice with lick direction within grace period
%         lick_choice = 3*ones(numel(Threepos{i}.meta{j}.pole_location),1);
%         ll = find(licks{j}(:,1));
%         lr = find(licks{j}(:,2));
%         lick_choice(ll) = 1;
%         lick_choice(lr) = 2;
%         
%         % Fix late licks
%         lick_choice([find(licks{j}(:,1) > 2500);find(licks{j}(:,2) > 2500)]) = 3;
%         
%         % Licking on both ports
%         two_licks = ll(find(ismember(ll,lr)));
%         for tl = 1:numel(two_licks)
%             [mn,mi] = min(licks{j}(two_licks(tl),:));
%             if mn > 2500
%                 lick_choice(two_licks(tl)) = 3;
%             else
%                 lick_choice(two_licks(tl)) = mi;
%             end
%         
%         end
%         
%         
%         
%         behav{j}.choice = lick_choice;
        
        %% Meta
        meta{j} = this_meta{t_id(j)};
        
%         % Trialtype and choice based on meta data (just a sanity check)
%         mtt = zeros(numel(trial_id),1);
%         mch = zeros(numel(trial_id),1);
%         mtt(tid) = this_meta{t_id(j)}.trialtype(tid);
%         mch(tid) = this_meta{t_id(j)}.reponse(tid);
        
%         behav{j}.meta_tt = mtt;
%         behav{j}.meta_ch = mch;
    
    end
    
    Threepos{i}.behav = behav;
%     Threepos{i}.licks = licks;
    Threepos{i}.meta = meta;
    
end

save ~/Dropbox/Data/3posdata/Threepos Threepos
%% Lick choice array length fix - NOW DONE IN THREEPOS_BEHAVDATA.m
for i = 1:5
    load(['~/Dropbox/Data/3posdata/licks_',num2str(a(i)),'.mat']);
    
    this_licks = eval(['licks_',num2str(a(i))]);
    
    t_id = find(tracked_sess(i,:));
    clear licks
    for j = 1:numel(Threepos{i}.behav)
        trial_id = Threepos{i}.behav{j}.trial_id;

        tid = trial_id(find(trial_id));
        l = this_licks{t_id(j)}(tid,:);
        
        licks{j} = this_licks{t_id(j)};
        
        % Fix choice with lick direction within grace period
        lick_choice = 3*ones(numel(Threepos{i}.meta{j}.pole_location),1);
        ll = find(licks{j}(:,1));
        lr = find(licks{j}(:,2));
        lick_choice(ll) = 1;
        lick_choice(lr) = 2;
        
        % Fix late licks
        lick_choice([find(licks{j}(:,1) > 2500);find(licks{j}(:,2) > 2500)]) = 3;
        
        % Licking on both ports
        two_licks = ll(find(ismember(ll,lr)));
        for tl = 1:numel(two_licks)
            [mn,mi] = min(licks{j}(two_licks(tl),:));
            if mn > 2500
                lick_choice(two_licks(tl)) = 3;
            else
                lick_choice(two_licks(tl)) = mi;
            end
        
        end
        
        
        
        Threepos{i}.behav{j}.choice = lick_choice;
    end
    Threepos{i}.licks = licks;
end
%% Check sync based on trialtype and pole position
a = [32,33,34,36,38];
colours = [0,1,0;1,0,0;0.5,0.5,0.5];
tt_name = {'Anterior';'Posterior';'No Go'};

for i = 1:5
    for j = 1:numel(Threepos{i}.behav)
        clf;
        undropped = find(Threepos{i}.behav{j}.dropped == 0);
        for t = 1:3;
            tt = find(Threepos{i}.behav{j}.trialtype(undropped) == t);
            plot(tt,Threepos{i}.behav{j}.barPos(undropped(tt),1));
            hold all
            plot(tt,Threepos{i}.behav{j}.barPos(undropped(tt),1),'k.');
            
        end
        title(['Mouse ',Threepos{i}.behav{j}.name(end-2:end-1),' Session ',num2str(j),' (',Threepos{i}.behav{j}.name(1:6),')'])
        drawnow;
        pause;
    end
end

%% Check trial type against metadata pole location
for i = 1:5
    for j = 1:numel(Threepos{i}.behav)
        clf;
        undropped = find(Threepos{i}.behav{j}.dropped == 0);
        tid = Threepos{i}.behav{j}.trial_id(undropped);
        for t = 1:3;
            tt = find(Threepos{i}.behav{j}.trialtype(undropped) == t);   
            plot(tt,Threepos{i}.meta{j}.pole_location(tid(tt)));
            hold all
            plot(tt,Threepos{i}.meta{j}.pole_location(tid(tt)),'k.');
            
        end
        title(['Mouse ',Threepos{i}.behav{j}.name(end-2:end-1),' Session ',num2str(j),' (',Threepos{i}.behav{j}.name(1:6),')'])
        drawnow;
        pause;
    end
end


%% Fixing tracking errors in certain files (do this on original data at some point)

mouse=5, i=1, j=24; Threepos{mouse}.behav{i}.touches(j,1) = 0; Threepos{mouse}.behav{i}.first_touch(j) = 5022;

%% Set bad sync file to dropped = 1
Threepos{3}.behav{2}.dropped(79:80) = 1;
Threepos{4}.behav{6}.dropped(65)    = 1;
%% Set trials with protraction/retraction variable == -1 to dropped 1
Threepos{4}.behav{6}.dropped(1) =1;
Threepos{4}.behav{6}.dropped(13) =1;

%% More trials with bad tracking
Threepos{1}.behav{3}.dropped(4) = 1;
Threepos{3}.behav{1}.dropped(131) = 1;
Threepos{3}.behav{3}.dropped(33) = 1;
Threepos{4}.behav{4}.dropped(70) = 1;

