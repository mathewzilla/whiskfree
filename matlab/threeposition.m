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
    
    for j = 1: numel(var_files)
        trials(j) = str2double(var_files(j).name(end-15:end-10));
        trial_num = find(xls_info(:,1) == trials(j));
        % IF file isn't in good_trials, don't bother loading it
        if trial_num
        trialtypes(j) = xls_info(trial_num,204);
        choices(j) = xls_info(trial_num,205);
        startframes(j) = xls_info(trial_num,3);
        
        load(var_files(j).name,'kappa_w','theta_w');
        kappa_w = [circshift(kappa_w,[0,-startframes(j)]),zeros(1,5000-numel(kappa_w))];
        theta_w = [circshift(theta_w,[0,-startframes(j)]),zeros(1,5000-numel(theta_w))];
        kappa(j,:) = kappa_w;
        theta(j,:) = theta_w;
        else
            kappa(j,:) = zeros(1,5000);
            theta(j,:) = zeros(1,5000);
            trialtypes(j) = 0;
            choices(j) = 0;
            startframes(j) = 0;
            dropped(j) = 1;
        end
    end
    
    behav_32{i}.kappa = kappa;
    behav_32{i}.theta = theta;
    
    behav_32{i}.startframe = startframes;
    behav_32{i}.trial = trials;
    behav_32{i}.choice = choices;
    behav_32{i}.trialtype = trialtypes;
    behav_32{i}.dropped = dropped;
    
    behav_32{i}.name = files(dates(i)).name;
end

save ~/work/whiskfree/data/behav_32.mat behav_32

%% 33: 
clear behav_33

dates = [4,5,6,8,11,19,23,26,30,33,17,20,21,24,34,55,]; %{'110315_33a','120315_33a'}; % '120315_33b'/'130315_33a'/'160315_33a'/'160315_33b'/ 3 trials of '160315_33a' need tracking
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
    
    for j = 1: numel(var_files)
        trials(j) = str2double(var_files(j).name(end-15:end-10));
        trial_num = find(xls_info(:,1) == trials(j));
        
        % IF file isn't in good_trials, don't bother loading it
        if trial_num
            trialtypes(j) = xls_info(trial_num,204);
            choices(j) = xls_info(trial_num,205);
            startframes(j) = xls_info(trial_num,3);
            
            load(var_files(j).name,'kappa_w','theta_w');
            kappa_w = [circshift(kappa_w,[0,-startframes(j)]),zeros(1,5000-numel(kappa_w))];
            theta_w = [circshift(theta_w,[0,-startframes(j)]),zeros(1,5000-numel(theta_w))];
            kappa(j,:) = kappa_w;
            theta(j,:) = theta_w;
        else
            kappa(j,:) = zeros(1,5000);
            theta(j,:) = zeros(1,5000);
            trialtypes(j) = 0;
            choices(j) = 0;
            startframes(j) = 0;
            dropped(j) = 1;
        end
    end
    
    behav_33{i}.kappa = kappa;
    behav_33{i}.theta = theta;
    
    behav_33{i}.startframe = startframes;
    behav_33{i}.trial = trials;
    behav_33{i}.choice = choices;
    behav_33{i}.trialtype = trialtypes;
    behav_33{i}.dropped = dropped;    
    
    behav_33{i}.name = files(dates(i)).name;
end

save ~/work/whiskfree/data/behav_33.mat behav_33

%% 34: 
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
    
    for j = 1: numel(var_files)
        trials(j) = str2double(var_files(j).name(end-15:end-10));
        trial_num = find(xls_info(:,1) == trials(j));
        
        % IF file isn't in good_trials, don't bother loading it
        if trial_num
            trialtypes(j) = xls_info(trial_num,204);
            choices(j) = xls_info(trial_num,205);
            startframes(j) = xls_info(trial_num,3);
             
            load(var_files(j).name,'kappa_w','theta_w');
            kappa_w = [circshift(kappa_w,[0,-startframes(j)]),zeros(1,5000-numel(kappa_w))];
            theta_w = [circshift(theta_w,[0,-startframes(j)]),zeros(1,5000-numel(theta_w))];
            kappa(j,:) = kappa_w;
            theta(j,:) = theta_w;
        else
            kappa(j,:) = zeros(1,5000);
            theta(j,:) = zeros(1,5000);
            trialtypes(j) = 0;
            choices(j) = 0;
            startframes(j) = 0;
            dropped(j) = 1;
        end
    end
    
    behav_34{i}.kappa = kappa;
    behav_34{i}.theta = theta;
    
    behav_34{i}.startframe = startframes;
    behav_34{i}.trial = trials;
    behav_34{i}.choice = choices;
    behav_34{i}.trialtype = trialtypes;
    behav_34{i}.trialtype = trialtypes;
    behav_34{i}.dropped = dropped;
        
    behav_34{i}.name = files(dates(i)).name;
