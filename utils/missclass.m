function [miss_rate,index] = missclass(est_label,label)
% input:
% est_label: (1xn) = Estimated data labels.
% label: (1xn) = True data labels.
%
% output:
% miss_rate: (1x1) = Misclassification rate (%).
% index: (1x1) = Permutation that gives the miss_rate.

[ dummy inx ] = sort(label);
label = label(inx);
est_label = est_label(inx);

ngroups = max(label)-min(label)+1;
npoints = zeros(1,ngroups);
unique_label = (min(label):max(label));

for i = 1:ngroups
    npoints(i) = sum(label == unique_label(i));
end

Permutations = perms(min(label):max(label));

if(size(est_label,2)==1)
    est_label=est_label';
end
miss = zeros(size(Permutations,1),1);
for k=1:size(est_label,1)
    for j=1:size(Permutations,1)
        miss(j,k) = length(find(est_label(k,1:npoints(1))~=Permutations(j,1)));
        for i=2:ngroups
            miss(j,k) = miss(j,k) + length(find(est_label(k,sum(npoints(1:i-1))+1:sum(npoints(1:i)))~=Permutations(j,i)));
        end
    end
end

[miss,inx] = min(miss,[],1);

miss_rate = miss/sum(npoints)*100;

index = Permutations(inx,:);