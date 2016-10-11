% three_pos_touch.m
% Script to load, plot and save-out touch data


%% Load/save touch_params into a touch_*.mat array
% Loop to go into data folders

% Done: 32,36
load ~/Dropbox/Data/3posdata/behav_34c.mat

for i = [1:2,4:11]
    touch_data = load([behav_34{i}.path,'/touch_params.csv']);
    touch_34{i} = touch_data;
end

save ~/work/whiskfree/data/touch_34.mat touch_34
save ~/Dropbox/Data/3posdata/touch_34.mat touch_34


%% 
load ~/Dropbox/Data/3posdata/behav_34c.mat
load ~/Dropbox/Data/3posdata/touch_34.mat
this_mouse = behav_34;
this_touch = touch_34;

%% Load touches and first_touch variables from remote data folders, and append behav_*.mat
for i = [10:11]; % 32: 1:9. 34: 1:2,4:11. 36: 1:7,9,10,13. 
    touch_params = this_touch{i};
    
    tracked = zeros(size(this_mouse{i}.trial));
    pro_tch = zeros(size(this_mouse{i}.trial));
    first_tch = zeros(size(this_mouse{i}.trial));
    tch = zeros(numel(this_mouse{i}.trial),5000);
    pro_ret_array = zeros(numel(this_mouse{i}.trial),5000);
    
    j = 0;
    %%
    for j = j+1:numel(this_mouse{i}.trial)
        trial = this_mouse{i}.trial(j)
        
        trial_num = find(touch_params(:,2) == trial);
        
        if touch_params(trial_num,4); % if tracked
            
            tracked(j) = 1;
            
            date_str = this_mouse{i}.name; % dir_str(end-20:end-11);
            mouse = date_str(8:10);
            d = date_str(1:2);
            y = date_str(5:6);
            m = date_str(3:4);
            
            filename = [this_mouse{i}.path,'/',this_mouse{i}.name,'_20',y,m,d,'_',num2str(this_mouse{i}.trial(j)),'_touch.mat'];
            load(filename,'touches','protraction_touch','first_touch','pro_ret');
            
            touches = [circshift(touches,[0,-this_mouse{i}.startframe(j)]),zeros(1,5000-numel(touches))];
            pro_ret = [circshift(pro_ret,[0,-this_mouse{i}.startframe(j)]),zeros(1,5000-numel(pro_ret))];
            tch(j,:) = touches;
            pro_ret_array(j,:) = pro_ret;
            
            first_tch(j) = first_touch;
            pro_tch(j) = protraction_touch;
            
            
            
            
        end
    end
    this_mouse{i}.tracked = tracked;
    this_mouse{i}.touches = tch;
    this_mouse{i}.first_touch = first_tch;
    this_mouse{i}.pro_touch = pro_tch;
    this_mouse{i}.pro_ret = pro_ret_array;
end
%%
behav_34 = this_mouse;
save ~/work/whiskfree/data/behav_34t.mat behav_34
save ~/Dropbox/Data/3posdata/behav_34t.mat behav_34

%% Compute first touch time, angle at touch/ kappa during touch (max kappa within 100ms of first touch)
% use touch_*, behav_* and meta_* structures computed in threepos_behavdata.m or

ff = dir('*_touch.mat');

touchcsv = 'touch_params.csv';
touch_params = csvread(touchcsv);


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
    
    
    
    protouch(i) = protraction_touch;
    ttype(i) = trialtype;
    
end

%


%% Pollock plot code from touch_gui
% CD to touch folder: eventually do this in a loop or something
dates =  [3,7,29,32,35,38,41,45,47,49,50,56]; % 32. Done (as of 11/08/16): 1,2,3,4 (chloe),5,6

% for i = [7:numel(dates)]
i = 7
cd /run/user/1000/gvfs/smb-share:server=130.88.94.172',share=test'/Dario/Behavioral_movies/32/
files = dir;
cd(files(dates(i)).name);
files(dates(i)).name
x = cellstr(ls);
cd (x{:})

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




%% Plot mean/median protouch per trial type
for i = 1:3
    valid = find(protouch);
    mean_protouch(i) = mean(protouch(valid(find(ttype(valid)==i))) - 1);
    sem_protouch(i) = std(protouch(valid(find(ttype(valid)==i))) - 1)./sqrt(numel(find(ttype(valid)==i)));
    
end

errorbar(mean_protouch,sem_protouch)
ylim([0,1])

%% Load touch_params (named here, in a loop eventually)

% 32
% Load session/ AB data to determine AB trials
session_data = csvread('~/work/whiskfree/data/session_36_r.csv');
AB_data = csvread('~/work/whiskfree/data/AB_36_r.csv');