end

save ~/work/whiskfree/data/behav_34.mat behav_34

%% 36: 
clear behav_36

dates = [60,64,67,68,12,14,17,20,21,24,27,63,66,4,6,9,16]; %{'060815_36a','070815_36a','070815_36b','080815_36a','090815_36a'};
% To track:
% On trials:
% Bad sessions: 
% Missing data: i13,j86+101
clear kappa theta kappa_w theta_w
for i = 1:numel(dates);
    i
%     cd /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'/Dario' Campagner'/BEHAVIORAL' MOVIES'/36/
    cd /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'
    cd Dario' Campagner'/BEHAVIORAL' MOVIES'/36/
    
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
    
    for j = 1: numel(var_files)
        trials(j) = str2double(var_files(j).name(end-15:end-10));
        trial_num = find(xls_info(:,1) == trials(j));
        
        % IF file isn't in good_trials, don't bother loading it
        if trial_num
            trialtypes(j) = xls_info(trial_num,204);
            choices(j) = xls_info(trial_num,205);
            startframes(j) = xls_info(trial_num,3);
            try
                load(var_files(j).name,'kappa_w','theta_w');
                kappa_w = [circshift(kappa_w,[0,-startframes(j)]),zeros(1,5000-numel(kappa_w))];
                theta_w = [circshift(theta_w,[0,-startframes(j)]),zeros(1,5000-numel(theta_w))];
                kappa(j,:) = kappa_w;
                theta(j,:) = theta_w;
            catch
                display(['Something was wrong with file',var_files(j).name])
                kappa(j,:) = zeros(1,5000);
                theta(j,:) = zeros(1,5000);
                trialtypes(j) = 0;
                choices(j) = 0;
                startframes(j) = 0;
                dropped(j) = 1;
            end
        else
            kappa(j,:) = zeros(1,5000);
            theta(j,:) = zeros(1,5000);
            trialtypes(j) = 0;
            choices(j) = 0;
            startframes(j) = 0;
            dropped(j) = 1;
        end
    end
    
    behav_36{i}.kappa = kappa;
    behav_36{i}.theta = theta;
    
    behav_36{i}.startframe = startframes;
    behav_36{i}.trial = trials;
    behav_36{i}.choice = choices;
    behav_36{i}.trialtype = trialtypes;
    behav_36{i}.trialtype = trialtypes;
    behav_36{i}.dropped = dropped;
        
    behav_36{i}.name = files(dates(i)).name;
end

save ~/work/whiskfree/data/behav_36.mat behav_36

%% 38
clear behav_38

dates = [];
% To track:
% On trials:
% Bad sessions: 
% Missing data:
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
    
    for j = 1: numel(var_files)
        trials(j) = str2double(var_files(j).name(end-15:end-10));
        trial_num = find(xls_info(:,1) == trials(j));
        
        % IF file isn't in good_trials, don't bother loading it
        if trial_num
            trialtypes(j) = xls_info(trial_num,204);
            choices(j) = xls_info(trial_num,205);
            startframes(j) = xls_info(trial_num,3);
            try
                load(var_files(j).name,'kappa_w','theta_w');
                kappa_w = [circshift(kappa_w,[0,-startframes(j)]),zeros(1,5000-numel(kappa_w))];
                theta_w = [circshift(theta_w,[0,-startframes(j)]),zeros(1,5000-numel(theta_w))];
                kappa(j,:) = kappa_w;
                theta(j,:) = theta_w;
            catch
                display(['Something was wrong with file',var_files(j).name])
                kappa(j,:) = zeros(1,5000);
                theta(j,:) = zeros(1,5000);
                trialtypes(j) = 0;
                choices(j) = 0;
                startframes(j) = 0;
                dropped(j) = 1;
            end
        else
            kappa(j,:) = zeros(1,5000);
            theta(j,:) = zeros(1,5000);
            trialtypes(j) = 0;
            choices(j) = 0;
            startframes(j) = 0;
            dropped(j) = 1;
        end
    end
    
    behav_38{i}.kappa = kappa;
    behav_38{i}.theta = theta;
    
    behav_38{i}.startframe = startframes;
    behav_38{i}.trial = trials;
    behav_38{i}.choice = choices;
    behav_38{i}.trialtype = trialtypes;
    behav_38{i}.trialtype = trialtypes;
    behav_38{i}.dropped = dropped;
        
    behav_38{i}.name = files(dates(i)).name;
