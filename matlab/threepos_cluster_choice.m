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
x1 = (V(p,2)'*theta_ds(p,:))./numel(p);
x2 = (V(a,2)'*theta_ds(a,:))./numel(a);

y1 = (V(p,3)'*theta_ds(p,:))./numel(p);
y2 = (V(a,3)'*theta_ds(a,:))./numel(a);

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
p = find(lab.tt == 1);
a = find(lab.tt == 2);

resp = [zeros(size(p));ones(size(a))];
resp = resp>0.5; % needs to be logical

% Predict using kappa alone
pred = [kappa_ds(p,:);kappa_ds(a,:)];
% pred = [theta_ds(p,:);theta_ds(a,:)];
% pred = [theta_ds(p,:),kappa_ds(p,:);theta_ds(a,:),kappa_ds(a,:)];
% pred = [V_b(1:20,p),V_b(1:20,a)]';

% GLM - logistic regression
tic
mdl = fitglm(pred,resp,'Distribution','binomial','Link','logit');
score_log = mdl.Fitted.Probability; % Probability estimates
time_log = toc

[Xlog,Ylog,Tlog,AUClog] = perfcurve(resp,score_log,'true');
% plot(Xlog,Ylog);
% hold all
% axis square;
AUClog

% Predict using SVM
tic
mdlSVM = fitcsvm(pred,resp,'Standardize',true);
mdlSVM = fitPosterior(mdlSVM);
[~,score_svm] = resubPredict(mdlSVM);
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


% Compute and plot the mouse's ROC curve
mouse_score = [1-[lab.ch(p) == lab.tt(p)];[lab.ch(a) == lab.tt(a)]];
[Xm,Ym,Tm,AUCm] = perfcurve(resp,mouse_score,'true');
plot(Xm,Ym);

legend(['Logistic regression:',num2str(AUClog)],['SVM:',num2str(AUCsvm)],['Naive Bayes: ',num2str(AUCnb)],['Mouse: ',num2str(AUCm)],'location','best')
xlabel('False positive'); ylabel('True positive')
title('ROC curves, 3 methods, trialtype, 20 PCs')
hold off


%% Need summary plot of data| PCs to see if separation exists for linear class

%% Try more focussed method based on what PCA says i.e. theta/kappa in particular time window.


%% Plot first 10 PCs, staggered
clf
for i = 1:10;
    subplot(1,4,1);
    plot(10*i+ score_t(:,i));
    hold all
    
    subplot(1,4,2);
        plot(10*i+ score_k(:,i));
    hold all
    
    subplot(1,4,[3,4])
        plot(10*i+ score_b(:,i));
    hold all
    
end
subplot(1,4,1); title('Theta')
subplot(1,4,1); title('Kappa')
subplot(1,4,1); title('Both')
suptitle('First 10 eigenvectors')


%% Plot variance explained for the 3 subsets
clf;
hold all
plot(cumsum(latent_t)./sum(latent_t),'b'); 
plot(cumsum(latent_k)./sum(latent_k),'r'); 
plot(cumsum(latent_b)./sum(latent_b),'m');

plot(cumsum(latent_t)./sum(latent_t),'b.'); 
plot(cumsum(latent_k)./sum(latent_k),'r.'); 
plot(cumsum(latent_b)./sum(latent_b),'m.');
ylim([0,1]);
xlim([0,50]);
plot([1,100],[0.9,0.9],'k--')
plot([1,100],[0.8,0.8],'k--')
legend('Theta','Kappa','Both')
title(['Cumulative variance explained by PCs, Mouse 36'])

%% Compute mean score vector for each class
score_dr = [score_t(:,1:15),score_k(:,1:15)];


mean_l = score_dr(find(lab.ch == 1),:);
mean_r = score_dr(find(lab.ch == 2),:);


%% Linear classifier to separate two classes
X = [mean_l;mean_r];
X = [X,ones(size(X,1),1)]; % column of zeros for regression
b = [ones(size(mean_l,1),1);-1*ones(size(mean_r,1),1)]; % labels for regression







%% Use first 15 dims for clustering
% theta_pc = score * coeff(:,1:20);
theta_pc = score(:,1:20);
c_data = cell(20,1);
for i = 1:20;
    [c_data{i}.cidx,c_data{i}.ctrs,c_data{i}.sumd,c_data{i}.D] = kmeans(theta_pc,i+1,'Replicates',10);
    c_data{i}.clusters = i + 1;
    
end

% Plot zscored cluster membership
for i = 1:20; plot(zscore(c_data{i}.cidx));hold all;end; hold off
title('Z-scored cluster membership')

%% Plot sumd. Median sumd (normalised sumd?)

for i = 1:20
    plot(c_data{i}.sumd);hold all;
end
hold off

%% MDH clustering
A = corrcoef(theta_pc');
A(find(eye(size(A,1)))) = 0;
A(find(A<0)) = 0;

[grps,Vpos,B,Q] = allevsplit(A); % Takes ages. Initial Output: max mod = 5, med max mod = 12.

%% Look at cluster centers with 5/12 clusters
clus = 4;
c_data{clus}.ctrs;

for i = 1:size(c_data{clus}.ctrs,1)
    plot(c_data{clus}.ctrs(i,:)*coeff(:,1:20)');
    hold all;
end

hold off

%% First try reconstructing data from PCs
n_pcs = 15;
theta_approx = coeff(:,1:n_pcs) * score(:,1:n_pcs)';
theta_approx = bsxfun(@plus,nanmean(theta_ds'),theta_approx);

subset = round(size(theta_approx,2) * rand(10,1))
figure(9);
for x = 1:numel(subset)
    plot(theta_approx(:,subset(x)));hold all; plot(theta_ds(subset(x),:)); hold off
    legend('PC reconstruction','Data')
    title(['PC reconstruction of trial ',num2str(subset(x)),' (',num2str(n_pcs),' PCs)'])
    pause
end
figure(10);
theta_approx = theta_approx';
plot(theta_ds(:),theta_approx(:),'.')
pcc = corrcoef(theta_ds(:),theta_approx(:)');
title(['Data vs reconstruction, all points. PCC = ',num2str(pcc(2,1))])

%% Plot pcc between theta_ds and theta_approx for diff numbers of pcs.
clf; hold all
pcc_n_pcs = zeros(50,1);
for n_pcs = 1:50;
    theta_approx = coeff(:,1:n_pcs) * score(:,1:n_pcs)';
    theta_approx = bsxfun(@plus,nanmean(theta_ds'),theta_approx);
    theta_approx = theta_approx';
    pcc = corrcoef(theta_ds(:),theta_approx(:)');
    if mod(n_pcs,10) == 1;
        plot(theta_ds(:),theta_approx(:),'.')
        title(['Data vs reconstruction, all points. PCC = ',num2str(pcc(2,1))])
        drawnow;
    end
    pcc_n_pcs(n_pcs) = pcc(2,1);
    
end
legend('1 PCs','11 PCs','21 PCs','31 PCs','41 PCs')
title('Data vs reconstruction, all points.')

figure;
plot(pcc_n_pcs);
xlabel('Number of eigenvectors used for reconstruction')
ylabel('PCC (data,reconstruction)')
ylim([0,1])

%% Sort clusters by intra-group similarity
% First compute Sxy matrix based on paired euclidean distance 

Sxy = pdist2(score(:,1:20),score(:,1:20),'seuclidean');

clus = 12;
G = [[1:size(score,1)]',c_data{clus}.cidx];
[newG,Sgrp,Sin,Sout] = sortbysimilarity(G,Sxy);

theta_ds(find(theta_ds < 60)) = 60;

%% Image theta, unsorted then sorted
tt = [ones(size(t{1},2),1);2*ones(size(t{2},2),1);3*ones(size(t{3},2),1)];
subplot(1,6,[1:2]);
imagesc(theta_data(:,900:1900))
ylabel('Trial')
xlabel('Time (ms)')
set(gca,'Xticklabel',[1100,1300,1500,1700,1900])
title('Unsorted')

subplot(1,6,3);
plot(tt,1:size(G,1));
set(gca,'Ydir','reverse')
ylim([1,size(G,1)])
xlabel('Trialtype')

subplot(1,6,[4:5]);
imagesc(theta_data(argsort(newG(:,2)),900:1900));
set(gca,'Xticklabel',[1100,1300,1500,1700,1900])
title('Sorted by cluster similarity')

subplot(1,6,6);
plot(sort(newG(:,2)),1:size(newG,1));
set(gca,'Ydir','reverse')
ylim([1,size(G,1)])
xlabel('Group')


suptitle(['Mouse ',this_mouse{1}.name(end-2:end-1),', Peri-touch whisker angle (pole up at 1000ms)'])
%% Plot mean of each cluster in different colours. 
% Looking for a better way of sorting the clusters
clus = 12;
for i = 1:clus+1
    thisG = find(newG(:,2) == i);
    these_theta = theta_ds(thisG,:);
    plot(20*i + mean(these_theta,1))
    hold all
    [mx,mi] = max(mean(these_theta,1));
    mx_i(i) = mi;
    plot(mi,20*i + mx,'k.')
end
hold off
    
%% Repeat, but in peak order
clus = 12;
sorted_mx = argsort(mx_i);
for i = 1:clus+1
    thisG = find(newG(:,2) == sorted_mx(i));
    these_theta = theta_ds(thisG,:);
    plot(20*i + mean(these_theta,1))
    hold all
    [mx,mi] = max(mean(these_theta,1));
    plot(mi,20*i + mx,'k.')
end
hold off

%% Use peak order in an image plot
peakorder = [];
newestG = zeros(size(newG));
newestG(:,1) = newG(:,1);
for i = 1:numel(mx_i)
    thisG = find(newG(:,2) == sorted_mx(i));
    peakorder = [peakorder;thisG];
    newestG(thisG,2) = i;

end


subplot(1,6,[1:2]);
imagesc(theta_ds)
set(gca,'Xticklabel',[1100,1300,1500,1700,1900])
ylabel('Trial')
xlabel('Time (ms)')
title('Unsorted')

subplot(1,6,3);
plot(tt,1:size(G,1));
set(gca,'Ydir','reverse')
ylim([1,size(G,1)])
xlabel('Trialtype')

subplot(1,6,[4:5]);
imagesc(theta_ds(peakorder,:));
set(gca,'Xticklabel',[1100,1300,1500,1700,1900])
title('Sorted by group mean peak time')

subplot(1,6,6);
plot(sort(newestG(:,2)),1:size(newestG,1));
set(gca,'Ydir','reverse')
ylim([1,size(G,1)])
xlabel('Group')

suptitle(['Mouse ',this_mouse{1}.name(end-2:end-1),', Peri-touch whisker angle (pole up at 1000ms)'])

%% Sort by linkage and plot dendogram at the side
Z = linkage(score(:,1:40));
subplot(1,5,1)
[M,T,PERM] = dendrogram(Z,1000,'orientation','left');
subplot(1,5,[2:5]);
imagesc(theta_data(argsort(T),900:1900));
suptitle(['Mouse ',this_mouse{1}.name(end-2:end-1),', Peri-touch whisker angle (pole up at 1000ms)'])

%% Image sorted data + sorted corr matrix
leaves = 500;

[M,T,PERM] = dendrogram(Z,leaves,'orientation','left');
subplot(1,2,1);
imagesc(theta_data(argsort(T),900:1900));
title(['Peri-touch whisker angle (pole up at 1000ms)'])

subplot(1,2,2);
imagesc(corrcoef(score(argsort(T),1:40)'))
title(['PCC score vectors (sorted)'])

suptitle(['Mouse ',this_mouse{1}.name(end-2:end-1),'. Max leaf nodes:',num2str(leaves)])
