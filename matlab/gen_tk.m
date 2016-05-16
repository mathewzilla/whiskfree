% Function to generate t and k arrays from behav_ data
function [t,k] = gen_tk(this_mouse);

k = cell(1,3);
t = cell(1,3);
for s = 1:numel(this_mouse)

    v = 1:this_mouse{s}.sync;
    for i = 1:3;
        tt = find(this_mouse{s}.trialtype(v) == i);
        ct = find(this_mouse{s}.choice(v(tt)) == i);
        
        pu = this_mouse{s}.poleup(v(tt(ct)));
        if ~isempty(pu)
%             this_k = circshift(delta_k,1000-pu);
%             this_t = circshift(this_mouse{s}.theta(v(tt(ct)),:)',1000-pu);
        t{i} = [t{i},circshift(this_mouse{s}.theta(v(tt(ct)),:)',1000-pu)];
        k{i} = [k{i},circshift(this_mouse{s}.kappa(v(tt(ct)),:)',1000-pu)];
        %     plot((conv2(this_mouse{1}.kappa(tt(ct),:)',ones(50,1),'valid'))./50 - mean(this_mouse{1}.kappa(tt(ct),1:100),2),'color',colours(i,:));
        %     plot(this_mouse{1}.kappa(tt(ct),:)','color',colours(i,:));
%         plot(bsxfun(@minus,(conv2(this_mouse{s}.kappa(v(tt(ct)),:)',ones(50,1),'valid')./50)',mean(this_mouse{s}.kappa(v(tt(ct)),1:100),2))','color',colours(i,:))
        end
    end
    
    
end