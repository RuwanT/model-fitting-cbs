function res = line2D_res(P,X)

x = X(1,:)';
y = X(2,:)';
n = length(x);

res = (y-[x ones(n,1)]*P).^2;
