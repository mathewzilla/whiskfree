% threepos_plotting.m
% Script to generate SfN poster plots from touch-curated data structure
% generated in threepos_retracking.m. Plotting code is based on touch_variables.m
clear all
load ~/Dropbox/data/3posdata/Threepos.mat

% Bugs to fix in primary data:
% mouse:5, i:1, j:24; behav{i}.touches(j,1) = 0; behav{i}.first_touch(j) = 5022;
a = [32,33,34,36,38,0];
% n = 0 ; % For all mice
clear tt ch sess tch pu fst_t th_tch first_touch l th_tch k k_tch k_tch5 delta_k t_period max_dk
saving = 0;
for mouse = 1:5; % Add special case 6 for concatenating all data
    
    behav = Threepos{mouse}.behav;
    meta =  Threepos{mouse}.meta;
    licks = Threepos{mouse}.licks;
    
    
    %% Extract all trials which have been tracked
    
     n = 0
%     clear tt ch sess tch pu fst_t th_tch first_touch l th_tch k k_tch k_tch5 delta_k t_period max_dk
    for i = 1:numel(behav)
        touched = find(behav{i}.dropped ==0);
        tid = behav{i}.trial_id;
        for j = 1:numel(touched)
            n = n + 1;
            
            
            tti = behav{i}.trialtype(touched(j));                 % trialtype
            chi = behav{i}.choice(tid(touched(j)));               % choice
            if mouse <4;
                if tti ==2
                    tt(n) = 1;
                elseif tti == 1
                    tt(n) = 2;
                elseif tti ==3;
                    tt(n) = 3;
                end
  
                if chi ==2
                    ch(n) = 1;
                elseif chi == 1
                    ch(n) = 2;
                elseif chi ==3;
                    ch(n) = 3;
                end
                
            else
                tt(n) = tti;
                ch(n) = chi;
            end

            
            
            sess(n) = i;                                            % session
            tch(n) = behav{i}.pro_touch(touched(j));                % touch type
            
            pu(n) = behav{i}.poleup(touched(j));                    % poleup
            fst_t(n) = 0;                                           % first touch time (zero = default)
            th_tch(n) = 0;                                          % theta at first touch (zero = default)
            k_tch(n) = 0;                                           % kappa at first touch (zero = default)
            k_tch5(n) = 0;                                          % kappa 5ms pre first touch (zero = default)
            delta_k(n) = 0;                                           % peri-touch delta kappa (zero = default)
            max_dk(n) = 0;                                          % max delta kappa (zero = default)
            
            % Lick times
            l(n,:) = licks{i}(tid(touched(j)),:);
            
            if numel(find(behav{i}.touches(touched(j),:)))>0;
                
                first_touch = behav{i}.first_touch(touched(j));
                
                
                
                
                vid_length = numel(find(behav{i}.theta(touched(j),:)));
                first_touch = first_touch - behav{i}.startframe(touched(j));
                first_touch = mod(first_touch,vid_length);
                fst_t(n) = first_touch;                             % Update touch time
                
                th_tch(n) = behav{i}.theta(touched(j),first_touch); % Theta at first touch
                
                k_tch(n) = behav{i}.kappa(touched(j),first_touch);  % Kappa at first touch (for delta kappa stuff)
                
                
                k_tch5(n) = mean(behav{i}.kappa(touched(j),first_touch-6:first_touch-1)); % Kappa 5ms pre first touch
                
                % Peri-touch delta kappa
                [mx,max_k] = max(abs(behav{i}.kappa(touched(j),behav{i}.poleup(touched(j)):behav{i}.poleup(touched(j))+800) - k_tch5(n)));
                delta_k(n) = mx;
                
                % Actual max delta kappa during touch, eventually pre lick (touch-period errors possible)
                
                t_period = find(behav{i}.touches(touched(j),:));
                [~,mdk] = max(abs(behav{i}.kappa(touched(j),t_period) - k_tch5(n)));
                
                max_dk(n) = behav{i}.kappa(touched(j),t_period(mdk)) - k_tch5(n);
                
                
            end
            
            % TO DO: Add Hilbert stuff.
            
            % Kappa peri-touch(max smoothed kappa from pole up to 2s in)
            [~,max_k] = max(abs(behav{i}.kappa(touched(j),851:1500)));
            k(n) = behav{i}.kappa(touched(j),max_k);
            
        end
    end
    
    
    % Set lick times > 2500 to 0
    l(find(l>2500)) = 0;
% end
    %% Swap TT and Choice labels for 32,33,34
    