[pro_ret,tt,ch,track_id] = organise_touch_36;

%% Swap tt 1 and 2 to make order posterior, anterior, no go. (for 32,33 and 34)
%  Swap pro_ret order to be retraction, protraction, no touch.
tt_temp = tt;
tt_temp(find(tt == 1)) = 2;
tt_temp(find(tt == 2)) = 1;
tt = tt_temp;

ch_temp = ch;
ch_temp(find(ch == 1)) = 2;
ch_temp(find(ch == 2)) = 1;
ch = ch_temp;

pro_ret_temp = pro_ret;
pro_ret_temp(find(pro_ret == 0)) = 3;
pro_ret_temp(find(pro_ret == 1)) = 2;
pro_ret_temp(find(pro_ret == 2)) = 1;

pro_ret = pro_ret_temp;


%% Compute mean/sem touch type|trial type
clf; hold all
c = colormap(lines);
colours = c([3,1,2],:);
colours(3,:) = [0.5,0.5,0.5]; % Grey for no go
for i = 1:3;
    mu = mean(pro_ret(find(tt==i)));
    sigma = std(pro_ret(find(tt==i)))./ sqrt(numel(find(tt==i)));
    numel(find(tt==i));
    
    errorbar(i,mu,sigma,'color',colours(i,:),'Linewidth',2)
end

set(gca,'XTick',[1,2,3],'XTickLabel',{'Posterior','Anterior','No Go'})
set(gca,'YTick',[1,2,3],'YTickLabel',{'Retraction','Protraction','No Touch'})

ylim([1,3])

title('Mean touch type | trial type')

%% histograms w/ jitter
% colour = hsv(3); %varycolor(3);
figure();
clear b x
for i = 1:3;
    [b(i,:),x(i,:)] = hist(pro_ret(find(tt==i))+0.25*randn(numel(find(tt==i)),1),linspace(0,4,40));
    bar(x(i,:),b(i,:),'facecolor',colours(i,:));
    hold all
end
hold off
legend('Posterior','Anterior','No Go')
set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})

title('Touch type histogram (+ jitter) | trial type')
%% Stacked bar graph
figure();
h = bar(x',b','stacked');
for i = 1:3;
    set(h(i),'facecolor',colours(i,:))
end
legend('Posterior','Anterior','No Go')
set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})

title('Touch type stacked histogram (+ jitter) | trial type')

%% Stairs plot
figure();
clear b x
for i = 1:3;
    [b(i,:),x(i,:)] = hist(pro_ret(find(tt==i))+0.25*randn(numel(find(tt==i)),1),linspace(0,4,40));
    stairs(x(i,:),b(i,:),'color',colours(i,:),'linewidth',2);
    hold all
end
hold off
legend('Posterior','Anterior','No Go')
set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})

title('Touch type histogram (+ jitter) | trial type')

%% Stacked bar/stairs with just 3 columns
clf
clear b x
for i = 1:3;
    [b(i,:),x(i,:)] = hist(pro_ret(find(tt==i)),[1,2,3]);
end
h = bar(x',b,'stacked')

for i = 1:3;
    set(h(i),'facecolor',colours(i,:))
end
legend('Retraction','Protraction','No Touch')
set(gca,'XTick',[1,2,3],'XTickLabel',{'Posterior','Anterior','No Go'})

title('Touch type stacked histogram | trial type')

%% Confusion matrix w/touch info - 1: trialtype and choice by touch type

tt_pr = zeros(3,3);
ch_pr = zeros(3,3);
for i = 1:numel(pro_ret)
    
    tt_pr(tt(i),pro_ret(i)) = tt_pr(tt(i),pro_ret(i)) + 1;
    ch_pr(ch(i),pro_ret(i)) = ch_pr(ch(i),pro_ret(i)) + 1;
end

%% Image plots of confusion matrices
figure
subplot(1,2,1);
imagesc(tt_pr)
axis square
set(gca,'YTick',[1,2,3],'YTickLabel',{'Posterior','Anterior','No Go'})
set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})
title('Trail type | touch type')
% set(gca,'Ydir','normal')
for i = 1:3;
    for j = 1:3;
        text(i-0.1,j,num2str(tt_pr(j,i)),'BackgroundColor',[0.5,0.5,0.5]); % ['(',num2str(i),',',num2str(j),')']
    end
end



subplot(1,2,2);
imagesc(ch_pr)
title('Choice | touch type')
axis square
set(gca,'YTick',[1,2,3],'YTickLabel',{'Posterior','Anterior','No Go'})
set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})
% set(gca,'Ydir','normal')
for i = 1:3;
    for j = 1:3;
        text(i-0.1,j,num2str(ch_pr(j,i)),'BackgroundColor',[0.5,0.5,0.5]); % ['(',num2str(i),',',num2str(j),')']
    end