end

save ~/work/whiskfree/data/behav_38.mat behav_38

%% NOTE: More data is ready for tracking on Isilon for 32,33 and 34

%% Load data for an example animal/session
load ~/Dropbox/Data/3posdata/behav_36b.mat

%% Image/plot whisker angle/curvature conditioned on trialtype/choice
figure(1); clf;
figure(2); clf; 
figure(3); clf;
figure(4); clf;

t_range =  1:5000;%500:2000;

mx_t = max(behav_32{1}.theta(:));
mx_k = max(behav_32{1}.kappa(:));

for i = 1:3;
    tt = find(behav_32{1}.trialtype == i);
    for j = 1:3;
        ct = find(behav_32{1}.choice(tt) == j);
        figure(1);
        subplot(3,3,i*3 - 3 + j); imagesc(behav_32{1}.theta(tt(ct),t_range)); hold all;
        title(['Ch:',num2str(j)])
        ylabel(['TT:', num2str(i)])
        figure(2)
        subplot(3,3,i*3 - 3 + j); imagesc(behav_32{1}.kappa(tt(ct),t_range)); hold all;
        title(['Ch:',num2str(j)])
        ylabel(['TT:', num2str(i)])
        figure(3);
        subplot(3,3,i*3 - 3 + j); myeb(behav_32{1}.theta(tt(ct),t_range)); hold all;
        title(['Ch:',num2str(j)])
        ylabel(['TT:', num2str(i)])
        figure(4)
        subplot(3,3,i*3 - 3 + j); myeb(behav_32{1}.kappa(tt(ct),t_range)); hold all;
        title(['Ch:',num2str(j)])
        ylabel(['TT:', num2str(i)])
    
    end
end
figure(1); suptitle('Theta') 
colormap redblue
figure(2); suptitle('Kappa') 
colormap redblue
figure(3); suptitle('Theta')
figure(4); suptitle('Kappa')

%% Theta/Kappa for left/right/no go TOGETHER - correct trials
figure(5); clf;
colours = [0,1,0,0.1;1,0,0,0.1;0,0,0,0.1];
% Plot approx pole positions as shaded boxes

% 60-70, 80-90, 100-110 degrees
% fill([60,60,70,70],[-6e-3,6e-3,6e-3,-6e-3],[1,0.8,0.8],'edgecolor',[1,0.8,0.8]);
% hold all
% fill([80,80,90,90],[-6e-3,6e-3,6e-3,-6e-3],[0.8,1,0.8],'edgecolor',[0.8,1,0.8]);
% fill([100,100,110,110],[-6e-3,6e-3,6e-3,-6e-3],[0.8,0.8,0.8],'edgecolor',[0.8,0.8,0.8]);


for i = 1:3;
    tt = find(behav_32{1}.trialtype == i);

        ct = find(behav_32{1}.choice(tt) == i);
%         ax(i*3 - 3 + j) = subplot(3,3,i*3 - 3 + j); 
        t = behav_32{1}.theta(tt(ct),:)';
        k = behav_32{1}.kappa(tt(ct),:)';
%         h = plot(conv(t(:),gausswin(10,1),'same')./10,conv(k(:),gausswin(10,1),'same')./10,'.','color',colours(i,:),'markersize',1); hold all;
          h = plot(conv(t(find(t)),gausswin(10,1),'same')./10,conv(k(find(t)),gausswin(10,1),'same')./10,'color',colours(i,:),'markersize',1); hold all;
end

legend('Posterior pole','Anterior pole','No Go')

%% Theta/Kappa for left/right/no go SEPARATELY - all trials
figure(6); clf;
for i = 1:3;
    tt = find(behav_32{1}.trialtype == i);
    for j = 1:3;
        ct = find(behav_32{1}.choice(tt) == j);
        ax(i*3 - 3 + j) = subplot(3,3,i*3 - 3 + j); 
        t = behav_32{1}.theta(tt(ct),:)';
        k = behav_32{1}.kappa(tt(ct),:)';
        plot(conv(t(:),gausswin(10,1),'same')./10,conv(k(:),gausswin(10,1),'same')./10,'.','markersize',1); hold all;
        title(['Ch:',num2str(j)])
        ylabel(['TT:', num2str(i)])

    end
