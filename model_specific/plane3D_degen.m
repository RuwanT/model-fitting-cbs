function isDegen = plane3D_degen(X,d)

np = length(X(1,:));

C = combnk(1:np,2);

minDist = zeros(length(C(:,1)),1);
for i=1:length(C(:,1))
    temp = X(:,C(i,1)) - X(:,C(i,2));
    minDist(i) = norm(temp);
end

min_dist = min(minDist);
isDegen = 1;
if (min_dist > d)
    isDegen=0;
end