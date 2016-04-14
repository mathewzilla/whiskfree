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
clear behav_32 behav_33 behav_34 behav_36 behav_38
% 32: 20-23.04. 0.83|0.84|0.89|0.84 correct (170,180,144,173 trials)

dates = {'200415_32a','210415_32a','220415_32a','230415_32a'};
clear kappa theta kappa_w theta_w
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
        kappa(j,:) = kappa_w;
        theta(j,:) = theta_w;
    end
    
    behav_32{i}.kappa = kappa;
    behav_32{i}.theta = theta;
end

% 33: 11-13,16.03. 0.91|0.84|0.87|0.86 correct (285,50,283,50 trials)
dates = {'110315_33a','120315_33a'}; % '120315_33b'/'130315_33a'/'160315_33a'/'160315_33b'/ 3 trials of '160315_33a' need tracking
clear kappa theta kappa_w theta_w
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
        kappa(j,:) = kappa_w;
        theta(j,:) = theta_w;
    end
    
    behav_33{i}.kappa = kappa;
    behav_33{i}.theta = theta;
end

% 34: 16,17.12.14. 0.84|0.85 correct (223,241 trials). '161214_34a' one trial missing- ONLY 2 SESSIONS TRACKED
dates = {'161214_34a','171214_34a'};
clear kappa theta kappa_w theta_w
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
        kappa(j,:) = kappa_w;
        theta(j,:) = theta_w;
    end
    
    behav_34{i}.kappa = kappa;
    behav_34{i}.theta = theta;
end
% 36: 06,07.08. 0.75|0.80 correct (424,97 trials) - DATA MISSING FROM TRAINED MICE SPREADSHEET (09.08)
dates = {'060815_36a','070815_36a','070815_36b','080815_36a','090815_36a'};

clear kappa theta kappa_w theta_w
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
        kappa(j,:) = kappa_w;
        theta(j,:) = theta_w;
    end
    
    behav_36{i}.kappa = kappa;
    behav_36{i}.theta = theta;
end
% 38: 16,21,24,30.07. 0.85|0.74|0.83|0.76 (192,168,211,195 trials)
dates = {'160715_38a','210715_38a','240715_38a','240715_38b','300715_38a'};
% NO GOOD TRIALS FILE FOR 38
clear kappa theta kappa_w theta_w
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
        kappa(j,:) = kappa_w;
        theta(j,:) = theta_w;
    end
    
    behav_38{i}.kappa = kappa;
    behav_38{i}.theta = theta;
end

%% Save a local copy
save ('~/work/whiskfree/data/all_mice_example.mat','behav_32','behav_33','behav_34','behav_36','behav_38')

%% Plot the behaviour of each mouse. Or all mice
mouse = [32,33,34,36,38];

