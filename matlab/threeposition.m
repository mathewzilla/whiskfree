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

%% For each mouse, load up one session (especially good one) of kappa/theta and see if it's obvious what the strategy is

% 32: 20-23.04. 0.83|0.84|0.89|0.84 correct (170,180,144,173 trials)

dates = {'200415_32a','210415_32a','220415_32a','230415_32a'};
for i = 1:numel(dates);
    cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/32/
    cd(dates{i});
    x = cellstr(ls);
    cd (x{:})
    
    var_files = dir('*_clean.mat');
    kappa = zeros(numel(var_files),5000);
    theta = zeros(numel(var_files),5000);
    for j = 1: numel(var_files)
        load(var_files(j).name,'kappa_w','theta_w');
        kappa_w = [kappa_w,zeros(1,5000-numel(kappa_w))];
        theta_w = [theta_w,zeros(1,5000-numel(theta_w))];
        kappa = [kappa;kappa_w];
        theta = [theta;theta_w];
    end
    
    behav_32{i}.kappa = kappa;
    behav_32{i}.theta = theta;
end

% 33: 11-13,16.03. 0.91|0.84|0.87|0.86 correct (285,50,283,50 trials)
dates = {'110315_33a','120315_33a','130315_33a','160315_33a'}; % '120315_33b'/ 3 trials of '160315_33a' need tracking
for i = 1:numel(dates);
    cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/33/
    cd(dates{i});
    x = cellstr(ls);
    cd (x{:})
    
    var_files = dir('*_clean.mat');
    kappa = zeros(numel(var_files),5000);
    theta = zeros(numel(var_files),5000);
    for j = 1: numel(var_files)
        load(var_files(j).name,'kappa_w','theta_w');
        kappa_w = [kappa_w,zeros(1,5000-numel(kappa_w))];
        theta_w = [theta_w,zeros(1,5000-numel(theta_w))];
        kappa = [kappa;kappa_w];
        theta = [theta;theta_w];
    end
    
    behav_33{i}.kappa = kappa;
    behav_33{i}.theta = theta;
end

% 34: 16,17.12.14. 0.84|0.85 correct (223,241 trials). '161214_34a' one trial missing- ONLY 2 SESSIONS TRACKED
dates = {'161214_34a','171214_34a'};
for i = 1:numel(dates);
    cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/34/
    cd(dates{i});
    x = cellstr(ls);
    cd (x{:})
    
    var_files = dir('*_clean.mat');
    kappa = zeros(numel(var_files),5000);
    theta = zeros(numel(var_files),5000);
    for j = 1: numel(var_files)
        load(var_files(j).name,'kappa_w','theta_w');
        kappa_w = [kappa_w,zeros(1,5000-numel(kappa_w))];
        theta_w = [theta_w,zeros(1,5000-numel(theta_w))];
        kappa = [kappa;kappa_w];
        theta = [theta;theta_w];
    end
    
    behav_34{i}.kappa = kappa;
    behav_34{i}.theta = theta;
end
% 36: 06,07.08. 0.75|0.80 correct (424,97 trials) - DATA MISSING FROM TRAINED MICE (08,09.08)
dates = {'060815_36a','070815_36a'};
for i = 1:numel(dates);
    cd /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'/Dario' Campagner'/BEHAVIORAL' MOVIES'/36/
    cd(dates{i});
    x = cellstr(ls);
    cd (x{:})
    
    var_files = dir('*_clean.mat');
    kappa = zeros(numel(var_files),5000);
    theta = zeros(numel(var_files),5000);
    for j = 1: numel(var_files)
        load(var_files(j).name,'kappa_w','theta_w');
        kappa_w = [kappa_w,zeros(1,5000-numel(kappa_w))];
        theta_w = [theta_w,zeros(1,5000-numel(theta_w))];
        kappa = [kappa;kappa_w];
        theta = [theta;theta_w];
    end
    
    behav_36{i}.kappa = kappa;
    behav_36{i}.theta = theta;
end
% 38: 16,21,24,30.07. 0.85|0.74|0.83|0.76 (192,168,211,195 trials)
dates = {'160715_38a','210715_38a','240715_38a','300715_38a'};
for i = 1:numel(dates);
    cd /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'/Dario' Campagner'/BEHAVIORAL' MOVIES'/38/
    cd(dates{i});
    x = cellstr(ls);
    cd (x{:})
    
    var_files = dir('*_clean.mat');
    kappa = zeros(numel(var_files),5000);
    theta = zeros(numel(var_files),5000);
    for j = 1: numel(var_files)
        load(var_files(j).name,'kappa_w','theta_w');
        kappa_w = [kappa_w,zeros(1,5000-numel(kappa_w))];
        theta_w = [theta_w,zeros(1,5000-numel(theta_w))];
        kappa = [kappa;kappa_w];
        theta = [theta;theta_w];
    end
    
    behav_38{i}.kappa = kappa;
    behav_38{i}.theta = theta;
end

%% Save a local copy