%     if mouse <4;
%         mouse
%         tt_temp = tt;
%         tt_temp(find(tt == 1)) = 2;
%         tt_temp(find(tt == 2)) = 1;
%         tt = tt_temp;
%         
%         ch_temp = ch;
%         ch_temp(find(ch == 1)) = 2;
%         ch_temp(find(ch == 2)) = 1;
%         ch = ch_temp;
%     end
%     
    
    
    
    %% P(touch|trial type)
    figure(17); clf
    choicename = {'Posterior','Middle','Anterior'};
    for i = 1:3;
        
        one_tt = find(tt == i);
        touch_trials = find(fst_t(one_tt));
        p_touch(i) = numel(touch_trials)/numel(one_tt);
    end
    
    bar([0,1,2],p_touch,'k')
    ylabel('P(Touch|Trial type)')
    set(gca,'XTicklabel',choicename)
    
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_P_touch_type'])
    
    
    %% Mouse performance when he does/doesn't touch the pole in L/R
    % figure(18);clf
    % choicename = {'Touch','No Touch'};
    %
    % % two_c = find(tt==1|tt==2);
    %
    % touch_trials = find(fst_t);%(two_c));
    % notouch_trials = 1:numel(fst_t); %two_c;
    % notouch_trials(touch_trials) = [];
    %
    % c_touch = numel(find(tt(touch_trials)==ch(touch_trials))) / numel(touch_trials);
    % c_notouch = numel(find(tt(notouch_trials)==ch(notouch_trials))) / numel(notouch_trials);
    % c_all = numel(find(tt==ch)) / numel(tt);
    %
    % subplot(1,3,1);
    % bar([1,2,3],[c_touch,c_notouch,c_all],'k')
    % ylabel('P(Correct choice)')
    % set(gca,'XTicklabel',choicename)
    
    
    
    
    %%    Multiple plots. Comment as appropriate
    %   angle at touch/ kappa peri touch/touch time/lick time per trial type
    figure(1);clf;
    figure(2);clf;
    figure(3);clf;
    
    figure(14);clf;
    figure(15);clf;
    figure(16);clf;
    c = colormap(lines);
    colours = c([3,1,2],:);
    colours(3,:) = [0.5,0.5,0.5]; % Grey for no go
    % colours = varycolor(3);
    
    
    
    for i = 1:3;
        
        % Theta
        touch_trials = find(fst_t);
        one_tt = find(tt(touch_trials)==i);
        these_ts = touch_trials(one_tt);
        
        numel(these_ts)
        
        xtees = linspace(70,140,71);%[~,xtees] = hist(th_tch(find(fst_t)),100);
        [tees] = histc(th_tch(these_ts),xtees);
        figure(1); % subplot(3,1,1);
        bar(xtees,tees,'facecolor',colours(i,:),'edgecolor',colours(i,:)); hold all
        %     [f,xi] = ksdensity(th_tch(these_ts));
        %     plot(xi,200*f,'linewidth',2,'color',0.5*(0.5+colours(i,:)))
        % Plot median on top
        plot(median(th_tch(these_ts)),40,'*','color',colours(i,:),'markersize',10); % was 80
        title('Theta at touch');box off
        
        % Cumsum
        figure(14);
        plot(xtees,cumsum(tees./sum(tees)),'color',colours(i,:),'linewidth',5); hold all
        title('Theta at touch')
        axis square; ylim([-0.01,1.01]);box off
        
        %     % Max Kappa peri touch
        %     [kees,xkees] = hist(k(these_ts),50);
        %     subplot(3,1,1);
        %     bar(xkees,kees,'facecolor',colours(i,:)); hold all
        %     % Plot median on top
        %     plot(median(k(these_ts)),40,'*','color',colours(i,:));
        %     title('Max kappa peri touch')
        
        %     % Kappa at touch
        %     [nk,xk] = hist(k_tch(these_ts),50);
        %     ax(1) = subplot(4,1,1);
        %     bar(xk,nk,'facecolor',colours(i,:)); hold all
        %     % Plot median on top
        %     plot(median(k_tch(these_ts)),40,'*','color',colours(i,:));
        %     title('Kappa at touch')
        
        %     % Kappa 5ms before touch
        %     [nk,xk] = hist(k_tch5(these_ts),50);
        %     ax(2) = subplot(4,1,2);
        %     bar(xk,nk,'facecolor',colours(i,:)); hold all
        %     % Plot median on top
        %     plot(median(k_tch5(these_ts)),40,'*','color',colours(i,:));
        %     title('Kappa 5ms pre-touch')
        
        %     % Delta Kappa peri touch
        %     [kees,xkees] = hist(k(these_ts)-median(k_tch(these_ts)),50);
        %     subplot(4,1,3);
        %     bar(xkees,kees,'facecolor',colours(i,:)); hold all
        %     % Plot median on top
        %     plot(median(k(these_ts)-median(k_tch(these_ts))),40,'*','color',colours(i,:));
        %     title('Max delta kappa peri touch')
        
        %     % Delta Kappa peri touch - mean 5ms pre kappa
        %     [kees,xkees] = hist(k(these_ts)-median(k_tch5(these_ts)),50);
        %     ax(4) = subplot(4,1,4);
        %     bar(xkees,kees,'facecolor',colours(i,:)); hold all
        %     % Plot median on top
        %     plot(median(k(these_ts)-median(k_tch5(these_ts))),40,'*','color',colours(i,:));
        %     title('Max delta kappa peri touch')
        
        
        % First touch time
        xtt = linspace(0,750,101); % [~,xtt] = hist(fst_t(find(fst_t))-pu(find(fst_t)),100);
        [ntt] = histc(fst_t(these_ts)-pu(these_ts),xtt);
        figure(2); %subplot(3,1,2);
        
        bar(xtt,ntt,'facecolor',colours(i,:),'edgecolor',colours(i,:)); hold all
        % Plot median on top
        plot(median(fst_t(these_ts)-pu(these_ts)),60,'*','color',colours(i,:),'markersize',10); % was 100
        title('First touch time');box off
        
        % Cumsum
        figure(15);
        plot(xtt,cumsum(ntt./sum(ntt)),'color',colours(i,:),'linewidth',5); hold all
        title('First touch time')
        axis square; ylim([-0.01,1.01]);box off
        
        % Per-trial computed delta Kappa during touch
        [~,xdk] = hist(max_dk(find(fst_t)),100);
        [ndk,~] = histc(max_dk(these_ts),xdk);
        figure(3); %subplot(3,1,3);
        bar(xdk,ndk,'facecolor',colours(i,:),'edgecolor',colours(i,:)); hold all
        % Plot median on top
        plot(median(max_dk(these_ts)),30,'*','color',colours(i,:),'markersize',10); % was 55
        title('Max delta kappa during touch (computed per trial)');box off
        
        % Cumsum
        figure(16);
        plot(xdk,cumsum(ndk./sum(ndk)),'color',colours(i,:),'linewidth',5); hold all
        title('Max delta kappa during touch (computed per trial)')
        axis square; ylim([-0.01,1.01]);box off
        
        
        %     % Touch type
        %     [ntch,xtch] = histc(tch(these_ts),3);
        %     subplot(3,1,3);
        %     bar(xtch,ntch,'facecolor',colours(i,:)); hold all
        %     % Plot median on top
        %     plot(median(tch(these_ts)),350,'*','color',colours(i,:));
        %     title('Touch type')
        
        
        
        %     % Lick time (left)
        %     [nl,xl] = hist(l(these_ts,1),50);
        %     subplot(4,1,4);
        %     bar(xl,nl,'facecolor',colours(i,:)); hold all
        %     % Plot median on top
        %     plot(median(l(these_ts,1)),210,'*','color',colours(i,:));
        %     % Lick right
        %     [nl,xl] = hist(l(these_ts,2),50);
        %     subplot(4,1,4);
        %     bar(xl,nl,'facecolor',0.5*colours(i,:)); hold all
        %     % Plot median on top
        %     plot(median(l(these_ts,2)),210,'*','color',0.5*colours(i,:));
        %     title('Lick time')
        
        %     % Phase
        %         [kees,xkees] = hist(k(these_ts),50);
        %     subplot(5,1,2);
        %     bar(xkees,kees,'facecolor',colours(i,:)); hold all
        %     % Plot median on top
        %     plot(median(k(these_ts)),40,'*','color',colours(i,:));
        %     title('Max kappa peri touch')
        
    end
    figure(1);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_theta_touch_hist'])
    figure(14);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_theta_touch_cumsum'])
    
    figure(2);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_first_touch_latency_hist'])
    figure(15);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_first_touch_latency_cumsum'])
    
    figure(3);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_delta_kappa_hist'])
    figure(16);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_delta_kappa_cumsum'])
    
    
    
    
    % linkaxes(ax)
    
    %% Change label of touch type to make more intuitive sense (i.e. ret, pro, NT)
    pro_ret_temp = tch;
    pro_ret_temp(find(tch == 0)) = 3;
    pro_ret_temp(find(tch == 1)) = 2;
    pro_ret_temp(find(tch == 2)) = 1;
    
    pro_ret = pro_ret_temp;
    
    %% Stacked bar or touch type
    % figure(19); clf
    clear b x
    for i = 1:3;
        [b(i,:),x(i,:)] = hist(pro_ret(find(tt==i)),[1,2,3]);
        %     subplot(3,1,i);
        %     h(i) = bar(x(i,:),b(i,:),'facecolor',colours(i,:),'edgecolor',colours(i,:));hold all;box off
        %     set(gca,'XTick',[])
    end
    % set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})
    % suptitle('Touch type stacked histogram | trial type')
    
    figure(18); clf
    h = bar(x',b','stacked'); hold all
    
    for i = 1:3;
        set(h(i),'facecolor',colours(i,:),'edgecolor','k')
    end
    legend('Posterior','Anterior','No Go')
    set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})
    
    title('Touch type stacked histogram | trial type')
    
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_3_touch_type_stacked'])
    
    
    %% Correct vs incorrect choices
    
    clear bc bi xc xi
    figure(21);clf;
    
    for i = 1:3;
        one_tt = find(tt==i);
        correct = find(ch(one_tt) == i);
        incorr = 1:numel(one_tt);
        incorr(correct) = [];
        
        [bc(i,:),xc(i,:)] = hist(pro_ret(one_tt(correct)),[1,2,3]);
        [bi(i,:),xi(i,:)] = hist(pro_ret(one_tt(incorr)),[1,2,3]);
        subplot(3,1,i);
        bar(x(i,:),bc(i,:),'facecolor',colours(i,:),'edgecolor',colours(i,:));hold all;box off
        bar(x(i,:),-bi(i,:),'facecolor',0.5*(1+colours(i,:)),'edgecolor',0.5*(1+colours(i,:)));hold all;box off
        
        set(gca,'XTick',[])
    end
    set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})
    suptitle('Touch type histogram | trial type')
    
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_3_touchtype_hist'])
  
    % figure(20); clf;
    % h = bar(x',bc','stacked'); hold all
    %
    % for i = 1:3;
    %     set(h(i),'facecolor',colours(i,:))%,'edgecolor',0.5*(1+colours(i,:)))
    % end
    %
    % h = bar(x',-bi','stacked'); hold all
    %
    % for i = 1:3;
    %     set(h(i),'facecolor',0.5*(1+colours(i,:)))%,'edgecolor',0.5*(1+colours(i,:)))
    % end
    %
    % legend('Posterior','Anterior','No Go')
    % set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})
    %
    % title('Touch type stacked histogram | trial type')
    
    %% Histograms/cumsum as before but for 2 choices only. For touch trials only
    %% Trial type/Lick conditioned features for all data
    % Look at lick times which followed touches (L and R trials only)
    figure(4);clf
    figure(5);clf
    figure(6);clf
    figure(7);clf
    figure(8);clf
    figure(9);clf
    
    for i = 1:2;
        
        % Touch + Lick trials
        touch_trials = find(fst_t);
        one_tt = find(tt(touch_trials)==i);
        these_ts = touch_trials(one_tt);
        
        % Swap lick direction for 32,33,34
        if mouse <4;
            corr_lick = find(l(these_ts,3-i));
            incorr_lick = find(l(these_ts,i));
        else
            
            corr_lick = find(l(these_ts,i));
            incorr_lick = find(l(these_ts,3-i));
        end
        
        % Correct theta at touch
        xtt = linspace(70,140,71);% [~,xtt] = hist(th_tch(touch_trials),50); %
        [ntt] = histc(th_tch(these_ts(corr_lick)),xtt);
        figure(4); %subplot(3,1,1);
        %     ntt./sum(ntt)
        bar(xtt,ntt,'facecolor',colours(i,:),'edgecolor',colours(i,:)); hold all
        % Plot median on top
        plot(median(th_tch(these_ts(corr_lick))),50,'*','color',colours(i,:),'markersize',10); % was 60
        
        % Cumsum
        figure(7);
        plot(xtt,cumsum(ntt./sum(ntt)),'color',colours(i,:),'linewidth',5); hold all
        
        % Incorrect theta at touch
        [ntt] = histc(th_tch(these_ts(incorr_lick)),xtt);
        figure(4); %subplot(3,1,1);
        %     ntt./sum(ntt)
        bar(xtt,-ntt,'facecolor',0.5*(1+colours(i,:)),'edgecolor',0.5*(1+colours(i,:))); hold all
        % Plot median on top
        plot(median(th_tch(these_ts(incorr_lick))),50,'*','color',0.5*(1+colours(i,:)),'markersize',10); % was 32:60, 36:50
        title('Theta at touch')
        
        % Cumsum
        figure(7);
        plot(xtt,cumsum(ntt./sum(ntt)),'color',0.5*(1+colours(i,:)),'linewidth',5); hold all
        title('Theta at touch')
        axis square
        
        % Correct first touch time
        xft = linspace(0,750,101); % [~,xft] = hist(fst_t(touch_trials)-pu(touch_trials),450); %
        [ntt] = histc(fst_t(these_ts(corr_lick))-pu(these_ts(corr_lick)),xft);
        figure(5); %subplot(3,1,2);
        %     ntt./sum(ntt)
        bar(xft,ntt,'facecolor',colours(i,:),'edgecolor',colours(i,:)); hold all
        % Plot median on top
        plot(median(fst_t(these_ts(corr_lick))-pu(these_ts(corr_lick))),35,'*','color',colours(i,:),'markersize',10); % was 32:50, 36:35
        
        % Cumsum
        figure(8);
        plot(xft,cumsum(ntt./sum(ntt)),'color',colours(i,:),'linewidth',5); hold all
        
        % Incorrect first touch time
        [ntt] = histc(fst_t(these_ts(incorr_lick))-pu(these_ts(incorr_lick)),xft);
        figure(5); %subplot(3,1,2);
        %     ntt./sum(ntt)
        bar(xft,-ntt,'facecolor',0.5*(1+colours(i,:)),'edgecolor',0.5*(1+colours(i,:))); hold all
        % Plot median on top
        plot(median(fst_t(these_ts(incorr_lick))-pu(these_ts(incorr_lick))),35,'*','color',0.5*(1+colours(i,:)),'markersize',10); % was 32:60, 36:35
        title('First touch time')
        
        % Cumsum
        figure(8);
        plot(xft,cumsum(ntt./sum(ntt)),'color',0.5*(1+colours(i,:)),'linewidth',5); hold all
        title('First touch time')
        axis square
        
        
        % Delta kappa
        % Correct
        [~,xdk] = hist(max_dk(touch_trials),50); %  xdk = linspace(-0.01,0.01,41);
        [ndk,~] = histc(max_dk(these_ts(corr_lick)),xdk);
        
        figure(6); %subplot(3,1,3);
        %     ndk./sum(ndk)
        bar(xdk,ndk,'facecolor',colours(i,:),'edgecolor',colours(i,:)); hold all
        % Plot median on top
        plot(median(max_dk(these_ts(corr_lick))),30,'*','color',colours(i,:),'markersize',10); % 32:50, 36:30
        
        % Cumsum
        figure(9);
        plot(xdk,cumsum(ndk./sum(ndk)),'color',colours(i,:),'linewidth',5); hold all
        
        % Incorrect
        [ndk,~] = histc(max_dk(these_ts(incorr_lick)),xdk);
        
        figure(6) ; %subplot(3,1,3);
        %     ndk./sum(ndk)
        bar(xdk,-ndk,'facecolor',0.5*(1+colours(i,:)),'edgecolor',0.5*(1+colours(i,:))); hold all
        % Plot median on top
        plot(median(max_dk(these_ts(incorr_lick))),30,'*','color',0.5*(1+colours(i,:)),'markersize',10); % 32:50, 36:30
        title('Max delta kappa during touch (computed per trial)')
        
        % Cumsum
        figure(9);
        plot(xdk,cumsum(ndk./sum(ndk)),'color',0.5*(1+colours(i,:)),'linewidth',5); hold all
        title('Max delta kappa during touch (computed per trial)')
        axis square
        
    end
    
    % xlim([0,3000])
    % subplot(311)
    % legend('Left Pole, Lick Left', '','Left Pole, Lick Right','','Right Pole, Lick Right', '','Right Pole, Lick Left','')
    
    figure(4);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_2_choice_theta_touch_hist'])
    figure(7);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_2_choice_theta_touch_cumsum'])
    
    figure(5);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_2_choice_first_touch_latency_hist'])
    figure(8);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_2_choice_first_touch_latency_cumsum'])
    
    figure(6);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_2_choice_delta_kappa_hist'])
    figure(9);
    print('-dpng',['~/Dropbox/behavioral_project/SfN_style_figs/M_',num2str(a(mouse)),'_2_choice_delta_kappa_cumsum'])
    
    
    end

    
    
    
    
