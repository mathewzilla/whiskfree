% Mathew H. Evans' version of Dario Campagner's PIPELINE
% Is to be called as a script in the appropriate data directory 
%
% MUST be run on a Windows PC, as it relies on xlswrite
%
% Copy the good_trials.xlsx spreadsheet

copyfile('/run/user/1000/gvfs/smb-share:server=130.88.94.172,share=test/Dario/Behavioral_movies/codes/good_trials_default.xlsx','good_trials.xlsx')
% GOL=117500;%1
% GOR=185000; %2
% NOGO=50000; %3
%34
% GOL=92500;%1
% GOR=160000; %2
% NOGO=50000; %3

% 38
GOL=25;%1
GOR=29; %2
NOGO=18; %3


% Z8002 CODE
% Process mikrotron dat file
% Extract triggerframe and save 'unitdata' text file
% rsp 080713

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialise:

% Specify the dat file sequence of interest:

% Need to load appropriate behaviour data file. 
% First parse the current folder to determine which file to load

dir_str = pwd;
date_str = dir_str(end-20:end-11);
mouse = date_str(8:10);
d = date_str(1:2);
y = date_str(5:6);
m_num = str2num(date_str(3:4));

% Determine month name
month_names = {'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};
m = month_names{m_num};

% Behaviour files are formatted like behaviour_38a_16-Jul-2015_session_data.mat

load(['/run/user/1000/gvfs/smb-share:server=130.88.94.172,share=test/Dario/Behavioral_movies/BehavStat/behaviour_',mouse,'_',d,'-',m,'-20',y,'_session_data.mat'])
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process:
    
% Process all *.dat files in current directory that match:
files = dir('*.dat');
session = files(1).name(1:10);

unitdatafile = [session '_test.unitdata'];


disp(sprintf('Processing %d files\n',length(files)))
blockstart = 1;
blockend=length(files);
savedata = zeros(length(files),3);
for fidx = 1:length(files)
    loadfile = files(fidx).name;
    disp(sprintf('Loading %s...',loadfile))
    fid = fopen(loadfile,'r');    
    % Load in header information
    header = read_mikrotron_datfile_header(fid);
    disp(sprintf('Triggerframe %d', header.triggerframe))
    fclose(fid);
    savedata(fidx,5) = header.nframes;
    savedata(fidx,4) = header.startframe;
    savedata(fidx,3) = header.triggerframe;
    savedata(fidx,2) = str2num(loadfile(end-9:end-4));
    savedata(fidx,1) = blockstart-1 + fidx;
    clear loadfile fid
end
clear fidx
fid = fopen(unitdatafile,'wt');

fprintf(fid,'%d\t%d\t%d\t%d\n',savedata')

fclose(fid)
id_movie=[1:blockend];
savedata2=savedata(id_movie,:);
xlwrite('good_trials.xlsx',id_movie','Sheet1',['B2:B',num2str(blockend)]);
xlwrite('good_trials.xlsx',savedata2(:,2),'Sheet1',['A2:A',num2str(blockend)]);
xlwrite('good_trials.xlsx',savedata2(:,4),'Sheet1',['C2:C',num2str(blockend)]);
xlwrite('good_trials.xlsx',savedata2(:,3),'Sheet1',['D2:D',num2str(blockend)]);
xlwrite('good_trials.xlsx',savedata2(:,5),'Sheet1',['E2:E',num2str(blockend)]);
%%

T_type=zeros(1,numel( session_data.response));
T_type(find(session_data.pole_location==GOL))=1;
T_type(find(session_data.pole_location==GOR))=2;
T_type(find(session_data.pole_location==NOGO))=3;
response=session_data.response;
response_correct=session_data.responsecorrect;
xlswrite('good_trials.xlsx',session_data.pole_location','Sheet1',['I2:I',num2str(blockend)]);
xlswrite('good_trials.xlsx',T_type','Sheet1',['GV2:GV',num2str(blockend)]);
xlswrite('good_trials.xlsx',response','Sheet1',['GW2:GW',num2str(blockend)]);
xlswrite('good_trials.xlsx',response_correct','Sheet1',['GX2:GX',num2str(blockend)]);