end

%% Look at correct/incorrect trials only
correct = find(ch==tt);
all_trials = 1:numel(ch);
errors = all_trials;
errors(correct) = [];

%% Confusion matrix of choice/touch type for correct/incorrect
pr_c = zeros(3,3);
pr_ic = zeros(3,3);
for i = 1:numel(correct)
    pr_c(ch(correct(i)),pro_ret(correct(i))) = pr_c(ch(correct(i)),pro_ret(correct(i))) + 1;
end

for i = 1:numel(errors)
    pr_ic(ch(errors(i)),pro_ret(errors(i))) = pr_ic(ch(errors(i)),pro_ret(errors(i))) + 1;
end

%% Image plots of confusion matrices
figure
colormap gray
subplot(1,2,1);
imagesc(pr_c)
axis square
set(gca,'YTick',[1,2,3],'YTickLabel',{'Posterior','Anterior','No Go'},'FontSize',14)
set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})
title('Correct choice | touch type')
% set(gca,'Ydir','normal')
for i = 1:3;
    for j = 1:3;
        text(i-0.1,j,num2str(pr_c(j,i)),'BackgroundColor',[0.8,0.8,0.8],'FontSize',18); % ['(',num2str(i),',',num2str(j),')']
    end
end

subplot(1,2,2);
imagesc(pr_ic)
title('Incorrect choice | touch type','FontSize',14)
axis square
set(gca,'YTick',[1,2,3],'YTickLabel',{'Posterior','Anterior','No Go'},'FontSize',14)
set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})
% set(gca,'Ydir','normal')
for i = 1:3;
    for j = 1:3;
        text(i-0.1,j,num2str(pr_ic(j,i)),'BackgroundColor',[0.8,0.8,0.8],'FontSize',18); % ['(',num2str(i),',',num2str(j),')']
    end
end

colormap(flipud(gray))

%% 3 way array of trialtype|choice|touchtype

cm_3 = zeros(3,3,3);
for i = 1:numel(pro_ret)
    
    cm_3(pro_ret(i),tt(i),ch(i)) = cm_3(pro_ret(i),tt(i),ch(i)) + 1;
    
end

tt_ch_pr = {};
for i = 1:3;
    for j = 1:3;
        for k = 1:3;
            tt_ch_pr{i,j,k} = [num2str(i),'-',num2str(j),'-',num2str(k)];
        end
    end
end

tcp = reshape(tt_ch_pr,9,3);


figure;
cm_3r = reshape(cm_3,9,3);
imagesc(cm_3r);
hold all

for i = 1:3;
    for j = 1:9;
        %         text(i,j-0.3,[num2str(i),'-',num2str(j)],'BackgroundColor',[0.5,0.5,0.5]);
        text(i-0.1,j,num2str(cm_3r(j,i)),'BackgroundColor',[0.8,0.8,0.8],'FontSize',18);
        %         text(i,j+0.3,tcp{j,i},'BackgroundColor',[0.5,0.5,0.5]);
        hold all
    end
end

set(gca,'XTick',[1,2,3],'XTickLabel',{'Posterior','Anterior','No Go'},'FontSize',18)
set(gca,'YTick',[2,5,8],'YTickLabel',{'Posterior','Anterior','No Go'})
xlabel('Choice')
ylabel('Trial Type')
axis square

% colormap cubehelix
% Plot lines on top

line([0.5,3.5;0.5,3.5;1.5,1.5;2.5,2.5]',[3.5,3.5;6.5,6.5;0.5,9.5;0.5,9.5]','Color',[0,0,0],'LineWidth',2)
colormap(flipud(gray))
% Use text to make new set of axes for touchtype labels
% text([9.5,9.5,9.5],[1,2,3],{'Retraction','Protraction','No Touch'})
%% Plot example trial type plots
clf;
for i = 1:3
    plot([find(touch_data(:,3) == i),find(touch_data(:,3) == i)]',[zeros(numel(find(touch_data(:,3) == i)),1),2*ones(numel(find(touch_data(:,3) == i)),1)]','color',colours(i,:),'linewidth',2)
    hold all
end
plot(touch_data(:,3)+1,'k','linewidth',2)

axis off

%% Write data out to file for pythonic stuff
csvwrite(['~/work/whiskfree/data/proret_36_subset_sorted.csv'],pro_ret);
csvwrite(['~/work/whiskfree/data/tt_36_subset_sorted.csv'],tt);
csvwrite(['~/work/whiskfree/data/ch_36_subset_sorted.csv'],ch);