%% Compute delta kappa for each pole position from kappa at touch (done above)

%% Restrict to good performing periods - Not done

% %% Phase at touch - may be interesting alongside touch timing - TO DO
% theta_ts = timeseries(theta,(1:numel(handles.theta))./1000);
% bandpass = [6,30];
% theta_filt = idealfilter(theta_ts,bandpass,'pass');
% H = hilbert(theta_filt.data);
%
% pro = find(angle(H)<=0);

%% Loop to look at lick data
% Lick zero is pole up. Grace period is 500ms thereafter. Therefore licking
% only counts after 1351ms
ll = [];
lr = [];
for i = 1:numel(licks)
    ll = [ll;licks{i}(:,1)];
    lr = [lr;licks{i}(:,2)];
end

clf
[hl,xl] = hist(851+ll(find(ll)),100);
bar(xl,hl)
hold all
[hr,xr] = hist(851+lr(find(lr)),100);
bar(xr,hr,'r')

%% Image plot of theta/kappa, with first touch and licking times overlaid.
%
s = unique(sess);
for j = 1:numel(s);
    i = s(j);
    touch_trials = find(behav{i}.first_touch);
    
    first_touch = behav{i}.first_touch(touch_trials) - behav{i}.startframe(touch_trials);
    first_touch  = mod(first_touch,5000);
    [~,sortid] = sort(first_touch);
    clf;
    % imagesc(abs(behav{i}.kappa(touch_trials,:)))
    subplot(1,5,[2:5]);
    imagesc(behav{i}.theta(touch_trials(sortid),:))
    hold all
    plot(first_touch(sortid),1:numel(touch_trials),'w.')
    
    % Plot trialtype information
    tt_i = behav{i}.trialtype(touch_trials);
    for j = 1:3
        plot(j*50*ones(1,numel(find(tt_i(sortid)==j))),find(tt_i(sortid)==j),'.','color',colours(j,:))
    end
    
    % Trial type as vertical histogram on left
    for j = 1:3;
        [h,x] = hist(find(tt_i(sortid)==j),25);
        subplot(1,5,1);hold all
        barh(x,-h,'facecolor',colours(j,:),'edgecolor',colours(j,:));
    end
    ylim([0.5,numel(touch_trials)+0.5])
    set(gca,'Ydir','reverse')
    
    
    % Plot correct/incorrect
    ch_i = behav{i}.choice(touch_trials);
    
    cor = find(tt_i(sortid) == ch_i(sortid));
    incor = 1:numel(touch_trials);
    incor(cor) = [];
    subplot(1,5,[2:5]);
    plot(200*ones(1,numel(cor)),cor,'c.')
    plot(250*ones(1,numel(incor)),incor,'m.')
    
    % Lick times.
    % First combine into single lick time vector
    lts = licks{i};
    ll = lts(touch_trials(sortid),1);
    lr = lts(touch_trials(sortid),2);
    
    
    
    plot(851 + ll(find(ll)),find(ll),'.');
    
    plot(851 + lr(find(lr)),find(lr),'.');
    
    pause;
    
