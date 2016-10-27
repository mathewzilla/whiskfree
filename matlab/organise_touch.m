function [pro_ret,tt,ch,track_id] = organise_touch(mouse)
%% Generic touch organisation code based on behav_, meta_ and touch_ files
%
% Input: Takes mouse name/number as input.
%
% Output: protraction/retraction status, trial type and choice for a number
% of trials. Also returns track_id, the index of original session/AB arrays 
% that were touch detected

load(['~/Dropbox/Data/3posdata/behav_',num2str(mouse),'t.mat']); % Need to change the behav file names to have consistent lettering
load(['~/Dropbox/Data/3posdata/meta_',num2str(mouse),'.mat'])
load(['~/Dropbox/Data/3posdata/touch_',num2str(mouse),'.mat'])


behav = eval(['behav_',num2str(mouse)]);
meta = eval(['meta_',num2str(mouse)]);
touch = eval(['touch_',num2str(mouse)]);

% Load session/ AB data to determine AB trials

% % debugging trialtype
% for i = 1:numel(meta);
%     dur = min([behav{i}.sync,numel(meta{i}.policy)]);
%     ttb = behav{i}.trialtype;
%     ttb(find(ttb==3)) = 0;
%     clf;
%     plot(meta{i}.trialtype(1:dur));
%     hold all;
%     plot(ttb(1:dur));
%     title(i);
%     pause;
% end


% Touch_params. Column 4: touch detection done Y/N. Column 15: touch type (0-none,1-pro,2-ret);

pro_ret = [];
tt = [];
ch =[];
track_id = [];
tracked_so_far = 0;

%% Session 1
touch_data = csvread('~/Dropbox/Data/3posdata/touch_params/36/touch_params_270715_36a.csv');
s = find(session_data == 1);
ab = find(AB_data(s));

tracked = find(touch_data(ab,4));
pro_ret = [pro_ret; touch_data(ab(tracked),15)];
tt = [tt; touch_data(ab(tracked),3)];
ch = [ch; touch_data(ab(tracked),14)];

track_id = [track_id; ab(tracked) + tracked_so_far];
tracked_so_far = tracked_so_far + numel(s);