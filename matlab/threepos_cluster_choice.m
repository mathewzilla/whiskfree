% Script for CHOICE CONDITIONED pca, clustering and classification of whisking data. 
% Whisking data needs to come from threeposition.m

% load ~/Dropbox/Data/3posdata/behav_36b.mat

this_mouse = behav_36;

colours = [1,0,0;0,1,0;0,0,0]; % 36
m_colours = [1,0.5,0.5;0.5,1,0.5;0.5,0.5,0.5]; % 36
titles = {'Posterior pole';'Anterior pole';'No Go'}; % 36

% this_mouse = behav_32;
% colours = [0,1,0;1,0,0;0,0,0]; % Others
% m_colours = [0.5,1,0.5;1,0.5,0.5;0.5,0.5,0.5]; % Others
% titles = {'Anterior pole';'Posterior pole';'No Go'}; % Others

% Generate t and k arrays
[t,k,lab] = gen_tk(this_mouse,'all');

%% Downsample theta and kappa with decimate

theta_ds = zeros(size(t,1),50);
kappa_ds = zeros(size(t,1),50);
for i = 1:size(t,1)
    theta_ds(i,:) = decimate(t(i,950:1440),10); % decimate(t(i,900:1890),10); %
    kappa_ds(i,:) = decimate(k(i,950:1440),10); % decimate(k(i,900:1890),10);
%     kappa_ds(i,:) = kappa_ds(i,:) - mean(kappa_ds(i,1:10)); % mean subtract kappa
end

both_ds = [zscore(theta_ds),zscore(kappa_ds)];

%% Plot mean theta/kappa by trialtype/choice
p = find(lab.tt == 1);
a = find(lab.tt == 2);
clf;

subplot(2,2,1);
myeb(mean(theta_ds(a,:)),std(theta_ds(a,:))./sqrt(numel(a)))
hold all
myeb(mean(theta_ds(p,:)),std(theta_ds(p,:))./sqrt(numel(p)))
title('Angle | TT')
% legend('','Anterior pole','','Posterior pole')
subplot(2,2,2);
myeb(mean(kappa_ds(a,:)),std(kappa_ds(a,:))./sqrt(numel(a)))
hold all
myeb(mean(kappa_ds(p,:)),std(kappa_ds(p,:))./sqrt(numel(p)))
title('Curvature | TT')
legend('','Anterior pole','','Posterior pole','location','bestoutside')

p = find(lab.ch == 1);
a = find(lab.ch == 2);
subplot(2,2,3);
myeb(mean(theta_ds(a,:)),std(theta_ds(a,:))./sqrt(numel(a)))
hold all
myeb(mean(theta_ds(p,:)),std(theta_ds(p,:))./sqrt(numel(p)))
title('Angle | choice')
% legend('','Anterior pole','','Posterior pole')
subplot(2,2,4);
myeb(mean(kappa_ds(a,:)),std(kappa_ds(a,:))./sqrt(numel(a)))
hold all
myeb(mean(kappa_ds(p,:)),std(kappa_ds(p,:))./sqrt(numel(p)))
title('Curvature | choice')
% legend('','Anterior pole','','Posterior pole')

suptitle(['Mean + SEM decimated variables, Mouse ',num2str(this_mouse{s}.name(end-2:end-1))])