end

%% Image plot in collected order, then ordered by touch type
% 32, i = 8
% imagesc(behav{i}.theta); % With ON period
tracked = find(behav{i}.tracked);
figure(22); clf

imagesc(behav{i}.theta(tracked,1:4500))
hold all
for j = 1:3;
    tt_i = find(behav{i}.trialtype(tracked) == j);
    ch_i = find(behav{i}.choice(tracked) == j);
    plot([4530*ones(size(ch_i)),4900*ones(size(ch_i))]',[ch_i,ch_i]','color',colours(j,:),'linewidth',2)
    
    plot([4950*ones(size(tt_i)),5300*ones(size(tt_i))]',[tt_i,tt_i]','color',colours(j,:),'linewidth',2)
end

correct = find(behav{i}.trialtype(tracked) == behav{i}.choice(tracked));
% incorr = tracked; incorr(correct) = [];

plot([5350*ones(size(correct)),5500*ones(size(correct))]',[correct,correct]','k','linewidth',2)

% Touch
touch_trials = find(behav{i}.first_touch(tracked));

first_touch = behav{i}.first_touch(tracked(touch_trials)) - behav{i}.startframe(tracked(touch_trials));
plot(first_touch,touch_trials,'s','markersize',3,'color',[0, 0.784, 0.392],'markerfacecolor',[0, 0.784, 0.392])
colorbar; box off
xlim([0,5500])

