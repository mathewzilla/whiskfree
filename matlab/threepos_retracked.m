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
   
   
   
