% threepos_alldata.m
% A script to load all behaviour data for a given mouse into a single
% structure

clear all

month_names = {'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};
sfz = 24414.0625; % 25000 %

% First look at 2014
all_data = {};
mouse_num = {'32','33','34','36','38'};
for a = 4:5;
    n = numel(all_data{a}.meta);% 0 when doing 2014, numel(all_data{a}.meta) for a=1:3 when doing 2015 or David data when a=4:5
    for m = 1:12;
%         % Katarina data
%         cd(['/mnt/isilon/fls/Dario Campagner/behavior_test_rsp/']) 
        % David data
        cd(['/mnt/NAS2/David/Matlab_data/']) % David data
        
        dirnames = dir(['*',month_names{m},'-2016']); % -2014 % -2016
        for d = 1:numel(dirnames)
            
            date_str = dirnames(d).name;
%             % Katarina data
%             cd(['/mnt/isilon/fls/Dario Campagner/behavior_test_rsp/',date_str])
            % David data
            cd(['/mnt/NAS2/David/Matlab_data/',date_str]) 
            clear mouse_data
            
            mouse_data = dir([mouse_num{a},'*']);
            if numel(mouse_data)>0
                display(['Mouse ',mouse_num{a},' data on ',date_str])
                
                for s = 1:numel(mouse_data)
%                     % Katarina data
%                     cd(['/mnt/isilon/fls/Dario Campagner/behavior_test_rsp/',date_str,'/',mouse_data(s).name])
                    % David data
                    cd(['/mnt/NAS2/David/Matlab_data/',date_str,'/',mouse_data(s).name])

                    numtrials = numel(dir) - 3;
                    if numtrials>=1
                        try
                            
                            % Parse date string
                            mouse = mouse_data(s).name;
                            d = date_str(1:2);
                            y = date_str(10:11);
                            m = date_str(4:6);
                            
%                             pause
                            session_data = [];
                            sess_file = dir('*_session_data.mat');
                            load([sess_file(1).name])
%                             load(['behaviour_',mouse,'_',num2str(d),'-',m,'-20',y,'_session_data.mat'])
                            
                            n = n+1;
                            
                            display('with session data!')
                            all_data{a}.meta{n} = session_data;
                            all_data{a}.meta{n}.path = pwd;
                            all_data{a}.meta{n}.name = [mouse_data(s).name,'/',date_str];
                            
                            
                            
                            
                            
                            
                            % Lick data
                            licktimes = zeros(numtrials,2);
                            licktimes_sf = zeros(numtrials,2);
                            valvetimes = zeros(numtrials,2);
                            timeout = zeros(numtrials,1);
                            resp_period = zeros(numtrials,2);
                            for k = 1:numtrials
                                this_data = load(['behaviour_',mouse,'_',d,'-',m,'-20',y,'_',num2str(k),'.mat']);
                                ll = find(this_data.read.lickleft,1,'first');
                                lr = find(this_data.read.lickright,1,'first');
                                vl = find(this_data.read.lickvalveleft,1,'first');
                                vr = find(this_data.read.lickvalveright,1,'first');
                                to = find(this_data.read.timeout,1,'first');
                                rp = [find(this_data.read.resp,1,'first'),find(this_data.read.resp,1,'last')];
                                
                                if ll
                                    licktimes(k,1) =  ll/sfz;
                                    licktimes_sf(k,1) =  ll;
                                end
                                if lr
                                    licktimes(k,2) =  lr/sfz;
                                    licktimes_sf(k,2) =  lr;
                                end
                                
                                if vl
                                    valvetimes(k,1) =  vl/sfz;
                                end
                                if vr
                                    valvetimes(k,2) =  vr/sfz;
                                end
                                if to
                                    timeout(k) = to/sfz;
                                end
                                
                                if rp
                                    resp_period(k,:) = ceil(1000*rp/sfz);
                                end
                                
                                
                            end
                            
                            licktimes = ceil(1000*licktimes);
                            
                            all_data{a}.licks{n}.licks_all = licktimes;
                            all_data{a}.licks{n}.licks_sf = licktimes_sf;
                            all_data{a}.licks{n}.valve = valvetimes;
                            all_data{a}.licks{n}.timeout = timeout;
                            all_data{a}.meta{n}.resp = resp_period;
                            
                        catch
                            display('No session data')
                        end
                    end
                end
            end
        end
    end
end