%% Same thing but sorted by trial type and correct/incorrect
sorted_index = [];
for j = 1:3;
    tt_i = find(behav{i}.trialtype(tracked) == j);
    for k = 1:3;
        ch_i = find(behav{i}.choice(tracked(tt_i)) == k);
        sorted_index = [sorted_index;tracked(tt_i(ch_i))];
    end
end
figure(33); clf;
imagesc(behav{i}.theta(sorted_index,1:4500))
hold all
for j = 1:3;
    tt_i = find(behav{i}.trialtype(sorted_index) == j);
    ch_i = find(behav{i}.choice(sorted_index) == j);
    plot([4530*ones(size(tt_i)),4900*ones(size(tt_i))]',[tt_i,tt_i]','color',colours(j,:),'linewidth',2)
    plot([4950*ones(size(ch_i)),5300*ones(size(ch_i))]',[ch_i,ch_i]','color',colours(j,:),'linewidth',2)
end

correct = find(behav{i}.trialtype(sorted_index) == behav{i}.choice(sorted_index));
% incorr = tracked; incorr(correct) = [];

plot([5350*ones(size(correct)),5500*ones(size(correct))]',[correct,correct]','k','linewidth',2)

% Touch
touch_trials = find(behav{i}.first_touch(sorted_index));
first_touch = behav{i}.first_touch(sorted_index(touch_trials)) - behav{i}.startframe(sorted_index(touch_trials));
plot(first_touch,touch_trials,'s','markersize',3,'color',[0, 0.784, 0.392],'markerfacecolor',[0, 0.784, 0.392])

