% threeposition.m
% Script to load and explore data from the Left, Right, No Go/ 3 position task
%
% Mice to analyse are 32, 33, 34, 36, 38
% Data are kept in 2 places: Petersen NAS and Isilon University storage.
% Directory paths to these locations are:
% NAS_path = /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/
% Isilon_path = /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'/Dario' Campagner'/BEHAVIORAL' MOVIES'/
% Data for the following dates are in these locations (as detailed in NAS_path/tracking_list.xls):
%
% 32/ Performance summary?:
%     NAS:18-19.02, 27-31.03, 01-03.04, 10.04, 16-17.04, 20-24.04, 27.04
%     Isilon: 28.04 - 01.05
%
% 33/ Performance summary:
%     NAS: 11-12.12.14, 15-17.12.14, 10-13.02, 16-19.02, 25-27.02,
%     03-06.03, 10-13.03, 16.03,
%     Isilon: 28.04 - 01.05
%
% 34/ Performance summary:
%     NAS: 11-12.12.14, 15-17.12.14, 03.02, 10-11.02, 13.02, 16-19.02,
%     25-27.02, 03-06.03, 10-13.03, 16.03, 18.03, 17.04, 20-24.04, 27.04
%     Isilon: 28.04 - 01.05
%
% 36/ Performance summary:
%     NAS: None
%     Isilon: 29.06 - 03.07, 06.07, 27-31.07, 04-09.08
%
% 38/ Performance summary:
%     NAS: None
%     Isilon: 12.06, 15-19.06, 22-24.06, 26.06, 29.06 - 03.07, 06-10.07,
%     12.07, 15-17.07, 21.07, 24.07, 30.07, 04-06.08, 09.08

%% For each mouse, load up all available sessions of kappa/theta and see if it's obvious what the strategy is

% TO DO: Store file name, trial type and choice in same loop.

% TO DO: List other single whisker sessions.