print('-dpng',['~/work/whiskfree/figs/classification/Mean_vars_AP_',this_mouse{1}.name(end-2:end-1),'.png'])
%% PCA (rotating matrix to find time points of highest variance.
% Plot SCORES to see timeseries of high variance components
[coeff_t,score_t,latent_t] = princomp(zscore(theta_ds)');

[coeff_k,score_k,latent_k] = princomp(zscore(kappa_ds)');

[coeff_b,score_b,latent_b] = princomp(both_ds');

%% PCA with COV and eig
clf; hold all;
% Theta
C_t = cov(theta_ds'); % C is then n x n
[V_t,D_t] = eig(C_t); % Eigenvectors and associated eigenvalues
E_t = diag(D_t); % Get eigenvalues by diag(D)
[E_t, order] = sort(E_t,'descend');
D_t = D_t(order,order);
V_t = V_t(:,order);

pc_t = V_t'*theta_ds ./ size(theta_ds,1);
plot(zscore(pc_t(1,:)));

% Kappa
C_k = cov(kappa_ds'); % C is then n x n
[V_k,D_k] = eig(C_k); % Eigenvectors and associated eigenvalues
E_k = diag(D_k); % Get eigenvalues by diag(D)
[E_k, order] = sort(E_k,'descend');
D_k = D_k(order,order);
V_k = V_k(:,order);

pc_k = V_k'*kappa_ds ./ size(kappa_ds,1);
plot(zscore(pc_k(1,:)));

% Both
C_b = cov(both_ds'); % C is then n x n
[V_b,D_b] = eig(C_b); % Eigenvectors and associated eigenvalues
E_b = diag(D_b); % Get eigenvalues by diag(D)
[E_b, order] = sort(E_b,'descend');
D_b = D_b(order,order);
V_b = V_b(:,order);

pc_b = V_b'*both_ds ./ size(both_ds,1);
plot(zscore(pc_b(1,:)));

%% Plot eigenvalues
plot(cumsum(E_t)./sum(E_t))
hold all
plot(cumsum(E_k)./sum(E_k))
plot(cumsum(E_b)./sum(E_b))

ylim([0,1]);
xlim([0,50]);
plot([1,100],[0.9,0.9],'k--')
plot([1,100],[0.8,0.8],'k--')
hold off
legend('Theta','Kappa','Both')
title(['Cumulative variance explained by PCs, Mouse 36'])

%% Scatter plot of Eigenvector loadings coloured by trialtypes 
p = find(lab.tt == 1);
a = find(lab.tt == 2);
clf
% theta
subplot(1,3,1);
plot3(V_t(a,1),V_t(a,2),V_t(a,3),'.'); hold all;
plot3(V_t(p,1),V_t(p,2),V_t(p,3),'.');
% kappa
subplot(1,3,2);
plot3(V_k(a,1),V_k(a,2),V_k(a,3),'.'); hold all;
plot3(V_k(p,1),V_k(p,2),V_k(p,3),'.');
% both
subplot(1,3,3);
plot3(V_b(a,1),V_b(a,2),V_b(a,3),'.'); hold all;
plot3(V_b(p,1),V_b(p,2),V_b(p,3),'.');


%% Pairplot
p = find(lab.ch == 1);
a = find(lab.ch == 2);
ng = find(lab.ch == 3);

this_V = V_k;
n = 0;
clf
for i = 1:10;
    for j = 1:10;
        n = n + 1;
        subplot_tight(10,10,n);
        if i ==j
            [b,bc] = hist(this_V(a,i),linspace(-0.15,0.15,50));
            bar(bc,b,'facecolor',[1,0.5,0],'edgecolor',[1,0.5,0]);
            hold all
            [b,bc] = hist(this_V(p,i),linspace(-0.15,0.15,50));
            bar(bc,b,'facecolor',[0,0.5,1],'edgecolor',[0,0.5,1]);
            [b,bc] = hist(this_V(ng,i),linspace(-0.15,0.15,50));
            bar(bc,b,'facecolor',[0,1,0.5],'edgecolor',[0,1,0.5]);
        else
            plot(this_V(a,j),this_V(a,i),'.','color',[1,0.5,0]);
            hold all
            plot(this_V(p,j),V(p,i),'.','color',[0,0.5,1]);
            plot(this_V(ng,j),V(ng,i),'.','color',[0,1,0.5]);
            xlim([-0.15,0.15])
            ylim([-0.15,0.15])
        end
    end
end

suptitle('Eigenvector entries. Kappa. Colour = choice')
% suptitle('Eigenvector entries. Kappa. Colour = trialtype')


%% Plot V' * theta_ds(lick left) vs V' * theta_ds(lick right)
p = find(lab.ch == 1);
a = find(lab.ch == 2);

% Need better way to normalise
x1 = (V(p,2)'*theta_ds(p,:));%./numel(p);
x2 = (V(a,2)'*theta_ds(a,:));%./numel(a);

y1 = (V(p,3)'*theta_ds(p,:));%./numel(p);
y2 = (V(a,3)'*theta_ds(a,:));%./numel(a);

clf;
plot(x1,y1); hold all
plot(x2,y2); hold off

%% use eigs to compute a small number of pcs
dims = 100;
[V2,D2] = eigs(C,dims);
W = theta_ds' * V2;
Y = W*V2';

subplot(1,2,1);
plot(theta_ds(1:5,:)')
title('Data')
subplot(1,2,2);
plot(Y(:,1:5));
title(['Reconstruction, (',num2str(dims),' PCs)'])

%% classification to choice/trialtype using perfcurve examples
% p = find(lab.tt == 1);
% a = find(lab.tt == 2);

p = find(lab.ch == 1);
a = find(lab.ch == 2);

resp = [zeros(size(p));ones(size(a))];
resp = resp>0.5; % needs to be logical

% Predict using kappa alone
% pred = [kappa_ds(p,:);kappa_ds(a,:)];
% pred = [theta_ds(p,:);theta_ds(a,:)];
pred = [theta_ds(p,:),kappa_ds(p,:);theta_ds(a,:),kappa_ds(a,:)];
% pred = [V_b(1:20,p),V_b(1:20,a)]';

% GLM - logistic regression
tic
% new matlab
mdl = fitglm(pred,resp,'Distribution','binomial','Link','logit');
score_log = mdl.Fitted.Probability; % Probability estimates

% old matlab
% mdl = glmfit(pred,resp,'binomial');  
% score_log = glmval(mdl,pred,'logit');
% time_log = toc

[Xlog,Ylog,Tlog,AUClog] = perfcurve(resp,score_log,'true');
% plot(Xlog,Ylog);
% hold all
% axis square;
AUClog

% Predict using SVM
tic
mdlSVM = fitcsvm(pred,resp,'Standardize',true);
mdlSVM = fitPosterior(mdlSVM);
% cv = crossval(mdlSVM);
[~,score_svm] = resubPredict(mdlSVM);
% [~,score] = kfoldPredict(cv);
time_svm = toc

[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(resp,score_svm(:,mdlSVM.ClassNames),'true');
plot(Xsvm,Ysvm);
AUCsvm

% Predict using naive bayes
tic
mdlNB = fitcnb(pred,resp);
[~,score_nb] = resubPredict(mdlNB);
time_nb = toc

[Xnb,Ynb,Tnb,AUCnb] = perfcurve(resp,score_nb(:,mdlNB.ClassNames),'true');

% Plotting
plot(Xlog,Ylog)
hold all
plot(Xsvm,Ysvm)
plot(Xnb,Ynb)
axis square


% % Compute and plot the mouse's ROC curve
% mouse_score = [1-[lab.ch(p) == lab.tt(p)];[lab.ch(a) == lab.tt(a)]];
% [Xm,Ym,Tm,AUCm] = perfcurve(resp,mouse_score,'true');
% plot(Xm,Ym);

legend(['Logistic regression:',num2str(AUClog)],['SVM:',num2str(AUCsvm)],['Naive Bayes: ',num2str(AUCnb)],'location','best')%['Mouse: ',num2str(AUCm)],'location','best')
xlabel('False positive'); ylabel('True positive')
title('ROC curves, 3 methods, choice, alldata') ; % 20 PCs')
hold off

print('-dpng',['~/work/whiskfree/figs/classification/ROC_alldata_alltime_CHOICE_',this_mouse{1}.name(end-2:end-1),'.png'])

%% Confusion matrices of the different methods (and mouse).


%% Run in a loop, computing AUC for 50ms chunks of raw data
p = find(lab.tt == 1);
a = find(lab.tt == 2);

resp = [zeros(size(p));ones(size(a))];
resp = resp>0.5; % needs to be logical

clf; 
subplot(1,2,1);
hold all
cmap = hsv(10);
for i = 1:10
    t_range = 900 + i*50: 900 + i*50 + 49;
    % Predict using kappa alone
    
    t(i,950:1440);
    
    pred = [t(p,t_range),k(p,t_range);t(a,t_range),k(a,t_range)];
    
    
    % GLM - logistic regression
    % new matlab
    mdl = fitglm(pred,resp,'Distribution','binomial','Link','logit');
    score_log = mdl.Fitted.Probability; % Probability estimates
    
    
    [X,Y,T,AUC(i)] = perfcurve(resp,score_log,'true');
    plot(X,Y);
end

xlabel('False positive'); ylabel('True positive')
legend(num2str([(1:10)*50 + 925]'))

subplot(1,2,2);
plot([(1:10)*50 + 925]',AUC); hold all
plot([1000,1000],[0.65,0.9],'k--');hold off

%% Single layer neural network with 3 output choices
% Code output as one-hot vector


%% Need summary plot of data| PCs to see if separation exists for linear class

%% Try more focussed method based on what PCA says i.e. theta/kappa in particular time window.

%% Export resp and pred for analysis elsewhere
% load ~/Dropbox/Data/3posdata/behav_32b.mat
% load ~/Dropbox/Data/3posdata/behav_33b.mat
% load ~/Dropbox/Data/3posdata/behav_34b.mat
% load ~/Dropbox/Data/3posdata/behav_36b.mat

mouse = {'behav_32','behav_33','behav_34','behav_36'};

for m = 1:4;
    
    this_mouse = eval(mouse{m});
    
    % this_mouse = behav_32;
    % colours = [0,1,0;1,0,0;0,0,0]; % Others
    % m_colours = [0.5,1,0.5;1,0.5,0.5;0.5,0.5,0.5]; % Others
    % titles = {'Anterior pole';'Posterior pole';'No Go'}; % Others
    
    % Generate t and k arrays
    [t,k,lab] = gen_tk(this_mouse,'all');
    
    % Downsample theta and kappa with decimate
    
    theta_ds = zeros(size(t,1),50);
    kappa_ds = zeros(size(t,1),50);
    for i = 1:size(t,1)
        theta_ds(i,:) = decimate(t(i,950:1440),10); % decimate(t(i,900:1890),10); %
        kappa_ds(i,:) = decimate(k(i,950:1440),10); % decimate(k(i,900:1890),10);
        %     kappa_ds(i,:) = kappa_ds(i,:) - mean(kappa_ds(i,1:10)); % mean subtract kappa
    end
    
    both_ds = [zscore(theta_ds),zscore(kappa_ds)];
    
    
    p = find(lab.ch == 1);
    a = find(lab.ch == 2);
    
    resp = [zeros(size(p));ones(size(a))];
    resp = resp>0.5; % needs to be logical
    
    % Predict using kappa alone
    % pred = [kappa_ds(p,:);kappa_ds(a,:)];
    % pred = [theta_ds(p,:);theta_ds(a,:)];
    pred = [theta_ds(p,:),kappa_ds(p,:);theta_ds(a,:),kappa_ds(a,:)];
    
    
    % Print to .csv in data folder
    csvwrite(['~/work/whiskfree/data/pred_',this_mouse{1}.name(end-2:end-1),'.csv'],pred);
    csvwrite(['~/work/whiskfree/data/resp_',this_mouse{1}.name(end-2:end-1),'.csv'],resp);
    
end