for j = 1:5;
    this_mouse = eval(['behav_',num2str(mouse(j))]);
    figure;
    colour = hsv(numel(this_mouse));
    for i = 1:numel(this_mouse)
        theta = this_mouse{i}.theta';
        kappa = this_mouse{i}.kappa';
        % Raw data (dropped frames omitted)
        %         plot(theta(find(theta(:))),kappa(find(kappa(:))),'.','color',colour(i,:),'markersize',1);
        
        % Rather beautiful smoothed version
        plot(conv(theta(find(theta(:))),gausswin(10,1),'same')./10,conv(kappa(find(kappa(:))),gausswin(10,1),'same')./10,'.','color',colour(i,:),'markersize',1);
        
        %         plot(this_mouse{i}.theta(:),this_mouse{i}.kappa(:),'.','color',colour(i,:),'markersize',1);
        hold all
    end
    legend(num2str([1:numel(this_mouse)]'))
    title(['Mouse ',num2str(mouse(j)),', All sessions']);
    xlim([20,140])
    ylim([-6e-3,6e-3])
    set(gca,'xdir','reverse')
    print('-dpng',['~/work/whiskfree/figs/initial/All_trials_Mouse_',num2str(mouse(j)),'.png'])
    
end

%% Colour each trial differently
clf;
for i = 5%:numel(this_mouse)
    theta = this_mouse{i}.theta';
    kappa = this_mouse{i}.kappa';
    % Raw data (dropped frames omitted)
    %         plot(theta(find(theta(:))),kappa(find(kappa(:))),'.','color',colour(i,:),'markersize',1);
    colour = hsv(size(theta,2));
    for j = 1:size(theta,2);
        % Rather beautiful smoothed version
        plot(conv(theta(:,j),gausswin(10,1),'same')./10,conv(kappa(:,j),gausswin(10,1),'same')./10,'.','color',colour(j,:),'markersize',1);
        
        %         plot(this_mouse{i}.theta(:),this_mouse{i}.kappa(:),'.','color',colour(i,:),'markersize',1);
        hold all
    end
end
%     legend(num2str([1:numel(this_mouse)]'))
xlim([20,140])
ylim([-6e-3,6e-3])
set(gca,'xdir','reverse')
title(['Mouse ',num2str(mouse(5))]);

%% Load behaviour summary spreadsheet to work out which trial type is which.
% for each folder, load in the key info (trial type per video, after
% checking which trial is which.
clear beh
all_dates{1} = {'200415_32a','210415_32a','220415_32a','230415_32a'};
all_dates{2} = {'110315_33a','120315_33a'};
all_dates{3} = {'161214_34a','171214_34a'};
all_dates{4} = {'060815_36a','070815_36a','070815_36b','080815_36a','090815_36a'};
for mouse = 1:4;
    for j = 1:numel(all_dates{mouse});
        if mouse == 1;
            cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/32/
        elseif mouse == 2;
            cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/33/
        elseif mouse == 3;
            cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/34/
        elseif mouse == 4;
            cd /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'/Dario' Campagner'/BEHAVIORAL' MOVIES'/36/
        end
        
        cd(all_dates{mouse}{j});
        x = cellstr(ls);
        cd (x{:});
        % list of files
        var_files = dir('*_clean.mat');
        
        nr_files=size(var_files,1);
        string_list=cell(nr_files,1);
        for i=1:nr_files
            string_list{i}=var_files(i).name;
        end
        
        xlsfile = 'good_trials.xlsx';
        xls_info = xlsread(xlsfile); % load in the data
        clear trial_num trialtype response correct_resp
        for i = 1:numel(string_list);
            trial(i) = str2double(string_list{i}(end-15:end-10));
            try
                trial_num(i) = find(xls_info(:,1) == trial(i));
                trialtype(i) = xls_info(trial_num(i),204);
                response(i) = xls_info(trial_num(i),205);
                correct_resp(i) = xls_info(trial_num(i),206);
            catch
                
                
                
                trial_num(i) = 0;
                trialtype(i) = 0;
                response(i) = 0;
                correct_resp(i) = 2;
            end
        end
        
        beh.tt{mouse}{j} = trialtype;
        beh.resp{mouse}{j} = response;
        beh.corr{mouse}{j} = correct_resp;
    end
end

%% Save a local copy
save ('~/work/whiskfree/data/all_mice_trialtype.mat','beh')

%% Colour plot by trial type
% Need a table of sync values
% 32| 135 all all 135
% 33| 
% 34|
% 36|
% 38|
mouse = [32,33,34,36,38];
for j = 1:4
    colour = [1 0 0;0 1 0;0.5 0.5 0.5;];
    this_mouse = eval(['behav_',num2str(mouse(j))]);
    for i = 1:numel(this_mouse)
        theta = this_mouse{i}.theta';
        kappa = this_mouse{i}.kappa';
        
        figure; hold all;
        for k = [1,2,3]
            trialtype = find(beh.tt{j}{i}==k);
            this_theta = theta(:,trialtype);
            this_kappa = kappa(:,trialtype);
            plot(conv(this_theta(find(this_theta(:))),gausswin(10,1),'same')./10,conv(this_kappa(find(this_kappa(:))),gausswin(10,1),'same')./10,'.','color',colour(k,:),'markersize',1);
        end
        legend('Left','Right','No Go')
        title(['Mouse ',num2str(mouse(j)),', Session ',all_dates{j}{i}]);
        xlim([20,140])
        ylim([-6e-3,6e-3])
        set(gca,'xdir','reverse')
        print('-dpng',['~/work/whiskfree/figs/initial/L_R_NG_Mouse_',num2str(mouse(j)),'_Session_',all_dates{j}{i},'.png'])
    
    end
end

%% Repeat but for animal choice
mouse = [32,33,34,36,38];
for j = 1:4
    colour = [1 0 0;0 1 0;0.5 0.5 0.5;];
    this_mouse = eval(['behav_',num2str(mouse(j))]);
    for i = 1:numel(this_mouse)
        theta = this_mouse{i}.theta';
        kappa = this_mouse{i}.kappa';
        
        figure; hold all;
        for k = [1,2,3]
            trialtype = find(beh.resp{j}{i}==k);
            this_theta = theta(:,trialtype);
            this_kappa = kappa(:,trialtype);
            plot(conv(this_theta(find(this_theta(:))),gausswin(10,1),'same')./10,conv(this_kappa(find(this_kappa(:))),gausswin(10,1),'same')./10,'.','color',colour(k,:),'markersize',1);
        end
        legend('Left','Right','No Go')
        title(['Mouse ',num2str(mouse(j)),', Session ',all_dates{j}{i}]);
        xlim([20,140])
        ylim([-6e-3,6e-3])
        set(gca,'xdir','reverse')
        
        print('-dpng',['~/work/whiskfree/figs/initial/Choice_L_R_NG_Mouse_',num2str(mouse(j)),'_Session_',all_dates{j}{i},'.png'])
        
    end
end


%% Light/dark red/green for correct/incorrect L and R (ignore No Go for now).

for j = 1:4
    colour = hsv(6);
%     colour = colour([1,3,5,8:10],:);
    this_mouse = eval(['behav_',num2str(mouse(j))]);
    for i = 1:numel(this_mouse)
        theta = this_mouse{i}.theta';
        kappa = this_mouse{i}.kappa';
        
        figure; hold all;
        for m = 1:6;
            plot(80,0,'.','color',colour(m,:))
        end
%         clf;hold all;
        for k = [1,2]
            trialtype = find(beh.tt{j}{i}==k);
            for l = [1:3]
                response = find(beh.resp{j}{i}==l);
                trial = trialtype(ismember(trialtype,response));
                this_theta = theta(:,trial);
                this_kappa = kappa(:,trial);
                plot(conv(this_theta(find(this_theta(:))),gausswin(10,1),'same')./10,conv(this_kappa(find(this_kappa(:))),gausswin(10,1),'same')./10,'.','color',colour(((k*3)-3) + l,:),'markersize',1);
            end
        
        end
             legend('Left-Left','Left-Right','Left-NoGo','Right-Left','Right-Right','Right-NoGo');
            title(['Mouse ',num2str(mouse(j)),', Session ',all_dates{j}{i}]);
            xlim([20,140])
            ylim([-6e-3,6e-3])
            set(gca,'xdir','reverse')
            print('-dpng',['~/work/whiskfree/figs/initial/Matrix_L_R_NG_Mouse_',num2str(mouse(j)),'_Session_',all_dates{j}{i},'.png'])
           
    end
end

%% Plot kappa/theta for one session, colouring the dots by time - NEED TRIGGER FRAME




%% Colour by phase (pro vs retraction) - Not v. informative
for j = 1:4;
    this_mouse = eval(['behav_',num2str(mouse(j))]);
    for i = 1:numel(this_mouse)
        theta = this_mouse{i}.theta';
        kappa = this_mouse{i}.kappa';
        
        theta = theta(:);
        theta = theta(find(theta));
        kappa = kappa(:);
        kappa = kappa(find(kappa));
        theta = conv(theta,gausswin(10,1),'same')./10;
        kappa = conv(kappa,gausswin(10,1),'same')./10;
        
        theta_ts = timeseries(theta,(1:numel(theta))./1000);
        bandpass = [6,30];
        theta_filt = idealfilter(theta_ts,bandpass,'pass');
        H = hilbert(theta_filt.data);
        
        ret = find(angle(H)>=0);
        pro = find(angle(H)<=0);
        
%         figure;
%         plot(theta)
%         hold all;
%         plot(pro,theta(pro),'m.')
%         plot(ret,theta(ret),'g.')
%         legend('Angle','Protraction','Retraction')
%         print('-dpng',['~/work/whiskfree/figs/initial/Protraction_retraction_plot_',num2str(mouse(j)),'_Session_',all_dates{j}{i},'.png'])


        
        figure
        hold all;
        plot(theta(pro),kappa(pro),'m.','markersize',1)
        plot(theta(ret),kappa(ret),'g.','markersize',1)
        legend('Protraction','Retraction')
        title(['Mouse ',num2str(mouse(j)),', Session ',all_dates{j}{i}]);
        xlim([20,140])
        ylim([-6e-3,6e-3])
        set(gca,'xdir','reverse')
        print('-dpng',['~/work/whiskfree/figs/initial/Protraction_retraction_',num2str(mouse(j)),'_Session_',all_dates{j}{i},'.png'])
          
        
    end
end

%% Theta/kappa distibutions i.e. histograms

mouse = [32,33,34,36,38];
stim = {'Left';'Right';'No Go'};
for j = 1:4
    colour = [1 0 0;0 1 0;0.5 0.5 0.5;];
    this_mouse = eval(['behav_',num2str(mouse(j))]);
    for i = 1:numel(this_mouse)
        theta = this_mouse{i}.theta';
        kappa = this_mouse{i}.kappa';
        
        figure; %clf; 
        hold all; clear ax bx

        for k = [1:3]
            trialtype = find(beh.tt{j}{i}==k);
            this_theta = theta(:,trialtype);
            this_kappa = kappa(:,trialtype);
            [h,xh] = hist(conv(this_theta(find(this_theta(:))),gausswin(10,1),'same')./10,50);
            ax(k) = subplot(3,2,k*2 -1);
            bar(xh,h,'facecolor',colour(k,:));hold all % ,'edgecolor',colour(k,:)
            
            [h,xh] = hist(conv(this_kappa(find(this_kappa(:))),gausswin(10,1),'same')./10,50);
            bx(k) = subplot(3,2,k*2);
            bar(xh,h,'facecolor',colour(k,:));hold all % ,'edgecolor',colour(k,:)
            legend(stim{k})
        end
        linkaxes(ax);
        linkaxes(bx);
        subplot(3,2,2);
        title('Kappa')
        xlim([-6e-3,6e-3])
        subplot(3,2,1);
        title('Angle');
        xlim([20,140])
        
        suptitle(['Mouse ',num2str(mouse(j)),', Session ',all_dates{j}{i}]);
        
       
       print('-dpng',['~/work/whiskfree/figs/initial/Hist_theta_kappa_L_R_NG_Mouse_',num2str(mouse(j)),'_Session_',all_dates{j}{i},'.png'])
    
    end
end

%% For a few trials, show touch on kappa/theta space + histograms 
% cd /run/user/1000/gvfs/smb-share:server=nasr.man.ac.uk',share=flsrss$/snapped/replicated/Petersen'/Dario' Campagner'/BEHAVIORAL MOVIES/36/090815_36a/2015_08_09
touch_files = dir('*_touch.mat');
ng = [1:3];
l = [4,5,6];
r = [11,12,13];
trials = [ng,l,r];
clear touches
for i = 1:numel(trials)
    t = load(touch_files(trials(i)).name,'touches');
    touches(i,:) = [t.touches,zeros(1,5000-numel(t.touches))];;

end

colour = [0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;...
          1 0 0;1 0 0;1 0 0;...
          0 1 0;0 1 0;0 1 0;];
this_mouse = eval(['behav_',num2str(mouse(4))]);

theta = this_mouse{5}.theta';
kappa = this_mouse{5}.kappa';

clf; %clf;
hold all;
for i = 1:numel(trials);
    this_theta = conv(theta(:,trials(i)),gausswin(10,1),'same')./10;
    this_kappa = conv(kappa(:,trials(i)),gausswin(10,1),'same')./10;
    plot(this_theta,this_kappa,'.','color',colour(i,:),'markersize',1)
    plot(this_theta(find(touches(i,:))),this_kappa(find(touches(i,:))),'k.','markersize',1)
    
end

title(['Mouse ',num2str(mouse(j)),', Session ',all_dates{4}{5}]);
xlim([20,140])
ylim([-6e-3,6e-3])
set(gca,'xdir','reverse')
print('-dpng',['~/work/whiskfree/figs/initial/Touch2_L_R_NG_Mouse_',num2str(mouse(4)),'_Session_',all_dates{4}{5},'.png'])

%% Histograms for touch times
this_mouse = eval(['behav_',num2str(mouse(4))]);
theta = this_mouse{5}.theta';
kappa = this_mouse{5}.kappa';
theta_tng = [];
kappa_tng = [];
for i = 1:3;
    theta_ng = conv(theta(:,trials(i)),gausswin(10,1),'same')./10;
    kappa_ng = conv(kappa(:,trials(i)),gausswin(10,1),'same')./10;
    theta_tng = [theta_tng,theta_ng(find(touches(i,:)))'];
    kappa_tng = [kappa_tng,kappa_ng(find(touches(i,:)))'];
end
theta_tl = [];
kappa_tl = [];
for i = 4:6;
    theta_l = conv(theta(:,trials(i)),gausswin(10,1),'same')./10;
    kappa_l = conv(kappa(:,trials(i)),gausswin(10,1),'same')./10;
    theta_tl = [theta_tl,theta_l(find(touches(i,:)))'];
    kappa_tl = [kappa_tl,kappa_l(find(touches(i,:)))'];
end
theta_tr = [];
kappa_tr = [];
for i = 7:9;
    theta_r = conv(theta(:,trials(i)),gausswin(10,1),'same')./10;
    kappa_r = conv(kappa(:,trials(i)),gausswin(10,1),'same')./10;
    theta_tr = [theta_tr,theta_r(find(touches(i,:)))'];
    kappa_tr = [kappa_tr,kappa_r(find(touches(i,:)))'];
end

[h,xh] = hist(theta_tng);
ax(3) = subplot(3,2,5);
bar(xh,h,'facecolor',[0.5,0.5,0.5]);
[h,xh] = hist(kappa_tng);
bx(3) = subplot(3,2,6);
bar(xh,h,'facecolor',[0.5,0.5,0.5]);
legend('No Go')

[h,xh] = hist(theta_tr);
ax(2) = subplot(3,2,3);
bar(xh,h,'facecolor',[0,1,0]);
[h,xh] = hist(kappa_tr);
bx(2) = subplot(3,2,4);
bar(xh,h,'facecolor',[0,1,0]);
legend('Right')

[h,xh] = hist(theta_tl);
ax(1) = subplot(3,2,1);
bar(xh,h,'facecolor',[1,0,0]);
[h,xh] = hist(kappa_tl);
bx(1) = subplot(3,2,2);
bar(xh,h,'facecolor',[1,0,0]);
legend('Left')


% linkaxes(ax,'x');
% linkaxes(bx,'x');
subplot(3,2,2);
title('Kappa')
xlim([-5e-3,2e-3])
subplot(3,2,1);
title('Angle');
xlim([20,140])
suptitle(['Touch only histogram. Mouse ',num2str(mouse(j)),', Session ',all_dates{4}{5}]);
print('-dpng',['~/work/whiskfree/figs/initial/Touch_Hist_L_R_NG_Mouse_',num2str(mouse(4)),'_Session_',all_dates{4}{5},'.png'])


%% Find reaction times/licking to limit relevant sensory information to that time.

%% Choice|Stimulus probability from theta/kappa over time.

%% Is contact detection necessary? - Yes