%% 32:
clear behav_32
dates =  [3,7,29,32,35,38,41,45,47,49,50,56]; % {'200415_32a','210415_32a','220415_32a','230415_32a'};
% To track: 18,57
% On trials: 55,59,61,62
% Bad session: 9
% Missing data: 32 (one trial).
% No good_trials file: Session 12 (270415_32a).
clear kappa theta kappa_w theta_w
for i = 1:numel(dates);
    i
    cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/32/
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})
    
    var_files = dir('*_clean.mat');
    kappa = zeros(numel(var_files),5000);
    theta = zeros(numel(var_files),5000);
    
    
    
    % Load good_trials file
    xlsfile = 'good_trials.xlsx';
    xls_info = xlsread(xlsfile);
    
    trialtypes = zeros(numel(var_files),1);
    trials = zeros(numel(var_files),1);
    choices = zeros(numel(var_files),1);
    startframes = zeros(numel(var_files),1);
    dropped = zeros(numel(var_files),1);
    poleup = zeros(numel(var_files),1);
    barPos = zeros(numel(var_files),2);
    fp_1 = zeros(numel(var_files),5000);
    fp_2 = zeros(numel(var_files),5000);
    
    for j = 1: numel(var_files)
        trials(j) = str2double(var_files(j).name(end-15:end-10));
        trial_num = find(xls_info(:,1) == trials(j));
        % IF file isn't in good_trials, don't bother loading it
        if trial_num
            trialtypes(j) = xls_info(trial_num,204);
            choices(j) = xls_info(trial_num,205);
            startframes(j) = xls_info(trial_num,3);
            poleup(j) = xls_info(trial_num,4);
            try
                load(var_files(j).name,'kappa_w','theta_w','r_base');
                kappa_w = [circshift(kappa_w,[0,-startframes(j)]),zeros(1,5000-numel(kappa_w))];
                theta_w = [circshift(theta_w,[0,-startframes(j)]),zeros(1,5000-numel(theta_w))];
                kappa(j,:) = kappa_w;
                theta(j,:) = theta_w;
                
                % Base of tracked whisker, proxy for follicle position. Allows
                % plotting angle to pole
                fp_1(j,:) = [circshift(r_base(:,1,1)',[0,-startframes(j)]),zeros(1,5000-size(r_base,1))]';
                fp_2(j,:) = [circshift(r_base(:,2,1)',[0,-startframes(j)]),zeros(1,5000-size(r_base,1))]';
                
                fname = [var_files(j).name(1:end-10),'.dat'];
                % Use pole tracker to plot video frame and store pole location
                % for triggerframe + 10
                
                [bp,frame] = poletracker(fname,14,1000,0);
                barPos(j,:) = bp';
                drawnow;
                
            catch
                display(['Something was wrong with file',var_files(j).name])
                kappa(j,:) = zeros(1,5000);
                theta(j,:) = zeros(1,5000);
                
                fp_1(j,:) = zeros(1,5000);
                fp_2(j,:) = zeros(1,5000);
                
                trialtypes(j) = 0;
                choices(j) = 0;
                startframes(j) = 0;
                dropped(j) = 1;
                poleup(j) = 0;
                barPos(j,:) = [0,0];
            end
        else
            kappa(j,:) = zeros(1,5000);
            theta(j,:) = zeros(1,5000);
            
            fp_1(j,:) = zeros(1,5000);
            fp_2(j,:) = zeros(1,5000);
            
            trialtypes(j) = 0;
            choices(j) = 0;
            startframes(j) = 0;
            dropped(j) = 1;
            poleup(j) = 0;
            barPos(j,:) = [0,0];
        end
    end
    
    behav_32{i}.kappa = kappa;
    behav_32{i}.theta = theta;
    
    behav_32{i}.fp_1 = fp_1;
    behav_32{i}.fp_2 = fp_2;
    
    behav_32{i}.startframe = startframes;
    behav_32{i}.trial = trials;
    behav_32{i}.choice = choices;
    behav_32{i}.trialtype = trialtypes;
    behav_32{i}.dropped = dropped;
    behav_32{i}.poleup = poleup;
    behav_32{i}.barPos = barPos;
    
    behav_32{i}.name = files(dates(i)).name;
    
    behav_32{i}.path = pwd;
end



% 32 sync end
for i = 1:numel(behav_32)
    behav_32{i}.sync = numel(behav_32{i}.trialtype);
end

% Unsynced exceptions
behav_32{3}.sync = 119;
behav_32{5}.sync = 193;
behav_32{7}.sync = 132;
behav_32{10}.sync = 130;


save ~/work/whiskfree/data/behav_32b.mat behav_32

% 33:
clear behav_33

dates = [4,5,6,8,11,19,23,26,30,33,17,20,21,24,34,55]; %{'110315_33a','120315_33a'}; % '120315_33b'/'130315_33a'/'160315_33a'/'160315_33b'/ 3 trials of '160315_33a' need tracking
% To track: 16,12,22,25,27,28,29,31,37,51,52,53,54,58,61,66
% On trials:
% Bad sessions:
% Missing data:
clear kappa theta kappa_w theta_w
for i = 1:numel(dates);
    cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/33/
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})
    
    var_files = dir('*_clean.mat');
    kappa = zeros(numel(var_files),5000);
    theta = zeros(numel(var_files),5000);
    % Load good_trials file
    xlsfile = 'good_trials.xlsx';
    xls_info = xlsread(xlsfile);
    
    trialtypes = zeros(numel(var_files),1);
    trials = zeros(numel(var_files),1);
    choices = zeros(numel(var_files),1);
    startframes = zeros(numel(var_files),1);
    dropped = zeros(numel(var_files),1);
    poleup = zeros(numel(var_files),1);
    barPos = zeros(numel(var_files),2);
    fp_1 = zeros(numel(var_files),5000);
    fp_2 = zeros(numel(var_files),5000);
    
    
    for j = 1: numel(var_files)
        trials(j) = str2double(var_files(j).name(end-15:end-10));
        trial_num = find(xls_info(:,1) == trials(j));
        
        % IF file isn't in good_trials, don't bother loading it
        if trial_num
            trialtypes(j) = xls_info(trial_num,204);
            choices(j) = xls_info(trial_num,205);
            startframes(j) = xls_info(trial_num,3);
            poleup(j) = xls_info(trial_num,4);
            try
                load(var_files(j).name,'kappa_w','theta_w','r_base');
                kappa_w = [circshift(kappa_w,[0,-startframes(j)]),zeros(1,5000-numel(kappa_w))];
                theta_w = [circshift(theta_w,[0,-startframes(j)]),zeros(1,5000-numel(theta_w))];
                kappa(j,:) = kappa_w;
                theta(j,:) = theta_w;
                
                % Base of tracked whisker, proxy for follicle position. Allows
                % plotting angle to pole
                fp_1(j,:) = [circshift(r_base(:,1,1)',[0,-startframes(j)]),zeros(1,5000-size(r_base,1))]';
                fp_2(j,:) = [circshift(r_base(:,2,1)',[0,-startframes(j)]),zeros(1,5000-size(r_base,1))]';
                
                fname = [var_files(j).name(1:end-10),'.dat'];
                % Use pole tracker to plot video frame and store pole location
                % for triggerframe + 10
                
                [bp,frame] = poletracker(fname,14,1000,1);
                barPos(j,:) = bp';
                drawnow;
            catch
                display(['Something was wrong with file',var_files(j).name])
                kappa(j,:) = zeros(1,5000);
                theta(j,:) = zeros(1,5000);
                
                fp_1(j,:) = zeros(1,5000);
                fp_2(j,:) = zeros(1,5000);
                
                trialtypes(j) = 0;
                choices(j) = 0;
                startframes(j) = 0;
                dropped(j) = 1;
                poleup(j) = 0;
                barPos(j,:) = [0,0];
            end
            
        else
            kappa(j,:) = zeros(1,5000);
            theta(j,:) = zeros(1,5000);
            
            fp_1(j,:) = zeros(1,5000);
            fp_2(j,:) = zeros(1,5000);
            
            trialtypes(j) = 0;
            choices(j) = 0;
            startframes(j) = 0;
            dropped(j) = 1;
            poleup(j) = 0;
            barPos(j,:) = [0,0];
        end
    end
    
    behav_33{i}.kappa = kappa;
    behav_33{i}.theta = theta;
    
    behav_33{i}.fp_1 = fp_1;
    behav_33{i}.fp_2 = fp_2;
    
    behav_33{i}.startframe = startframes;
    behav_33{i}.trial = trials;
    behav_33{i}.choice = choices;
    behav_33{i}.trialtype = trialtypes;
    behav_33{i}.dropped = dropped;
    behav_33{i}.poleup = poleup;
    behav_33{i}.barPos = barPos;
    
    behav_33{i}.name = files(dates(i)).name;
    
    behav_33{i}.path = pwd;
end



% 33 sync end
for i = 1:numel(behav_33)
    behav_33{i}.sync = numel(behav_33{i}.trialtype);
end
% 
                % plotting angle to pole
% % Unsynced exceptions
behav_33{8}.sync = 0;
behav_33{11}.sync = 98;
behav_33{12}.sync = 183;
% behav_33{10}.sync = 130;

save ~/work/whiskfree/data/behav_33b.mat behav_33



% 34:
clear behav_34

dates = [30,34]; % {'161214_34a','171214_34a'};
% To track:
% 21,23,24,27,4,15,18,25,28,31,35,40,54,56,58,5,8,9,11,12,16,19,22,26,29,36,32,43,46,49,51,52,60
% On trials:
% Bad sessions:
% Missing data:
clear kappa theta kappa_w theta_w
for i = 1:numel(dates);
    i
    cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/34/
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})
    
    var_files = dir('*_clean.mat');
    kappa = zeros(numel(var_files),5000);
    theta = zeros(numel(var_files),5000);
    % Load good_trials file
    xlsfile = 'good_trials.xlsx';
    xls_info = xlsread(xlsfile);
    
    trialtypes = zeros(numel(var_files),1);
    trials = zeros(numel(var_files),1);
    choices = zeros(numel(var_files),1);
    startframes = zeros(numel(var_files),1);
    dropped = zeros(numel(var_files),1);
    poleup = zeros(numel(var_files),1);
    barPos = zeros(numel(var_files),2);
    fp_1 = zeros(numel(var_files),5000);
    fp_2 = zeros(numel(var_files),5000);
    
    
    for j = 1: numel(var_files)
        trials(j) = str2double(var_files(j).name(end-15:end-10));
        trial_num = find(xls_info(:,1) == trials(j));
        
        % IF file isn't in good_trials, don't bother loading it
        if trial_num
            trialtypes(j) = xls_info(trial_num,204);
            choices(j) = xls_info(trial_num,205);
            startframes(j) = xls_info(trial_num,3);
            poleup(j) = xls_info(trial_num,4);
            try
                load(var_files(j).name,'kappa_w','theta_w','r_base');
                kappa_w = [circshift(kappa_w,[0,-startframes(j)]),zeros(1,5000-numel(kappa_w))];
                theta_w = [circshift(theta_w,[0,-startframes(j)]),zeros(1,5000-numel(theta_w))];
                kappa(j,:) = kappa_w;
                theta(j,:) = theta_w;
                
                % Base of tracked whisker, proxy for follicle position. Allows
                % plotting angle to pole
                fp_1(j,:) = [circshift(r_base(:,1,1)',[0,-startframes(j)]),zeros(1,5000-size(r_base,1))]';
                fp_2(j,:) = [circshift(r_base(:,2,1)',[0,-startframes(j)]),zeros(1,5000-size(r_base,1))]';
                
                fname = [var_files(j).name(1:end-10),'.dat'];
                % Use pole tracker to plot video frame and store pole location
                % for triggerframe + 10
                
                [bp,frame] = poletracker(fname,14,1000,1);
                barPos(j,:) = bp';
                drawnow;
            catch
                display(['Something was wrong with file',var_files(j).name])
                kappa(j,:) = zeros(1,5000);
                theta(j,:) = zeros(1,5000);
                
                fp_1(j,:) = zeros(1,5000);
                fp_2(j,:) = zeros(1,5000);
                
                trialtypes(j) = 0;
                choices(j) = 0;
                startframes(j) = 0;
                dropped(j) = 1;
                poleup(j) = 0;
                barPos(j,:) = [0,0];
            end
        else
            kappa(j,:) = zeros(1,5000);
            theta(j,:) = zeros(1,5000);
            
            fp_1(j,:) = zeros(1,5000);
            fp_2(j,:) = zeros(1,5000);
            
            trialtypes(j) = 0;
            choices(j) = 0;
            startframes(j) = 0;
            dropped(j) = 1;
            poleup(j) = 0;
            barPos(j,:) = [0,0];
        end
    end
    
    behav_34{i}.kappa = kappa;
    behav_34{i}.theta = theta;
    
    behav_34{i}.fp_1 = fp_1;
    behav_34{i}.fp_2 = fp_2;
    
    behav_34{i}.startframe = startframes;
    behav_34{i}.trial = trials;
    behav_34{i}.choice = choices;
    behav_34{i}.trialtype = trialtypes;
    behav_34{i}.dropped = dropped;
    behav_34{i}.poleup = poleup;
    behav_34{i}.barPos = barPos;
    
    behav_34{i}.name = files(dates(i)).name;
    
    behav_34{i}.path = pwd;
end



% 34 sync end
for i = 1:numel(behav_34)
    behav_34{i}.sync = numel(behav_34{i}.trialtype);
end
% 
% Unsynced exceptions
behav_34{2}.sync = 168;
% behav_34{5}.sync = 193;
% behav_34{7}.sync = 132;
% behav_34{10}.sync = 130;

save ~/work/whiskfree/data/behav_34b.mat behav_34

% 36:
clear behav_36

dates = [60,64,67,68,12,14,17,20,21,24,27,63,66,4,6,9,16]; %{'060815_36a','070815_36a','070815_36b','080815_36a','090815_36a'};
% To track:
% On trials:
% Bad sessions:
% Missing data: i13,j86+101
clear kappa theta kappa_w theta_w
for i = 1:numel(dates);
    i
        cd /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'/Dario' Campagner'/BEHAVIORAL' MOVIES'/36/
%     cd /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'
%     cd Dario' Campagner'/BEHAVIORAL' MOVIES'/36/
    
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})
    
    var_files = dir('*_clean.mat');
    kappa = zeros(numel(var_files),5000);
    theta = zeros(numel(var_files),5000);
    % Load good_trials file
    xlsfile = 'good_trials.xlsx';
    xls_info = xlsread(xlsfile);
    
    trialtypes = zeros(numel(var_files),1);
    trials = zeros(numel(var_files),1);
    choices = zeros(numel(var_files),1);
    startframes = zeros(numel(var_files),1);
    dropped = zeros(numel(var_files),1);
    poleup = zeros(numel(var_files),1);
    barPos = zeros(numel(var_files),2);
    fp_1 = zeros(numel(var_files),5000);
    fp_2 = zeros(numel(var_files),5000);
    
    
    for j = 1: numel(var_files)
        trials(j) = str2double(var_files(j).name(end-15:end-10));
        trial_num = find(xls_info(:,1) == trials(j));
        
        % IF file isn't in good_trials, don't bother loading it
        if trial_num
            trialtypes(j) = xls_info(trial_num,204);
            choices(j) = xls_info(trial_num,205);
            startframes(j) = xls_info(trial_num,3);
            poleup(j) = xls_info(trial_num,4);
            try
                load(var_files(j).name,'kappa_w','theta_w','r_base');
                kappa_w = [circshift(kappa_w,[0,-startframes(j)]),zeros(1,5000-numel(kappa_w))];
                theta_w = [circshift(theta_w,[0,-startframes(j)]),zeros(1,5000-numel(theta_w))];
                kappa(j,:) = kappa_w;
                theta(j,:) = theta_w;
                
                % Base of tracked whisker, proxy for follicle position. Allows
                % plotting angle to pole
                fp_1(j,:) = [circshift(r_base(:,1,1)',[0,-startframes(j)]),zeros(1,5000-size(r_base,1))]';
                fp_2(j,:) = [circshift(r_base(:,2,1)',[0,-startframes(j)]),zeros(1,5000-size(r_base,1))]';
                
                fname = [var_files(j).name(1:end-10),'.dat'];
                % Use pole tracker to plot video frame and store pole location
                % for triggerframe + 10
                
                [bp,frame] = poletracker(fname,14,1000,1);
                barPos(j,:) = bp';
                drawnow;
                
                
            catch
                display(['Something was wrong with file',var_files(j).name])
                kappa(j,:) = zeros(1,5000);
                theta(j,:) = zeros(1,5000);
                
                fp_1(j,:) = zeros(1,5000);
                fp_2(j,:) = zeros(1,5000);
                
                trialtypes(j) = 0;
                choices(j) = 0;
                startframes(j) = 0;
                dropped(j) = 1;
                poleup(j) = 0;
                barPos(j,:) = [0,0];
            end
        else
            kappa(j,:) = zeros(1,5000);
            theta(j,:) = zeros(1,5000);
            
            fp_1(j,:) = zeros(1,5000);
            fp_2(j,:) = zeros(1,5000);
            
            trialtypes(j) = 0;
            choices(j) = 0;
            startframes(j) = 0;
            dropped(j) = 1;
            poleup(j) = 0;
            barPos(j,:) = [0,0];
        end
    end
    
    behav_36{i}.kappa = kappa;
    behav_36{i}.theta = theta;
    
    behav_36{i}.fp_1 = fp_1;
    behav_36{i}.fp_2 = fp_2;
    
    behav_36{i}.startframe = startframes;
    behav_36{i}.trial = trials;
    behav_36{i}.choice = choices;
    behav_36{i}.trialtype = trialtypes;
    behav_36{i}.dropped = dropped;
    behav_36{i}.poleup = poleup;
    behav_36{i}.barPos = barPos;
    
    behav_36{i}.name = files(dates(i)).name;
    
    behav_36{i}.path = pwd;
end



% 36 sync end
for i = 1:numel(behav_36)
    behav_36{i}.sync = numel(behav_36{i}.trialtype);
end
% 
% Unsynced exceptions
behav_36{14}.sync = 0;
behav_36{15}.sync = 0;
% behav_36{7}.sync = 132;
% behav_36{10}.sync = 130;

save ~/work/whiskfree/data/behav_36b.mat behav_36

%% 38
clear behav_38

dates = [29,34,38,41,49,52,58,8,12,15,37,46,56,9,10,13,21]%,60,64,67,68];
% To track:
% On trials:
% Bad sessions:
% Missing data: 300715_38b
clear kappa theta kappa_w theta_w
for i = 1:numel(dates);
    i
    %     cd /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'/Dario' Campagner'/BEHAVIORAL' MOVIES'/36/
    cd /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'
    cd Dario' Campagner'/BEHAVIORAL' MOVIES'/38/
    
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})
    
    var_files = dir('*_clean.mat');
    kappa = zeros(numel(var_files),5000);
    theta = zeros(numel(var_files),5000);
    % Load good_trials file
    xlsfile = 'good_trials.xlsx';
    xls_info = xlsread(xlsfile);
    
    trialtypes = zeros(numel(var_files),1);
    trials = zeros(numel(var_files),1);
    choices = zeros(numel(var_files),1);
    startframes = zeros(numel(var_files),1);
    dropped = zeros(numel(var_files),1);
    poleup = zeros(numel(var_files),1);
    barPos = zeros(numel(var_files),2);
    fp_1 = zeros(numel(var_files),5000);
    fp_2 = zeros(numel(var_files),5000);
    
    
    for j = 1: numel(var_files)
        trials(j) = str2double(var_files(j).name(end-15:end-10));
        trial_num = find(xls_info(:,1) == trials(j));
        
        % IF file isn't in good_trials, don't bother loading it
        if trial_num
            trialtypes(j) = xls_info(trial_num,204);
            choices(j) = xls_info(trial_num,205);
            startframes(j) = xls_info(trial_num,3);
            poleup(j) = xls_info(trial_num,4);
            try
                load(var_files(j).name,'kappa_w','theta_w');
                kappa_w = [circshift(kappa_w,[0,-startframes(j)]),zeros(1,5000-numel(kappa_w))];
                theta_w = [circshift(theta_w,[0,-startframes(j)]),zeros(1,5000-numel(theta_w))];
                kappa(j,:) = kappa_w;
                theta(j,:) = theta_w;
                
                % Base of tracked whisker, proxy for follicle position. Allows
                % plotting angle to pole
                fp_1(j,:) = [circshift(r_base(:,1,1)',[0,-startframes(j)]),zeros(1,5000-size(r_base,1))]';
                fp_2(j,:) = [circshift(r_base(:,2,1)',[0,-startframes(j)]),zeros(1,5000-size(r_base,1))]';
                
                fname = [var_files(j).name(1:end-10),'.dat'];
                % Use pole tracker to plot video frame and store pole location
                % for triggerframe + 10
                
                [bp,frame] = poletracker(fname,14,1000,1);
                barPos(j,:) = bp';
                drawnow;
                
            catch
                display(['Something was wrong with file',var_files(j).name])
                kappa(j,:) = zeros(1,5000);
                theta(j,:) = zeros(1,5000);
                
                fp_1(j,:) = zeros(1,5000);
                fp_2(j,:) = zeros(1,5000);
                
                trialtypes(j) = 0;
                choices(j) = 0;
                startframes(j) = 0;
                dropped(j) = 1;
                poleup(j) = 0;
                barPos(j,:) = [0,0];
            end
        else
            kappa(j,:) = zeros(1,5000);
            theta(j,:) = zeros(1,5000);
            
            fp_1(j,:) = zeros(1,5000);
            fp_2(j,:) = zeros(1,5000);
            
            trialtypes(j) = 0;
            choices(j) = 0;
            startframes(j) = 0;
            dropped(j) = 1;
            poleup(j) = 0;
            barPos(j,:) = [0,0];
        end
    end
    
    behav_38{i}.kappa = kappa;
    behav_38{i}.theta = theta;
    
    behav_38{i}.fp_1 = fp_1;
    behav_38{i}.fp_2 = fp_2;
    
    behav_38{i}.startframe = startframes;
    behav_38{i}.trial = trials;
    behav_38{i}.choice = choices;
    behav_38{i}.trialtype = trialtypes;
    behav_38{i}.dropped = dropped;
    behav_38{i}.poleup = poleup;
    behav_38{i}.barPos = barPos;
    
    behav_38{i}.name = files(dates(i)).name;
    
    behav_38{i}.path = pwd;
end



% 38 sync end
% for i = 1:numel(behav_38)
%     behav_38{i}.sync = numel(behav_38{i}.trialtype);
% end
% 
% % Unsynced exceptions
% behav_38{3}.sync = 119;
% behav_38{5}.sync = 193;
% behav_38{7}.sync = 132;
% behav_38{10}.sync = 130;

save ~/work/whiskfree/data/behav_38.mat behav_38

%% NOTE: More data is ready for tracking on Isilon for 32,33 and 34

%% Loop to check file type sensory input consistency (i.e. looking for mis-alignment)

colours = [0,1,0;1,0,0;0.5,0.5,0.5];
tt_name = {'Anterior';'Posterior';'No Go'};
session = 3;


% % 32
% dates =  [3,7,29,32,35,38,41,45,47,49,50,56]; % {'200415_32a','210415_32a','220415_32a','230415_32a'};
% cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/32/

% 33
dates = [4,5,6,8,11,19,23,26,30,33,17,20,21,24,34,55];
cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/33/


files = dir;
cd(files(dates(session)).name);
files(dates(session)).name
x = cellstr(ls);
cd (x{:})

var_files = dir('*_clean.mat');

% Load good_trials filewhos
xlsfile = 'good_trials.xlsx';
xls_info = xlsread(xlsfile);
barPos = zeros(numel(var_files),2);
for j = numel(var_files)-50 : numel(var_files) % 192:numel(var_files); % Looking at last 50 trials in a session
    trial = str2double(var_files(j).name(end-15:end-10));
    trial_num = find(xls_info(:,1) == trial);
    
    
    
    % IF file isn't in good_trials, don't bother loading it
    if trial_num
        try
            trialtype = xls_info(trial_num,204);
            triggermovie  = xls_info(trial_num,6);
            fname = [var_files(j).name(1:end-10),'.dat'];
            % Use pole tracker to plot video frame and store pole location
            % for triggerframe or some other frame
            
            [barPos(j,:),frame] = poletracker(fname,14,1000,1);
            title(['Trial ',num2str(j),', Trialtype = ',num2str(trialtype),', (',tt_name{trialtype},')'],'color',colours(trialtype,:))
            
            % Plot tracked whisker solution on top
            load(var_files(j).name,'r_base');
            temp = WhikerMan_functions({squeeze(1+r_base(1000,:,:)),[0:0.01:20]},8);
            b_tmp = temp{:};
            hold all
            plot(b_tmp(1,:),b_tmp(2,:),'m','Linewidth',2);
            drawnow;pause;
        catch
        end
    end
end


%% Plot extracted bar position instead of loading the videos again
% Add file loading if needed
% load ~/work/whiskfree/data/behav_38b.mat
% load ~/work/whiskfree/data/example_frame frame
this_mouse = behav_32;

% First check barPos makes sense
for s = 1:numel(this_mouse)
   clf;
   imagesc(frame);
   hold all
   plot(this_mouse{s}.fp_1(:,1),this_mouse{s}.fp_2(:,2),'.')
   hold all
   plot(this_mouse{s}.barPos(:,1),this_mouse{s}.barPos(:,2),'.') 
   title(['Mouse ',this_mouse{s}.name(end-2:end-1),' Session ',num2str(s),' (',this_mouse{s}.name(1:6),')'])
   pause;
end

% Then plot barPos per trial type to see when things stop working
% figure;
for s = 1:numel(this_mouse)
    clf
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype == i);
        plot(tt,this_mouse{s}.barPos(tt,1));
        hold all
        plot(tt,this_mouse{s}.barPos(tt,1),'k.');
 
    end
    title(['Mouse ',this_mouse{s}.name(end-2:end-1),' Session ',num2str(s),' (',this_mouse{s}.name(1:6),')'])
    pause
    
end



%% Load data for an example animal/session

% load ~/Dropbox/Data/3posdata/behav_36b.mat
% load ~/Dropbox/Data/3posdata/behav_32.mat
load ~/work/whiskfree/data/behav_32b.mat
load ~/work/whiskfree/data/behav_33b.mat
load ~/work/whiskfree/data/behav_34b.mat
load ~/work/whiskfree/data/behav_36b.mat
% load ~/work/whiskfree/data/behav_38.mat

this_mouse = behav_32;

%% Image/plot whisker angle/curvature conditioned on trialtype/choice
figure(1); clf;
figure(2); clf;
figure(3); clf;
figure(4); clf;

t_range =  1:5000;%500:2000;

mx_t = max(this_mouse{1}.theta(:));
mx_k = max(this_mouse{1}.kappa(:));

for i = 1:3;
    tt = find(this_mouse{1}.trialtype == i);
    for j = 1:3;
        ct = find(this_mouse{1}.choice(tt) == j);
        figure(1);
        subplot(3,3,i*3 - 3 + j); imagesc(this_mouse{1}.theta(tt(ct),t_range)); hold all;
        title(['Ch:',num2str(j)])
        ylabel(['TT:', num2str(i)])
        figure(2)
        subplot(3,3,i*3 - 3 + j); imagesc(this_mouse{1}.kappa(tt(ct),t_range)); hold all;
        title(['Ch:',num2str(j)])
        ylabel(['TT:', num2str(i)])
        figure(3);
        subplot(3,3,i*3 - 3 + j); myeb(this_mouse{1}.theta(tt(ct),t_range)); hold all;
        title(['Ch:',num2str(j)])
        ylabel(['TT:', num2str(i)])
        figure(4)
        subplot(3,3,i*3 - 3 + j); myeb(this_mouse{1}.kappa(tt(ct),t_range)); hold all;
        title(['Ch:',num2str(j)])
        ylabel(['TT:', num2str(i)])
        
    end
end
figure(1); suptitle('Theta')
% colormap redblue
figure(2); suptitle('Kappa')
% colormap redblue
figure(3); suptitle('Theta')
figure(4); suptitle('Kappa')

%% Theta/Kappa for left/right/no go TOGETHER - correct trials
figure(15); clf;
this_mouse = behav_36;
% colours = [0,1,0,0.1;1,0,0,0.1;0,0,0,0.1];
colours = [1,0,0,0.1;0,1,0,0.1;0,0,0,0.1]; % Mouse 36 has reversed choice order
% Plot approx pole positions as shaded boxes

% 60-70, 80-90, 100-110 degrees
% fill([60,60,70,70],[-6e-3,6e-3,6e-3,-6e-3],[1,0.8,0.8],'edgecolor',[1,0.8,0.8]);
% hold all
% fill([80,80,90,90],[-6e-3,6e-3,6e-3,-6e-3],[0.8,1,0.8],'edgecolor',[0.8,1,0.8]);
% fill([100,100,110,110],[-6e-3,6e-3,6e-3,-6e-3],[0.8,0.8,0.8],'edgecolor',[0.8,0.8,0.8]);
plot(0,0,'g');hold all;
plot(0,0,'r')
plot(0,0,'k')
for s = 1:numel(this_mouse)
%     figure
    for i = 1:3;
        v = 1:this_mouse{s}.sync;
%         tt = find(this_mouse{s}.trialtype(v) == i);
        tt = v;
        
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        %         ax(i*3 - 3 + j) = subplot(3,3,i*3 - 3 + j);
        t = this_mouse{s}.theta(v(tt(ct)),:)';
        k = this_mouse{s}.kappa(v(tt(ct)),:)';
        %         h = plot(conv(t(:),gausswin(10,1),'same')./10,conv(k(:),gausswin(10,1),'same')./10,'.','color',colours(i,:),'markersize',1); hold all;
        h = plot(conv(t(find(t)),gausswin(10,1),'same')./10,conv(k(find(t)),gausswin(10,1),'same')./10,'color',colours(i,:),'markersize',1); hold all;
    end
end
title(['Mouse ',this_mouse{s}.name(end-2:end-1),' coloured by choice'])
set(gca,'XDir','reverse')
legend('Anterior pole','Posterior pole','No Go')

print('-dpng',['~/work/whiskfree/figs/pt_2/',this_mouse{s}.name(end-2:end-1),'_CHOICE_kappa_theta_alpha.png'])

%% Theta/Kappa for left/right/no go SEPARATELY - all trials

for s = 1:numel(this_mouse)
    figure(s+2); clf;
    for i = 1:3;
        v = 1:this_mouse{s}.sync;
        tt = find(this_mouse{s}.trialtype(v) == i);
        for j = 1:3;
            ct = find(this_mouse{s}.choice(v(tt)) == j);
            ax(i*3 - 3 + j) = subplot(3,3,i*3 - 3 + j);
            t = this_mouse{s}.theta(v(tt(ct)),:)';
            k = this_mouse{s}.kappa(v(tt(ct)),:)';
            plot(conv(t(:),gausswin(10,1),'same')./10,conv(k(:),gausswin(10,1),'same')./10,'.','markersize',1); hold all;
            title(['Ch:',num2str(j)])
            ylabel(['TT:', num2str(i)])
            
        end
    end
    perf = numel(find((behav_32{s}.trialtype - behav_32{s}.choice) == 0)) ./ numel(behav_32{s}.trialtype);
    suptitle(['Session ',num2str(s),'(',this_mouse{s}.name,'). Performance ',num2str(perf)])
    linkaxes(ax);
end

%% Kappa for L/R/NG
figure(8);clf
colours = [1,0,0;0,1,0;0,0,0];
for s = 1:numel(this_mouse)
    subplot(4,4,s);
    v = 1:this_mouse{s}.sync;
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype(v) == i);
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        
        %     plot(mean(abs(this_mouse{1}.kappa(tt(ct),:))));
        data = bsxfun(@minus,(conv2(this_mouse{s}.kappa(v(tt(ct)),:)',ones(50,1),'valid')./50)',mean(this_mouse{s}.kappa(v(tt(ct)),1:100),2))';
        m = mean(abs(data'));
        sem = std(data'./sqrt(numel(ct)));
        myeb(1:numel(m),m,sem,[colours(i,:),0]);
        hold all
    end
end
legend('Posterior pole','','Anterior pole','','No Go','','Location','BestOutside')
suptitle('Mean kappa, correct choice');

%% Raw kapp for L/R/NG
figure(9);clf

colours = [0,0,0,0.25;0,0,0,0.25;0,0,0,0.25];
% colours = [0,0,0;0,0,0;0,0,0];
% colours = [0,0,0,0.1;0,0,0,0.1;0,0,0,0.1];
% Plot approx pole positions as shaded boxes
% 60-70, 80-90, 100-110 degrees
titles = {'Posterior pole';'Anterior pole';'No Go'};
for s = 1:numel(this_mouse)
    clf
    v = 1:this_mouse{s}.sync;
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype(v) == i);
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        subplot(1,3,i)
        
        %     plot((conv2(this_mouse{1}.kappa(tt(ct),:)',ones(50,1),'valid'))./50 - mean(this_mouse{1}.kappa(tt(ct),1:100),2),'color',colours(i,:));
        %     plot(this_mouse{1}.kappa(tt(ct),:)','color',colours(i,:));
        plot(bsxfun(@minus,(conv2(this_mouse{s}.kappa(v(tt(ct)),:)',ones(50,1),'valid')./50)',mean(this_mouse{s}.kappa(v(tt(ct)),1:100),2))','color',colours(i,:))
        title(titles{i})
        %     ylim([-6e-3,6e-3])
        ylim([-1e-3,2e-3])
        xlim([0,2500])
    end
    suptitle(['Whisker curvature, correct choice. Mouse ',this_mouse{s}.name,'(Session ',num2str(s),')']);
    
    pause
    
end
% legend('Posterior pole','','Anterior pole','','No Go','')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PT 2 PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Organise data into t and k arrays for plotting

% colours = [0,0,0;0,0,0;0,0,0];
% colours = [0,0,0,0.1;0,0,0,0.1;0,0,0,0.1];

% load ~/Dropbox/Data/3posdata/behav_34b.mat

% this_mouse = behav_36;
this_mouse = behav_36;
colours = [1,0,0;0,1,0;0,0,0]; % 36
m_colours = [1,0.5,0.5;0.5,1,0.5;0.5,0.5,0.5]; % 36
titles = {'Posterior pole';'Anterior pole';'No Go'}; % 36
 
% colours = [0,1,0;1,0,0;0,0,0]; % Others
% m_colours = [0.5,1,0.5;1,0.5,0.5;0.5,0.5,0.5]; % Others
% titles = {'Anterior pole';'Posterior pole';'No Go'}; % Others




k = cell(1,3);
t = cell(1,3);
for s = 1:numel(this_mouse)

    v = 1:this_mouse{s}.sync;
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype(v) == i);
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        
        pu = this_mouse{s}.poleup(v(tt(ct)));
        if ~isempty(pu)
%             this_k = circshift(delta_k,1000-pu);
%             this_t = circshift(this_mouse{s}.theta(v(tt(ct)),:)',1000-pu);
        t{i} = [t{i},circshift(this_mouse{s}.theta(v(tt(ct)),:)',1000-pu)];
        k{i} = [k{i},circshift(this_mouse{s}.kappa(v(tt(ct)),:)',1000-pu)];
        %     plot((conv2(this_mouse{1}.kappa(tt(ct),:)',ones(50,1),'valid'))./50 - mean(this_mouse{1}.kappa(tt(ct),1:100),2),'color',colours(i,:));
        %     plot(this_mouse{1}.kappa(tt(ct),:)','color',colours(i,:));
%         plot(bsxfun(@minus,(conv2(this_mouse{s}.kappa(v(tt(ct)),:)',ones(50,1),'valid')./50)',mean(this_mouse{s}.kappa(v(tt(ct)),1:100),2))','color',colours(i,:))
        end
    end
    
    
end

%% Mean and sem theta/kappa
figure(8); clf;
figure(9); clf;
for i = 1:3
    figure(8)
    myeb(1:5000,nanmean(t{i},2)',nanstd(t{i}')./sqrt(size(t{i},2)),[colours(i,:),0]);
    hold all
    suptitle(['Whisker angle, correct choice. Mouse ',this_mouse{1}.name(end-2:end-1)]);
    xlabel('Time (ms)')
    ylabel('Whisker angle')
    

    figure(9)
    myeb(1:5000,nanmean(k{i},2)',nanstd(k{i}')./sqrt(size(k{i},2)),[colours(i,:),0]);
    hold all
    suptitle(['Whisker curvature, correct choice. Mouse ',this_mouse{1}.name(end-2:end-1)]);
    xlabel('Time (ms)')
    ylabel('Whisker curvature')
end

figure(8);
plot([1000,1000],[85,115],'k--')
legend('Anterior pole','','Posterior pole','','No Go','','Pole up')% 32
% legend('Posterior pole','','Anterior pole','','No Go','','Pole up')% 36
print('-dpng',['~/work/whiskfree/figs/pt_2/Angle_alltrials_mean_Mouse_',this_mouse{s}.name(end-2:end-1),'.png'])
figure(9);
plot([1000,1000],[-2.5e-3,0.5e-3],'k--')
legend('Anterior pole','','Posterior pole','','No Go','','Pole up')% 32
% legend('Posterior pole','','Anterior pole','','No Go','','Pole up')% 36
print('-dpng',['~/work/whiskfree/figs/pt_2/Curvature_alltrials_mean_Mouse_',this_mouse{s}.name(end-2:end-1),'.png'])

figure(8); xlim([500,2500]);
print('-dpng',['~/work/whiskfree/figs/pt_2/Angle_alltrials_mean_Mouse_',this_mouse{s}.name(end-2:end-1),'_ZOOM.png'])
figure(9); xlim([500,2500]);
print('-dpng',['~/work/whiskfree/figs/pt_2/Curvature_alltrials_mean_Mouse_',this_mouse{s}.name(end-2:end-1),'_ZOOM.png'])


%% Mean theta for L/R/NG for 12 sessions
figure(10);clf
% colours = [0,1,0;1,0,0;0,0,0];

for s = 1:12%numel(this_mouse);
    subplot(4,3,s);
    
    % Plot approx pole positions as shaded boxes
    % 60-70, 80-90, 100-110 degrees
    %fill([1,5000,5000,1],[60,60,70,70],[1,0.8,0.8],'edgecolor',[1,0.8,0.8]);
%     hold all
%     fill([1,5000,5000,1],[85,85,95,95],[0.8,1,0.8],'edgecolor',[0.8,1,0.8]);
%     fill([1,5000,5000,1],[105,105,115,115],[1,0.8,0.8],'edgecolor',[1,0.8,0.8]);%[0.8,0.8,0.8]);
%     fill([1,5000,5000,1],[125,125,135,135],[0.8,0.8,0.8],'edgecolor',[0.8,0.8,0.8]); % 36
    
    v = 1:this_mouse{s}.sync;
    
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype(v) == i);
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        pu = this_mouse{s}.poleup(v(tt(ct)));
        if ~isempty(pu)

            this_t = circshift(this_mouse{s}.theta(v(tt(ct)),:)',1000-pu);
            this_k = circshift(this_mouse{s}.kappa(v(tt(ct)),:)',1000-pu);
            %     plot(mean(abs(this_mouse{1}.kappa(tt(ct),:))));
            m = mean((conv2(this_t,ones(50,1),'valid')')./50);
            sem = std((conv2(this_t,ones(50,1),'valid')')./50)./sqrt(numel(ct));
            myeb(1:numel(m),m,sem,[colours(i,:),0]);
            hold all
        end
    end
    
    
    % legend('Posterior pole','','Anterior pole','','No Go','')
    xlim([550,2500])
    title(this_mouse{s}.name)
end

suptitle(['Mean abs theta, correct choice. Mouse',this_mouse{1}.name(end-2:end-1)]);
% xlim([0,2500])

print('-dpng',['~/work/whiskfree/figs/pt_2/Mean_angle_12_sessions_Mouse_',this_mouse{s}.name(end-2:end-1),'.png'])


%% Performance of whole sessions
clear perf
for i = 1:numel(this_mouse)
    perf(i) = numel(find((this_mouse{i}.trialtype - this_mouse{i}.choice) == 0)) ./ numel(this_mouse{i}.trialtype);
    
    
end
figure(11); clf;
plot(perf)
ylim([0,1])
ylabel('Mean performance')
xlabel('Sessions')

title(['Mean performance, all tracked sessions, Mouse ',this_mouse{s}.name(end-2:end-1)])
print('-dpng',['~/work/whiskfree/figs/pt_2/Mouse_',this_mouse{s}.name(end-2:end-1),'_performance_wholesession.png'])


%% 5-trial average performance for individual sessions
clf; hold all;
win = 61;
numsofar = 0;
for i = 1:numel(this_mouse)
    v = 1:this_mouse{i}.sync;
    correct = (this_mouse{i}.trialtype(v) - this_mouse{i}.choice(v)) == 0;
    perf = conv(+correct,ones(win,1),'valid')./win;
    plot(numsofar+1 : numsofar+numel(perf), perf)
    numsofar = numsofar + numel(perf);
end
ylim([0,1])
title(['Mouse ',this_mouse{1}.name(end-2:end-1),' rolling average performance (',num2str(win),' trial rolling average)'])
print('-dpng',['~/work/whiskfree/figs/pt_2/Mouse_',this_mouse{s}.name(end-2:end-1),'_performance_rollingave.png'])

%% Plot rolling change in trial type - is it possible to see 'On' policy at start of some sessions?

clf; hold all;
win = 18;
numsofar = 0;
for i = 1:numel(this_mouse)
    TT = conv(abs(diff(this_mouse{i}.trialtype)),ones(win,1),'valid')./win;
    plot(numsofar+1 : numsofar+numel(TT), TT)
    numsofar = numsofar + numel(TT);
end

plot(1:numsofar,ones(numsofar,1),'--','color',[0.5,0.5,0.5])
title(['Mouse ',this_mouse{1}.name(end-2:end-1),' rolling average change in trial type (random ~ 1)'])
ylim([-1,2])
print('-dpng',['~/work/whiskfree/figs/pt_2/Mouse_',this_mouse{s}.name(end-2:end-1),'_nonrandom_trialtype.png'])


% x = 2*rand(2200,1);
% plot(conv(round(x),ones(30,1),'valid')./30,'color',[.5,.5,.5])

%% Image plot where every column is a histogram (so a 2D histogram of theta by time)
figure(16); clf;
figure(17); clf;
titles = {'Posterior pole';'Anterior pole';'No Go'}; % 36


clf 
clear ax
for i = 1:3;
%     tt = find(this_mouse{1}.trialtype == i);
%     ct = find(this_mouse{1}.choice(tt) == i);
%     t = this_mouse{1}.theta(tt(ct),:)';
%     k = this_mouse{1}.kappa(tt(ct),:)';


    figure(16); hold all
    ax(i) = subplot(3,1,i)
    [hdata,haxes] = hist3([t{i}(find(t{i})),mod(find(t{i}),5000)],'edges',{linspace(41,140,50);linspace(1,5000,100)});
    surf(linspace(1,5000,100),linspace(41,140,50),hdata,'edgecolor','none')
    view([0,90])
    title(titles{i})
    
    figure(17); hold all
    bx(i) = subplot(3,1,i)
    [hdata,haxes] = hist3([k{i}(find(k{i})),mod(find(k{i}),5000)],'edges',{linspace(-3e-3,3e-3,50);linspace(1,5000,100)});
    surf(linspace(1,5000,100),linspace(-3e-3,3e-3,50),hdata,'edgecolor','none')
    view([0,90])
    title(titles{i})
    %     set(gca,'xticklabels',haxes{2})
%     set(gca,'yticklabels',haxes{1})
%     view([-90 90])
end

figure(16);
linkaxes(ax)
ylabel('Whisker angle')
xlabel('Time (ms)')
suptitle(['Whisking 2d histogram, Mouse ',this_mouse{1}.name(end-2:end-1)])
print('-dpng',['~/work/whiskfree/figs/pt_2/Mouse_',this_mouse{s}.name(end-2:end-1),'_whisker_angle_2Dhistogram.png'])

figure(17);
linkaxes(bx)
ylabel('Whisker curvature')
xlabel('Time (ms)')
suptitle(['Curvature 2d histogram, Mouse ',this_mouse{1}.name(end-2:end-1)])
print('-dpng',['~/work/whiskfree/figs/pt_2/Mouse_',this_mouse{s}.name(end-2:end-1),'_curvature_2Dhistogram.png'])



%% Plot kappa/theta over time in chunks
clf;
for s = 2 %:numel(this_mouse)
    v = 1:this_mouse{s}.sync;
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype(v) == i);
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        
        
        t = this_mouse{s}.theta(v(tt(ct)),:)';
        k = this_mouse{s}.kappa(v(tt(ct)),:)';
        
        for i = 1:8;
            subplot(2,4,i)
            title([num2str((i*500)-499),':',num2str(i*500)])
            tt = t((i*500)-499:i*500,:);
            kt = k((i*500)-499:i*500,:);
            plot(tt(:),kt(:),'.','markersize',1); hold all
            ylim([-6e-3,6e-3])
            xlim([40,160])
        end
        
    end
end
suptitle(['Mouse ',this_mouse{s}.name(end-2:end-1),', session ',num2str(s),', 500 ms at a time'])

print('-dpng',['~/work/whiskfree/figs/pt_2/Theta_kappa_timechunks_Mouse_',this_mouse{s}.name(end-2:end-1),'.png'])




% end % For all mice loop


%% Vertical histograms of theta extrema for each trial type
% O'Connor 2010a Fig 11.
figure(12);
clf;
% colours = [0,1,0;1,0,0;0,0,0];
% m_colours = [0.5,1,0.5;1,0.5,0.5;0.5,0.5,0.5];
xvals = linspace(31,160,65);

for s = 1%:11%numel(this_mouse);
%     figure;
    v = 1:this_mouse{s}.sync;
    
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype(v) == i);
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        t = this_mouse{s}.theta(v(tt(ct)),:)';
        k = this_mouse{s}.kappa(v(tt(ct)),:)';
        
        
        
        % Fill dropped frames with mean
        temp = mean(t(:))*ones(size(t));
        
        temp(find(t)) = t(find(t));;
        
        mx = histc(max(temp),xvals);
        
        mn = histc(min(temp),xvals);
        
        subplot(1,3,i);
        
        % Bars of pole location
        fill([0,30,30,0],[95,95,105,105],[0.8,1,0.8],'edgecolor',[0.8,1,0.8]);
        hold all
        fill([0,30,30,0],[70,70,80,80],[1,0.8,0.8],'edgecolor',[1,0.8,0.8]);
        fill([0,30,30,0],[120,120,130,130],[0.8,0.8,0.8],'edgecolor',[0.8,0.8,0.8]);
        
        barh(xvals,mx,'facecolor',m_colours(i,:),'edgecolor',m_colours(i,:));hold all
        barh(xvals,mn,'facecolor','none','edgecolor',colours(i,:))
        title(titles{i})
    end
    
end

suptitle(['Angle extrema per trial Mouse ',this_mouse{s}.name(end-2:end-1)])


print('-dpng',['~/work/whiskfree/figs/pt_2/Mouse_',this_mouse{s}.name(end-2:end-1),'_angle_extrema.png'])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end of pt_2 figs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Real pole angle stuff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Compute + plot angle to the pole from the whisker 'base'
animal = {'behav_32';'behav_33';'behav_34';'behav_36'};

clf;
clear ax
for a = 1:4;
    this_mouse = eval(animal{a});
    for s = 1:numel(this_mouse)
        delta_w1 = bsxfun(@minus,this_mouse{s}.fp_1,this_mouse{s}.barPos(:,1));
        delta_w2 = bsxfun(@minus,this_mouse{s}.fp_2,this_mouse{s}.barPos(:,2));
        
        % angle of contact point wrt fp
        this_mouse{s}.theta_0 = atan2(delta_w1,delta_w2)*180./pi +90;
    end
    s = 2
    % Dummy point to display whisker angle from fp
    dummy_x = this_mouse{s}.fp_1 + (100.*cos(this_mouse{s}.theta./180.*pi));
    dummy_y = this_mouse{s}.fp_2 - (100.*sin(this_mouse{s}.theta./180.*pi)); % minus to account for flipped y axis in image
    
    %% For all trials in a session of a given type, plot angle to the pole
    v = 1:this_mouse{s}.sync;
    ax(a) = subplot(2,2,a);
    hold all
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype(v) == i);
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        
        
        t = this_mouse{s}.theta(v(tt(ct)),:)';
        k = this_mouse{s}.kappa(v(tt(ct)),:)';
        
        f1 = this_mouse{s}.fp_1(v(tt(ct)),:)';
        f2 = this_mouse{s}.fp_2(v(tt(ct)),:)';
        
        t0 = this_mouse{s}.theta_0(v(tt(ct)),:)';
        
        plot(t0,'color',m_colours(i,:))
        
    end
    title(['Mouse ',this_mouse{s}.name(end-2:end-1)])
end
suptitle('Angle to the pole')
linkaxes(ax)
% print('-dpng',['~/work/whiskfree/figs/pt_2/All_mice_angle_to_pole.png'])

%% Plot fp, pole position, whisker angle and angle to pole on top of example frame
s = 1;
trial = 53;

t = this_mouse{s}.theta(trial,:)';
k = this_mouse{s}.kappa(trial,:)';

f1 = this_mouse{s}.fp_1(trial,:)';
f2 = this_mouse{s}.fp_2(trial,:)';

d1 = dummy_x(trial,:)';
d2 = dummy_y(trial,:)';

t0 = theta_0(trial,:)';
bp = this_mouse{s}.barPos(trial,:);


clf;
imagesc(frame)
hold all
plot(bp(1),bp(2),'c.','markersize',15)
plot(bp(1),bp(2),'wo','markersize',5)
i = 499;
fp_plot = plot([f1(i),bp(1)],[f2(i),bp(2)],'c');
dp_plot = plot([f1(i),d1(1)],[f2(i),d2(1)],'r');

for i = 500:2500;

    set(fp_plot,'XData',[f1(i),bp(1)]);
    set(fp_plot,'YData',[f2(i),bp(2)]);
    set(dp_plot,'XData',[f1(i),d1(i)]);
    set(dp_plot,'YData',[f2(i),d2(i)]);
    
    title(['Angle_W: ',num2str(round(t(i))),', Angle_P: ',num2str(round(t0(i))),'. Frame:',num2str(i)])
    drawnow
end

%% Plot kappa given angle to the pole





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots using pole angle info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot theta/kappa on each trial with transparent-ish lines - NEW MATLAB ONLY
figure(10);clf
clear ax bx
% colours = [0,0,0,0.1;0,0,0,0.1;0,0,0,0.1]; % 36
% colours = [0,0,0;0,0,0;0,0,0]
for i = 1:3
    ax(i) = subplot(2,3,i);
    plot(t{i},'color',[colours(i,:),0.1]);
    hold all
    title(titles{i})
    bx(i) = subplot(2,3,i+3);
    plot(k{i},'color',[colours(i,:),0.1]);
    hold all
    %     ylim([-6e-3,6e-3])
%     ylim([-1e-3,2e-3])
%     xlim([0,2500])
end

subplot(2,3,1);
ylabel('Angle')
subplot(2,3,4);
ylabel('Curvature')


suptitle(['Whisker curvature, correct choice. Mouse ',this_mouse{s}.name(end-2:end-1)]);
linkaxes(ax)
linkaxes(bx)
% legend('Posterior pole','','Anterior pole','','No Go','')
% print('-dpng',['~/work/whiskfree/figs/pt_2/Curvature_angle_alltrial_Mouse_',this_mouse{s}.name(end-2:end-1),'.png'])
%%
set(ax(1),'xlim',[500,1500])
set(bx(1),'xlim',[500,1500])
print('-dpng',['~/work/whiskfree/figs/pt_2/Curvature_angle_alltrial_ZOOM_Mouse_',this_mouse{s}.name(end-2:end-1),'.png'])

%% Raw theta for L/R/NG separate coloured plots w/ lines for a given session.
% figure(9);clf
% colours = [1,0,0,0.25;0,1,0,0.25;0,0,0,0.25];
colours = [0,0,0,0.25;0,0,0,0.25;0,0,0,0.25];

% colours = [0,0,0;0,0,0;0,0,0];
% Plot approx pole positions as shaded boxes
% 60-70, 80-90, 100-110 degrees
titles = {'Posterior pole';'Anterior pole';'No Go'};

for s = 1:numel(this_mouse)
    v = 1:this_mouse{s}.sync;
    figure;
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype(v) == i);
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        subplot(1,3,i)
        fill([1,5000,5000,1],[70,70,80,80],[1,0.8,0.8],'edgecolor',[1,0.8,0.8]);
        hold all
        fill([1,5000,5000,1],[95,95,105,105],[0.8,1,0.8],'edgecolor',[0.8,1,0.8]);
        fill([1,5000,5000,1],[120,120,130,130],[0.8,0.8,0.8],'edgecolor',[0.8,0.8,0.8]);
        
        plot((conv2(this_mouse{s}.theta(v(tt(ct)),:)',ones(50,1),'valid'))./50,'color',colours(i,:));
        
        %     plot(this_mouse{1}.theta(tt(ct),:)','color',colours(i,:));
        
        title(titles{i})
        ylim([40,140])
        xlim([0,2500])
    end
    
    
    % legend('Posterior pole','','Anterior pole','','No Go','')
    suptitle(['Whisker angle, correct choice. Mouse',this_mouse{s}.name]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots using time (inc movies)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot mean theta and kappa for each trial type in a session together on a single theta/kappa plot, coloured by time

m_t = zeros(5000,3);
m_k = zeros(5000,3);
for s = 1 %:numel(this_mouse)
    v = 1:this_mouse{s}.sync;
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype(v) == i);
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        
        
        t = this_mouse{s}.theta(v(tt(ct)),:)';
        delta_t = bsxfun(@minus,t',mean(t(1:100,:))')' + mean(mean(t(1:100,:)));
        
        k = this_mouse{s}.kappa(v(tt(ct)),:)';
        delta_k = bsxfun(@minus,k',mean(k(1:100,:))')' + mean(mean(k(1:100,:)));
        
        m_t(:,i) = mean(t,2);
        m_k(:,i) = mean(k,2);
        
    end
end

clf;
hold all;
m_plot_1 = plot(m_t(1,1),m_k(1,1),'g.')
m_plot_2 = plot(m_t(1,2),m_k(1,2),'r.')
m_plot_3 = plot(m_t(1,3),m_k(1,3),'k.')
for i = 2:4500
    
    set(m_plot_1,'YData',m_k(1:i,1));
    set(m_plot_1,'XData',m_t(1:i,1));
    set(m_plot_2,'YData',m_k(1:i,2));
    set(m_plot_2,'XData',m_t(1:i,2));
    
    set(m_plot_3,'YData',m_k(1:i,3));
    set(m_plot_3,'XData',m_t(1:i,3));
    
    ylim([-6e-3,6e-3])
    xlim([40,140])
    title(['Time:',num2str(i)])
    drawnow;
end

%% Code to make a movie
data.savefile = '/media/mathew/Bigger Data1/whisker_movies/32_stim_by_time_deltaK';
% New movie setup
data.profile = 'Motion JPEG AVI'; % This is the default. Update mp4.Quality below to ensure best conversion quality possible (note setting quality to 100 increases files size from 37MB to 187MB)
% data.profile = 'MPEG-4'; % This is tiny. Good for talks. Cannot be read by Janelia Whisker Tracker, and doesn't work on Linux
mp4obj = VideoWriter(data.savefile,data.profile);
mp4obj.FrameRate = 50;%video.header.framerate/20;
mp4obj.Quality = 100; % Default is 75

open(mp4obj)

%% All trials simultaneously, over time
this_mouse = behav_36;
clf;
hold all;
t = cell(1,3);
k = cell(1,3);
for s = 1:numel(this_mouse)
    v = 1:this_mouse{s}.sync;
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype(v) == i);
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        
        %         delta_t = this_mouse{s}.theta(v(tt(ct)),:)';
        %         delta_t = bsxfun(@minus,delta_t',mean(delta_t(1:100,:))')' + mean(mean(delta_t(1:100,:)));
        delta_k = this_mouse{s}.kappa(v(tt(ct)),:)';
        if ~isempty(delta_k)
            pu = this_mouse{s}.poleup(v(tt(ct)));
            
            this_k = circshift(delta_k,1000-pu);
            this_t = circshift(this_mouse{s}.theta(v(tt(ct)),:)',1000-pu);
            
            
            this_k = bsxfun(@minus,this_k',nanmean(this_k(990:1000,:))')';
%             this_t = bsxfun(@minus,this_t',nanmean(this_t(990:1000,:))')' + 90;
            
            t{i} = [t{i},conv2(this_t,ones(10,1),'same')./10];
            %                 k{i} = [k{i},conv2(this_mouse{s}.kappa(v(tt(ct)),:)',ones(10,1),'same')./10];
            %         t{i} = [t{i},delta_t];
            k{i} = [k{i},conv2(this_k,ones(10,1),'same')./10];
        end
    end
end

%% Plot

ylims = [-1e-2,1e-2];
fill([95,95,105,105],[ylims,fliplr(ylims)],[0.8,1,0.8],'edgecolor',[0.8,1,0.8]);
hold all
fill([70,70,80,80],[ylims,fliplr(ylims)],[1,0.8,0.8],'edgecolor',[1,0.8,0.8]);
fill([120,120,130,130],[ylims,fliplr(ylims)],[0.8,0.8,0.8],'edgecolor',[0.8,0.8,0.8]);

m_plot_1 = plot(t{1}(1,:),k{1}(1,:),'r.')%,'markersize',1);
m_plot_2 = plot(t{2}(1,:),k{2}(1,:),'g.')%,'markersize',1);
m_plot_3 = plot(t{3}(1,:),k{3}(1,:),'k.')%,'markersize',1);

set(gca,'Xdir','reverse')
for i = 500:4500
    
    set(m_plot_1,'YData',k{1}(i,:));
    set(m_plot_1,'XData',t{1}(i,:));
    set(m_plot_2,'YData',k{2}(i,:));
    set(m_plot_2,'XData',t{2}(i,:));
    
    set(m_plot_3,'YData',k{3}(i,:));
    set(m_plot_3,'XData',t{3}(i,:));
    
    ylim(ylims)
    xlim([40,160])
    title(['Time:',num2str(i),' Mouse ',this_mouse{1}.name(end-2:end-1)])
    drawnow;
    %     Comment/ uncomment to make a video
    %     img = getframe(gcf);
    %     writeVideo(mp4obj,img);
end

% close(mp4obj)

%% Plot average for all trials for a given mouse, using arrays generated above in movie loop
% colours = [1,0,0;0,1,0;0,0,0];
colours = [0,1,0;1,0,0;0,0,0];
clf
for i = [3,1,2];
%     m = mean((conv2(t{i},ones(50,1),'same')')./50);
%     sem = std((conv2(t{i},ones(50,1),'same')')./50) ./sqrt(size(t{i},2));
    m = mean(t{i}');
    sem = std(t{i}') ./sqrt(size(t{i},2));
    myeb(1:numel(m),m,sem,[colours(i,:),0])
    hold all
end
plot([1000,1000],[75,100],'k--')
xlabel('Time from trial start (ms)')
ylabel('Whisker angle')

title(['Mean whisker angle on all correct trials, Mouse ',this_mouse{1}.name(end-2:end-1)])
xlim([500,3500])
% print('-dpng',['~/work/whiskfree/figs/pt_2/',this_mouse{s}.name(end-2:end-1),'_mean_angle.png'])

%% Image of theta/kappa for all trials of a trial type
% titles = {'Posterior pole';'Anterior pole';'No Go'}; % 36
clf

% work out max/min for normalisation
clear mn mx
for i = 1:3;
    mn(i) = min(k{i}(:));
    mx(i) = max(k{i}(:));
end

normy = max(abs([mn,mx]));


for i = 1:3;
    subplot(2,3,i);
    imagesc(t{i}(500:2500,:)')
    title(titles{i})
    
    subplot(2,3,i+3);
    imagesc(k{i}(500:2500,:)')%./normy)
    
end
subplot(2,3,1);
ylabel('Theta')
subplot(2,3,4);
ylabel('Kappa')
xlabel('Time since trial start (ms)')

suptitle(['Mouse ',this_mouse{s}.name(end-2:end-1),' (pole-up at 500ms)'])

print('-dpng',['~/work/whiskfree/figs/pt_2/All_mice_angle_to_pole.png'])

%% Concatenate data to make one image per mouse on same axis
% TO DO add ticks/lines for sessions + trialtypes

%% Image plot of whisker position in the 3 trial types (based on t and k calculated above)
figure(11);
clf;
clear hdata
for i = 1:3;
    ax(i) = subplot_tight(3,1,i)
    [hdata{i},haxes] = hist3([t{i}(find(t{i})),k{i}(find(t{i}))],'edges',{linspace(41,140,100);linspace(-6e-3,6e-3,100)});
    surf(linspace(41,140,100),linspace(-6e-3,6e-3,100),hdata{i}','edgecolor','none')
    %     set(gca,'xticklabels',haxes{2})
    %     set(gca,'yticklabels',haxes{1})
    view([0 90])
    %         axis off
end
linkaxes(ax);

%% Countour plots of whisker position in the 3 trial types
figure(13);
clf;

clear ax

colours = [0,1,0;1,0,0;0,0,0];

fill([95,95,105,105],[-6e-3,6e-3,6e-3,-6e-3],[0.8,1,0.8],'edgecolor',[0.8,1,0.8]);
hold all
fill([70,70,80,80],[-6e-3,6e-3,6e-3,-6e-3],[1,0.8,0.8],'edgecolor',[1,0.8,0.8]);
fill([120,120,130,130],[-6e-3,6e-3,6e-3,-6e-3],[0.8,0.8,0.8],'edgecolor',[0.8,0.8,0.8]);
for i = 1:3;
    
    [hdata,haxes] = hist3([t{i}(find(t{i})),k{i}(find(t{i}))],'edges',{linspace(41,140,100);linspace(-6e-3,6e-3,100)});
    contour(linspace(41,140,100),linspace(-6e-3,6e-3,100),hdata',10,'color',colours(i,:)); hold all;drawnow;
    
    %     set(gca,'xticklabels',haxes{2})
    %     set(gca,'yticklabels',haxes{1})
    view([0 90])
    %     pause;
    
end
title(this_mouse{s}.name)


%% Try subtracting torsion as mean kappa per theta outside contact.
title(['Mouse ',this_mouse{1}.name(end-2:end),' rolling average trialtype difference (',num2str(win),' trials)'])

%% Find reaction times/licking to limit relevant sensory information to that time.

%% Choice|Stimulus probability from theta/kappa over time.

%% Is contact detection necessary? - Yes


