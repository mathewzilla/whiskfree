% Script for counting re-tracked files. Involves reading in a master excel
% spreadsheet, then looking up session level spreadsheets and counting good
% trials



retrack_db = {};


%% 32
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
    tracked_files = find(all_files);
    tracked_file_names = retrack_table(tracked_files,2);
    
    retrack_db{1,i}.session = files(dates(i)).name;
    retrack_db{1,i}.tracked_files = tracked_files;
    retrack_db{1,i}.tracked_file_names = tracked_file_names;
    retrack_db{1,i}.path = pwd;
end
%% 33
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
    tracked_files = find(all_files);
    tracked_file_names = retrack_table(tracked_files,2);
    
    retrack_db{2,i}.session = files(dates(i)).name;
    retrack_db{2,i}.tracked_files = tracked_files;
    retrack_db{2,i}.tracked_file_names = tracked_file_names;
    retrack_db{2,i}.path = pwd;
end

%% 34
dates = [27,30,34,25,31,35,54,56,22,26];
for i = 1:numel (dates)
    cd /mnt/NAS1/Dario/Behavioral_movies/34
    files = dir;
    cd(files(dates(i)).name);
    files(dates(i)).name
    x = cellstr(ls);
    cd (x{:})
    
    retrack_table = csvread('quality_touch_params.csv');
    all_files = retrack_table(:,12);
    tracked_files = find(all_files);
    tracked_file_names = retrack_table(tracked_files,2);
    
    retrack_db{3,i}.session = files(dates(i)).name;
    retrack_db{3,i}.tracked_files = tracked_files;
    retrack_db{3,i}.tracked_file_names = tracked_file_names;
    retrack_db{3,i}.path = pwd;
end
%% 36

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
    tracked_files = find(all_files);
    tracked_file_names = retrack_table(tracked_files,2);
    
    retrack_db{4,i}.session = files(dates(i)).name;
    retrack_db{4,i}.tracked_files = tracked_files;
    retrack_db{4,i}.tracked_file_names = tracked_file_names;
    retrack_db{4,i}.path = pwd;
end
%% 38
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
    tracked_files = find(all_files);
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
% tracked_sess(1,[1:3,5:8]) = 1; 
% tracked_sess(2,[1:3,6]) = 1; 
% tracked_sess(3,[1,2,4:11]) = 1; 
% Dropping bad sessions
tracked_sess(1,[1:3,5:7]) = 1;
tracked_sess(2,[2:3,6]) = 1;
tracked_sess(3,[1,2,5:11]) = 1;
tracked_sess(4,[1:7,9,10]) = 1;
tracked_sess(5,1:10) = 1;

% Strip out bad retrack_db sessions
retrack_db{1,7} = [];
retrack_db{2,1} = retrack_db{2,2};
retrack_db{2,2} = retrack_db{2,3};
retrack_db{2,3} = retrack_db{2,4};
retrack_db{2,4} = [];
for j = 3:9; retrack_db{3,j} = retrack_db{3,j+1}; end
retrack_db{3,10} = [];


a = [32,33,34,36,38];

tracked_all = zeros(5,1);
tracked_AB = zeros(5,1);

for i = 1:5;
load(['~/Dropbox/data/3posdata/meta_',num2str(a(i)),'.mat']);
load(['~/Dropbox/data/3posdata/behav_',num2str(a(i)),'t.mat']);
this_mouse = eval(['behav_',num2str(a(i))]);
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



