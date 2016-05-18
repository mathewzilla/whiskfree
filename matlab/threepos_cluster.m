% Script for pca + clustering of whisking data. 
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
[t,k] = gen_tk(this_mouse);

%% Downsample with decimate

theta_data = [t{1}';t{2}';t{3}'];
theta_ds = zeros(size(theta_data,1),100);
for i = 1:size(theta_data,1)
    theta_ds(i,:) = decimate(theta_data(i,900:1890),10);
    
%     theta_ds(i,:) = theta_ds(i,:) - mean(theta_ds(i,1:10));
end

%% PCA
[coeff,score,latent] = princomp(theta_ds);

% Use first 15 dims for clustering
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

subplot(1,6,3);
plot(tt,1:size(G,1));
set(gca,'Ydir','reverse')
ylim([1,size(G,1)])
xlabel('Trialtype')

subplot(1,6,[4:5]);
imagesc(theta_data(argsort(newG(:,2)),900:1900));

subplot(1,6,6);
plot(sort(newG(:,2)),1:size(newG,1));
set(gca,'Ydir','reverse')
ylim([1,size(G,1)])
xlabel('Group')

title('Downsampled whisker angle')
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

subplot(1,6,3);
plot(tt,1:size(G,1));
set(gca,'Ydir','reverse')
ylim([1,size(G,1)])

subplot(1,6,[4:5]);
imagesc(theta_ds(peakorder,:));

subplot(1,6,6);
plot(sort(newestG(:,2)),1:size(newestG,1));
set(gca,'Ydir','reverse')
ylim([1,size(G,1)])




