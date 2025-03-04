%PIPELINE
%copiare il goodtrial file dal default one
%generare il goodtrial file con il numero di trial corretto
%aggiungere trial a prima colonna
%sistemare good trial file con il codice di Z8002
%aggiungere delle colonne in cui ti dice se e` goL,goR,nogo e la risposta.
close all
clear all
clear
clear mex
mese={'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'} 

mouse_name='TH14a';
% session = ['240415_',mouse_name];
session = ['02_09_15_',mouse_name];
ret=0;
% vid = ['20',session(5:6),session(3:4),session(1:2)];
vid =['20',session(7:8),session(4:5),session(1:2)];

%CHANGE
% cd (['Z:\Dario\Behavioral_movies\', mouse_name(1:2) ,'\',session,'\20',session(5:6),'_',vid(5:6),'_',vid(7:8)])
 cd (['I:\Sarah Fox\Thalamic mice\Behaviour\TH14\Video Data\',session(1:end-1),'\20',session(7:8),'_',vid(5:6),'_',vid(7:8)])

%CHANGE
% copyfile('C:\dario\BEHAVIORAL_CODE\good_trials_default.xlsx',['Z:\Dario\Behavioral_movies\', mouse_name(1:2) ,'\',session,'\20',session(5:6),'_',vid(5:6),'_',vid(7:8),'\good_trials.xlsx'])
copyfile('X:\Dario\Behavioral_movies\codes\good_trials_default.xlsx',['I:\Sarah Fox\Thalamic mice\Behaviour\TH14\Video Data\',session(1:end-1),'\20',session(7:8),'_',vid(5:6),'_',vid(7:8),'\good_trials.xlsx'])

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
% cd 'M:\movie_backup_Dario\good movies not on Z800_2\300914a\2014_09_30'

% Z8002 CODE
% Process mikrotron dat file
% Extract triggerframe and save 'unitdata' text file
% rsp 080713

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialise:

% Specify the dat file sequence of interest:

%vid =['20',session(5:6),session(3:4),session(1:2)];
% cd 'M:\movie_backup_Dario\good movies not on Z800_2\300914a\2014_09_30'

% %CHANGE
% cd (['Z:\Dario\Behavioral_movies\', mouse_name(1:2) ,'\',session,'\20',session(5:6),'_',vid(5:6),'_',vid(7:8)])
 %cd (['I:\Sarah Fox\Thalamic mice\Behaviour\TH14\Video Data\', mouse_name(1:2) ,'\',session,'\20',session(5:6),'_',vid(5:6),'_',vid(7:8)])

% Script will process all dat files in the current directly that match [session '_' vid '*.dat'] 
% load(['Z:\Dario\Behavioral_movies\BehavStat\behaviour_',mouse_name,'_',vid(7:8),'-',mese{str2num(vid(5:6))},'-20',session(5:6),'_session_data']);
 load(['I:\Sarah Fox\Thalamic mice\Behaviour\TH14\Matlab\',vid(7:8),'-',mese{str2num(vid(5:6))},'-20',session(7:8),'\',mouse_name,'\behaviour_',mouse_name,'_',vid(7:8),'-',mese{str2num(vid(5:6))},'-20',session(7:8),'_session_data']);

%load(['X:\Dario\Behavioral_movies\BehavStat\resync_trials_',session]);
if ret,figure, plot(trial_id), return, end
% Specify the ephys block that corresponds to the dat file with earliest
% timestamph matching the above criteria:
blockstart = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process:

unitdatafile = [session '_test.unitdata'];
    
% Process all *.dat files in current directory that match:
files = dir([session(10:14) '_' vid '_*.dat']);
 %files.name = '031213a_20131203_114303.dat';
disp(sprintf('Processing %d files\n',length(files)))
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
    savedata(fidx,2) = str2num(loadfile(end-12:end-7));
    savedata(fidx,1) = blockstart-1 + fidx;
    clear loadfile fid
end
clear fidx
fid = fopen(unitdatafile,'wt');

fprintf(fid,'%d\t%d\t%d\t%d\n',savedata')

fclose(fid)
id_movie=[1:blockend];
% id_movie=xlsread('good_trials.xlsx','Sheet1','B2:B8');
savedata2=savedata(id_movie,:);
xlswrite('good_trials.xlsx',id_movie','Sheet1',['B2:B',num2str(blockend)]);
xlswrite('good_trials.xlsx',savedata2(:,2),'Sheet1',['A2:A',num2str(blockend)]);
xlswrite('good_trials.xlsx',savedata2(:,4),'Sheet1',['C2:C',num2str(blockend)]);
xlswrite('good_trials.xlsx',savedata2(:,3),'Sheet1',['D2:D',num2str(blockend)]);
xlswrite('good_trials.xlsx',savedata2(:,5),'Sheet1',['E2:E',num2str(blockend)]);
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


