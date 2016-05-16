% Script for pca + clustering of whisking data. 
% Whisking data needs to come from threeposition.m

% load ~/Dropbox/Data/3posdata/behav_36b.mat


colours = [1,0,0;0,1,0;0,0,0]; % 36
m_colours = [1,0.5,0.5;0.5,1,0.5;0.5,0.5,0.5]; % 36
titles = {'Posterior pole';'Anterior pole';'No Go'}; % 36

% this_mouse = behav_32;
% colours = [0,1,0;1,0,0;0,0,0]; % Others
% m_colours = [0.5,1,0.5;1,0.5,0.5;0.5,0.5,0.5]; % Others
% titles = {'Anterior pole';'Posterior pole';'No Go'}; % Others

% Generate t and k arrays
[t,k] = gen_tk(behav_36);

%% Downsample with decimate

theta_data = [t{1}';t{2}';t{3}'];
theta_ds = zeros(size(theta_data,1),100);
for i = 1:size(theta_data,1)
    theta_ds(i,:) = decimate(theta_data(i,900:1890),10);
end

%% PCA
[coeff,score,latent] = princomp(theta_ds);

% Use first 15 dims for clustering
theta_pc = score * coeff(:,1:15);
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

%% MDH Q value
B = corrcoef(theta_pc');
B(find(eye(size(B,1)))) = 0;
B(find(B<0)) = 0;

for i = 1:numel(c_data)
ngrps = c_data{i}.clusters;

            S = zeros(100,ngrps);
        

            for loop = 1:ngrps
                S(:,loop) = (c_data{i}.cidx(:) == loop);
            end

trace(S' * B * S);