colormap cubehelix
colorbar; box off
xlim([0,5500])


%% Cumulative distibution plots

%% Just plot the lick times across trials
plot(l(:,1),1:length(l),'.')
hold all
plot(l(:,2),1:length(l),'.')

%% Session wise performance data
for i = 1:numel(behav)
    these = find(sess ==i); perf(i) = sum(tt(these)==ch(these))/numel(these);
end
clf;
subplot(2,1,1);
plot(perf); hold all; plot(perf,'b.');
plot([0,14],[0.7,0.7],'r--')
plot([0,14],[0.6,0.6],'g--')
ylim([0,1])
subplot(2,1,2);
plot(conv(+[tt==ch],ones(20,1))/20)
hold all
plot(diff(sess))
ylim([0,1])
plot([0,1200],[0.7,0.7],'r--')



%% Scatter plot of pairs of features - th_tch (theta at touch), max_dk (max
% delta kappa), fst_t (first touch time)
figure(10);
clf
for i = 1:3;
    these_ts = find(tt==i);
    corr_choice = find(ch(these_ts)==i);
    incorr_choice = these_ts;
    incorr_choice(corr_choice) = [];
    subplot(1,3,1);
    plot(th_tch(these_ts(corr_choice)),max_dk(these_ts(corr_choice)),'.','color',colours(i,:)); hold all
    plot(th_tch(incorr_choice),max_dk(incorr_choice),'.','color',0.5*(1+colours(i,:))); hold all
    xlabel('Angle at touch')
    ylabel('Delta Kappa')
    %     axis square
    
    subplot(1,3,2);
    plot(fst_t(these_ts(corr_choice))-pu(these_ts(corr_choice)),max_dk(these_ts(corr_choice)),'.','color',colours(i,:)); hold all
    plot(fst_t(incorr_choice)-pu(incorr_choice),max_dk(incorr_choice),'.','color',0.5*(1+colours(i,:))); hold all
    xlabel('Time of first touch')
    ylabel('Delta Kappa')
    %     axis square
    
    subplot(1,3,3);
    plot(th_tch(these_ts(corr_choice)),fst_t(these_ts(corr_choice))-pu(these_ts(corr_choice)),'.','color',colours(i,:)); hold all
    plot(th_tch(incorr_choice),fst_t(incorr_choice)-pu(incorr_choice),'.','color',0.5*(1+colours(i,:))); hold all
    xlabel('Angle at touch')
    ylabel('Time of first touch')
    %     axis square
    
end

%% Same as above but just the first plot
figure(11); clf
for i = 1:3;
    these_ts = find(tt==i);
    corr_choice = find(ch(these_ts)==i);
    incorr_choice = these_ts;
    incorr_choice(corr_choice) = [];
    plot(th_tch(these_ts(corr_choice)),max_dk(these_ts(corr_choice)),'.','color',colours(i,:),'markersize',10); hold all
    plot(th_tch(incorr_choice),max_dk(incorr_choice),'.','color',0.5*(1+colours(i,:)),'markersize',10); hold all
    
    %     scatter(th_tch(these_ts(corr_choice)),max_dk(these_ts(corr_choice)),'filled','Markerfacecolor',colours(i,:),'Markeredgecolor',[1,1,1]); hold all
    %     scatter(th_tch(incorr_choice),max_dk(incorr_choice),'filled','Markerfacecolor',0.5*(1+colours(i,:)),'Markeredgecolor',[1,1,1]); hold all
    
    
    xlabel('Angle at touch')
    ylabel('Delta Kappa')
    %     axis square
    
end

%% Scatter kappa vs touch type
figure(12); clf
for i = 1:3;
    these_ts = find(tt==i);
    corr_choice = find(ch(these_ts)==i);
    incorr_choice = these_ts;
    incorr_choice(corr_choice) = [];
    plot(pro_ret(these_ts(corr_choice))+0.05*randn(size(corr_choice)),max_dk(these_ts(corr_choice)),'.','color',colours(i,:),'markersize',10); hold all
    plot(pro_ret(incorr_choice)+0.05*randn(size(incorr_choice)),max_dk(incorr_choice),'.','color',0.5*(1+colours(i,:)),'markersize',10); hold all
    
    %     scatter(th_tch(these_ts(corr_choice)),max_dk(these_ts(corr_choice)),'filled','Markerfacecolor',colours(i,:),'Markeredgecolor',[1,1,1]); hold all
    %     scatter(th_tch(incorr_choice),max_dk(incorr_choice),'filled','Markerfacecolor',0.5*(1+colours(i,:)),'Markeredgecolor',[1,1,1]); hold all
    
    
    xlabel('Touch Type')
    set(gca,'XTick',[1,2,3],'XTickLabel',{'Retraction','Protraction','No Touch'})
    ylabel('Delta Kappa')
    %     axis square
    
end

