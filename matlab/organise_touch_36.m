function [pro_ret,tt,ch,track_id] = organise_touch_36

%% Load and organise curated touch data for mouse 36
%
% Input: Takes no inputs
%
% Output: protraction/retraction status, trial type and choice for a number
% of trials. Also returns track_id, the index of original session/AB arrays 
% that were touch detected



% Load session/ AB data to determine AB trials
session_data = csvread('~/work/whiskfree/data/session_36_r.csv');
AB_data = csvread('~/work/whiskfree/data/AB_36_r.csv');

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

track_id = [track_id; ab(tracked)+tracked_so_far];
tracked_so_far = tracked_so_far + numel(s);

%% Session 2
touch_data = csvread('~/Dropbox/Data/3posdata/touch_params/36/touch_params_290715_36a.csv');
s = find(session_data == 2);
ab = find(AB_data(s));

tracked = find(touch_data(ab,4));
pro_ret = [pro_ret; touch_data(ab(tracked),15)];
tt = [tt; touch_data(ab(tracked),3)];
ch = [ch; touch_data(ab(tracked),14)];

track_id = [track_id; ab(tracked)+tracked_so_far];
tracked_so_far = tracked_so_far + numel(s);

%% Session 3
touch_data = csvread('~/Dropbox/Data/3posdata/touch_params/36/touch_params_300715_36a.csv');
s = find(session_data == 3);
ab = find(AB_data(s));

tracked = find(touch_data(ab,4));
pro_ret = [pro_ret; touch_data(ab(tracked),15)];
tt = [tt; touch_data(ab(tracked),3)];
ch = [ch; touch_data(ab(tracked),14)];

track_id = [track_id; ab(tracked)+tracked_so_far];
tracked_so_far = tracked_so_far + numel(s);

%% Session 4
touch_data = csvread('~/Dropbox/Data/3posdata/touch_params/36/touch_params_310715_36a.csv');
s = find(session_data == 4);
ab = find(AB_data(s));

tracked = find(touch_data(ab,4));
pro_ret = [pro_ret; touch_data(tracked,15)];
tt = [tt; touch_data(tracked,3)];
ch = [ch; touch_data(tracked,14)];

track_id = [track_id; ab(tracked)+tracked_so_far];
tracked_so_far = tracked_so_far + numel(s);

%% Session 5
touch_data = csvread('~/Dropbox/Data/3posdata/touch_params/36/touch_params_040815_36a.csv');
s = find(session_data == 5);
ab = find(AB_data(s));

tracked = find(touch_data(ab,4));
pro_ret = [pro_ret; touch_data(ab(tracked),15)];
tt = [tt; touch_data(ab(tracked),3)];
ch = [ch; touch_data(ab(tracked),14)];

track_id = [track_id; ab(tracked)+tracked_so_far];
tracked_so_far = tracked_so_far + numel(s);

%% Session 6
touch_data = csvread('~/Dropbox/Data/3posdata/touch_params/36/touch_params_050815_36a.csv');
s = find(session_data == 6);
ab = find(AB_data(s));

tracked = find(touch_data(ab,4));
pro_ret = [pro_ret; touch_data(ab(tracked),15)];
tt = [tt; touch_data(ab(tracked),3)];
ch = [ch; touch_data(ab(tracked),14)];

track_id = [track_id; ab(tracked)+tracked_so_far];
tracked_so_far = tracked_so_far + numel(s);

%% Session 7
touch_data = csvread('~/Dropbox/Data/3posdata/touch_params/36/touch_params_060815_36a.csv');
s = find(session_data == 7);
ab = find(AB_data(s));

tracked = find(touch_data(ab,4));
pro_ret = [pro_ret; touch_data(ab(tracked),15)];
tt = [tt; touch_data(ab(tracked),3)];
ch = [ch; touch_data(ab(tracked),14)];

track_id = [track_id; ab(tracked)+tracked_so_far];
tracked_so_far = tracked_so_far + numel(s);


%% Skipping 8
s = find(session_data == 8);
tracked_so_far = tracked_so_far + numel(s);


%% Session 9
touch_data = csvread('~/Dropbox/Data/3posdata/touch_params/36/touch_params_070815_36b.csv');
s = find(session_data == 9);
ab = find(AB_data(s));

tracked = find(touch_data(ab,4));
pro_ret = [pro_ret; touch_data(ab(tracked),15)];
tt = [tt; touch_data(ab(tracked),3)];
ch = [ch; touch_data(ab(tracked),14)];

track_id = [track_id; ab(tracked)+tracked_so_far];
tracked_so_far = tracked_so_far + numel(s);

%% Session 10
touch_data = csvread('~/Dropbox/Data/3posdata/touch_params/36/touch_params_080815_36a.csv');
s = find(session_data == 10);
ab = find(AB_data(s));

tracked = find(touch_data(ab,4));
pro_ret = [pro_ret; touch_data(tracked,15)];
tt = [tt; touch_data(tracked,3)];
ch = [ch; touch_data(tracked,14)];

track_id = [track_id; ab(tracked)+tracked_so_far];
tracked_so_far = tracked_so_far + numel(s);

%% Sessions 11 + 12 TO DO
s = find(session_data == 11);
tracked_so_far = tracked_so_far + numel(s);

s = find(session_data == 12);
tracked_so_far = tracked_so_far + numel(s);

%% Session 13
touch_data = csvread('~/Dropbox/Data/3posdata/touch_params/36/touch_params_300615_36a.csv');
s = find(session_data == 13);
ab = find(AB_data(s));

tracked = find(touch_data(ab,4));
pro_ret = [pro_ret; touch_data(ab(tracked),15)];
tt = [tt; touch_data(ab(tracked),3)];
ch = [ch; touch_data(ab(tracked),14)];

track_id = [track_id; ab(tracked)+tracked_so_far];
tracked_so_far = tracked_so_far + numel(s);