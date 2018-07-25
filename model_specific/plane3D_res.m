function res = plane3D_res(P,X)

x = X(1,:)';
y = X(2,:)';
z = X(3,:)';
n = length(x);

res = (z-[x,y, ones(n,1)]*P).^2;