%% Scatter angle at touch vs touch type
figure(13); clf
for i = 1:3;
    these_ts = find(tt==i);
    corr_choice = find(ch(these_ts)==i);
    incorr_choice = these_ts;
    incorr_choice(corr_choice) = [];
    plot(th_tch(these_ts(corr_choice)),pro_ret(these_ts(corr_choice))+0.05*randn(size(corr_choice)),'.','color',colours(i,:),'markersize',10); hold all
    plot(th_tch(incorr_choice),pro_ret(incorr_choice)+0.05*randn(size(incorr_choice)),'.','color',0.5*(1+colours(i,:)),'markersize',10); hold all
    
    %     scatter(th_tch(these_ts(corr_choice)),max_dk(these_ts(corr_choice)),'filled','Markerfacecolor',colours(i,:),'Markeredgecolor',[1,1,1]); hold all
    %     scatter(th_tch(incorr_choice),max_dk(incorr_choice),'filled','Markerfacecolor',0.5*(1+colours(i,:)),'Markeredgecolor',[1,1,1]); hold all
    
    
    ylabel('Touch Type')
    set(gca,'YTick',[1,2,3],'YTickLabel',{'Retraction','Protraction','No Touch'})
    ylabel('Theta at touch')
    %     axis square
    
end

%% Classification of TT/Choice based on single/small numbers of features.
% ldatt_th_tch = fitdiscr(th_tch,tt);         % Matlab 2016
% ldaClass = resubPredict(ldatt_th_tch)       % Matlab 2016

% TO DO: Try again with touch only.
%        ALSO - GMM

% Percentages ordered 32, 34, 36