end

linkaxes(ax);

%% Kappa for L/R/NG
figure(7);clf
colours = [1,0,0;0,1,0;0,0,0];

for i = 1:3;
    tt = find(behav_32{1}.trialtype == i);
    ct = find(behav_32{1}.choice(tt) == i);
    
    %     plot(mean(abs(behav_32{1}.kappa(tt(ct),:))));
    data = bsxfun(@minus,(conv2(behav_32{1}.kappa(tt(ct),:)',ones(50,1),'valid')./50)',mean(behav_32{1}.kappa(tt(ct),1:100),2))';
    m = mean(data');
    sem = std(data'./sqrt(numel(ct)));
    myeb(1:numel(m),m,sem,[colours(i,:),0]);
    hold all
end

legend('Posterior pole','','Anterior pole','','No Go','')
title('Mean kappa, correct choice');

%% Raw kapp for L/R/NG
figure(7);clf

% colours = [0,0,0,0.25;0,0,0,0.25;0,0,0,0.25];
colours = [0,0,0;0,0,0;0,0,0];
% colours = [0,0,0,0.1;0,0,0,0.1;0,0,0,0.1];
% Plot approx pole positions as shaded boxes
% 60-70, 80-90, 100-110 degrees
titles = {'Posterior pole';'Anterior pole';'No Go'};
for i = 1:3;
    tt = find(behav_32{1}.trialtype == i);
    ct = find(behav_32{1}.choice(tt) == i);
    subplot(1,3,i)
    
    %     plot((conv2(behav_32{1}.kappa(tt(ct),:)',ones(50,1),'valid'))./50 - mean(behav_32{1}.kappa(tt(ct),1:100),2),'color',colours(i,:));
    %     plot(behav_32{1}.kappa(tt(ct),:)','color',colours(i,:));
    plot(bsxfun(@minus,(conv2(behav_32{1}.kappa(tt(ct),:)',ones(50,1),'valid')./50)',mean(behav_32{1}.kappa(tt(ct),1:100),2))','color',colours(i,:))
    title(titles{i})
%     ylim([-6e-3,6e-3])
    ylim([-1e-3,2e-3])
    xlim([0,2500])
end


% legend('Posterior pole','','Anterior pole','','No Go','')
suptitle('Whisker curvature, correct choice');
%% Mean theta for L/R/NG
figure(8);clf
colours = [1,0,0;0,1,0;0,0,0];

% Plot approx pole positions as shaded boxes
% 60-70, 80-90, 100-110 degrees
fill([1,5000,5000,1],[60,60,70,70],[1,0.8,0.8],'edgecolor',[1,0.8,0.8]);
hold all
fill([1,5000,5000,1],[80,80,90,90],[0.8,1,0.8],'edgecolor',[0.8,1,0.8]);
fill([1,5000,5000,1],[100,100,110,110],[0.8,0.8,0.8],'edgecolor',[0.8,0.8,0.8]);


for i = 1:3;
    tt = find(behav_32{1}.trialtype == i);
    ct = find(behav_32{1}.choice(tt) == i);
    
    %     plot(mean(abs(behav_32{1}.kappa(tt(ct),:))));
    m = mean((conv2(behav_32{1}.theta(tt(ct),:)',ones(50,1),'valid')')./50);
    sem = std((conv2(behav_32{1}.theta(tt(ct),:)',ones(50,1),'valid')')./50)./sqrt(numel(ct));
    myeb(1:numel(m),m,sem,[colours(i,:),0]);
    hold all
end


% legend('Posterior pole','','Anterior pole','','No Go','')
title('Mean abs theta, correct choice');
xlim([0,2500])


%% Raw theta for L/R/NG
figure(9);clf
% colours = [1,0,0,0.25;0,1,0,0.25;0,0,0,0.25];
% colours = [0,0,0,0.25;0,0,0,0.25;0,0,0,0.25];

colours = [0,0,0;0,0,0;0,0,0];
% Plot approx pole positions as shaded boxes
% 60-70, 80-90, 100-110 degrees
titles = {'Posterior pole';'Anterior pole';'No Go'};


for i = 1:3;
    tt = find(behav_32{1}.trialtype == i);
    ct = find(behav_32{1}.choice(tt) == i);
    subplot(1,3,i)
    fill([1,5000,5000,1],[60,60,70,70],[1,0.8,0.8],'edgecolor',[1,0.8,0.8]);
    hold all
    fill([1,5000,5000,1],[80,80,90,90],[0.8,1,0.8],'edgecolor',[0.8,1,0.8]);
    fill([1,5000,5000,1],[100,100,110,110],[0.8,0.8,0.8],'edgecolor',[0.8,0.8,0.8]);
    
    plot((conv2(behav_32{1}.theta(tt(ct),:)',ones(50,1),'valid'))./50,'color',colours(i,:));

%     plot(behav_32{1}.theta(tt(ct),:)','color',colours(i,:));
    
    title(titles{i})
    ylim([40,140])
    xlim([0,2500])
end


% legend('Posterior pole','','Anterior pole','','No Go','')
suptitle('Whisker angle, correct choice');

%% Image plot of whisker position in the 3 trial types
figure(11);
for i = 1:3;
    tt = find(behav_32{1}.trialtype == i);
    ct = find(behav_32{1}.choice(tt) == i);
    t = behav_32{1}.theta(tt(ct),:)';
    k = behav_32{1}.kappa(tt(ct),:)';
    
    subplot(1,3,i)
    [hdata,haxes] = hist3([t(find(t)),k(find(t))],'edges',{linspace(41,140,100);linspace(-6e-3,6e-3,100)});
    surf(linspace(-6e-3,6e-3,100),linspace(41,140,100),hdata,'edgecolor','none')
%     set(gca,'xticklabels',haxes{2})
%     set(gca,'yticklabels',haxes{1})
    view([-90 90])
end

%% Countour plots of whisker position in the 3 trial types
figure(11);
clf;
fill([95,95,105,105],[-6e-3,6e-3,6e-3,-6e-3],[0.8,1,0.8],'edgecolor',[0.8,1,0.8]);
hold all
fill([70,70,80,80],[-6e-3,6e-3,6e-3,-6e-3],[1,0.8,0.8],'edgecolor',[1,0.8,0.8]);
fill([120,120,130,130],[-6e-3,6e-3,6e-3,-6e-3],[0.8,0.8,0.8],'edgecolor',[0.8,0.8,0.8]);
   
colours = [0,1,0;1,0,0;0,0,0];
for i = 1:3;
    tt = find(behav_32{1}.trialtype == i);
    ct = find(behav_32{1}.choice(tt) == i);
    t = behav_32{1}.theta(tt(ct),:)';
    k = behav_32{1}.kappa(tt(ct),:)';
    
    [hdata,haxes] = hist3([t(find(t)),k(find(t))],'edges',{linspace(41,140,100);linspace(-6e-3,6e-3,100)});
    contour(linspace(41,140,100),linspace(-6e-3,6e-3,100),hdata',10,'color',colours(i,:)); hold all;drawnow;
    
%     set(gca,'xticklabels',haxes{2})
%     set(gca,'yticklabels',haxes{1})
    view([0 90])
%     pause;
end


%% Vertical histograms of theta extrema for each trial type
% O'Connor 2010a Fig 11.
figure(12);
clf;
colours = [0,1,0;1,0,0;0,0,0];
m_colours = [0.5,1,0.5;1,0.5,0.5;0.5,0.5,0.5];
xvals = linspace(61,160,50);
for i = 1:3;
    tt = find(behav_32{1}.trialtype == i);
    ct = find(behav_32{1}.choice(tt) == i);
    t = behav_32{1}.theta(tt(ct),:)';
    k = behav_32{1}.kappa(tt(ct),:)';
    
     
    
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
    
end


%% Image plot where every column is a histogram (so a 2D histogram of theta by time)
figure(16);
clf 
clear ax
for i = 1:3;
    tt = find(this_mouse{1}.trialtype == i);
    ct = find(this_mouse{1}.choice(tt) == i);
    t = this_mouse{1}.theta(tt(ct),:)';
    k = this_mouse{1}.kappa(tt(ct),:)';
    
    ax(i) = subplot(3,1,i)
    [hdata,haxes] = hist3([t(find(t)),mod(find(t),5000)],'edges',{linspace(41,140,50);linspace(1,5000,100)});
    surf(linspace(1,5000,100),linspace(41,140,50),hdata,'edgecolor','none')
    view([0,90])
    %     set(gca,'xticklabels',haxes{2})
%     set(gca,'yticklabels',haxes{1})
%     view([-90 90])
end
linkaxes(ax)

%% Try subtracting torsion as mean kappa per theta outside contact.





%% Find reaction times/licking to limit relevant sensory information to that time.

%% Choice|Stimulus probability from theta/kappa over time.

%% Is contact detection necessary? - Yes