% TRIALTYPE
% Theta at touch - 39.2%, 58.9%, 70.8%
ldatt_th_tch = classify(th_tch',th_tch',tt'); % Old Matlab
correct = find(ldatt_th_tch==tt');            % Old Matlab
perf_th = numel(correct)/numel(tt)

% Delta kappa - 49.9%, 30.5%, 50.1%
ldatt_max_dk = classify(max_dk',max_dk',tt');
correct = find(ldatt_max_dk==tt');
perf_dk = numel(correct)/numel(tt)

% First touch time - 52.5%, 46.5%, 48.4%
ldatt_fst = classify(fst_t',fst_t',tt');
correct = find(ldatt_fst==tt');
perf_fst = numel(correct)/numel(tt)

% Touch type - 61.7%, 62.2%, 59.0%
ldatt_tch = classify(tch',tch',tt');
correct = find(ldatt_tch==tt');
perf_tch = numel(correct)/numel(tt)

% CHOICE
% Theta at touch - 56.3%, 61.5%, 69.4%
ldach_th_tch = classify(th_tch',th_tch',ch');
correct = find(ldach_th_tch==ch');
perf_thC = numel(correct)/numel(tt)

% Delta Kappa - 43%, 24.1%, 48.5%
ldach_max_dk = classify(max_dk',max_dk',ch');
correct = find(ldach_max_dk==ch');
perf_dkC = numel(correct)/numel(tt)

% First touch time - 49.8%, 41.9%, 35%
ldach_fst = classify(fst_t',fst_t',ch');
correct = find(ldach_fst==ch');
perf_fst = numel(correct)/numel(tt)

% Touch type - 57.4%, 58.7%, 51.9%
ldach_tch = classify(tch',tch',ch');
correct = find(ldach_tch==ch');
perf_tch = numel(correct)/numel(tt)

% Mouse performance - 76.8%, 73.7%, 70.1%
correct = find(tt'==ch');
perf_mus = numel(correct)/numel(tt)

%% Two choice verison?
two_c = find(tt==1|tt==2);
% TRIALTYPE
% Theta at touch - 66.3%, 65.1%, 92%
ldatt_th_tch = classify(th_tch(two_c)',th_tch(two_c)',tt(two_c)'); % Old Matlab
correct = find(ldatt_th_tch==tt(two_c)');                          % Old Matlab
perf_th = numel(correct)/numel(tt(two_c))

% Delta kappa - 65.4%, 56.6%, 64.5%
ldatt_max_dk = classify(max_dk(two_c)',max_dk(two_c)',tt(two_c)');
correct = find(ldatt_max_dk==tt(two_c)');
perf_dk = numel(correct)/numel(tt(two_c))

% First touch time - 60%, 50.91%, 57%
ldatt_fst = classify(fst_t(two_c)',fst_t(two_c)',tt(two_c)');
correct = find(ldatt_fst==tt(two_c)');
perf_fst = numel(correct)/numel(tt(two_c))

% Touch type - 73.4%, 75.6%, 73.1%
ldatt_tch = classify(tch(two_c)',tch(two_c)',tt(two_c)');
correct = find(ldatt_tch==tt(two_c)');
perf_tch = numel(correct)/numel(tt(two_c))


% Mouse performance - 81.7%, 77.9%, 72.77%
correct = find(ch(two_c)'==tt(two_c)');
perf_mus = numel(correct)/numel(tt(two_c))

%CHOICE
% Theta at touch - 62.7%, 57.3%, 43.2%
ldach_th_tch = classify(th_tch(two_c)',th_tch(two_c)',ch(two_c)');
correct = find(ldach_th_tch==ch(two_c)');
perf_thC = numel(correct)/numel(tt(two_c))

% Delta Kappa - 31.1%, 30.8%, 53.3%
ldach_max_dk = classify(max_dk(two_c)',max_dk(two_c)',ch(two_c)');
correct = find(ldach_max_dk==ch(two_c)');
perf_dkC = numel(correct)/numel(tt(two_c))

% First touch time - 42.2%, 24.9%, 48.4%
ldach_fst = classify(fst_t(two_c)',fst_t(two_c)',ch(two_c)');
correct = find(ldach_fst==ch(two_c)');
perf_fst = numel(correct)/numel(tt(two_c))

% Touch type - 33.8%, 36.1%, 67.9%
ldach_tch = classify(tch(two_c)',tch(two_c)',ch(two_c)');
correct = find(ldach_tch==ch(two_c)');
perf_tch = numel(correct)/numel(tt(two_c))


%% Plots of above performance data

% THREE CHOICES/TRIALTYPES
% 4 features for TT discrimination + mouse
perf_tt = [39.2, 58.9, 70.8; 49.9, 30.5, 50.1;52.5, 46.5, 48.4;61.7, 62.2, 59.0; 76.8, 73.7, 70.1];

% 4 features for Choice discrimination
perf_ch = [56.3, 61.5, 69.4;43, 24.1, 48.5;49.8, 41.9, 35;57.4, 58.7, 51.9];

% TWO CHOICES/TRIALTYPES
% 4 features for TT discrim + mouse
perf_tt2 = [66.3,65.1,92;65.4, 56.6, 64.5;60, 50.91, 57;73.4, 75.6, 73.1;81.7, 77.9, 72.77];

% 4 features for Choice discrim
perf_ch2 = [62.7,57.3,43.2;31.1,30.8,53.3;42.2,24.9,48.4;33.8,36.1,67.9];

%% Plotting
% 3 Trialtypes
clf
feature_labels = {'Theta at touch';'Delta kappa';'First touch time';'Touch Type';'Mouse'};
plot(perf_tt); hold all
plot(perf_tt,'k.')

set(gca,'XTick',[1,2,3,4,5],'XTickLabel',feature_labels)
plot([1,5],[33.3,33.3],'r--')
ylabel('Percent correct')
legend('32','34','36')
title('Predicting all 3 Trialtypes')

% 2 Trialtypes
clf
feature_labels = {'Theta at touch';'Delta kappa';'First touch time';'Touch Type';'Mouse'};
plot(perf_tt2); hold all
plot(perf_tt2,'k.')

set(gca,'XTick',[1,2,3,4,5],'XTickLabel',feature_labels)
plot([1,5],[33.3,33.3],'r--')
ylabel('Percent correct')
legend('32','34','36')
title('Predicting Go L/Go R')

%%
% 3 choices
clf
feature_labels = {'Theta at touch';'Delta kappa';'First touch time';'Touch Type'};
plot(perf_ch); hold all
plot(perf_ch,'k.')
set(gca,'XTick',[1,2,3,4],'XTickLabel',feature_labels)
plot([1,5],[33.3,33.3],'r--')
ylabel('Percent correct')
legend('32','34','36')
title('Predicting all 3 choices')
xlim([1,4])

% 2 choices
clf
feature_labels = {'Theta at touch';'Delta kappa';'First touch time';'Touch Type'};
plot(perf_ch2); hold all
plot(perf_ch2,'k.')

set(gca,'XTick',[1,2,3,4],'XTickLabel',feature_labels)
plot([1,5],[33.3,33.3],'r--')
ylabel('Percent correct')
legend('32','34','36')
title('Predicting Choice L/R')

%% New

%% Angular range


%% Fixing errors in behav data
% 32 .
% (1|26,56).(2|59,66).(3|7)(4,NT:2,3,45,52,53,55,56,57,59,60,63,71,72,79).(8|41)
% 36 (9|2)
behav{i}.first_touch(touched(j)) = 0; % when there is no touch

behav{i}.touches(touched(j),1:837) = 0; % usually ~805 is ok
behav{i}.first_touch(touched(j)) = 932 + behav{i}.startframe(touched(j)); %1076,1112.853,969.1042.  932.

%% helper plot for error checking. Also poster example: 36 {10}(50) (i=10,j=50 also)
i = 10; j = 50;
clf
plot(behav{i}.theta(touched(j),:))
hold all
% plot(find(behav{i}.pro_ret(touched(j),:)),behav{i}.theta(touched(j),find(behav{i}.pro_ret(touched(j),:))),'g.')
plot(first_touch,behav{i}.theta(touched(j),first_touch),'k.')
plot(90+ 5*zscore(behav{i}.kappa(touched(j),:)))
plot(find(behav{i}.touches(touched(j),:)),90*ones(numel(find(behav{i}.touches(touched(j),:))),1),'k.')

% Licking
lick_time = behav{i}.poleup(touched(j)) + licks{i}(touched(j),:);
if lick_time
    plot([lick_time,lick_time],[75,80],'c','linewidth',2)
end

%% Export fields
plot_data.theta = behav{i}.theta(touched(j),:);
plot_data.kappa = behav{i}.kappa(touched(j),:);
plot_data.poleup = behav{i}.poleup(touched(j));
plot_data.touches = behav{i}.touches(touched(j),:);
plot_data.lick_time = lick_time;

save('plot_data.mat','plot_data')

%% Data for whisking latency plot
% V1. 32{9}
theta = behav{i}.theta(find(behav{i}.tracked),1:4500);
save('theta_32_9.mat','theta')

%% V2. All data for a given mouse
n = 0;
clear all_theta
for i = 1:numel(behav)
    tracked = [];
    try
        tracked = behav{i}.tracked;
    catch
        display(['Session ',num2str(i),' not touch-detected'])
    end
    if ~isempty(tracked)
        touched = find(tracked);
        %%
        for j = 1:numel(touched)
            n = n+1;
            temp_theta = behav{i}.theta(touched(j),:);
            all_theta(n,:) = circshift(temp_theta,[0,1000-behav{i}.poleup(touched(j))]);
        end
    end
end

imagesc(all_theta)

save('theta_34_all.mat','all_theta')
